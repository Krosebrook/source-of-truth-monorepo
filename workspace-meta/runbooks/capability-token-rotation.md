# Capability Token Rotation Validation Runbook

## Purpose
Ensure all FlashFusion agent capability tokens are rotated securely via the shared secrets manager and that automation hooks remain healthy before each release cycle.

## Scope
- Orchestrator, evaluator, and tool-runner tokens issued to production, staging, and sandbox environments.
- Secrets stored in the shared secrets manager (e.g., AWS Secrets Manager, Vault, or equivalent) and synced to runtime via CI/CD.

## Prerequisites
- Access to the secrets manager with read/describe permissions.
- Access to CI/CD logs (`agents:orchestrate` pipeline) and telemetry dashboards for rotation events.
- Knowledge of current token inventory (`ops/capability-token-registry.yaml` when published).

## Rotation Cadence
- **Regular cadence**: Every 30 days.
- **Triggered rotation**: Immediately on incident response (`policy-hit`, `credential anomaly`, or `chaos drill` outcome).

## Validation Checklist
1. **Inventory Review**
   - Export current token list from secrets manager.
   - Confirm metadata: owner, environment, creation timestamp, last rotated timestamp.
2. **Automation Health**
   - Inspect CI/CD job `agents:rotate-tokens` (or equivalent) for the last run; ensure success status.
   - Verify webhook/notification to Slack `#flashfusion-ai` for rotation completion.
3. **Rotation Execution**
   - Initiate rotation workflow (manual trigger or scheduled job verification).
   - Confirm new secret version created with correct tags (`env`, `scope`, `expiry`).
   - Validate old token revoked or scheduled for revocation within 24 hours.
4. **Integration Verification**
   - Deploy to staging with fresh tokens; run smoke test: `pnpm agents:simulate --suite smoke`.
   - Check telemetry for authentication success and absence of token-expiry warnings.
5. **Audit Logging**
   - Append rotation event to `logs/agents/rotation-log.md` (owner, date, environments touched).
   - Update ticket `OPS-DEVOPS-ROTATION` with evidence links (screenshots, log excerpts).

## Exception Handling
- If automation fails, escalate to DevOps on-call (rotation severity P1) and follow incident response playbook.
- Document manual steps taken, including revocation commands and validation evidence.

## Approvals
- Rotation and validation results require sign-off from DevOps lead and AI Ops owner before promotion activities.

## Claims Check
- Runbook references planned artefacts (`capability-token-registry.yaml`, `rotation-log.md`) that must be populated during rollout.
- Assumes shared secrets manager with versioning support; update steps if infrastructure differs.
