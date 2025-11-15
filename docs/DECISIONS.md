# Decision Log — Canonical Operations

| Timestamp (UTC-5) | Decision | Owner | Approvers | Artefacts / Notes |
| --- | --- | --- | --- | --- |
| 2025-11-01T18:55 | Kick off documentation refresh covering CLAUDE.md, AGENTS.md, README.md, CHECKPOINT.md plus supporting intake/decision/registry logs. | Orchestrator | Sponsor | Objective captured in `docs/intake.md`. |
| 2025-11-01T18:58 | Set thinking budget (6k tokens) and 2h execution window for documentation tasks; constrain tooling to Codex CLI edits. | Orchestrator | Sponsor | Documented in `docs/intake.md#budgets-&-constraints`. |
| 2025-11-01T19:00 | Defer SBOM/SLSA regeneration to follow-up run pending cosign/syft availability; require hash logging post-run. | Orchestrator | Sponsor, Auditor | Action recorded in `CHECKPOINT.md` need-priority plan. |
| 2025-11-01T19:05 | Update agent registry and session continuity log once documentation edits completed to preserve audit trace. | Orchestrator | Sponsor | Registry entry added in `agents/registry.json`; session log to be appended. |
| 2025-11-02T09:00 | Consolidated `checkpoint.md` into `CHECKPOINT.md`, deleting duplicate. | Orchestrator | Sponsor | Ensured single source of truth for project roadmap. |
| 2025-11-13T05:05 | Approve installation of syft 1.37.0 + cosign 2.4.0 for SBOM/signing, authorize SBOM run for `/home/kyler`. | Auditor | Sponsor | Artefacts logged in `artefacts/sbom/`; entry `sbom-refresh-2025-11-13` in `compliance_log.json`. |
| 2025-11-13T05:15 | Mandate immediate logging updates (`docs/intake.md`, `docs/DECISIONS.md`, `docs/SESSION_CONTINUITY_LOG.md`, `CHECKPOINT.md`) to capture audit outcomes. | Orchestrator | Sponsor | Updates in respective docs; checkpoint `Evidence — 2025-11-13` section added. |
| 2025-11-13T05:25 | Require Stripe + utility scripts to include env validation and CLI guardrails before execution. | Safety Evaluator | Sponsor | Changes pending in `UPDATE_STRIPE_ENV.sh`, `set_stripe_env.sh`, `scripts/shell/*`. |
| 2025-11-13T05:35 | Publish quick health readouts for HarvestFlow, project-nexus, FlashFusion consolidated, and INT Smart Triage; store alongside repository docs. | Orchestrator | Sponsor | STATUS sections to be added in respective repos. |
| 2025-11-13T05:45 | Institute log retention cadence + rotation workflow leveraging `scripts/shell/rotate-logs.sh` and document in runbook/checklist. | Auditor | Sponsor | To be referenced in README checklist + session log. |
| 2025-11-13T06:05 | Harden HarvestFlow/project-nexus/FlashFusion pipelines (lint/test tooling) before continuing implementation work. | Orchestrator | Sponsor | STATUS files added per repo with latest command output. |
| 2025-11-13T06:15 | Reject ingestion of customer-supplied live Stripe credentials; require masked/test values or secure secret manager hand-off. | Safety Evaluator | Sponsor | Documented in `docs/SESSION_CONTINUITY_LOG.md`; live keys were not written to disk. |
