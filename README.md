# WebRTC-videocall

VideoRTC is a browser-based multi-participant video calling prototype built as
part of a diploma thesis. The repository contains the application source code
and its development environment; it is not a production-ready video calling
service.

The application uses React, TypeScript and Vite in the browser. Janus Gateway's
VideoRoom plugin is the Selective Forwarding Unit (SFU): each browser publishes
one local stream to Janus and receives remote participant streams from Janus.

## Features

- Multi-participant video calls through the Janus VideoRoom SFU
- Joining and creating rooms with display names
- Local and remote audio/video streams
- Microphone and camera controls, plus controlled room exit
- HTTPS and WSS through NGINX in the Docker Compose environment
- ICE with a public STUN server in the browser and Coturn TURN fallback
- Automated Playwright and axe-core checks, plus manual keyboard and axe
  DevTools assessment

## Architecture

```text
Browser -- HTTPS/WSS --> NGINX -- HTTP --> frontend (Vite development server)
                           |
                           +-- WSS --> Janus WebSocket API / VideoRoom

Browser -- WebRTC media --> Janus VideoRoom SFU
Browser -- WebRTC media --> Coturn --> Janus, when TURN relay is needed
```

The browser signals directly with Janus through the NGINX WebSocket proxy;
there is no separate application signalling server. NGINX terminates HTTPS and
WSS, but WebRTC media does not pass through NGINX.

The browser gathers candidates using `stun:stun.l.google.com:19302` and the
Coturn TURN service. Janus itself uses Coturn for its STUN and TURN settings.
In normal use, ICE selects a suitable route; relay transport is not forced.

## Repository layout

```text
WebRTC-videocall/
├── frontend/                 React, TypeScript, Vite and Playwright tests
├── infrastructure/
│   ├── coturn/               Coturn configuration template
│   ├── janus/                Janus and VideoRoom configuration
│   ├── nginx/                HTTPS and WebSocket proxy configuration
│   └── ssl/                  Development certificate generation scripts
├── docker/                   Dockerfiles
├── thesis/                   Diploma thesis source (Typst)
├── docker-compose.yml        Local development environment
└── README.md
```

## Development environment

The environment has been developed and tested primarily with Windows, Docker
Desktop and PowerShell. Other operating systems may work, but they are not
claimed to be tested configurations.

Required software:

- Docker Desktop with Docker Compose v2
- OpenSSL available on `PATH` for generating development certificates
- Node.js only when running the frontend checks outside Docker

### 1. Clone the repository

```powershell
git clone https://github.com/Mayzanen/WebRTC-videocall.git
cd WebRTC-videocall
```

### 2. Create local deployment configuration

The TURN and Janus runtime configurations are intentionally local and ignored
by Git. Copy their templates before starting the stack:

```powershell
Copy-Item infrastructure\coturn\turnserver.conf.example infrastructure\coturn\turnserver.conf
Copy-Item infrastructure\janus\janus.jcfg.example infrastructure\janus\janus.jcfg
```

Edit `infrastructure/coturn/turnserver.conf` before using the stack outside a
controlled local environment:

- Replace `203.0.113.10` in the template. It is an address reserved for
  documentation and cannot be used as a working TURN server address. Set the
  external side of `external-ip` to the Docker host's actual public IPv4
  address.
- For the supplied Compose network, retain the internal `/172.18.0.10`
  mapping. If the Docker network is deliberately changed, its internal address
  must match the Coturn `external-ip` mapping and `relay-ip` setting.
- Replace the static development TURN username and password.
- Set the same TURN username and password in `infrastructure/janus/janus.jcfg`
  and in the `frontend` environment section of `docker-compose.yml`.

The fixed Docker address and the UDP relay port range are intentional parts of
the current deployment design. Do not change them merely as a configuration
cleanup step.

