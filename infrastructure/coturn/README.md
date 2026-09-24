# Coturn Configuration

This directory contains the Coturn TURN/STUN server configuration.

## What is Coturn?

Coturn is the STUN/TURN service used by browser-to-Janus WebRTC connections.
It provides relay candidates when direct connectivity to the Janus VideoRoom
SFU is unavailable.

## Configuration

The `turnserver.conf` file contains:
- **STUN**: For NAT discovery (port 3478)
- **TURN**: For relaying media when direct connection fails (ports 10000-10200)
- **Credentials**: Static development user (`videouser:videopass`)

## Ports

- `3478` - STUN/TURN UDP
- `5349` - TURN TLS listener (not used by the current frontend)
- `10000-10200` - Media relay ports

## Current deployment settings

The Compose network assigns Coturn the fixed address `172.18.0.10`. Its
`external-ip` setting maps that address to the deployment public IP. Both
values must be updated together when moving the stack to another host.

`no-tcp-relay` disables TCP relay endpoints; it does not disable TURN over UDP.

## Development Credentials

```javascript
const iceServers = [
  { urls: 'stun:localhost:3478' },
  {
	urls: 'turn:localhost:3478',
	username: 'videouser',
	credential: 'videopass'
  }
];
```

## Production Considerations

For production:
1. Use dynamic credentials with REST API
2. Set proper external IP
3. Use TLS (port 5349)
4. Configure database (Redis/PostgreSQL)
5. Use strong passwords
6. Enable rate limiting

## Testing

Test STUN server:
```bash
# Using webrtc-tester or browser console
const pc = new RTCPeerConnection({
  iceServers: [{ urls: 'stun:localhost:3478' }]
});
```

## Monitoring

Check logs:
```bash
docker logs videortc-coturn
```
