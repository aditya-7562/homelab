# Recovery Playbooks

This document provides **explicit, step-by-step recovery procedures** for known failure scenarios.
The goal is to reduce guesswork during incidents and ensure consistent recovery actions.

These playbooks assume:
- Single-VM deployment
- Docker-based services
- No automated self-healing

---

## Playbook Principles

- Prefer **simple, reversible actions**
- Restore service before root cause analysis
- Avoid manual state mutation where possible
- Every step should be executable by a human under pressure

---

## Playbook 1: Jenkins Unavailable

### Symptoms
- Jenkins UI unreachable
- CI/CD pipelines not running
- GitHub webhook events not processed

### Verification
```bash
docker ps -a | grep jenkins
```

### Recovery Steps

1. Restart Jenkins container:
```bash
docker compose up -d jenkins
```

2. Verify UI access on port 8080

3. Trigger a test pipeline

### Post-Recovery

- Review Jenkins logs
- Confirm no pipelines were partially executed

---

## Playbook 2: Reverse Proxy Misrouting

### Symptoms

- HTTP 404 / 502 errors
- TLS errors for specific hostnames
- Backend containers healthy but unreachable

### Verification

- Access Nginx Proxy Manager UI
- Inspect affected proxy host configuration

### Recovery Steps

1. Correct hostname and backend mapping
2. Reload proxy configuration
3. Validate service via HTTPS

### Post-Recovery

- Confirm other services remain reachable
- Review recent configuration changes

---

## Playbook 3: Application Container Crash

### Symptoms

- Application endpoint unreachable
- Reverse proxy healthy
- Container in exited state

### Verification
```bash
docker ps -a | grep portfolio
```

### Recovery Steps

1. Restart the container:
```bash
docker compose up -d portfolio
```

2. Monitor logs:
```bash
docker logs portfolio
```

### Post-Recovery

- Identify crash cause
- Decide whether redeployment is required

---

## Playbook 4: Failed Deployment

### Symptoms

- Jenkins pipeline fails
- New version does not start
- Errors during container startup

### Verification

- Inspect Jenkins build logs
- Check container status

### Recovery Steps

1. Identify faulty commit
2. Revert commit in Git:
```bash
git revert <commit-hash>
git push origin main
```

3. Allow Jenkins to redeploy

### Post-Recovery

- Confirm service availability
- Document failure cause

---

## Playbook 5: Resource Exhaustion

### Symptoms

- High CPU or memory usage
- Slow responses
- Container restarts

### Verification
```bash
docker stats
df -h
```

### Recovery Steps

1. Stop non-essential containers
2. Restart affected services
3. Free disk space if needed

### Post-Recovery

- Identify resource-hungry processes
- Adjust workloads

---

## What This System Does NOT Do Automatically

- No auto-restarts beyond Docker defaults
- No alert-triggered remediation
- No traffic shifting

These omissions are intentional and documented.

---

## Incident Ownership Model

- One operator performs recovery
- Actions are serialized
- No concurrent remediation

This reduces risk in small systems.

---

## Summary

These playbooks ensure:

- Predictable recovery
- Minimal guesswork
- Clear operational ownership

They reflect how real on-call runbooks look in practice.