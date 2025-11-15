# AI System Inventory — Initial Seed (2025-11-15)

> Based on The IIA’s “Catalyst for Strong AI Governance” checklist: each AI/agentic system must have an owner, purpose statement, risk tier, data classification, oversight signal, and last validation date. This table will expand as new systems come online and will feed the automated registry + compliance reports.

| System | Purpose & Scope | Owner | Data Classification | Risk Tier | Primary Documentation | Last Validation | Notes / Next Validation |
| --- | --- | --- | --- | --- | --- | --- | --- |
| **HarvestFlow** | Production pipeline + dashboard orchestrating file audits, release bundles, and log rotation for customer workspaces. | Kyler (Eng Ops) | Customer metadata, audit artefacts (PII-adjacent) | High (customer-facing, write access) | `projects/local/harvestflow/README.md`, `projects/local/harvestflow/docs/governance.md`, `docs/projects/REPOSITORY_AUDIT_2025-11-02.md` | 2025-11-13 | SBOM/regression suite scheduled weekly; requires OTEL pilot coverage. Next validation: 2025-11-20 after telemetry run. |
| **FlashFusion Consolidated** | Monorepo powering multi-LLM IDE + agent marketplace. Consolidated lint/test workflows; currently staging environment only. | Kyler (Product) | Limited customer prompts/logs (sanitized), internal tooling configs | Medium (staging, limited PII) | `docs/reports/BEST_PRACTICES_VALIDATION.md`, `projects/local/chaosclubco/flashfusion/STATUS.md` (when generated) | 2025-11-13 | Outstanding lint warnings noted; council to review fairness/explainability guardrails. Next validation: 2025-11-22 post-warnings fix. |
| **project-nexus (Encore)** | Backend services prototyped with Encore for agent routing + billing experiments. Awaiting `encore auth login` to run full test suite. | Kyler (Platform) | Synthetic datasets, billing simulations | Medium (no prod data yet) | `projects/local/krosebrook/project-nexus/STATUS.md` (pending), `docs/SESSION_CONTINUITY_LOG.md` (2025-11-13 entry) | 2025-11-13 | Blocked by Encore auth; once resolved, run integration suite + update risk tier. Next validation: 2025-11-19 (council meeting). |

### Action Items
- [ ] Automate export of this table to JSON (`workspace-meta/inventory/ai_systems.json`) for downstream tooling.
- [ ] Attach SBOM references + cosign hashes in `docs/compliance/compliance_log.json` per system once telemetry pilot is executed.
- [ ] Expand inventory with INT Smart Triage + future Marketplace agents after council kickoff.
