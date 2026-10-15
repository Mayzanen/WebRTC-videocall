# VideoRTC - WebRTC Video Call Application

Browser-based multi-participant video-call application built with **React**,
**TypeScript**, **Janus Gateway**, and **WebRTC**. Janus VideoRoom acts as an
SFU: each browser publishes one local stream to Janus and receives remote
participant streams from Janus. This is not a peer-to-peer mesh application.

## 🚀 Features

- 📹 Multi-participant real-time video calling through the Janus VideoRoom SFU
- 🎤 Audio/Video controls
- 🔒 Secure HTTPS connections
- 🐳 Docker-based deployment
- ♿ Keyboard-accessible controls with SVG icons and accessible names

## 🏗️ Architecture

### Tech Stack

- **Frontend**: React 18 + TypeScript + Vite
- **WebRTC Gateway**: Janus Gateway (VideoRoom plugin)
- **TURN/STUN**: Coturn server for NAT traversal
- **Reverse Proxy**: NGINX with SSL termination
- **Containerization**: Docker + Docker Compose

### Project Structure

```
videortc/
├── frontend/                 # React frontend application
│   ├── src/
│   │   ├── components/      # React components
│   │   ├── pages/           # Page components
│   │   ├── services/        # Janus & WebRTC services
│   │   ├── App.tsx          # Main app component
│   │   └── main.tsx         # Entry point
│   ├── package.json
│   ├── tsconfig.json
│   └── vite.config.ts
│
├── infrastructure/          # Configuration files
│   ├── janus/              # Janus Gateway config
│   ├── coturn/             # TURN/STUN server config
│   ├── nginx/              # NGINX reverse proxy config
│   └── ssl/                # SSL certificates
│
├── docker/                  # Dockerfiles
│   ├── frontend.Dockerfile
│   ├── janus.Dockerfile
│   └── nginx.Dockerfile
│
├── docker-compose.yml       # Docker orchestration
├── thesis/                   # Diploma thesis source (Typst)
└── README.md
```

## 📋 Prerequisites

- **Docker** 20.10+
- **Docker Compose** 2.0+
- **OpenSSL** (for certificate generation)

## 🔧 Setup

### 1. Clone the Repository

```bash
git clone <repository-url>
cd videortc
```

### 2. Generate SSL Certificates

SSL certificates are required for WebRTC (HTTPS/WSS connections).

**Linux/Mac/WSL:**
```bash
cd infrastructure/ssl
chmod +x generate-certs.sh
./generate-certs.sh
cd ../..
```

**Windows (PowerShell):**
```powershell
cd infrastructure\ssl
.\generate-certs.ps1
cd ..\..
```

### 3. Configure the Development Host Name

The Compose environment uses `videocall.local` for the browser-facing Janus
and TURN endpoints. For a local single-machine setup, map the name to the
machine running NGINX in the hosts file (with administrator privileges):

```text
127.0.0.1 videocall.local
```

When moving the stack to another host, update the certificate subject
alternative names, the frontend connection settings and Coturn's deployment
address configuration together.

### 4. Build and Start Services

```bash
docker compose up -d --build
```

This will start:
- **Frontend** on port 5173, also proxied through NGINX
- **Janus Gateway** on ports 8088, 8089, 8188, and 20000-20200/UDP
- **Coturn** on ports 3478 and 5349 (TCP/UDP), with 10000-10200/UDP relay ports
- **NGINX** on ports 80 (HTTP redirect) and 443 (HTTPS)

### 5. Access the Application

Open your browser and navigate to:

```
https://videocall.local/
```

⚠️ **Note**: You'll see a security warning because we're using self-signed certificates. This is normal for development.

**How to proceed:**
- **Firefox**: Click "Advanced" → "Accept the Risk and Continue"
- **Chrome**: Click "Advanced" → "Proceed to videocall.local (unsafe)"
- **Safari**: Click "Show Details" → "visit this website"

## 🎮 Usage

### Starting a Video Call

1. **Enter Your Name**: Type your display name
2. **Create/Join Room**: 
   - Click "Generate" to create a new room, or
   - Enter an existing Room ID
3. **Click "Join Call"**: Grant camera/microphone permissions when prompted
4. **Share Room ID**: Give the Room ID to someone else to join

### During a Call

- **Toggle Audio**: Mute/unmute your microphone
- **Toggle Video**: Turn camera on/off
- **End Call**: Leave the room and return to home

## 🐳 Docker Services

### View Logs

```bash
# All services
docker compose logs -f

# Specific service
docker compose logs -f frontend
docker compose logs -f janus
docker compose logs -f nginx
docker compose logs -f coturn
```

### Restart Services

```bash
# All services
docker compose restart

# Specific service
docker compose restart frontend
```

### Stop Services

```bash
docker compose down
```

### Rebuild After Changes

```bash
docker compose up -d --build
```

## 🔍 Troubleshooting

### Camera/Microphone Not Working

1. **Check browser permissions**: Make sure you've granted access
2. **Use HTTPS**: WebRTC requires secure connections
3. **Check browser console**: Look for error messages

### Connection Issues

1. **Check Janus logs**:
   ```bash
   docker compose logs janus
   ```

2. **Verify Coturn is running**:
   ```bash
   docker compose ps coturn
   ```

