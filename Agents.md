# AGENTS.md

## Project overview

This is a diploma thesis project implementing a browser-based multi-participant WebRTC video call service.

The main goal is to implement and evaluate a working browser-based video call system using WebRTC and a Janus VideoRoom SFU. The system is containerized with Docker Compose.

The project is also used as the implementation basis for a diploma thesis. Changes should therefore favor:

* clear and understandable architecture
* maintainable TypeScript code
* reproducible Docker-based deployment
* explicit logging useful for thesis debugging and evaluation
* standards-based WebRTC behavior
* accessibility where applicable
* avoiding unnecessary complexity

Do not introduce technologies or architectural components without a clear reason.

---

# Architecture

The main components are:

* React + TypeScript frontend
* Janus WebRTC Gateway
* Janus VideoRoom plugin / SFU
* Coturn STUN/TURN server
* NGINX reverse proxy
* Docker Compose

The intended architecture is:

```text
Browser A
   |
   | HTTPS / WSS
   v
 NGINX
   |
   +---------------------> React frontend
   |
   +---------------------> Janus WebSocket API
                              |
                              v
                         Janus VideoRoom
                              ^
                              |
                         WebRTC media
                              |
                         Browser A/B
                              |
                              v
                            Coturn
                       STUN/TURN when needed
```

Important:

* The browser connects directly to Janus for WebSocket signaling.
* There is no separate application server forwarding WebRTC signaling.
* Janus VideoRoom acts as the SFU.
* Media is handled by WebRTC between the browsers and Janus.
* Coturn is used for ICE/STUN/TURN connectivity when required.
* NGINX terminates HTTPS/WSS and routes traffic to the appropriate container.

---

# Current repository concepts

The frontend contains at least these important components:

* `WebRTCManager.ts`
* `JanusClient.ts`

### JanusClient

`JanusClient` handles communication with Janus over WebSocket, including:

* WebSocket connection
* Janus session creation
* plugin handle attachment
* Janus messages
* transactions
* JSEP messages
* trickle ICE candidates
* correlation-ID logging

### WebRTCManager

`WebRTCManager` is responsible for:

* obtaining local media using `getUserMedia`
* creating `RTCPeerConnection`
* configuring ICE servers
* creating publisher/subscriber handles
* publishing local media
* subscribing to remote feeds
* handling Janus VideoRoom events
* handling ICE candidates
* audio/video controls
* cleanup when leaving a room

Keep UI concerns separate from WebRTC/Janus connection management.

---

# Janus configuration

Janus is running in Docker.

Relevant containers:

```text
videortc-janus
videortc-coturn
videortc-frontend
videortc-nginx
```

The Docker network is:

```text
videortc-network
```

Subnet:

```text
172.18.0.0/16
```

Known container addresses:

```text
Janus:     172.18.0.3
Coturn:    172.18.0.10
Frontend:  172.18.0.2
NGINX:     172.18.0.4
Gateway:   172.18.0.1
```

The Coturn IP is intentionally fixed to:

```text
172.18.0.10
```

Do not change this IP casually.

It was previously necessary to fix the Coturn container IP because the relay configuration referenced an old Docker IP. The old configuration caused errors such as:

```text
errno=99
```

when Coturn attempted to bind relay ports.

The current fixed IP solved those relay binding errors.

---

# Coturn configuration

Current relevant configuration:

```ini
listening-port=3478
tls-listening-port=5349

listening-ip=0.0.0.0

external-ip=91.157.161.57/172.18.0.10
relay-ip=172.18.0.10

min-port=10000
max-port=10200

verbose

realm=videortc.local

user=videouser:videopass

fingerprint
lt-cred-mech

no-cli

max-bps=1000000
bps-capacity=0

no-tcp-relay
```

The public/external IP currently used is:

```text
91.157.161.57
```

The internal Docker relay IP is:

```text
172.18.0.10
```

The relay port range is:

```text
10000-10200/UDP
```

Docker publishes:

```text
3478:3478/udp
3478:3478/tcp
5349:5349/tcp
5349:5349/udp
10000-10200:10000-10200/udp
```

Do not remove or change the UDP relay port mapping without understanding its effect on TURN.

`no-tcp-relay` is currently enabled.

This means TCP relay endpoints are disabled. It does not mean that UDP TURN is disabled.

---

# Current frontend ICE configuration

The frontend currently uses:

