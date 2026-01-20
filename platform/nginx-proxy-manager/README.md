# Nginx Proxy Manager

Nginx Proxy Manager (NPM) acts as the **single ingress point** for all externally accessible services in this homelab.

It is responsible for:
- Receiving inbound HTTP/HTTPS traffic
- Terminating TLS
- Routing requests to backend containers
- Centralizing exposure control

In practical terms, **nothing reaches an application container without passing through NPM**.

---

## Why a Reverse Proxy Is Mandatory

Running services directly on exposed ports does not scale operationally.

A reverse proxy provides:
- One place to manage ingress
- One TLS termination layer
- One surface to audit and harden

Without this layer, every service becomes its own security and networking problem.

---

## Why Nginx Proxy Manager (Instead of Raw Nginx)

### Decision
NPM is used instead of manually managed Nginx configuration.

### Rationale
- Faster iteration during experimentation
- Built-in Let’s Encrypt integration
- Visual validation of routing rules
- Reduced risk of syntax-level misconfiguration

This project prioritizes **operational flow and clarity** over low-level config mastery.

---

## Deployment Model

NPM runs as a Docker container using Docker Compose.

### Key Characteristics
- Persistent storage for:
  - Configuration
  - Certificates
- Attached to the shared `homelab_proxy` Docker network
- Exposes only required ports to the host

All backend services remain unexposed at the host level unless explicitly required.

---

## Port Responsibilities

| Port | Purpose |
|----|--------|
| 80 | HTTP ingress (redirect to HTTPS) |
| 443 | HTTPS ingress |
| 81 | NPM administrative UI |

Ports 80 and 443 are the **only intended public entry points** for application traffic.

---

## TLS Strategy

### Certificate Management
- TLS certificates are issued via Let’s Encrypt
- Certificate lifecycle is managed by NPM
- Backend services communicate over plain HTTP inside Docker

### Benefits
- No TLS complexity inside application containers
- Clear separation of transport security and application logic
- Centralized certificate renewal

---

## Routing Strategy

Requests are routed based on:
- Hostname
- Protocol
- Port

Each service:
- Registers a hostname
- Exposes an internal port
- Relies on NPM for external access

This avoids:
- Port collisions
- Hardcoded IP usage
- Direct container exposure

---

## Dependency on Docker Networking

NPM relies on Docker DNS for service discovery.

### Implications
- Backend services must:
  - Share the `homelab_proxy` network
  - Use stable container names
- NPM does not require knowledge of host IPs

This keeps routing **container-native**, not host-dependent.

---

## Failure Scenarios

### NPM Container Crash
- All externally accessible services become unreachable
- Containers continue running internally
- Recovery requires restarting NPM only

This clearly establishes NPM as a **critical dependency**.

---

### Misconfigured Proxy Host
- Only the affected service becomes unavailable
- Other services remain functional
- Failure blast radius is limited by routing rules

This demonstrates controlled failure domains.

---

## Security Considerations

- Administrative UI exposed on a non-standard port (81)
- UI access protected by authentication
- TLS enforced for all public services

Known limitations:
- No IP allowlisting
- No WAF integration

These risks are accepted and documented.

---

## Operational Responsibilities

NPM is responsible for:
- Ingress availability
- Certificate health
- Correct routing

It is **not responsible for**:
- Application uptime
- Application errors
- CI/CD failures

Clear ownership simplifies debugging and accountability.

---

## Summary

Nginx Proxy Manager serves as:
- The system’s front door
- A traffic router
- A TLS termination layer

Its role is intentionally narrow but operationally critical.
