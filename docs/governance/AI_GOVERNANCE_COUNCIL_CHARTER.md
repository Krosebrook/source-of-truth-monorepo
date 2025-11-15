# AI Governance Council Charter (Draft — 2025-11-15)

## Mission
Provide cross-functional oversight for all AI/agentic initiatives so that deployments align with business outcomes, regulatory commitments (EU AI Act, US EO 14179), and internal guardrails documented in `AGENTS.md` and `EU_AI_ACT_COMPLIANCE.md`.

## Scope
- Approve AI use cases, data sourcing, and deployment gates for HarvestFlow, FlashFusion consolidated, project-nexus, and future marketplaces.
- Track KPIs tied to governance OKRs (review cycle time, incident MTTR, CSAT deltas, audit findings burn-down).
- Ensure fairness, transparency, accountability, and observability requirements are embedded across the SDLC.

## Authority
- Empowered by Sponsor (Kyler) to pause launches, require remediation plans, and allocate work toward compliance/security fixes before feature work resumes.
- Can request evidence (logs, SBOMs, OTEL traces) from any domain skill agent or engineering squad.

## Membership
| Role | Representative | Responsibilities |
| --- | --- | --- |
| Sponsor (Chair) | Kyler | Sets agenda, approves decisions, escalates blockers. |
| Orchestrator Agent Lead | Codex CLI (Claude Sonnet 4.5) | Prepares plans, tracks budgets, publishes artefacts. |
| Auditor | Compliance Auditor | Maintains `docs/compliance/compliance_log.json`, SBOM/SLSA attestations, AI inventory accuracy. |
| Safety Evaluator | Safety Evaluator | Runs jailbreak/policy assessments, validates telemetry guardrails. |
| Data/Platform SME | Rotating (HarvestFlow, FlashFusion, project-nexus leads) | Presents system posture, test results, pending risks. |
| Legal/Policy SME | TBD (invited when regulatory updates land) | Interprets EU AI Act, GDPR, PCI, etc. |

## RACI Snapshot
- **Responsible**: Orchestrator + system owners for preparing updates/actions.
- **Accountable**: Sponsor (Kyler).
- **Consulted**: Auditor, Safety Evaluator, Legal SME.
- **Informed**: Domain squads + Product leadership via `docs/DECISIONS.md` + Continuity Log.

## Cadence & Deliverables
- **Meeting Frequency**: Weekly until automation stabilizes; then bi-weekly. First quorum deadline: 2025-11-19.
- **Artefacts**:
  - Agenda + minutes appended to `docs/sessions/` (TBD file).
  - Updated AI inventory + registry deltas.
  - Compliance log updates (trace IDs, hashes, SBOM references).
  - Action items tracked via `docs/SESSION_CONTINUITY_LOG.md`.
- **Inputs**: AI inventory deltas, telemetry metrics, open audit findings, incident reports.
- **Outputs**: Approved/rejected deployment decisions, assigned remediations, KPI dashboards snapshots.

## Operating Procedures
1. **Pre-read package** published 24h before meeting (inventory, telemetry summary, risk list).
2. **Meeting** runs 30 minutes with strict agenda (status, decisions, blockers).
3. **Decisions** logged in `docs/DECISIONS.md` with owner + due date.
4. **Follow-ups** recorded in `docs/SESSION_CONTINUITY_LOG.md` along with residual risks.
5. **Escalations** triggered if:
   - Risk tier upgraded to “high” without mitigation plan.
   - Compliance evidence missing for >2 weeks.
   - Telemetry gaps exceed thresholds defined in OTEL pilot.

## Success Metrics
- Time-to-approve new AI use cases under 5 business days.
- 0 unreviewed high-risk deployments.
- Telemetry coverage ≥ 90% of agent workflows with trace IDs tied to compliance entries.

## Next Steps
- [ ] Confirm membership + quorum.
- [ ] Schedule first meeting (target 2025-11-19) and circulate pre-read.
- [ ] Define KPI reporting template (hook into OTEL pilot output).
