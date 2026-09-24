import { JanusClient, JanusResponse } from '@services/janus';

export interface WebRTCConfig {
    iceServers: RTCIceServer[];
}

export interface VideoRoomOptions {
    roomId: string | number;
    displayName: string;
    audio?: boolean;
    video?: boolean;
}

export type FeedId = string | number;

interface SubscriberSession {
    handleId: number;
    pc: RTCPeerConnection;
    stream: MediaStream;
}

export class WebRTCManager {
    private janusClient: JanusClient;
    private config: WebRTCConfig;

    private publisherHandleId: number | null = null;
    private publisherPc: RTCPeerConnection | null = null;
    private publisherPublishStarted = false;
    private localStream: MediaStream | null = null;
    private roomId: string | number | null = null;
    private pendingRemoteCandidates: Map<number, RTCIceCandidateInit[]> =
        new Map();
    private pendingLocalCandidates: Map<
        number,
        Array<RTCIceCandidateInit | null>
    > = new Map();

    private subscribers: Map<FeedId, SubscriberSession> = new Map();

    private onLocalStreamCb?: (stream: MediaStream) => void;
    private onRemoteStreamCb?: (
        feedId: FeedId,
        stream: MediaStream,
        display: string
    ) => void;
    private onRemoveFeedCb?: (feedId: FeedId) => void;

    constructor(janusUrl: string, config: WebRTCConfig) {
        this.janusClient = new JanusClient(janusUrl);
        this.config = config;

        this.janusClient.setEventHandlers({
            onMessage: (msg) => this.handleJanusMessage(msg),
            onError: (err) => console.error('[WebRTC] Janus error:', err),
        });
    }

    async initialize(): Promise<void> {
        await this.janusClient.connect();
        await this.janusClient.createSession();
    }

    async joinRoom(options: VideoRoomOptions): Promise<void> {
        this.roomId = options.roomId;

        this.publisherHandleId = await this.janusClient.attach(
            'janus.plugin.videoroom'
        );

        await this.ensureRoomExists(this.publisherHandleId, options.roomId);

        this.localStream = await this.getUserMedia({
            audio: options.audio !== false,
            video: options.video !== false,
        });

        this.onLocalStreamCb?.(this.localStream);

        this.publisherPc = this.createPeerConnection(this.publisherHandleId);

        this.localStream.getTracks().forEach((track) => {
            this.publisherPc!.addTrack(track, this.localStream!);
        });

        await this.janusClient.sendPluginMessage(
            this.publisherHandleId,
            {
                request: 'join',
                room: options.roomId,
                ptype: 'publisher',
                display: options.displayName,
            }
        );
    }

    async leaveRoom(): Promise<void> {
        if (this.publisherHandleId) {
            await this.janusClient.sendPluginMessage(this.publisherHandleId, {
                request: 'leave',
            });
        }

        this.cleanup();
    }

    disconnect(): void {
        this.cleanup();
        this.janusClient.disconnect();
    }

    toggleAudio(enabled: boolean): void {
        this.localStream
            ?.getAudioTracks()
            .forEach((t) => (t.enabled = enabled));
    }

    toggleVideo(enabled: boolean): void {
        this.localStream
            ?.getVideoTracks()
            .forEach((t) => (t.enabled = enabled));
    }

    onLocalStream(cb: (stream: MediaStream) => void): void {
        this.onLocalStreamCb = cb;
    }

    onRemoteStream(
        cb: (feedId: FeedId, stream: MediaStream, display: string) => void
    ): void {
        this.onRemoteStreamCb = cb;
    }

    onRemoveFeed(cb: (feedId: FeedId) => void): void {
        this.onRemoveFeedCb = cb;
    }

    getLocalStream(): MediaStream | null {
        return this.localStream;
    }

    isConnected(): boolean {
        return this.janusClient.isConnected();
    }

