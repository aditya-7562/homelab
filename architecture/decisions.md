# Architecture Decisions

This document captures the **intentional architectural decisions** made in this project.
Each decision reflects a conscious trade-off aligned with the project’s scope: a **single-node, production-inspired SRE homelab**.

The goal is not architectural perfection, but **clarity, debuggability, and operational realism**.

---

## 1. Single VM Architecture

### Decision
The entire platform runs on a **single GCP virtual machine**.

### Rationale
- Keeps failure modes **observable and understandable**
- Avoids distributed-system complexity that adds little learning value at this stage
- Mirrors early-stage or internal tooling setups commonly found in real companies

### Trade-offs
| Pros | Cons |
|----|----|
| Simple networking | No high availability |
| Easy debugging | Single point of failure |
| Low cost | No horizontal scaling |

### Why this is acceptable
High availability is **explicitly out of scope**.  
Downtime during deployments and failures is acceptable and documented.

---

## 2. Docker + Docker Compose (Instead of Kubernetes)

### Decision
Services are orchestrated using **Docker Compose**, not Kubernetes.

### Rationale
- Compose provides:
  - Explicit service definitions
  - Predictable networking
  - Fast feedback loops
- Kubernetes would obscure:
  - Container lifecycle visibility
  - Networking fundamentals
  - Failure root causes

### Trade-offs
| Docker Compose | Kubernetes |
|--------------|------------|
| Simple & readable | Powerful but complex |
| Low operational overhead | Requires cluster management |
| Single-node friendly | Designed for multi-node |

### Future Direction
Kubernetes is **not rejected**, only postponed.  
The current setup establishes a baseline that can later be migrated to Kubernetes with clear before/after comparisons.

---

## 3. Shared Reverse Proxy Network (`homelab_proxy`)

### Decision
All externally exposed services attach to a shared external Docker network:  
`homelab_proxy`

### Rationale
- Centralizes ingress control
- Simplifies TLS termination
- Prevents services from exposing ports directly to the host unless required

### Benefits
- Clear separation between:
  - Ingress (proxy)
  - Application services
- Enables hostname-based routing
- Reduces accidental port exposure

### Trade-offs
- Network becomes a shared dependency
- Proxy misconfiguration can affect multiple services

This trade-off is **intentional** and explored in failure simulations.

---

## 4. Nginx Proxy Manager Instead of Raw Nginx

### Decision
Nginx Proxy Manager (NPM) is used for reverse proxy and TLS management.

### Rationale
- Provides:
  - UI-driven certificate management
  - Rapid iteration during experimentation
  - Reduced config friction for multiple services

### Trade-offs
| Benefit | Cost |
|------|------|
| Faster setup | UI abstraction hides config |
| Built-in Let's Encrypt | Less transparent than raw Nginx |

### Why this is acceptable
The project prioritizes **operational flow** over manual configuration mastery.  
Raw Nginx can replace NPM later without changing service topology.

---

## 5. Jenkins for CI/CD

### Decision
Jenkins is used as the CI/CD engine, running as a container.

### Rationale
- Demonstrates pipeline-as-code via Groovy
- Explicit control over build, deploy, and failure handling
- Mirrors legacy and hybrid environments still common in industry

### Trade-offs
| Pros | Cons |
|----|----|
| Highly flexible | Requires maintenance |
| Scriptable logic | UI can be misused |
| Industry relevance | Heavier than modern SaaS CI |

### Key Design Choice
Pipelines are **defined in code**, not manually configured in the UI.

---

## 6. Deployment Strategy: Recreate Container

### Decision
Deployments use **container recreation**, not rolling or blue/green strategies.

### Rationale
- Single-node environment
- Low-traffic application
- Downtime is acceptable

### Benefits
- Simple rollback via Git revert
- Predictable state transitions
- Minimal operational complexity

### Trade-offs
- Brief downtime during deploy
- No parallel version testing

This mirrors many internal tools and admin dashboards in real systems.

---

## 7. Observability: Minimal but Honest

### Decision
Observability relies on:
- Docker logs
- Host-level metrics
- Basic uptime checks

### Rationale
- Avoids false confidence from unused dashboards
- Forces direct interaction with system state
- Encourages understanding before tooling

### Explicit Non-Decisions
- No Prometheus
- No Grafana
- No alerting pipelines

These are **documented gaps**, not forgotten features.

---

## 8. Security Posture: Practical Baseline

### Decision Summary
- SSH: key-based only
- Secrets: Jenkins credentials store
- Firewall: GCP-level rules
- TLS: terminated at proxy

### Rationale
- Matches realistic early-stage setups
- Keeps security centralized and auditable
- Avoids embedding secrets in source control

### Known Limitations
- No secret rotation automation
- No runtime security scanning

These are acknowledged risks, not oversights.

---

## 9. Failure as a First-Class Concept

### Decision
Failure scenarios are **intentionally introduced and documented**.

### Covered Failures
- CI system crash
- Reverse proxy misconfiguration
- Application container crash

### Why this matters
SRE work begins **after things break**.  
This project optimizes for recovery clarity, not illusionary stability.

---

## Final Note

Every decision in this project answers one question:

> “What does this teach about operating real systems?”

When complexity does not increase learning value, it is rejected.
