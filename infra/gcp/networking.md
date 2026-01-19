# GCP Networking Overview

This document explains how **cloud-level networking** and **container-level networking** are intentionally separated in this project.

The guiding principle is simple:

> GCP handles **reachability**. Docker handles **service communication**.

Mixing the two creates unnecessary complexity and confusion.

---

## Cloud Networking Scope

At the GCP level, networking is responsible for:
- Assigning a public IP to the VM
- Enforcing firewall rules
- Routing traffic to the VM boundary

GCP networking **does not**:
- Route traffic between containers
- Perform service discovery
- Handle TLS termination

Those responsibilities are delegated to Docker and the reverse proxy.

---

## VPC Configuration

- Default VPC is used
- No custom subnets
- No VPC peering
- No shared VPC

### Rationale
- Single VM deployment
- No inter-service cloud communication
- Avoids unnecessary abstraction

Using the default VPC keeps focus on container networking rather than cloud topology.

---

## Public IP Usage

### Why a Public IP is Required
- HTTPS access to hosted services
- GitHub webhook delivery to Jenkins
- Let’s Encrypt ACME challenge resolution

This VM represents a **publicly reachable edge**, not a private backend.

---

## Traffic Flow (Ingress)

1. Client sends request to public IP (ports 80/443)
2. GCP firewall validates the request
3. Traffic reaches the VM
4. Nginx Proxy Manager receives the request
5. Request is routed to the appropriate container via Docker network

At no point does GCP make decisions about:
- Which service receives traffic
- How TLS is handled
- How services discover each other

---

## Docker Networking Boundary

All service-to-service communication occurs within Docker networks.

### Primary Network: `homelab_proxy`
- External Docker bridge network
- Shared by:
  - Nginx Proxy Manager
  - Jenkins
  - n8n
  - Portfolio service

This network enables:
- DNS-based service discovery by container name
- Reverse proxy routing without exposing ports

---

## Internal Networks

Some services define **private internal networks** for isolation.

Example:
- Jenkins ↔ Docker-in-Docker communication

These networks:
- Are not exposed externally
- Limit blast radius
- Reduce unintended service coupling

---

## Why Not Use Cloud Load Balancers?

### Reasons
- Single backend VM
- No high availability requirement
- Load balancer would add:
  - Cost
  - Operational complexity
  - Minimal learning value

Reverse proxying is handled entirely inside the VM.

---

## Failure Boundaries

### Cloud Network Failure
- VM unreachable
- All services down simultaneously
- Diagnosed at GCP level

### Container Network Failure
- VM reachable
- Proxy reachable
- Specific services unreachable

This clear separation simplifies troubleshooting.

---

## Debugging Strategy

Network issues are debugged in layers:

1. GCP firewall rules
2. VM reachability (SSH / ping)
3. Docker network attachment
4. Reverse proxy routing
5. Application container health

Each layer has a **clear owner and scope**.

---

## Security Considerations

- No container ports are directly exposed unless required
- All external ingress is funneled through the proxy
- Docker networks are treated as internal trust zones

This limits accidental exposure and simplifies audits.

---

## Summary

This networking model:
- Keeps cloud networking minimal and explicit
- Pushes service logic into containers
- Creates clear debugging boundaries

The result is a system that is **easy to reason about when things break**.