```ts
const webrtc = new WebRTCManager(janusUrl, {
    iceServers: [
        { urls: 'stun:stun.l.google.com:19302' },
        {
            urls: [
                'turn:91.157.161.57:3478?transport=udp',
                'turn:91.157.161.57:3478?transport=tcp',
            ],
            username: 'videouser',
            credential: 'videopass',
        },
    ],
});
```

The important production/test TURN endpoint is:

```text
turn:91.157.161.57:3478
```

---

# Current WSS configuration

The frontend uses:

```text
wss://91.157.161.57/janus
```

The Janus WebSocket connection currently works from both test machines.

There was previously a certificate trust problem when connecting using the public IP. That has been worked around for testing, and Janus WSS connectivity is now confirmed.

Do not treat Janus WSS connectivity as the current primary problem.

---

# Current debugging state

## What is confirmed working

Janus WebSocket connectivity works.

The browser can:

1. connect to Janus over WSS
2. create a Janus session
3. attach to `janus.plugin.videoroom`
4. create/ensure the room
5. obtain local camera/microphone
6. create an `RTCPeerConnection`
7. create an SDP offer
8. receive a JSEP answer from Janus
9. reach signaling state `stable`
10. gather a TURN relay ICE candidate

This is important because the problem is no longer simply "TURN does not work".

---

# Current successful TURN observation

The browser recently produced:

```text
[WebRTC] ICE candidate: {
    type: 'relay',
    protocol: 'udp',
    address: '91.157.161.57',
    port: 10044,
    ...
}
```

This is a critical observation.

It proves that the browser is able to obtain a TURN relay candidate.

The candidate is a UDP relay candidate using:

```text
91.157.161.57:10044
```

Therefore, do not assume that the absence of a relay candidate is still the problem.

---

# Current ICE errors

The browser also reports:

```text
turn:91.157.161.57:3478?transport=tcp
701 Failed to establish connection
```

and:

```text
stun:91.157.161.57:3478
701 STUN binding request timed out
```

and:

```text
stun:stun.l.google.com:19302
701 STUN binding request timed out
```

and:

```text
turn:91.157.161.57:3478?transport=udp
701 TURN allocate request timed out
```

However, despite the UDP TURN error, a relay candidate is subsequently produced.

Therefore these 701 errors should not automatically be interpreted as proof that TURN is completely broken.

The TCP TURN error is also not currently the main issue because:

```ini
no-tcp-relay
```

is enabled.

---

# Current Janus behavior that needs investigation

After successful SDP exchange, the browser receives Janus events indicating that its publisher disappears.

Typical sequence:

```text
Publisher received JSEP answer
Signaling state: stable
Publisher SDP exchange complete
Joined room
ICE candidate: relay / udp / 91.157.161.57:10044
```

Then:

```text
Publisher unpublished feed <feed-id>
No subscriber found for feed <feed-id>

Publisher unpublished feed <feed-id>
No subscriber found for feed <feed-id>

Publisher left feed <feed-id>
No subscriber found for feed <feed-id>
```

The same behavior has been observed with different feed IDs.

This is currently the most interesting symptom.

The application appears to lose/remove the publisher shortly after the JSEP exchange.

Do not assume that this is definitely caused by Janus itself. It could be:

* WebRTC/ICE failure causing application cleanup
* publisher cleanup logic
* an incorrect Janus VideoRoom event interpretation
* a PeerConnection lifecycle problem
* a race condition
* an error in publisher/subscriber handle handling
* another application-level condition

Investigate the actual code path before changing architecture.

---

# Important test observation

Two test machines have been used, referred to as A and B.

Both can reach Janus over WSS.

Both have experienced similar ICE timeout behavior.

Machine A is less useful for some networking tests because it connects to the same server's public IP and may involve NAT loopback/hairpin behavior.

Machine B is preferable for testing external connectivity to the server.

When testing TURN/network behavior, prefer machine B.

---

# Coturn logs

Coturn is currently successfully allocating relay ports.

Examples observed:

```text
Local relay addr: 172.18.0.10:10175
ALLOCATE processed, success
```

and:

```text
Local relay addr: 172.18.0.10:10035
ALLOCATE processed, success
```

and multiple other successful allocations.

Coturn has also successfully processed:

```text
CREATE_PERMISSION
```

The earlier relay binding errors such as:

```text
errno=99
```

are no longer occurring after fixing the Coturn container IP.

