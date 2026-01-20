# Portfolio Service

The portfolio service is a **simple HTTP application** used to demonstrate
how applications are deployed, exposed, and recovered in a production-inspired environment.

The service itself is intentionally low-complexity so that **operational behavior** remains the focus.

---

## Purpose of This Service

This service exists to:
- Provide a real deployment target
- Exercise CI/CD pipelines
- Validate reverse proxy routing
- Demonstrate failure and recovery scenarios

It is not meant to showcase application-level complexity.

---

## Deployment Model

The portfolio service runs as a Docker container built from source.

### Characteristics
- Built via Jenkins pipeline
- Deployed using Docker Compose
- Attached to the `homelab_proxy` network
- Exposed internally on port `80`

External access is provided exclusively through Nginx Proxy Manager.

---

## CI/CD Integration

### Trigger
- Push to `main` branch on GitHub

### Deployment Flow
1. Jenkins pulls latest code
2. Docker image is rebuilt
3. Existing container is stopped
4. New container is started

This is a **recreate-style deployment**.

---

## Downtime Characteristics

- Brief downtime during container recreation
- Downtime is acceptable by design
- No traffic shifting or version overlap

This reflects real-world internal tools and low-traffic services.

---

## Rollback Strategy

### Method
- Git revert to previous stable commit
- Redeploy via Jenkins

### Benefits
- Simple
- Auditable
- Source-of-truth remains Git

No image registry rollback logic is required.

---

## Networking

- Service does not expose ports directly to the host
- Communication occurs over Docker network
- Identified by container name via Docker DNS

This avoids tight coupling to host IPs.

---

## Failure Scenarios

### Application Container Crash
- Service becomes unavailable
- Reverse proxy remains healthy
- Restart restores service

This demonstrates clean separation between ingress and application layers.

---

### Bad Deployment
- New container fails to start
- Jenkins pipeline fails
- System remains on last working version

Partial deployments are avoided.

---

## Observability

### Available Signals
- Container logs
- Jenkins build logs
- Basic uptime verification via HTTP

No application-level metrics are implemented.

---

## Security Considerations

- No secrets baked into image
- No direct public port exposure
- TLS handled upstream

Security responsibility is delegated appropriately.

---

## Why This Is Enough

The portfolio service:
- Is realistic enough to deploy
- Is simple enough to debug
- Exposes meaningful operational behavior

This aligns with the project’s goal: **demonstrating reliability thinking, not application complexity**.

---

## Summary

This service serves as:
- A CI/CD testbed
- A routing validation target
- A controlled failure surface

Its simplicity is intentional and strategic.
