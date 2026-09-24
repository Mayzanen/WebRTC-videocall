# NGINX Configuration

This directory contains the NGINX reverse proxy configuration for the VideoRTC application.

## Purpose

NGINX serves as a reverse proxy that:
1. **HTTPS Termination**: Handles SSL/TLS for secure connections (required for WebRTC)
2. **Routing**: Routes requests to appropriate backend services
3. **WebSocket Proxy**: Proxies WebSocket connections to Janus
4. **Frontend Proxy**: Proxies the Vite development server
5. **Security**: Adds security headers and rate limiting

## Routes

### Frontend
- `https://<host>/` → React app (frontend:5173)
- WebSocket support for Vite HMR

### Janus WebSocket
- `wss://<host>/janus` → Janus WebSocket (janus:8089)
- WebSocket connection for real-time signaling

### Janus HTTP API (Optional)
- `https://localhost/janus-api/` → Janus REST API (janus:8088)
- For non-WebSocket requests

### Health Check
- `https://localhost/health` → Health check endpoint

## Security Features

### SSL/TLS
- TLS 1.2 and 1.3
- Strong cipher suites
- HSTS enabled

### Headers
- `X-Frame-Options: SAMEORIGIN`
- `X-Content-Type-Options: nosniff`
- `X-XSS-Protection: 1; mode=block`

### Rate Limiting
- API: 10 requests/second
- WebSocket: 5 connections/second
- Burst allowance: 20

## Configuration Details

### SSL Certificates
Location: `/etc/nginx/certs/`
- `server.crt` - Certificate
- `server.key` - Private key

### Timeouts
- WebSocket: 7 days (keep-alive)
- HTTP: 65 seconds

### Compression
Gzip enabled for:
- Text files (HTML, CSS, JS)
- JSON/XML
- Fonts
- SVG images

## Testing

### Test NGINX
```bash
# Check configuration
docker exec videortc-nginx nginx -t

# Reload configuration
docker exec videortc-nginx nginx -s reload

# View logs
docker logs videortc-nginx
```

### Test endpoints
```bash
# Health check
curl -k https://localhost/health

# Frontend (should return HTML)
curl -k https://localhost/

# Janus API (should return Janus info)
curl -k https://localhost/janus-api/info
```

## Production Considerations

For production:
1. Use real SSL certificates (Let's Encrypt)
2. Set proper `server_name`
3. Adjust rate limits based on traffic
4. Enable access logs with rotation
5. Add IP whitelisting if needed
6. Configure upstream health checks
7. Add caching for static assets

## Troubleshooting

### Common Issues

**502 Bad Gateway**
- Backend service not running
- Check: `docker ps` and `docker logs <service>`

**WebSocket connection fails**
- Check proxy settings for `Upgrade` header
- Verify timeouts are sufficient

**SSL certificate errors**
- Regenerate certificates with correct SAN
- Check certificate paths in config

**Rate limit errors (429)**
- Adjust `limit_req_zone` settings
- Increase burst allowance
