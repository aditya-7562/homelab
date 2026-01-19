# GCP Firewall Rules

This document describes the **network exposure strategy** for the homelab at the Google Cloud Platform (GCP) firewall level.

Firewall rules are enforced **before traffic reaches the VM**, making them the primary security boundary for the system.

---

## Design Principles

The firewall configuration follows four core principles:

1. **Explicit exposure** – only required ports are opened
2. **Centralized ingress** – most traffic flows through the reverse proxy
3. **Minimal attack surface** – no wildcard or unnecessary rules
4. **Cloud-first enforcement** – security is handled at the infrastructure edge

---

## Inbound Firewall Rules

### Allowed Ports

| Port | Service | Reason |
|----|--------|-------|
| 22 | SSH | Administrative access (key-based only) |
| 80 | HTTP | Redirected to HTTPS via proxy |
| 443 | HTTPS | Primary ingress for all services |
| 81 | Nginx Proxy Manager | Proxy administration |
| 8080 | Jenkins | CI/CD UI and webhook receiver |
| 5678 | n8n | Temporary debug access |

These rules are applied **only to this VM** via instance targeting.

---

## Port Exposure Rationale

### Port 22 – SSH
- Required for VM administration
- Restricted to key-based authentication
- No password login allowed

---

### Port 80 – HTTP
- Used only for:
  - Initial HTTP requests
  - Let’s Encrypt ACME challenges
- All traffic is redirected to HTTPS

---

### Port 443 – HTTPS
- Primary ingress for all user-facing services
- TLS is terminated at Nginx Proxy Manager
- Backend services are never exposed directly

---

### Port 81 – Nginx Proxy Manager UI
- Required for:
  - Managing proxy hosts
  - Certificate lifecycle
- Access should be restricted to trusted IPs when possible

This port represents a **high-value administrative surface**.

---

### Port 8080 – Jenkins UI
- Used for:
  - Pipeline monitoring
  - Webhook-triggered CI/CD
- Exposed intentionally to allow GitHub webhook delivery

In a stricter setup, this would be gated via VPN or IP allowlist.

---

### Port 5678 – n8n
- Used only during:
  - Workflow testing
  - Debugging
- Not required for normal operation once reverse proxy routing is active

This port is a **temporary exposure**, not a permanent dependency.

---

## Denied Traffic

All other inbound traffic is implicitly denied.

This includes:
- Unused application ports
- Container-internal ports
- Docker daemon access
- Random high ports

The default-deny posture ensures accidental exposure is avoided.

---

## Outbound Traffic

### Policy
- All outbound traffic is allowed

### Rationale
- Required for:
  - OS updates
  - Docker image pulls
  - GitHub access
  - Let’s Encrypt certificate issuance

Outbound restriction is deferred to keep the system functional and debuggable.

---

## Interaction with Host Firewall

- No UFW or iptables rules are configured inside the VM
- Cloud firewall rules are treated as the **single source of truth**

This avoids rule duplication and confusion during troubleshooting.

---

## Security Trade-offs

### Accepted Risks
- Administrative UIs exposed on public IP
- No IP-based allowlists enforced yet

### Mitigations
- Strong authentication
- TLS encryption
- Minimal port surface
- Clear documentation of risk

These trade-offs are acceptable for the project’s scope and audience.

---

## Failure Scenarios

### Misconfigured Firewall Rule
- Service becomes unreachable
- No partial failure — traffic is blocked entirely
- Diagnosis starts at cloud firewall, not container layer

This reinforces the importance of layered debugging.

---

## Summary

The firewall setup:
- Exposes only what is necessary
- Centralizes ingress control
- Makes network boundaries explicit

It favors **clarity and safety** over convenience.
