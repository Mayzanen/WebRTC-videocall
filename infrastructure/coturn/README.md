# Coturn configuration

Coturn provides the TURN fallback used when a browser cannot establish a
direct media path to Janus. The browser gathers candidates from a public STUN
server and from Coturn TURN; Janus uses this Coturn instance for its own STUN
and TURN settings.

## Local configuration

`turnserver.conf` is deliberately ignored by Git because it contains the
deployment's public address and TURN credential. Create it from the tracked
template:

```powershell
Copy-Item turnserver.conf.example turnserver.conf
```

The template's `203.0.113.10` address is reserved for documentation and cannot
be used as a working TURN server address. Before deploying outside a controlled
local environment, replace the external side of `external-ip` with the Docker
host's actual public IPv4 address. For the supplied Compose network, retain
the fixed Docker relay address `172.18.0.10`; if the Docker network is
deliberately changed, update the internal side of `external-ip` and `relay-ip`
to match it. Keep the relay range `10000-10200/UDP` and its Docker port
publishing intact unless the network deployment is intentionally changed.

If the static development TURN credential is replaced, update the same value
in all of these locations:

1. The local `turnserver.conf` file.
2. The local `../janus/janus.jcfg` file.
3. The `VITE_TURN_USERNAME` and `VITE_TURN_CREDENTIAL` values in
   `docker-compose.yml`.

The browser receives its TURN credential through ICE configuration. It is not a
server secret, and a `VITE_*` variable does not protect it. Use an appropriate
credential mechanism for deployments rather than treating the development
credential as production authentication. The template cannot provide working
TURN relay until its address and matching credentials are set for the target
environment.

## Ports

- `3478/UDP` and `3478/TCP`: STUN/TURN listener
- `5349/UDP` and `5349/TCP`: TURN TLS listener
- `10000-10200/UDP`: TURN media relay

## Diagnostics

Run these commands from the repository root:

```powershell
docker compose ps coturn
docker compose logs coturn
```

ICE candidate gathering, SDP negotiation and media connectivity are separate
stages. Do not force relay transport or change Coturn settings based only on a
signalling or WebSocket error.
