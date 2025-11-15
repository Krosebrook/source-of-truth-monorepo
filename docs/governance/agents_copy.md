# FlashFusion Agent Operations Field Guide

## Purpose
- Provide a single 2025-ready reference that fuses FlashFusion platform guidance, Kyler’s Codex CLI loops, and HarvestFlow/Smart Triage playbooks.
- Anchor every agent launch to measurable business or customer outcomes while keeping autonomy gated by policy, budgets, and human checkpoints.
- Reinforce shared security, evaluation, and documentation standards across orchestrators, skills, tools, evaluators, and auditors.

## Core Operating Principles
- **Outcome-first**: articulate impact metrics in the intake brief; revisit them during verification and retro.
- **Bounded autonomy**: enforce thinking budgets, capability scopes, and escalation paths before execution.
- **Human governance**: require approvals for intent shifts, risky tool calls, releases, and incident handling; document decisions in immutable logs.
- **Secure-by-default**: sanitize prompts, redact secrets, run least-privilege tokens, and preserve append-only audit trails.
- **Continuous evaluation**: schedule offline suites, sandbox simulations, telemetry reviews, and human spot checks every sprint; block rollouts on evaluation regressions.
- **Controllable runtime**: instrument the agent loop as inspectable middleware with override hooks before layering domain-specific logic.

## Architecture Layers & Responsibilities
| Layer | Key Duties | Operational Notes |
| --- | --- | --- |
| Orchestrator agent | Capture goal + policy snapshot, draft plan graph, assign tools/skills, govern budgets, escalate risk | Enable extended thinking (≥4k baseline, ≥8k for complex), own incident management, surface policy hits immediately. |
| Domain skills | Codify repeatable workflows (billing, fulfillment, triage) | Maintain `SKILL.md` ≤200 tokens with gerund titles; provide deterministic tests on Haiku + Sonnet. |
| Tool adapters | Wrap external systems with deterministic IO and telemetry | Favor Tool Runner beta, validate via JSON Schema, stream deltas, hash inputs/outputs, log retries. |
| Safety & evaluators | Enforce policy, jailbreak detection, regression scoring, release gating | Block promotion below thresholds; trigger human review on policy violations or confidence dips. |
| Memory & knowledge | Manage vector stores, Files API assets, memory namespaces | Apply retention/rotation policies, scrub secrets pre-storage, label namespaces by task scope. |
| Context Engineer | Produce `context_map.md` + `flow_matrix.json` (spec 3.1) | Keep deterministic key order, note dependencies, highlight escalation paths. |
| Prompt Architect | Emit `scoped_prompt.md` + `validation_rules.yaml` | Document constraints, guardrails, and evaluation hooks; annotate assumptions. |
| Builder Agent | Package `deliverable_bundle.zip` without placeholders | Include all artefacts, wire provenance manifests, respect deterministic ordering. |
| Auditor | Generate `audit_report.md` + `compliance_log.json` | Provide QualityScore tables, policy verdicts, and CLEAR rollbacks. |
| Synthesizer | Publish `knowledge_pack.md` | Translate audits into learnings, next steps, backlog inputs for Agent Guild. |

## Execution Lifecycle
1. **Intake** — Capture goal, constraints, stakeholders, risk tier, success metrics, budgets; snapshot policy context.
2. **Plan** — Orchestrator proposes plan graph, selects skills/tools, allocates token/runtime budgets, seeks human approval for medium/high risk paths.
3. **Execute** — Agents call approved tools via capability tokens, respect budgets, attach provenance hashes, emit telemetry with `traceId`.
4. **Verify** — Evaluators run contract tests, simulations, Anthropic Evaluation Tool suites, and human spot checks; halt on policy hits or score regressions.
5. **Release** — Shadow deploy, canary, and promote only after metrics clear; document rollback triggers and execution transcripts.
6. **Retro** — Log learnings, telemetry deltas, backlog updates in Agent Guild knowledge base; refresh golden datasets quarterly.

## Operational Controls
- **Planning discipline**: start with explicit exit criteria per plan node; use reflective critiques after significant actions and escalate below-confidence thresholds.
- **Reliability & safety**: validate inputs/outputs at every tool boundary; rotate capability tokens automatically; schedule quarterly chaos drills (tool outage, revoked credential, adversarial prompt).
- **Compliance**: maintain GDPR/CCPA/SOX/HIPAA policy packs; require human approval for privileged operations; purge secrets from stored context/memory.
- **Observability**: stream plan graphs, tool calls, budgets, evaluation scores to telemetry lake; correlate `traceId` with commits, tickets, deploy IDs; retain logs ≥18 months with tamper-evident storage; mirror critical incidents to Slack `#flashfusion-ai`.

## Repository Integration Essentials
- Structure: `src/` services, `api/` (Vercel functions), `public/` static assets, `test/` mirrors source, `supabase/` SQL migrations.
- Commands: `npm run dev`, `npm run build`, `npm test`, `npm run lint`, `npm run format`, `npm run validate`, `npm run agents:*` for operational control.
- Testing: aim ≥70% coverage (≥80% core workflows); script smoke tests for planner termination and deterministic tool usage; version control prompts, few-shots, schemas with rollout notes.
- Security hygiene: never commit secrets; rely on `.env.local` + `scripts/validate-env.js`; ensure Supabase migrations stay in sync; run `npm run predeploy` before releases; gate memory writes and purge stale embeddings.

## Governance & Continuous Improvement
- Follow lifecycle gates G0–G8 with named owners (Product Lead, AI Architect, Security, Compliance, DevOps).
- Maintain golden regression datasets mixing nominal, edge, and adversarial transcripts; refresh quarterly.
- Shadow deploy new agents; require a full business cycle of telemetry before full rollout.
- Review telemetry weekly for drift or policy hits; run quarterly chaos drills; publish postmortems and prompt cookbooks to Agent Guild; update starter kits after each sprint retro.

## Deliverable Standards (spec_version 3.1)
- Include a **CLAIMS CHECK** section in every deliverable, noting confirmed facts, assumptions, and open risks.
- Ensure deterministic artefacts: `context_map.md`, `flow_matrix.json`, `validation_rules.yaml`, `audit_report.md`, `knowledge_pack.md`.
- Document provenance logs (messages, tool calls, budgets) alongside QualityScore tables and compliance verdicts.
- Raise policy violations or uncertainties before finalizing outputs; escalate unresolved items to human owners.
