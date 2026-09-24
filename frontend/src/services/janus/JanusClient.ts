import type { JanusMessage, JanusResponse, JanusEventHandlers } from './types';

export class JanusClient {
  private ws: WebSocket | null = null;
  private url: string;
  private sessionId: number | null = null;
  private transactions: Map<string, {
    resolve: (r: JanusResponse) => void;
    reject: (e: Error) => void;
    requestType: string;
    timer: ReturnType<typeof setTimeout>;
  }> = new Map();
  private eventHandlers: JanusEventHandlers = {};
  private keepAliveInterval: number | null = null;
  readonly correlationId: string;

  constructor(url: string) {
    this.url = url;
    this.correlationId = `janus-${Date.now().toString(36)}-${Math.random().toString(36).substring(2, 7)}`;
  }

  // Connect to Janus WebSocket
  connect(): Promise<void> {
    return new Promise((resolve, reject) => {
      try {
        this.ws = new WebSocket(this.url, 'janus-protocol');

        this.ws.onopen = () => {
          this.startKeepAlive();
          this.eventHandlers.onConnected?.();
          resolve();
        };

        this.ws.onmessage = (event) => {
          try {
            const message: JanusResponse = JSON.parse(event.data);
            this.handleMessage(message);
          } catch (error) {
            console.error(`[Janus:${this.correlationId}] Failed to parse message:`, error);
          }
        };

        this.ws.onerror = (error) => {
          console.error(`[Janus:${this.correlationId}] WebSocket error:`, error);
          const err = new Error('WebSocket connection failed');
          this.eventHandlers.onError?.(err);
          reject(err);
        };

        this.ws.onclose = () => {
          this.stopKeepAlive();
          this.eventHandlers.onDisconnected?.();
        };
      } catch (error) {
        reject(error);
      }
    });
  }

  // Disconnect from Janus
  disconnect(): void {
    this.stopKeepAlive();

    if (this.sessionId) {
      this.sendMessage({ janus: 'destroy', session_id: this.sessionId, transaction: this.generateTransactionId() });
      this.sessionId = null;
    }

    if (this.ws) {
      this.ws.close();
      this.ws = null;
    }

    this.transactions.forEach(({ reject, timer }) => {
      clearTimeout(timer);
      reject(new Error('Disconnected'));
    });
    this.transactions.clear();
  }

  // Set event handlers
  setEventHandlers(handlers: JanusEventHandlers): void {
    this.eventHandlers = { ...this.eventHandlers, ...handlers };
  }

  // Create a Janus session
  async createSession(): Promise<number> {
    const response = await this.sendRequest({ janus: 'create' });

    if (response.data?.id) {
      this.sessionId = response.data.id;
      return this.sessionId;
    }

    throw new Error('Failed to create session');
  }

  // Attach to a Janus plugin
  async attach(plugin: string): Promise<number> {
    if (!this.sessionId) {
      throw new Error('No active session');
    }

    const response = await this.sendRequest({
      janus: 'attach',
      plugin,
      session_id: this.sessionId,
    });

    if (response.data?.id) {
      return response.data.id;
    }

    throw new Error(`Failed to attach to plugin ${plugin}`);
  }

  // Send a message to a plugin handle
  async sendPluginMessage(
    handleId: number,
    body: Record<string, unknown>,
    jsep?: RTCSessionDescriptionInit
  ): Promise<JanusResponse> {
    if (!this.sessionId) {
      throw new Error('No active session');
    }

    const message: JanusMessage = {
      janus: 'message',
      session_id: this.sessionId,
      handle_id: handleId,
      body,
    };

    if (jsep) {
      message.jsep = jsep;
    }

    return this.sendRequest(message);
  }

  // Send trickle ICE candidate
  async trickle(handleId: number, candidate: RTCIceCandidateInit | null): Promise<void> {
    if (!this.sessionId) {
      throw new Error('No active session');
    }

    await this.sendRequest({
      janus: 'trickle',
      session_id: this.sessionId,
      handle_id: handleId,
      candidate: candidate || { completed: true },
    });
  }

  // Private: Send a message and wait for response
  private sendRequest(message: JanusMessage): Promise<JanusResponse> {
    return new Promise((resolve, reject) => {
      const transaction = this.generateTransactionId();
      message.transaction = transaction;

      // Timeout after 10 seconds
      const timer = setTimeout(() => {
        if (this.transactions.has(transaction)) {
          this.transactions.delete(transaction);
          reject(new Error('Request timeout'));
        }
      }, 10000);

      this.transactions.set(transaction, {
        resolve,
        reject,
        requestType: message.janus,
        timer,
      });

      try {
        this.sendMessage(message);
      } catch (err) {
        clearTimeout(timer);
        this.transactions.delete(transaction);
        reject(err);
      }
    });
  }

