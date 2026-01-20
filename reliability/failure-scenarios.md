# Failure Scenarios

This document enumerates **known, intentional failure scenarios** in the system.
Each scenario describes what breaks, what does not, and how the failure is detected.

Failures are treated as **expected system states**, not exceptional events.

---

## Design Philosophy

- Failures are inevitable
- Blast radius must be understood
- Recovery must be documented
- Silence is worse than downtime

This system is designed to **fail loudly and predictably**.

---

## Failure Scenario 1: Jenkins Container Crash

### Description
The Jenkins container stops unexpectedly or crashes.

### What Breaks
- CI/CD pipelines become unavailable
- New deployments cannot be triggered

### What Does NOT Break
- Running application containers
- Reverse proxy routing
- Existing traffic

### Detection
- Jenkins UI unreachable
- Pipeline jobs not executing
- Container status shows `exited`

### Recovery
1. Restart Jenkins container
2. Verify UI accessibility
3. Resume pipelines

### Blast Radius
- CI/CD only
- No runtime impact

---

## Failure Scenario 2: Nginx Proxy Manager Misconfiguration

### Description
A proxy host is misconfigured or deleted.

### What Breaks
- Affected service becomes unreachable
- TLS routing may fail for that hostname

### What Does NOT Break
- Other services
- Backend containers
- CI/CD pipelines

### Detection
- HTTP 404 / 502 errors
- Browser certificate errors
- NPM UI shows incorrect routing

### Recovery
1. Correct proxy configuration
2. Reload configuration
3. Validate routing

### Blast Radius
- Single service per misconfiguration

---

## Failure Scenario 3: Application Container Crash

### Description
The portfolio service container crashes or stops.

### What Breaks
- Application becomes unavailable

### What Does NOT Break
- Reverse proxy
- CI/CD pipelines
- Other services

### Detection
- HTTP request fails
- Container status indicates failure
- Logs show application error

### Recovery
1. Restart container
2. Investigate logs
3. Redeploy if required

### Blast Radius
- Single application

---

## Failure Scenario 4: Bad Deployment

### Description
A code change causes the new container to fail during deployment.

### What Breaks
- New version does not become available

### What Does NOT Break
- Previous deployment (until replacement attempt)
- Reverse proxy
- Other services

### Detection
- Jenkins pipeline failure
- Container startup error
- Application health check failure

### Recovery
1. Identify faulty commit
2. Revert commit
3. Redeploy via Jenkins

### Blast Radius
- Single service
- Short-lived outage

---

## Failure Scenario 5: VM Resource Exhaustion

### Description
CPU, memory, or disk usage reaches critical levels.

### What Breaks
- Containers may slow or crash
- CI jobs may fail

### What Does NOT Break
- Cloud firewall rules
- Persistent storage

### Detection
- Host metrics indicate saturation
- Container failures increase
- System responsiveness degrades

### Recovery
1. Free resources
2. Restart affected containers
3. Adjust workloads

### Blast Radius
- Potentially system-wide

---

## What Is Not Simulated

The following failures are acknowledged but not tested:
- Full VM loss
- Disk corruption
- Cloud-level networking outage

These are out of scope for a single-node homelab.

---

## Key Takeaways

- Failures are scoped and documented
- Most failures affect **only one layer**
- Recovery paths are clear and manual

This reinforces the core SRE concept:
> Reliability is not about preventing failure — it’s about surviving it.