Therefore, do not revert to the old hypothesis that Coturn cannot bind its relay ports.

---

# Important Docker networking observation

Coturn logs show remote clients with addresses such as:

```text
172.18.0.1:53003
172.18.0.1:42955
172.18.0.1:51000
```

This is consistent with Docker/Windows NAT hiding the original client address from the container.

This may be relevant when investigating:

* TURN response routing
* NAT behavior
* Docker Desktop networking
* hairpin NAT
* external UDP relay traffic

Do not assume that seeing `172.18.0.1` means the browser itself is located at that address.

---

# Current ICE logging

`WebRTCManager.ts` has been modified to log ICE candidates in a useful form:

```ts
pc.onicecandidate = (event) => {
    if (event.candidate) {
        console.log('[WebRTC] ICE candidate:', {
            type: event.candidate.type,
            protocol: event.candidate.protocol,
            address: event.candidate.address,
            port: event.candidate.port,
            candidate: event.candidate.candidate,
        });
    } else {
        console.log('[WebRTC] ICE candidate gathering complete');
    }

    this.janusClient.trickle(
        handleId,
        event.candidate ?? null
    );
};
```

This logging should be preserved unless there is a strong reason to change it.

The goal is to distinguish:

* `host`
* `srflx`
* `relay`

candidates.

---

# Current WebRTC state logging

The code has logging for:

```ts
pc.onicecandidateerror
pc.oniceconnectionstatechange
pc.onconnectionstatechange
pc.onsignalingstatechange
```

The current logs have shown:

```text
Signaling state: have-local-offer
Signaling state: stable
ICE gathering state: gathering
ICE gathering state: complete
```

but no useful:

```text
ICE connection state
Connection state
```

transitions have appeared before the publisher disappears.

This needs investigation.

---

# Current debugging priority

The immediate goal is to determine why the Janus publisher disappears after SDP exchange.

Priority order:

1. Determine whether `WebRTCManager` calls cleanup/leave logic.
2. Determine whether the Janus VideoRoom publisher is explicitly unpublished by the application.
3. Determine whether the PeerConnection emits any failure/connection-state event before the publisher disappears.
4. Determine whether Janus reports an error associated with the publisher handle.
5. Check whether the publisher's WebRTC negotiation actually reaches a connected ICE state.
6. Only then make further Coturn/network changes if the evidence points there.

Do not make broad configuration changes without first identifying which layer is failing.

---

# Very useful code paths to inspect

When investigating the publisher disappearance, inspect:

* `cleanup()`
* `leaveRoom()`
* publisher handle creation
* publisher `join`
* publisher `publish`
* JSEP answer handling
* `pc.onicecandidate`
* `pc.oniceconnectionstatechange`
* `pc.onconnectionstatechange`
* `pc.onconnectionstatechange`
* `pc.ontrack`
* Janus `unpublished` event handling
* Janus `leaving` event handling
* Janus `hangup` event handling
* Janus error handling
* any code that closes the PeerConnection
* any code that detaches a Janus handle

Search for all calls to:

```text
cleanup
leaveRoom
close
destroy
detach
hangup
unpublish
```

before modifying anything.

---

# Important debugging rule

Do not "fix" the problem by disabling functionality just to make the logs look cleaner.

The goal is to identify the actual failure.

In particular:

* Do not remove TURN.
* Do not remove Janus.
* Do not switch to P2P architecture.
* Do not remove the VideoRoom SFU.
* Do not remove ICE.
* Do not remove cleanup logic unless testing whether it causes the problem.
* Do not disable WebRTC error handling.

Temporary diagnostic changes are fine, but clearly mark them as diagnostic.

---

# Expected WebRTC architecture

The intended multi-participant flow is:

```text
Publisher browser
      |
      | publish
      v
Janus VideoRoom SFU
      |
      +----> Subscriber browser 1
      |
      +----> Subscriber browser 2
      |
      +----> Subscriber browser N
```

Each publisher sends media to Janus.

Subscribers receive media from Janus.

The browser should not establish direct peer-to-peer media connections between participants.

---

# Thesis requirements relevant to implementation

The implementation should satisfy these functional requirements:

* F1: Home view allows creating/joining a room using a room ID, including random room ID generation.
* F2: User can enter a display name.
* F3: Browser obtains local media with `getUserMedia`.
* F4: Local video is displayed.
* F5: Remote video streams are displayed and managed by feed ID.
* F6: Janus `publishers` list is handled when joining.
* F7: Janus `unpublished` and `leaving` events are handled.
* F8: Audio can be toggled.
* F9: Video can be toggled.
* F10: Leaving a room releases resources and performs cleanup.

