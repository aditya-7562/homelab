# Homelab Proxy Network

This document describes the homelab_proxy Docker network, which serves as the shared ingress and service-routing network for the system.

It is a deliberately shared network with clearly defined responsibilities.

## Purpose of homelab_proxy

The homelab_proxy network exists to:

- Allow Nginx Proxy Manager to route traffic to backend services
- Enable container-to-container communication without host port exposure
- Centralize ingress control

Without this network, each service would require direct port exposure, increasing complexity and risk.

## Network Type

- Docker bridge network
- Created externally
- Referenced by multiple Docker Compose stacks

This allows independent service stacks to attach to the same network.

## Services Attached

The following services connect to homelab_proxy:

- Nginx Proxy Manager
- Jenkins
- n8n
- Portfolio service

Only services that must be reachable via the reverse proxy are attached.

## DNS and Service Discovery

Docker provides:

- Automatic DNS resolution by container name
- Stable internal IP addressing

Nginx Proxy Manager routes requests using:

- Container names
- Internal container ports

No hardcoded IPs are used.

## Security Considerations

### Benefits

- No need to expose backend service ports
- Reduces host-level attack surface
- Centralizes TLS termination

### Risks

- Shared network increases blast radius if proxy is compromised
- Misconfiguration can affect multiple services

These risks are accepted and documented.

## Failure Behavior

### Network Failure

- All proxy-routed services become unreachable
- Containers remain running

### Service Failure

- Only the affected service is unavailable
- Other services remain healthy

This distinction simplifies debugging.

## Why Not Per-Service Networks?

Per-service networks were considered but rejected because:

- Reverse proxy requires shared visibility
- Added complexity provided little security gain
- Single-operator system

This trade-off favors clarity.

## Future Improvements (Not Implemented)

Possible future enhancements:

- Split ingress and east-west traffic
- Introduce mTLS
- Enforce network policies via orchestration

Deferred until system complexity justifies them.

## Summary

The homelab_proxy network is:

- A shared ingress fabric
- A routing dependency
- A conscious trade-off

It reinforces a core SRE principle:

> Shared infrastructure must have clear ownership and scope.