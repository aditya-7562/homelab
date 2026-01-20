# Metrics

This document describes what metrics are observed, how they are collected, and what they are used for in this system.

Observability in this project is intentionally minimal and manual.
The goal is to build situational awareness, not dashboards for their own sake.

## Observability Philosophy

This system follows three rules:

1. Observe what you can act on
2. Prefer raw signals over aggregated abstractions
3. Do not claim metrics you do not actually use

As a result, metrics collection is pragmatic rather than comprehensive.

## Metric Sources

Metrics are collected from two primary sources:

- Host-level metrics (VM)
- Container-level metrics (Docker)

No application-level instrumentation is implemented.

## Host-Level Metrics

### What Is Observed

| Metric | Purpose |
|--------|---------|
| CPU usage | Detect saturation and throttling |
| Memory usage | Identify memory pressure |
| Disk usage | Prevent disk exhaustion |
| Load average | Detect sustained resource contention |

### How Metrics Are Accessed

OS-level tools:

- `top`
- `htop`
- `free`
- `df -h`
- GCP VM monitoring overview

Metrics are accessed on-demand, not continuously scraped.

## Container-Level Metrics

### What Is Observed

| Metric | Purpose |
|--------|---------|
| CPU usage per container | Identify noisy neighbors |
| Memory usage per container | Detect memory leaks |
| Container restarts | Detect crash loops |
| Container state | Identify failed services |

### How Metrics Are Accessed

- `docker stats`
- `docker ps -a`

This provides real-time visibility into container health.

## Service-Level Signals

Instead of detailed metrics, the system relies on binary service signals:

- Service reachable or not
- HTTP request succeeds or fails

These checks are sufficient for:

- Detecting outages
- Validating deployments
- Confirming recovery

## What Is Explicitly NOT Measured

The following are intentionally not implemented:

- Application latency percentiles
- Request throughput
- Error rates
- Custom business metrics
- Distributed tracing

### Why

- Low traffic volume
- Single-node deployment
- No automated alerting
- High overhead relative to learning value

Adding these would create false confidence without operational use.

## Metric Usage During Incidents

Metrics are used to answer specific questions:

- Is the VM resource-constrained?
- Is a specific container misbehaving?
- Is the issue systemic or isolated?

They are not used for:

- Forecasting
- Capacity planning
- SLA reporting

## Failure Detection Strategy

Failures are detected via:

- Service unreachability
- Container crash state
- Resource exhaustion symptoms

Metrics support diagnosis, not detection.

## Known Limitations

- No historical metric retention
- No trend analysis
- No threshold-based alerting
- Manual inspection only

These limitations are documented and accepted.

## Future Improvements (Not Implemented)

Potential future extensions include:

- Prometheus-based scraping
- Grafana dashboards
- Alert thresholds

These are deferred until:

- System complexity increases
- Metrics have clear operational value

## Summary

The metrics approach in this system is:

- Honest
- Action-oriented
- Minimal by design

It reflects a core SRE principle:

> Observability exists to support decisions, not to impress.