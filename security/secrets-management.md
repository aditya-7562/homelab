# Secrets Management

This document describes how secrets are stored, accessed, and protected in the system.

The approach is intentionally simple and centralized, aligned with the project's single-node scope and operational maturity.

Secrets management here focuses on reducing accidental exposure, not enterprise-grade secret rotation.

## What Counts as a Secret

In this system, secrets include:

- API keys
- Tokens
- Webhook secrets
- Credentials used by automation tools
- Application-level secrets (if any)

Anything that enables access or impersonation is treated as a secret.

## Where Secrets Are Stored

### Primary Store: Jenkins Credentials

All operational secrets are stored in the Jenkins Credentials Store.

**Characteristics:**

- Encrypted at rest by Jenkins
- Scoped per pipeline or job
- Injected into runtime environments when needed

Secrets are never committed to source control.

## How Secrets Are Used

### CI/CD Pipelines

- Secrets are injected as environment variables
- Scope is limited to pipeline execution
- Secrets are not logged or echoed

### Automation Workflows

- Credentials are stored in tool-specific encrypted stores (e.g., n8n)
- Access is limited to workflow execution context

## What Is Explicitly Avoided

The following practices are intentionally not used:

- `.env` files committed to Git
- Hardcoded secrets in Dockerfiles
- Secrets baked into container images
- Secrets passed via CLI arguments

These patterns increase leak risk and reduce auditability.

## Access Control

### Who Can Access Secrets

- Jenkins administrators only
- No shared credentials between users
- No anonymous access

### Scope Control

Secrets are scoped to:

- Specific pipelines
- Specific automation workflows

This limits blast radius in case of compromise.

## Secret Lifecycle

### Creation

- Secrets are manually added to Jenkins
- Source is verified before storage

### Rotation

Rotation is manual

Triggered by:

- Suspected exposure
- Credential expiration
- Service changes

### Deletion

- Secrets are removed when no longer required
- No automated rotation is implemented.

## Threat Model Considerations

### Protected Against

- Accidental Git leaks
- Unauthorized pipeline access
- Credential exposure in logs

### Not Protected Against

- Jenkins host compromise
- Privileged container escape
- Insider threats

These risks are accepted and documented.

## Why This Is Acceptable

This approach is sufficient for:

- Single-node systems
- Small operational teams
- Learning environments

Introducing Vault or cloud secret managers here would add ceremony without value.

## Future Improvements (Not Implemented)

If system complexity increases:

- External secret manager (e.g., Vault)
- Automatic rotation
- Short-lived credentials
- Per-service identity

These are deferred until operational needs justify them.

## Summary

Secrets management in this system is:

- Centralized
- Explicit
- Auditable
- Manual by design

It reflects an important SRE principle:

> Secure systems start with eliminating the most common ways secrets leak.