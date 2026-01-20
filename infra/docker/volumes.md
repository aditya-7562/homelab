# Docker Volumes and Persistence

This document describes how persistent data is managed across containers using Docker volumes and bind mounts.

Persistence is required for:

- CI/CD state
- Automation workflows
- Certificates
- Application data

## Persistence Philosophy

The system follows these rules:

1. Containers are disposable
2. Data is not
3. Persistence is explicit
4. Backups are manual

Volumes exist to preserve state across container restarts and upgrades.

## Volume Types Used

### Bind Mounts

Bind mounts are used for:

- Jenkins home directory
- n8n data directory
- Nginx Proxy Manager configuration and certificates

They map host directories directly into containers.

### Named Volumes

Named volumes are used selectively where:

- Docker-managed lifecycle is preferred
- Direct host access is unnecessary

Most persistence in this system uses bind mounts for transparency.

## Service-Level Persistence

### Jenkins

Stores:

- Job definitions
- Credentials
- Build history

Loss of volume = loss of CI/CD state

### Nginx Proxy Manager

Stores:

- Proxy configuration
- TLS certificates

Loss of volume = reconfiguration required

### n8n

Stores:

- Workflow definitions
- Encrypted credentials

Loss of volume = automation reset

### Portfolio Service

Stateless

No persistent storage required

## Backup Strategy

### Current State

- No automated backups
- Manual copy of volume directories when required

### Rationale

- Small data footprint
- Single operator
- Low change frequency

## Failure Implications

### Volume Corruption or Deletion

- Service state loss
- Requires manual reconstruction

This risk is accepted and documented.

## What Is Not Implemented

- Automated backups
- Snapshot scheduling
- Remote replication

These are deferred due to scope.

## Summary

Volume management in this system is:

- Explicit
- Minimal
- Transparent

It supports a core operational principle:

> State must be visible before it can be protected.