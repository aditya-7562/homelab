# SRE Production-Inspired Homelab (GCP + Docker + Jenkins)

This repository documents a **production-inspired single-node SRE homelab** deployed on Google Cloud Platform (GCP).  
The goal is not scale or high availability, but **clarity of operational thinking**, automation, and failure awareness.

The system demonstrates how core SRE principles apply even in constrained environments:
- Automation over manual intervention
- Explicit trade-offs instead of hidden assumptions
- Documented failure modes and recovery paths
- Separation of concerns between infrastructure, platform, and applications

This project is intentionally **single-VM** and **Docker Compose–based** to keep the focus on reliability fundamentals rather than orchestration complexity.

---

## High-Level Architecture

- **Cloud Provider:** Google Cloud Platform  
- **Compute:** Single VM (Compute Engine)  
- **Container Runtime:** Docker  
- **Orchestration:** Docker Compose  
- **Reverse Proxy & TLS:** Nginx Proxy Manager  
- **CI/CD:** Jenkins  
- **Automation:** n8n  
- **Applications:** Portfolio service (HTTP)

All externally exposed services are routed through a shared Docker bridge network (`homelab_proxy`) and fronted by Nginx Proxy Manager.

---

## Why This Project Exists

Most DevOps portfolios focus on *tools used*.  
This project focuses on **decisions made**.

Specifically:
- Why Docker Compose is sufficient for a single-node system
- How CI/CD behaves when failures occur
- What breaks first in a real deployment
- How downtime is handled when zero-downtime is not a requirement

This aligns more closely with **entry-level SRE expectations** than overengineered “mini-Kubernetes” demos.

---

## Scope and Non-Goals

### In Scope
- Single-node production-like setup
- Automated deployments via Jenkins
- Reverse proxy and TLS termination
- Basic observability using native tooling
- Explicit failure simulation and recovery documentation

### Explicit Non-Goals
- Multi-node clustering
- High availability
- Auto-scaling
- Managed Kubernetes (currently)

These exclusions are intentional and documented, not limitations hidden behind buzzwords.

---

## CI/CD Flow (Portfolio Service)

1. Code is pushed to the `main` branch on GitHub
2. GitHub webhook triggers Jenkins pipeline
3. Jenkins:
   - Pulls latest code
   - Rebuilds Docker image
   - Recreates the running container using Docker Compose
4. In case of failure:
   - Deployment stops
   - Recovery is performed via Git revert and redeploy

This approach prioritizes **predictability and debuggability** over zero-downtime complexity.

---

## Observability (Current State)

This system favors **visibility over tooling sprawl**.

### Implemented
- Container-level logs via `docker logs`
- Host-level metrics (CPU, RAM, disk)
- Basic service uptime verification

### Not Implemented (By Design)
- Alerting pipelines
- Metrics dashboards
- Distributed tracing

These omissions are documented and discussed rather than silently ignored.

---

## Failure Awareness

The project explicitly documents and simulates failure scenarios, including:
- Jenkins container crashes
- Reverse proxy misconfiguration
- Application container failures

Each scenario includes:
- Expected symptoms
- Blast radius
- Recovery steps

This shifts the focus from “everything works” to “what happens when it doesn’t.”

---

## Security Posture (Current)

- SSH access: key-based only
- Secrets: stored in Jenkins credential store
- Network security: GCP firewall rules
- TLS: terminated at Nginx Proxy Manager

Security decisions are pragmatic for scope and are documented transparently.

---

## Repository Structure

- architecture/ → design decisions and diagrams
- infra/ → GCP and Docker-level infrastructure
- platform/ → Jenkins, NPM, n8n, application services
- ci-cd/ → pipelines and rollback strategy
- reliability/ → failure scenarios and recovery playbooks
- observability/ → metrics, logging, uptime visibility
- security/ → access, secrets, and network controls
- scripts/ → bootstrap, backup, and restore helpers

Each directory contains focused documentation explaining **why** things exist, not just **how**.