# SLOs and SLAs

This document describes the service reliability expectations for the system, using the concepts of SLAs, SLOs, and SLIs.

In this project, these concepts are defined conceptually but not enforced programmatically.

This distinction is intentional.

## Definitions (Context)

- **SLI (Service Level Indicator):** A measurable signal of service behavior
- **SLO (Service Level Objective):** A target value for an SLI
- **SLA (Service Level Agreement):** A contractual commitment tied to penalties

This system does not provide external guarantees, therefore no SLAs exist.

## Service Level Indicators (SLIs)

### Primary SLI: Service Reachability

**Definition:** Whether the service responds to HTTP requests successfully.

**Measurement Method:**

- Manual HTTP access
- Basic uptime verification

This binary indicator is sufficient for the system’s scope.

## Service Level Objectives (SLOs)

### Conceptual SLO

| Metric | Target |
|--------|--------|
| Service availability | Best effort |

No numeric uptime percentage is defined.

### Why No Numeric SLO Exists

- Low traffic
- No alerting
- No historical metrics
- No automated measurement

Assigning numeric SLOs without enforcement would be misleading.

## Error Budget

**Status:** No error budget is defined.

### Rationale

Error budgets require:

- Continuous measurement
- Alerting
- Automated tracking

None of these exist in the current system.

## Service Level Agreements (SLAs)

**Status:** No SLAs are defined.

### Reason

- No external users
- No contractual obligations
- No penalties or guarantees

This is an internal, experimental system.

## Downtime Expectations

### Planned Downtime

- Occurs during deployments
- Accepted and documented
- Short-lived

### Unplanned Downtime

Possible due to:

- Container crashes
- Proxy misconfiguration
- Resource exhaustion

Recovery is manual and documented.

## Why This Is Acceptable

This system is:

- Single-node
- Low-traffic
- Operator-managed

The goal is operational understanding, not compliance reporting.

## Future Evolution (Not Implemented)

If the system grows, the following could be introduced:

- Automated uptime measurement
- Numeric SLOs
- Error budget tracking
- Alert-driven enforcement

These are deferred until they provide real value.

## Summary

In this system:

- SLIs exist conceptually
- SLOs are qualitative
- SLAs do not exist

This reflects a core SRE truth:

> Reliability targets only matter when they can be measured and enforced.