3. **Test STUN server** (in browser console):
   ```javascript
   const pc = new RTCPeerConnection({
	 iceServers: [{ urls: 'stun:localhost:3478' }]
   });
   ```

### WebSocket Connection Failed

1. **Check NGINX logs**:
   ```bash
   docker compose logs nginx
   ```

2. **Verify WebSocket endpoint**: Should be `wss://localhost/janus`

3. **Check NGINX config**: Ensure WebSocket proxy is configured correctly

### Docker Build Issues

1. **Rebuild the affected services**:
   ```bash
   docker compose up -d --build
   ```

2. **Check disk space** and inspect the relevant service logs before removing
   Docker images, volumes or caches.

## 🔐 Security Notes

### Development

- Self-signed certificates are used
- Static TURN credentials are used for controlled development and testing
- No authentication or authorization

### Production Recommendations

⚠️ **DO NOT use this setup in production without:**

1. **Real SSL Certificates**: Use Let's Encrypt or commercial CA
2. **TURN Authentication**: Implement dynamic credentials with REST API
3. **User Authentication**: Add login/signup system
4. **Rate Limiting**: Protect against abuse
5. **Monitoring**: Set up logging and alerting
6. **Network Security**: Configure firewall rules
7. **HTTPS Only**: Remove HTTP redirect option

## 📚 API Documentation

### Environment Variables

Frontend (`.env` or Docker Compose):
```env
VITE_JANUS_WS_URL=wss://<host>/janus
VITE_TURN_SERVER=turn:<host>:3478
VITE_TURN_USERNAME=<development-turn-user>
VITE_TURN_CREDENTIAL=<development-turn-credential>
```

Docker Compose supplies `videocall.local` development values. When the Vite
server is run directly without these variables, the client defaults to local
endpoints. `VITE_*` values are exposed to the browser, so they must not contain
production secrets. The included static TURN credentials are intended only for
controlled development and testing.

### Janus Configuration

Located in `infrastructure/janus/janus.jcfg`:
- WebSocket transport on port 8089
- VideoRoom plugin enabled
- ICE/STUN/TURN configuration

### NGINX Configuration

Located in `infrastructure/nginx/nginx.conf`:
- HTTPS on port 443
- WebSocket proxy to Janus
- Security headers
- Rate limiting

## 🧪 Testing

The Playwright suite covers the home-page form and validation
(`tests/home.spec.ts`), automated accessibility checks
(`tests/accessibility.spec.ts`), and the in-call controls (`tests/call.spec.ts`).

Install the frontend dependencies and the Chromium browser once:

```bash
cd frontend
npm ci
npx playwright install chromium
```

The home-page and accessibility tests start a local Vite server automatically;
they do not require the Docker stack:

```bash
npx playwright test tests/home.spec.ts tests/accessibility.spec.ts
```

The Call-page controls tests establish a real WebRTC and Janus session, so
they require the Docker Compose stack to be running and reachable through
`videocall.local`:

```powershell
docker compose up -d
cd frontend
$env:BASE_URL = 'https://videocall.local'
npx playwright test tests/call.spec.ts
```

With the stack running, execute all tests with `npx playwright test`; use
`npm run test:ui` for Playwright's interactive runner. The automated
accessibility checks use axe-core against WCAG 2.0/2.1 A and AA rule sets. They
support the accessibility assessment but do not demonstrate complete WCAG
conformance, so manual testing with axe DevTools and keyboard use is also
needed.

### Manual testing

1. Open two browser windows or devices.
2. Create a room in one browser and join it from the other.
3. Verify local and remote media, audio/video controls, leaving and rejoining.
4. Test with participants on different networks when TURN relay behaviour must
   be verified. Do not force relay transport in normal use: ICE selects the
   available path.

## 📦 Frontend build

```bash
cd frontend
npm ci
npm run build
```

Output in `frontend/dist/`

The Compose frontend service intentionally runs Vite's development server for
development and demonstration. Serving `frontend/dist/` as a static production
frontend is a separate deployment task.

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## 📝 License

No license file is currently included in the repository.

## 🆘 Support

For issues and questions:
1. Check the troubleshooting section
2. Review Docker logs
3. Open an issue on GitHub

## 🎯 Roadmap

MVP (Current):
- [x] Multi-participant video calling through the Janus VideoRoom SFU
- [x] Audio/video controls
- [x] Docker deployment
- [x] Self-signed SSL

Future Enhancements:
- [x] Multi-participant rooms through the Janus VideoRoom SFU
- [ ] Screen sharing
- [ ] Chat functionality
- [ ] Recording
- [ ] User authentication
- [ ] Room management UI
- [ ] Automatic recovery after a longer network interruption
- [ ] Load, performance, mobile-device and broader browser testing
- [x] E2E/accessibility testing with Playwright + axe-core (automated) and axe DevTools (manual)
- [ ] Accessibility evaluation with assistive technologies and user testing

## 📖 Resources

- [Janus Gateway Documentation](https://janus.conf.meetecho.com/docs/)
- [WebRTC MDN Guide](https://developer.mozilla.org/en-US/docs/Web/API/WebRTC_API)
- [Coturn Documentation](https://github.com/coturn/coturn)
- [React Router Documentation](https://reactrouter.com/)

---

**Made with ❤️ for learning WebRTC**
