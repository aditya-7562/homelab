# Jenkins (CI/CD Engine)

Jenkins is used as the **central automation engine** for this homelab.
It is responsible for turning code changes into **repeatable, observable deployments**.

In this system, Jenkins is not treated as a UI tool — it is treated as **infrastructure**.

---

## Why Jenkins

### Decision
Jenkins is used instead of managed CI services (e.g., GitHub Actions).

### Rationale
- Full control over:
  - Execution environment
  - Pipeline logic
  - Failure behavior
- Pipeline-as-code via Groovy
- Commonly found in real-world, mixed-maturity environments

This choice emphasizes **automation literacy** over convenience.

---

## Deployment Model

Jenkins runs as a Docker container managed by Docker Compose.

### Characteristics
- Persistent volume for:
  - Job definitions
  - Build history
  - Credentials
- Exposed on port `8080`
- Attached to the shared `homelab_proxy` network

The Jenkins master itself is **stateless at runtime**, with state stored on disk.

---

## Docker-in-Docker (DinD)

### Purpose
Jenkins requires the ability to:
- Build Docker images
- Manage application containers

This is achieved using a **Docker-in-Docker sidecar container**.

### Design
- Jenkins communicates with DinD over an internal Docker network
- DinD runs in privileged mode
- Docker socket is not mounted into Jenkins

### Trade-offs
| Benefit | Cost |
|------|------|
| Isolation from host Docker | Privileged container |
| Clean Docker environment | Higher attack surface |

This trade-off is accepted for learning and clarity.

---

## Pipeline Model

### Trigger
- GitHub webhook on push to `main` branch

### Behavior
Pipelines are defined in code and:
1. Pull the latest repository state
2. Build application Docker images
3. Recreate running containers using Docker Compose
4. Fail fast on errors

No manual UI steps are required after initial setup.

---

## Rollback Strategy

### Mechanism
- Git revert to last known good commit
- Redeploy via Jenkins pipeline

### Why This Works
- Application state is version-controlled
- Deployments are deterministic
- Rollback is explicit and auditable

This avoids complex image tagging or registry logic.

---

## Failure Scenarios

### Jenkins Container Crash
- CI/CD pipelines become unavailable
- Running applications remain unaffected
- Recovery requires restarting Jenkins container

This separation ensures CI failures do not cascade into runtime outages.

---

### Pipeline Failure
- Deployment halts
- No partial state is applied
- System remains in last known good state

Failures are visible and actionable.

---

## Security Model

### Credentials
- Secrets stored in Jenkins credential store
- No secrets committed to repository

### Access
- Jenkins UI protected via authentication
- Admin access limited

### Known Limitations
- No credential rotation automation
- No RBAC segmentation

These are documented, not ignored.

---

## Observability

Jenkins provides:
- Build logs
- Execution history
- Failure traceability

External monitoring is intentionally not layered on top at this stage.

---

## Why Jenkins Runs in a Container

- Reproducible environment
- Easy recovery
- Clear dependency boundaries

Jenkins is treated as **replaceable infrastructure**, not a pet server.

---

## Summary

Jenkins serves as:
- The automation backbone
- The CI/CD control plane
- A deliberate failure domain

It reinforces the principle that **reliability starts with repeatable automation**.
