# Logging Strategy

This document describes the logging strategy used in the system and how logs are leveraged during normal operation and incident response.

Logging in this project is intentionally simple, centralized, and manual.
Logs are treated as the primary debugging signal.

## Logging Philosophy

The system follows these principles:

1. Logs over metrics for root cause
2. Human-readable over structured complexity
3. Centralize access, not storage
4. Do not log what you do not read

This avoids log sprawl without sacrificing debuggability.

## Log Sources

Logs are generated at three layers:

- Application containers
- Platform containers
- Host system

Each layer serves a distinct purpose.

## Application Logs

### Source

Application containers (e.g., portfolio service)

### Characteristics

- Written to stdout/stderr
- Captured by Docker logging driver
- Accessible via Docker CLI

### Access

```bash
docker logs <container-name>
```

### Use Cases

- Debugging application crashes
- Investigating deployment failures
- Verifying application startup

## Platform Logs

### Sources

- Jenkins
- Nginx Proxy Manager
- n8n

### Characteristics

- Written to container logs
- Persisted via Docker volumes when applicable

### Access

```bash
docker logs jenkins
docker logs nginx-proxy-manager
docker logs n8n
```

### Use Cases

- CI/CD failure analysis
- Reverse proxy routing issues
- Automation workflow failures

## Host-Level Logs

### Sources

- System services
- Docker daemon

### Access

- System journal
- Docker service logs

### Use Cases

- Diagnosing container runtime issues
- Identifying resource-related failures
- Debugging host-level problems

## Log Retention

- Logs are retained as long as containers exist
- No log rotation or archiving is implemented
- Old logs are discarded when containers are recreated

This approach trades historical analysis for simplicity.

## What Is Not Implemented

The following are intentionally excluded:

- Centralized log aggregation
- Structured log indexing
- Log-based alerting
- Long-term retention

These features are deferred due to:

- Low log volume
- Manual incident response
- Single-node scope

## Logging During Incidents

During incidents, logs are used to:

- Confirm failure type
- Identify failure origin
- Validate recovery actions

Logs are inspected after service restoration, not during it.

## Known Limitations

- No cross-service correlation
- No search or filtering beyond CLI tools
- Logs are lost if containers are removed

These limitations are accepted and documented.

## Future Extensions (Not Implemented)

Possible future improvements include:

- Centralized log collection (e.g., ELK stack)
- Structured logging formats
- Retention policies

These will be evaluated only if log volume and operational complexity increase.

## Summary

The logging strategy is:

- Minimal
- Transparent
- Operator-focused

It supports the system's primary goal:

> Debugging real failures without unnecessary tooling.