    private async handleJanusMessage(message: JanusResponse): Promise<void> {
        const handleId = message.sender as number | undefined;
        const pluginData = message.plugindata?.data;

        if (message.janus === 'trickle') {
            await this.handleRemoteTrickle(handleId, message.candidate);
            return;
        }

        if (message.janus === 'hangup') {
            console.warn('[WebRTC] Janus reported PeerConnection hangup:', {
                handleId,
                reason: message.reason,
            });
            return;
        }

        if (handleId === this.publisherHandleId) {
            if (message.jsep) {
                if (
                    pluginData?.videoroom !== 'event' ||
                    pluginData?.configured !== 'ok'
                ) {
                    console.warn('[WebRTC] Unexpected publisher JSEP:', {
                        videoroom: pluginData?.videoroom,
                        pluginData,
                    });
                } else {
                    await this.publisherPc!.setRemoteDescription(
                        new RTCSessionDescription(message.jsep)
                    );
                    await this.flushPendingRemoteCandidates(
                        handleId,
                        this.publisherPc!
                    );
                }
            }

            if (pluginData?.videoroom === 'joined') {
                const publishers =
                    (pluginData.publishers as Array<{
                        id: FeedId;
                        display: string;
                    }>) ?? [];

                if (!this.publisherPc) {
                    throw new Error('Publisher PeerConnection is unavailable');
                }

                const offer = await this.publisherPc.createOffer({
                    offerToReceiveAudio: false,
                    offerToReceiveVideo: false,
                });
                await this.publisherPc.setLocalDescription(offer);

                // Local ICE gathering begins after setLocalDescription. Mark the
                // publish request as started before releasing queued candidates.
                this.publisherPublishStarted = true;
                const publishRequest = this.janusClient.sendPluginMessage(
                    handleId,
                    { request: 'publish' },
                    this.publisherPc.localDescription ?? offer
                );
                await this.flushPendingLocalCandidates(handleId);
                await publishRequest;

                for (const pub of publishers) {
                    await this.subscribeToFeed(pub.id, pub.display);
                }
            }

            if (pluginData?.videoroom === 'event') {
                const newPublishers =
                    (pluginData.publishers as Array<{
                        id: FeedId;
                        display: string;
                    }>) ?? [];

                for (const pub of newPublishers) {
                    if (!this.subscribers.has(pub.id)) {
                        await this.subscribeToFeed(pub.id, pub.display);
                    }
                }

                const unpublished =
                    pluginData.unpublished as FeedId | 'ok' | undefined;

                if (unpublished && unpublished !== 'ok') {
                    await this.removeSubscriber(unpublished);
                }

                const leaving =
                    pluginData.leaving as FeedId | 'ok' | undefined;

                if (leaving && leaving !== 'ok') {
                    await this.removeSubscriber(leaving);
                }
            }

            return;
        }

        for (const [, sub] of this.subscribers) {
            if (sub.handleId !== handleId) continue;

            if (message.jsep) {
                await sub.pc.setRemoteDescription(
                    new RTCSessionDescription(message.jsep)
                );
                await this.flushPendingRemoteCandidates(handleId, sub.pc);

                const answer = await sub.pc.createAnswer();

                await sub.pc.setLocalDescription(answer);

                await this.janusClient.sendPluginMessage(
                    sub.handleId,
                    {
                        request: 'start',
                        room: this.roomId,
                    },
                    answer
                );
            }

            break;
        }
    }

    private async handleRemoteTrickle(
        handleId: number | undefined,
        candidate: JanusResponse['candidate']
    ): Promise<void> {
        if (handleId === undefined) {
            console.warn('[WebRTC] Received remote trickle without a handle ID');
            return;
        }

        if (!candidate || candidate.completed === true) {
            return;
        }

        const pc = this.getPeerConnectionForHandle(handleId);

        if (!pc) {
            console.warn(
                `[WebRTC] No PeerConnection found for remote ICE candidate(handle ${handleId})`
            );
            return;
        }

        if (!pc.remoteDescription) {
            const candidates = this.pendingRemoteCandidates.get(handleId) ?? [];
            candidates.push(candidate);
            this.pendingRemoteCandidates.set(handleId, candidates);
            return;
        }

        await this.addRemoteIceCandidate(handleId, pc, candidate);
    }

    private getPeerConnectionForHandle(
        handleId: number
    ): RTCPeerConnection | null {
        if (handleId === this.publisherHandleId) {
            return this.publisherPc;
        }

        for (const sub of this.subscribers.values()) {
            if (sub.handleId === handleId) {
                return sub.pc;
            }
        }

        return null;
    }

    private async flushPendingRemoteCandidates(
        handleId: number,
        pc: RTCPeerConnection
    ): Promise<void> {
        const candidates = this.pendingRemoteCandidates.get(handleId);

        if (!candidates) return;

        this.pendingRemoteCandidates.delete(handleId);

        for (const candidate of candidates) {
            await this.addRemoteIceCandidate(handleId, pc, candidate);
        }
    }

    private async flushPendingLocalCandidates(handleId: number): Promise<void> {
        const candidates = this.pendingLocalCandidates.get(handleId);

        if (!candidates) return;

        this.pendingLocalCandidates.delete(handleId);

        for (const candidate of candidates) {
            await this.sendLocalTrickle(handleId, candidate);
        }
    }

