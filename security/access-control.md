# Access Control

This document describes who can access what in the system and how access is controlled.

Access control is intentionally simple and centralized, reflecting the project’s single-operator, single-node scope.

The focus is on preventing accidental or unauthorized access, not on fine-grained enterprise RBAC.

## Access Control Philosophy

The system follows four principles:

1. Human access is explicit
2. Automation access is scoped
3. Administrative access is limited
4. Nothing is publicly writable

Every access path should be explainable in one sentence.

## SSH Access (VM-Level)

### Authentication

- SSH key-based access only
- Password authentication disabled

### Authorized Users

- Single operator
- No shared keys

### Scope

Full VM access

Used for:

- Maintenance
- Recovery
- Debugging

Root login is avoided for routine operations.

## Jenkins Access

### User Access

- Jenkins UI protected by authentication
- Admin access restricted

### Permissions

**Admin user:**

- Manage credentials
- Manage pipelines

No multi-user RBAC implemented.

This reflects a single-operator environment.

## CI/CD Execution Context

### Pipeline Permissions

Pipelines execute with:

- Only required credentials
- Limited environment exposure

### Separation of Duties

- Humans trigger changes via Git
- Jenkins executes changes via pipelines
- No manual deployments are performed.

## Nginx Proxy Manager Access

### UI Access

- Protected by authentication
- Administrative access limited

### Permissions

Full access required to manage:

- Proxy hosts
- Certificates

No read-only roles are defined.

## n8n Access

### UI Access

- Authentication enabled
- No anonymous access

### Workflow Permissions

- Single operator manages workflows
- Credentials scoped per workflow

## Application Access

### External Access

- Read-only HTTP access
- No authenticated user actions

### Internal Access

- Containers communicate via Docker networks
- No service-to-service authentication

## What Is Explicitly Not Implemented

The following are intentionally excluded:

- Multi-user RBAC
- Identity federation
- Per-service identities
- Audit logging

These features are unnecessary for current scope.

## Risk Acceptance

Accepted risks include:

- Broad admin access for single operator
- No separation between operators

These risks are mitigated by:

- Limited system exposure
- Clear documentation
- Low operational complexity

## Future Enhancements (Not Implemented)

If the system evolves:

- Role-based access control
- Read-only roles
- Audit trails
- Service identities

These will be introduced when justified.

## Summary

Access control in this system is:

- Explicit
- Minimal
- Centralized

It aligns with the project's guiding principle:

> Simplicity is a security feature when scope is controlled.