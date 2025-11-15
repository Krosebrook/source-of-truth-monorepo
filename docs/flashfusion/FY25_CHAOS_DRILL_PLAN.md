# FlashFusion FY25 Chaos Drill Plan

## Purpose
Codify quarterly chaos-drill scenarios, owners, and approval checkpoints required before production rollout.

## Scenario Matrix
| Scenario | Description | Owner | Evidence Required | Status |
| --- | --- | --- | --- | --- |
| Tool Runner outage | Simulate primary tool adapter downtime; validate fallback skills and incident escalation | Security + DevOps | Drill runbook, telemetry captures, incident log | Pending Security sign-off |
| Credential revocation | Force capability-token invalidation during execution; confirm rotation + recovery | Security + AI Ops | Rotation log entry, recovery timings, evaluator results | Pending Security sign-off |
| Adversarial prompt injection | Execute curated adversarial prompts to validate policy enforcement and evaluator gating | Security + Safety Team | Evaluation scores, policy-hit analysis, human review notes | Pending Security sign-off |

## Timeline
- **Q1 FY25**: Tool Runner outage drill
- **Q2 FY25**: Credential revocation drill
- **Q3 FY25**: Adversarial prompt injection drill
- **Q4 FY25**: Composite drill covering all scenarios with expanded telemetry analysis

## Approval Workflow
1. Draft drill plan and share with Security owner for review.
2. Collect feedback, update scenarios, and log adjustments in `docs/flashfusion/OPS_COORDINATION_LOG.md`.
3. Obtain written approval (email or ticket comment) before scheduling drills.
4. After drill execution, file `compliance_log.json` entry and update `knowledge_pack.md`.

## Claims Check
- Scenarios align with requirements in `agents.md` and `claude.md` for quarterly chaos drills.
- Awaiting Security owner approval; no sign-off received as of 2025-10-29.
- Requires coordination with DevOps for shared telemetry capture during drills.