Non-functional requirements include:

* N1: Coturn is used for STUN/TURN NAT traversal.
* N2: HTTPS/WSS is used with NGINX SSL termination.
* N3: More than two participants are supported using the Janus VideoRoom SFU.
* N4: The complete system is runnable using Docker Compose.
* N5: WebRTC/Janus keep-alive behavior is supported.
* N6: Janus signaling logs use correlation IDs.

Accessibility requirements are handled separately and are based on WCAG 2.1.

---

# Coding preferences

Prefer straightforward TypeScript.

Avoid unnecessary abstractions.

Prefer existing project architecture over introducing new frameworks or libraries.

When modifying WebRTC code:

* preserve existing logging unless it is clearly obsolete
* make lifecycle transitions explicit
* avoid silently swallowing errors
* log enough context to identify the affected Janus handle/feed
* keep publisher and subscriber PeerConnections clearly distinguishable
* ensure event handlers cannot accidentally operate on an already-cleaned-up connection

When changing behavior, explain the reason in code comments only when the reason would otherwise be non-obvious.

---

# Debugging methodology

For networking/WebRTC problems, distinguish these layers:

```text
1. Browser
   |
2. ICE candidate gathering
   |
3. STUN/TURN connectivity
   |
4. Janus signaling
   |
5. SDP negotiation
   |
6. ICE connectivity
   |
7. DTLS/SRTP/media
   |
8. Application lifecycle / cleanup
```

Do not treat a failure in one layer as evidence that a different layer is broken.

Current confirmed facts:

```text
Browser -> Janus WSS       WORKS
Browser -> local media     WORKS
Browser -> SDP offer       WORKS
Janus -> SDP answer        WORKS
Browser -> TURN relay      RELAY CANDIDATE WORKS
Publisher lifetime        CURRENT PROBLEM
ICE connectivity           NOT YET CONFIRMED
Media flow                 NOT YET CONFIRMED
```

---

# Current known browser log

A representative successful part of the latest test:

```text
WebSocket connected
Session created
Attached to plugin janus.plugin.videoroom
Publisher handle attached
Requesting local media
Local media acquired
Creating PeerConnection
TURN server: turn:91.157.161.57:3478
Signaling state: have-local-offer
Sending publisher join request
ICE gathering state: gathering
Publisher received JSEP answer
Signaling state: stable
Publisher SDP exchange complete
Joined room
ICE candidate:
    type: relay
    protocol: udp
    address: 91.157.161.57
    port: 10044
```

Then:

```text
Publisher unpublished feed ...
Publisher left feed ...
```

The exact cause of this transition is currently unknown.

---

# Instructions for Codex

Before editing code:

1. Read this file.
2. Inspect the relevant implementation in `WebRTCManager.ts` and `JanusClient.ts`.
3. Trace the publisher lifecycle from `joinRoom()` through JSEP exchange to cleanup.
4. Search for every path that can close/detach/unpublish the publisher.
5. Check whether any asynchronous callback can trigger cleanup unexpectedly.
6. Check whether the `unpublished`/`leaving` Janus events are caused by the application itself or are received from Janus.
7. Report the likely cause and supporting code evidence before making a broad change.

When proposing a fix:

* explain the root cause
* make the smallest reasonable change
* preserve the existing architecture
* do not change Docker networking unless the evidence requires it
* do not change Coturn configuration unless the evidence requires it
* do not replace Janus VideoRoom with another architecture

When possible, verify changes with:

```text
npm run build
```

and any existing tests/lint commands in the repository.

If a command is unavailable, report that rather than inventing a command.

---

# Current investigation status

Last confirmed state:

**TURN relay candidate generation now works.**

The current investigation has moved from:

```text
"Why can't the browser obtain a TURN relay candidate?"
```

to:

```text
"Why does the Janus publisher disappear shortly after successful SDP exchange?"
```

The next useful action is therefore to inspect the publisher lifecycle and cleanup paths in `WebRTCManager.ts`, while also checking Janus logs for the same timestamp/handle.

Do not assume that the TURN 701 messages are the root cause.
Do not assume that Janus is the root cause.
Use the code and synchronized logs to determine which component initiates the publisher removal.