    private handleLocalIceCandidate(
        handleId: number,
        candidate: RTCIceCandidateInit | null
    ): void {
        if (handleId === this.publisherHandleId && !this.publisherPublishStarted) {
            const candidates = this.pendingLocalCandidates.get(handleId) ?? [];
            candidates.push(candidate);
            this.pendingLocalCandidates.set(handleId, candidates);
            return;
        }

        void this.sendLocalTrickle(handleId, candidate);
    }

    private async sendLocalTrickle(
        handleId: number,
        candidate: RTCIceCandidateInit | null
    ): Promise<void> {
        try {
            await this.janusClient.trickle(handleId, candidate);
        } catch (error) {
            console.error(
                `[WebRTC] Failed to send local ICE candidate(handle ${handleId}):`,
                error
            );
        }
    }

    private async addRemoteIceCandidate(
        handleId: number,
        pc: RTCPeerConnection,
        candidate: RTCIceCandidateInit
    ): Promise<void> {
        const candidateType = candidate.candidate
            ?.match(/ typ ([^ ]+)/)?.[1] ?? 'unknown';

        try {
            await pc.addIceCandidate(candidate);
        } catch (error) {
            console.error(
                `[WebRTC] Failed to add remote ICE candidate(handle ${handleId}):`,
                {
                    candidateType,
                    error,
                }
            );
        }
    }

    private async subscribeToFeed(
        feedId: FeedId,
        display: string
    ): Promise<void> {
        const handleId = await this.janusClient.attach(
            'janus.plugin.videoroom'
        );

        const stream = new MediaStream();
        const pc = this.createPeerConnection(handleId);

        pc.ontrack = (event) => {
            stream.addTrack(event.track);
            this.onRemoteStreamCb?.(feedId, stream, display);
        };

        this.subscribers.set(feedId, {
            handleId,
            pc,
            stream,
        });

        await this.janusClient.sendPluginMessage(handleId, {
            request: 'join',
            room: this.roomId,
            ptype: 'subscriber',
            feed: feedId,
        });
    }

    private async removeSubscriber(feedId: FeedId): Promise<void> {
        const sub = this.subscribers.get(feedId);

        if (!sub) return;

        sub.pc.close();
        sub.stream.getTracks().forEach((t) => t.stop());

        this.subscribers.delete(feedId);
        this.onRemoveFeedCb?.(feedId);
    }

    private async ensureRoomExists(
        handleId: number,
        roomId: string | number
    ): Promise<void> {
        try {
            const response = await this.janusClient.sendPluginMessage(
                handleId,
                {
                    request: 'create',
                    room: roomId,
                    publishers: 8,
                }
            );

            const error =
                response.plugindata?.data?.error_code as number | undefined;

            if (error && error !== 427) {
                console.warn(
                    `[WebRTC] Unable to create room ${roomId} (Janus error ${error})`
                );
            }
        } catch (err) {
            console.warn(
                '[WebRTC] Failed to ensure room exists:',
                err
            );
        }
    }

    private createPeerConnection(
        handleId: number
    ): RTCPeerConnection {
        const pc = new RTCPeerConnection(this.config);

        pc.onicecandidate = (event) => {
            this.handleLocalIceCandidate(handleId, event.candidate ?? null);
        };

        pc.onicecandidateerror = (event) => {
            console.error(
                '[WebRTC] ICE candidate error:',
                {
                    url: event.url,
                    errorCode: event.errorCode,
                    errorText: event.errorText,
                    address: event.address,
                    port: event.port,
                }
            );
        };

        pc.oniceconnectionstatechange = () => {
            if (pc.iceConnectionState === 'failed') {
                console.warn(`[WebRTC] ICE connection failed(handle ${handleId})`);
            }
        };

        pc.onconnectionstatechange = () => {
            if (pc.connectionState === 'failed') {
                console.warn(`[WebRTC] PeerConnection failed(handle ${handleId})`);
            }
        };

        return pc;
    }

    private async getUserMedia(
        constraints: MediaStreamConstraints
    ): Promise<MediaStream> {
        try {
            return await navigator.mediaDevices.getUserMedia(
                constraints
            );
        } catch {
            throw new Error(
                'Failed to access camera/microphone'
            );
        }
    }

    private cleanup(): void {
        this.localStream
            ?.getTracks()
            .forEach((t) => t.stop());

        this.localStream = null;

        this.publisherPc?.close();
        this.publisherPc = null;
        this.publisherHandleId = null;
        this.publisherPublishStarted = false;
        this.pendingRemoteCandidates.clear();
        this.pendingLocalCandidates.clear();

        for (const [feedId] of this.subscribers) {
            this.removeSubscriber(feedId);
        }

        this.subscribers.clear();

        this.roomId = null;
        this.onLocalStreamCb = undefined;
        this.onRemoteStreamCb = undefined;
        this.onRemoveFeedCb = undefined;
    }
}
