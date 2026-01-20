# Network Isolation

This document describes how network isolation is used as a security control in the system.

Isolation is enforced primarily at the container networking layer, with cloud networking acting as the outer boundary.

The goal is to limit blast radius, not to create airtight segmentation.

## Network Isolation Philosophy

This system follows three rules:

1. Expose as little as possible
2. Isolate by default
3. Share networks only when required

Isolation is a means to reduce accidental coupling and unintended access.

## Isolation Layers

Network isolation exists at two levels:

- Cloud-level (GCP firewall)
- Container-level (Docker networks)

Each layer has a distinct responsibility.

## Cloud-Level Isolation

### GCP Firewall

- Controls which ports reach the VM
- Blocks all non-explicit inbound traffic
- Acts as the system's external perimeter
- No service bypasses this layer.

## Container-Level Isolation

### Docker Networks

The system uses multiple Docker networks with different scopes.

#### homelab_proxy (Shared External Network)

External Docker bridge network

Used by:

- Nginx Proxy Manager
- Jenkins
- n8n
- Portfolio service

This network exists only to support reverse proxy routing.

#### Internal Service Networks

Some services define private internal networks.

Example:

- Jenkins ↔ Docker-in-Docker communication

Characteristics:

- Not exposed externally
- Not shared with unrelated services
- Limits lateral movement

## Port Exposure Strategy

Most containers do not publish ports to the host

Services rely on:

- Docker DNS
- Reverse proxy routing

Ports are published only when:

- External access is strictly required
- Debugging is temporarily necessary

This minimizes attack surface.

## Trust Zones

The system implicitly defines trust zones:

- Public Internet
- Reverse proxy
- Application and platform containers
- Internal service networks

Each boundary reduces what an attacker can access.

## What Isolation Does NOT Do

Network isolation in this system does not:

- Prevent compromise of a privileged container
- Enforce zero-trust networking
- Provide service-to-service authentication

These are acknowledged limitations.

## Failure and Misconfiguration Risks

### Shared Network Risks

- Misconfigured proxy can affect multiple services
- Compromised proxy increases blast radius

These risks are accepted for simplicity.

## Why This Level of Isolation Is Enough

This isolation strategy:

- Matches the system's scale
- Reduces accidental exposure
- Keeps networking debuggable

More granular isolation would add complexity without proportional benefit.

## Future Improvements (Not Implemented)

Potential enhancements include:

- Per-service networks
- mTLS between services
- Network policies via orchestration platforms

These are deferred until scale demands them.

## Summary

Network isolation in this system is:

- Intentional
- Minimal
- Layered

It supports a core SRE principle:

> Security boundaries should be simple enough to reason about during failure.