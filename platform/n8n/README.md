# n8n (Automation Platform)

n8n is used as a **general-purpose automation layer** in this homelab.
It handles event-driven workflows that do **not** belong in CI/CD pipelines.

In this system:
- Jenkins = code lifecycle automation
- n8n = operational and workflow automation

This separation is intentional.

---

## Why n8n Exists in This System

Not all automation is deployment-related.

n8n is suited for:
- Event-driven workflows
- Scheduled tasks
- External integrations
- Non-deployment automation

Embedding this logic in Jenkins would blur responsibilities and increase coupling.

---

## Deployment Model

n8n runs as a Docker container managed via Docker Compose.

### Characteristics
- Persistent storage for:
  - Workflow definitions
  - Credentials
  - Execution history
- Attached to the shared `homelab_proxy` network
- Reverse proxied via Nginx Proxy Manager

Direct port exposure is used only during debugging.

---

## Webhook and URL Configuration

n8n operates behind a reverse proxy and requires explicit configuration.

### Key Settings
- Public host and protocol defined
- Webhook URLs resolved via reverse proxy hostname
- Internal service communication remains HTTP

This avoids webhook signature mismatch issues commonly seen behind proxies.

---

## Example Use Cases

Typical workflows include:
- Notifications triggered by system events
- Scheduled health checks
- Automation around CI outcomes
- Glue logic between services

These workflows are **orthogonal to deployment logic**.

---

## Security Model

### Credentials
- Stored encrypted in n8n data volume
- Never committed to source control

### Access
- UI exposed only via HTTPS
- Authentication enabled

No anonymous access is allowed.

---

## Failure Scenarios

### n8n Container Crash
- Automation workflows stop executing
- Core services continue unaffected
- Recovery requires container restart

This isolates automation failures from system availability.

---

### Misconfigured Webhook
- Individual workflow fails
- No impact on unrelated workflows or services

Failure blast radius is deliberately limited.

---

## Observability

n8n provides:
- Execution logs per workflow
- Failure traces
- Retry visibility

External alerting is not yet implemented.

---

## Why n8n Is Not Overused

n8n is **not**:
- A CI engine
- A scheduler replacement for system cron
- A monitoring system

Its scope is deliberately constrained to workflow automation.

---

## Summary

n8n provides:
- Event-driven automation
- Clear separation from CI/CD
- Controlled failure domains

It reinforces the SRE principle that **automation should be purpose-built, not overloaded**.
