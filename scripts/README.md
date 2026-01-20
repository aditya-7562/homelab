# Operator Scripts

This directory contains operator-facing scripts used to bootstrap, protect, and recover the system.

These scripts are intentionally:

- Simple
- Manual
- Explicit

They prioritize predictable recovery over automation complexity.

## Script Inventory

| Script | Purpose |
| --- | --- |
| bootstrap.sh | Bring a fresh VM to a running platform |
| backup.sh | Create a point-in-time backup of persistent state |
| restore.sh | Restore system state from a backup archive |

Each script addresses a specific operational phase.

## bootstrap.sh — System Bring-Up
When to Use

- Initial VM setup
- VM recreation after failure
- Clean environment rebuild

What It Does

- Installs Docker and Docker Compose
- Creates required Docker networks
- Prepares directory structure
- Starts all core services

What It Does Not Do

- Configure applications
- Restore data
- Apply security hardening

Bootstrap prepares the platform, not its state.

## backup.sh — State Protection
When to Use

- Before risky changes
- Periodically during normal operation
- Prior to VM shutdown or rebuild

What It Backs Up

- Jenkins state
- Nginx Proxy Manager configuration and certificates
- n8n workflows and credentials

What It Does Not Back Up

- Containers
- Images
- OS configuration

Only persistent state is archived.

## restore.sh — Disaster Recovery
When to Use

- After VM rebuild
- After data loss
- During disaster recovery drills

What It Does

- Stops running services
- Restores backed-up data
- Restarts all services

Safety Measures

- Requires explicit confirmation
- Overwrites existing data only after operator approval
- Recovery is deliberate, not automatic

## Operational Assumptions

These scripts assume:

- Single-VM deployment
- Docker-based services
- Manual operator control
- No automated remediation

They are designed for human-in-the-loop operation.

## Failure Handling Philosophy

These scripts support a core reliability principle:

> Recovery should be simple, documented, and boring.

No script attempts to:

- Guess operator intent
- Automatically remediate failures
- Hide destructive actions

## Limitations

- No automated scheduling
- No remote backup storage
- No integrity verification
- No rollback during restore

These limitations are acknowledged and accepted.

## Future Enhancements (Not Implemented)

If system complexity increases:

- Scheduled backups
- Remote storage integration
- Restore verification checks
- Partial restores

These are deferred until operational need arises.

## Summary

The scripts in this directory:

- Enable reproducible setup
- Protect critical state
- Support manual disaster recovery

They complete the system’s operational lifecycle.