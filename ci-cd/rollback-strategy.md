# Rollback Strategy

This document describes how failed deployments are **detected, contained, and reversed** in this system.

The rollback approach is intentionally simple, predictable, and auditable.

---

## Guiding Principles

1. **Git is the source of truth**
2. **Rollbacks must be explicit**
3. **Partial state is unacceptable**
4. **Recovery should be boring**

Complex rollback mechanisms are avoided unless they solve real problems.

---

## What Triggers a Rollback

A rollback is required when:
- A deployment pipeline fails
- The application fails to start
- A change introduces runtime errors
- A configuration change breaks routing

Rollbacks are operator-driven, not automatic.

---

## Rollback Mechanism

### Method
- Revert the problematic commit in Git
- Push the revert to `main`
- Jenkins pipeline redeploys the previous version

This ensures the deployed state always matches repository state.

---

## Why Git Revert (Instead of Image Rollback)

### Benefits
- Clear audit trail
- Human-readable context
- No dependency on image registries
- No tag management complexity

The system avoids maintaining parallel deployment state.

---

## Rollback Flow

1. Failure is observed (pipeline or runtime)
2. Faulty commit is identified
3. Commit is reverted in Git
4. Jenkins pipeline is triggered
5. Known-good version is redeployed

No manual container manipulation is required.

---

## Downtime Behavior

- Service experiences downtime during redeploy
- Downtime duration equals container restart time
- Downtime is acceptable within scope

Zero-downtime rollback is not a requirement.

---

## Failure Containment

- Failed deployments do not affect unrelated services
- Reverse proxy remains functional
- CI failures do not crash running containers

Blast radius is intentionally limited.

---

## Known Limitations

- No automated health-based rollback
- No canary or blue/green deployments
- No version overlap

These are acknowledged trade-offs.

---

## Why This Strategy Works Here

This rollback strategy fits:
- Single-node environments
- Low-traffic services
- Early-stage or internal tools

It prioritizes correctness over sophistication.

---

## Summary

Rollback in this system is:
- Simple
- Transparent
- Auditable

The goal is not speed, but **certainty**.
