# AGENTS.md

## Project

This diploma thesis project is a browser-based multi-participant video call
application. It uses React and TypeScript in the browser, Janus VideoRoom as
an SFU, Coturn for STUN/TURN, NGINX for HTTPS/WSS proxying, and Docker Compose
for the local server environment.

Prefer clear, maintainable TypeScript, reproducible Docker configuration,
standards-based WebRTC behaviour, and changes that are easy to describe and
evaluate in the thesis. Do not introduce frameworks, services, or architectural
layers without a concrete need.

## Architecture

```text
Browser -- HTTPS/WSS --> NGINX -- HTTP --> frontend (Vite development server)
                           |
                           +-- WSS --> Janus WebSocket API / VideoRoom

Browser -- WebRTC media --> Janus VideoRoom SFU
Browser -- WebRTC media --> Coturn --> Janus, when TURN relay is needed
```

- The browser signals directly with Janus over its WebSocket API; there is no
  separate application signalling server.
- Janus VideoRoom is the SFU. Browsers publish media to Janus and subscribe to
  remote feeds from Janus. Do not replace this with a peer-to-peer design.
- Coturn is an ICE/STUN/TURN fallback. Do not force relay transport or remove
  TURN merely to simplify testing or logs.
- NGINX terminates HTTPS/WSS and routes frontend and Janus traffic.
- The current frontend container runs Vite's development server. This is
  suitable for development and demonstrations; a static production frontend is
  a separate future deployment concern.

## Important implementation areas

- `frontend/src/services/webrtc/WebRTCManager.ts` owns local media,
  `RTCPeerConnection` instances, publisher/subscriber lifecycle, ICE, and
  cleanup.
- `frontend/src/services/janus/JanusClient.ts` owns the WebSocket, Janus
  sessions and handles, transactions, JSEP/trickle messages, keep-alives, and
  correlation IDs.
- React components render state and invoke manager operations; keep UI concerns
  separate from WebRTC and Janus lifecycle code.
- Remote feeds are managed by Janus feed ID. Publisher and subscriber peer
  connections are intentionally distinct.

## Networking and deployment guardrails

- Read the active Compose, NGINX, Janus, Coturn, and environment configuration
  before changing networking behaviour.
- Coturn uses a fixed Docker address (`172.18.0.10`) for relay configuration.
  Do not change it, its external-address mapping, or the configured relay-port
  range without evidence and a deployment-level reason.
- Keep UDP TURN relay port publishing intact unless the change is explicitly
  required and its effect is understood.
- ICE candidate gathering, a successful SDP exchange, and media connectivity
  are different layers. Diagnose the failing layer before changing STUN, TURN,
  Janus, or browser configuration.
- Treat credentials, certificates, IP addresses, and environment values as
  deployment data. Do not log secrets or copy credentials into source comments
  or documentation.

## Working conventions

- Keep normal successful operation quiet. Retain concise lifecycle diagnostics
  and meaningful `console.warn`/`console.error` messages; do not log SDP,
  candidates, Janus payloads, statistics, or credentials by default.
- For WebRTC/Janus changes, make lifecycle transitions explicit, avoid silently
  swallowing errors, and guard asynchronous handlers against cleaned-up state.
- Before changing publisher or subscriber behaviour, trace `joinRoom()`, JSEP,
  event handling, `leaveRoom()`, `cleanup()`, and `disconnect()`.
- Preserve working ICE, WebRTC, Janus, and signalling behaviour unless a clear
  defect is demonstrated. Prefer the smallest change that fixes the evidence.
- Keep source comments for non-obvious protocol or lifecycle reasons; remove
  stale debugging comments and temporary diagnostics when no longer needed.

## Validation

For frontend dependency or code changes, run the available checks from
`frontend` or through the frontend Docker service:

```text
npm ci
npm audit
npm run build
npm run lint
```

Run existing tests when their required browser/runtime is available. For changes
to deployment files, also validate the relevant Docker build or Compose service.
Report unavailable checks rather than inventing replacements.

## Thesis scope

The implementation supports creating and joining rooms, display names, local
and remote video, publisher discovery and removal, audio/video toggles, and
controlled leave/cleanup. Accessibility is evaluated separately against WCAG
2.1 using axe-based automated checks and Axe DevTools; do not make speculative
UI or accessibility redesigns outside that work.
