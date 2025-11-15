# Claude Skills & Operations Playbook

## Role in FlashFusion Stack
- Claude-led skills power structured workflows inside the orchestrator plan graph while respecting bounded autonomy and policy budgets.
- Extended thinking budgets (≥4k baseline, ≥8k complex) enable multi-step reasoning; enforce reflective checkpoints before committing external actions.
- Memory interactions use scoped namespaces; scrub secrets prior to writes and honor retention/rotation policies.

## Skill Authoring Standards
- Keep `SKILL.md` ≤200 tokens with a gerund title (e.g., “ReconcilingInvoices”); clearly state prerequisites, inputs, outputs, and escalation rules.
- Provide deterministic test harnesses that run on Haiku + Sonnet; codify nominal, edge, and adversarial cases.
- Store prompt assets, examples, and schema definitions in version control with rollout notes; track changes across releases.
- Use the Context Engineer’s `context_map.md` and `flow_matrix.json` (spec 3.1) as the single source of truth for dependencies and escalation paths.
- Append **CLAIMS CHECK** sections summarizing verified facts, assumptions, gaps, and required human approvals.

## Tooling & Adapter Guidance
- Favor Tool Runner beta for Claude tool calls; define JSON Schema contracts, validate requests/responses, and hash IO payloads for audit trails.
- Implement retries with exponential backoff and policy-aware budgets; stop execution on schema violations or low-confidence critiques.
- Rotate capability tokens automatically and alert on anomalous usage; log every tool invocation with provenance hashes keyed by `traceId`.

## Safety, Evaluation & Governance
- Integrate evaluator agents that score jailbreaking, policy alignment, and regression metrics; block promotions below thresholds.
- Trigger human review on policy hits, confidence dips, or when tool usage exceeds authorized budgets.
- Run offline suites, sandbox simulations, and Anthropic Evaluation Tool runs each sprint; document evidence in `audit_report.md`.
- Shadow deploy updates, collect one business cycle of telemetry, and only then promote; mirror critical incidents to Slack `#flashfusion-ai`.

## Telemetry & Documentation
- Stream plan graphs, tool calls, token spend, and evaluation scores to the telemetry lake with `traceId` correlation; maintain logs ≥18 months in tamper-evident storage.
- Map runs to commits, tickets, and deployments to preserve auditability; update `docs/PROGRESS.md`, `docs/DECISIONS.md`, and Agent Guild knowledge packs post-release.
- Capture lessons learned and drift indicators in `knowledge_pack.md`; queue backlog items for prompt or tool enhancements.