The browser receives TURN credentials as part of its ICE configuration. Values
named `VITE_*` are therefore browser-visible and must not be treated as server
secrets. The included static credential is only a development example; a real
deployment should use a suitable TURN credential mechanism and separate
deployment-specific configuration. The template does not provide working TURN
relay without these environment-specific settings.

### 3. Generate development certificates

Run this command from the repository root:

```powershell
.\infrastructure\ssl\generate-certs.ps1
```

The generated private key and certificates remain local because
`infrastructure/ssl/*.key`, `*.crt` and `*.pem` are ignored by Git. The script
creates a self-signed certificate for `videocall.local`, `localhost` and
`127.0.0.1`; use a certificate issued for the real host name in a deployment.

### 4. Configure the local host name

With administrator privileges, add the following line to
`C:\Windows\System32\drivers\etc\hosts`:

```text
127.0.0.1 videocall.local
```

### 5. Start the services

Run Docker commands from the repository root:

```powershell
docker compose up -d --build
docker compose ps
```

The frontend container deliberately runs Vite's development server. This is
appropriate for development and demonstrations, not a static production
frontend deployment.

### 6. Open the application

Open <https://videocall.local/> and accept the self-signed certificate warning
for local development. When prompted, allow camera and microphone access.

## Testing and checks

The following sequence can be run in one PowerShell window. It starts from the
repository root; the frontend commands use the `build`, `lint` and `test`
scripts defined in `frontend/package.json`.

```powershell
cd frontend
npm ci
npm run build
npm run lint
npx playwright install chromium
npm run test -- tests/home.spec.ts tests/accessibility.spec.ts
cd ..
```

The home-page and automated accessibility checks start a local Vite server and
do not require Docker Compose. They include the automated axe-core checks.

The call control tests create a real WebRTC and Janus session. The preceding
sequence has returned to the repository root, so start Docker Compose there,
then return to `frontend` for the test:

```powershell
docker compose up -d
cd frontend
$env:BASE_URL = 'https://videocall.local'
npm run test -- tests/call.spec.ts
```

The axe-core checks support the accessibility assessment, but do not establish
complete WCAG 2.1 conformance. Manual keyboard testing and axe DevTools checks
remain part of the assessment.

## Troubleshooting

### WebSocket connection fails

The browser-facing Janus endpoint is
`wss://videocall.local/janus`, not `wss://localhost/janus`. Verify the local
host-name mapping, development certificate and proxy logs:

```powershell
docker compose logs nginx
docker compose logs janus
```

### ICE or media connection fails

The browser configuration combines the public Google STUN server with the
local Coturn TURN server. Check the generated local configuration, Coturn logs,
the published UDP relay ports and the configured external address before
changing ICE behaviour:

```powershell
docker compose logs coturn
docker compose ps
```

Candidate gathering, SDP negotiation and successful media connectivity are
separate stages. A successful WebSocket connection alone does not prove that a
media path works.

### Rebuild after configuration changes

```powershell
docker compose up -d --build
```

Use `docker compose logs <service>` to inspect an individual service. Avoid
removing Docker images, volumes or caches before identifying the failing layer.

## Limitations and future work

This prototype has known boundaries:

- It does not automatically restore calls after a longer network interruption.
- Large-participant load and performance testing has not been performed.
- Browser and device testing is limited; mobile browsers were not tested.
- Complete WCAG 2.1 conformance has not been demonstrated.
- There is no user authentication or room-specific access control.
- The Vite development server is not a production server solution.

Potential future work includes automatic reconnection after extended network
interruptions, broader performance and device testing, screen sharing, more
complete accessibility evaluation with assistive technologies and users, and
authentication and room permissions.

## License

No license file is currently included. Selecting a license remains the
repository owner's decision.

## Resources

- [Janus Gateway documentation](https://janus.conf.meetecho.com/docs/)
- [WebRTC API on MDN](https://developer.mozilla.org/en-US/docs/Web/API/WebRTC_API)
- [Coturn documentation](https://github.com/coturn/coturn)