  // Private: Send a message without waiting for response
  private sendMessage(message: JanusMessage): void {
    if (!this.ws || this.ws.readyState !== WebSocket.OPEN) {
      throw new Error('WebSocket not connected');
    }

    this.ws.send(JSON.stringify(message));
  }

  // Private: Handle incoming messages
  private handleMessage(message: JanusResponse): void {
    // Janus responds to "message" requests in two steps: an immediate "ack"
    // (just confirming receipt) followed later by the real "event"/"success"/
    // "error" response carrying the actual plugin data (e.g. join/create result).
    // Other requests (trickle/keepalive/destroy/attach/create session) only
    // ever get the "ack"/"success" as their one and only response, so those
    // must still resolve immediately.
    if (message.janus === 'ack' && message.transaction && this.transactions.has(message.transaction)) {
      const pending = this.transactions.get(message.transaction)!;
      if (pending.requestType === 'message') {
        // Wait for the real event/success/error response instead.
        return;
      }
      clearTimeout(pending.timer);
      this.transactions.delete(message.transaction);
      pending.resolve(message);
      return;
    }

    // Handle transaction-based responses
    if (message.transaction && this.transactions.has(message.transaction)) {
      const { resolve, reject, timer } = this.transactions.get(message.transaction)!;
      clearTimeout(timer);
      this.transactions.delete(message.transaction);

      if (message.janus === 'error') {
        const err = message.error as { code: number; reason: string } | undefined;
        reject(new Error(err ? `Janus error ${err.code}: ${err.reason}` : 'Unknown Janus error'));
      } else {
        resolve(message);
      }

      // Plugin "event" responses (join/create/start results, etc.) also need
      // to reach WebRTCManager's async event handling, since that's where
      // 'joined'/'attached'/error payloads are interpreted.
      if (message.janus === 'event') {
        this.dispatchMessage(message);
      }
      return;
    }

    // Janus full trickle sends its own ICE candidates as asynchronous messages.
    if (message.janus === 'trickle') {
      this.dispatchMessage(message);
      return;
    }

    if (message.janus === 'hangup') {
      console.warn(`[Janus:${this.correlationId}] PeerConnection hangup`, {
        handleId: message.sender,
        reason: message.reason,
      });
      this.dispatchMessage(message);
      return;
    }

    // Handle asynchronous events (no matching transaction, e.g. events about
    // other participants, or webrtcup/media notifications)
    if (message.janus === 'event' || message.janus === 'webrtcup' || message.janus === 'media') {
      this.dispatchMessage(message);
    } else if (message.janus === 'error') {
      const error = message.error as { code?: number; reason?: string } | undefined;
      console.error(`[Janus:${this.correlationId}] Unhandled Janus error`, {
        code: error?.code,
        reason: error?.reason,
      });
    }
  }

  private dispatchMessage(message: JanusResponse): void {
    try {
      const result = this.eventHandlers.onMessage?.(message);
      void Promise.resolve(result).catch((error) => {
        const err = error instanceof Error ? error : new Error(String(error));
        console.error(`[Janus:${this.correlationId}] Failed to process Janus message:`, err);
        this.eventHandlers.onError?.(err);
      });
    } catch (error) {
      const err = error instanceof Error ? error : new Error(String(error));
      console.error(`[Janus:${this.correlationId}] Failed to dispatch Janus message:`, err);
      this.eventHandlers.onError?.(err);
    }
  }

  // Private: Start keep-alive mechanism
  private startKeepAlive(): void {
    this.keepAliveInterval = window.setInterval(() => {
      if (this.sessionId && this.isConnected()) {
        this.sendMessage({
          janus: 'keepalive',
          session_id: this.sessionId,
          transaction: this.generateTransactionId(),
        });
      }
    }, 30000);
  }

  // Private: Stop keep-alive
  private stopKeepAlive(): void {
    if (this.keepAliveInterval !== null) {
      clearInterval(this.keepAliveInterval);
      this.keepAliveInterval = null;
    }
  }

  // Private: Generate transaction ID
  private generateTransactionId(): string {
    return Math.random().toString(36).substring(2, 12);
  }

  // Getters
  getSessionId(): number | null {
    return this.sessionId;
  }

  isConnected(): boolean {
    return this.ws !== null && this.ws.readyState === WebSocket.OPEN;
  }
}
