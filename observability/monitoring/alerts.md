# Alerts

This document describes the current alerting posture of the system.

At present, no automated alerting is implemented.

This is an intentional, documented decision — not an omission.

## Current State

### Alerting Status

| Capability | Status |
|------------|--------|
| Automated alerts | ❌ Not implemented |
| Email notifications | ❌ |
| Webhook alerts | ❌ |
| Pager/on-call integration | ❌ |

All incident detection is manual.

## How Failures Are Detected Today

Failures are detected through:

- Direct user access (service unreachable)
- Manual health verification
- Jenkins pipeline failures
- Container crash inspection
- Host resource checks

This relies on human observation, not automation.

## Why Alerting Is Not Implemented

Alerting is intentionally deferred for the following reasons:

- Single-node system
- No on-call rotation
- Low traffic
- No defined SLAs
- No automated remediation

Introducing alerts without response mechanisms would create noise without action.

## Risks of No Alerting

Accepted risks include:

- Delayed incident awareness
- Manual polling required
- Failures may go unnoticed during idle periods

These risks are acknowledged and accepted for the project’s scope.

## Mitigations

Even without alerts, risk is reduced by:

- Clear failure scenarios
- Documented recovery playbooks
- Simple system topology
- Low operational complexity

Failures are easy to diagnose once noticed.

## Future Alerting Triggers (Not Implemented)

If alerting were introduced, candidates include:

- Service unreachable for N minutes
- Container restart loops
- Disk usage threshold breaches
- Jenkins pipeline failures

These are planned concepts, not active features.

## Why This Honesty Matters

Claiming alerting without:

- Clear thresholds
- Defined responders
- Runbooks

is worse than having no alerting at all.

This system favors operational truth over résumé padding.

## Summary

Alerting in this system is:

- Currently absent
- Consciously deferred
- Transparently documented

This aligns with a core SRE principle:

> Alerts should wake humans only when action is required.