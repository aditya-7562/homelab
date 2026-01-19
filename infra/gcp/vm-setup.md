# GCP VM Setup

This document describes the **compute foundation** of the homelab: a single Google Cloud Platform (GCP) virtual machine.
The setup is intentionally minimal and transparent to keep the focus on **system behavior and operability**, not cloud abstractions.

---

## VM Overview

- **Cloud Provider:** Google Cloud Platform
- **Service:** Compute Engine
- **Deployment Model:** Single VM
- **Purpose:** Host all platform and application containers

This VM acts as the **entire failure domain** for the system.

---

## Machine Characteristics

### Instance Type
- General-purpose Compute Engine VM
- Balanced CPU and memory profile

### Operating System
- Linux (Ubuntu-based)
- Chosen for:
  - Broad ecosystem support
  - Familiarity in production environments
  - Strong Docker compatibility

### Disk
- Single persistent disk
- Used for:
  - OS
  - Docker volumes
  - Jenkins state
  - Application data

No separate data disks are provisioned to keep storage behavior explicit and observable.

---

## Networking Configuration

### External Access
- VM is assigned a public IP
- Required for:
  - HTTPS traffic to hosted services
  - GitHub webhook delivery to Jenkins

### Internal Networking
- No VPC peering
- No internal load balancers
- All service-to-service communication happens inside Docker networks

This avoids mixing cloud networking with container networking concerns.

---

## Firewall Rules (GCP Level)

Firewall rules are enforced **at the cloud boundary**, not inside the VM.

### Allowed Inbound Ports
| Port | Purpose |
|----|--------|
| 22 | SSH (key-based access only) |
| 80 | HTTP (redirected to HTTPS) |
| 443 | HTTPS |
| 81 | Nginx Proxy Manager admin UI |
| 8080 | Jenkins UI |
| 5678 | n8n (temporary / debug access) |

### Design Intent
- Only explicitly required ports are exposed
- Most services rely on reverse proxy routing instead of direct exposure

---

## SSH Access

### Authentication
- SSH key-based access only
- Password authentication disabled

### User Model
- Non-interactive access preferred
- Root login avoided for routine operations

This reduces brute-force risk and aligns with standard production baselines.

---

## Host-Level Responsibilities

The VM is responsible for:
- Running Docker daemon
- Managing container lifecycle
- Hosting persistent volumes
- Exposing minimal network surface

The VM does **not**:
- Perform application logic
- Handle TLS directly
- Execute CI logic outside containers

These responsibilities are delegated to containers to keep concerns isolated.

---

## Why a Single VM?

### Benefits
- Clear blast radius
- Predictable performance
- Simplified debugging
- Lower operational cost

### Limitations
- No redundancy
- Manual recovery if VM fails
- No automatic failover

These limitations are **explicitly accepted** for this project’s scope.

---

## Failure Implications

If the VM goes down:
- All services become unavailable
- Recovery requires VM restart or recreation
- Persistent data survives via attached disk

This failure mode is intentional and documented to reinforce infrastructure realism.

---

## Future Extensions (Not Implemented)

The following are consciously deferred:
- Multi-zone deployments
- Managed instance groups
- Load balancers
- Auto-healing

These are not missing features — they are **out-of-scope decisions**.

---

## Summary

This VM setup provides:
- A stable, minimal compute base
- Clear operational boundaries
- Honest failure behavior

It prioritizes **learning and observability** over resilience illusions.
