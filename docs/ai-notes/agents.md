# FlashFusion AI Agent System Guidelines (2025)

FlashFusion agents combine structured orchestration, trusted tool access, and verifiable reasoning to automate core business and engineering workflows. This guide merges the system-level guardrails with repository conventions so every team member has a single reference.

## Core Principles
- **Outcome-first**: Each agent exists to deliver a measurable business or user outcome.
- **Bounded autonomy**: Agents operate within explicit policies, budgets, and escalation paths.
- **Human governance**: Humans approve goals, review high-impact changes, and own incident response.
- **Secure-by-default**: Data classification, least privilege, and full audit trails are non-negotiable.
- **Evaluate continuously**: Offline evals, sandbox runs, and production telemetry inform every release.

## Repository Quick Reference
- `src/`: Application modules and entry points.
- `tests/`: Unit/integration tests that mirror `src/` paths.
- `assets/` or `public/`: Static files (images, styles, fixtures).
- `scripts/`: Developer utilities (build, lint, release).
- `docs/`: Design notes, ADRs, diagrams, and examples.
- Install dependencies: Node via `npm ci`; Python via `pip install -r requirements.txt`.
- Run locally: Node `npm run dev`; Python `python -m src`.
- Test: Node `npm test`; Python `pytest -q`.
- Build: Node `npm run build`; Python `python -m build`.
- Discover commands with `npm run`, `scripts/`, or `make help`.
- Formatting: Prettier + ESLint for JS/TS (`npm run format`, `npm run lint`); Black + Ruff for Python (`black .`, `ruff check`).
- Naming: PascalCase (classes), camelCase (JS/TS functions), snake_case (Python files/functions), kebab-case (web assets).
- Testing mirrors `src/` structure, targets ≥80 % coverage, and stays deterministic via dependency injection.
- Commits follow Conventional Commits; PRs include context, linked issues, screenshots (if UI), risks/rollbacks, and updated docs/tests.
- Security hygiene: never commit secrets, validate inputs at boundaries, avoid logging sensitive data, and use least-privilege tokens.

## Reference Architecture

### Agent Roles
- **Orchestrators**: Plan multi-step work, allocate tasks, and enforce guardrail policies.
- **Domain specialists**: Execute scoped domain logic (sales ops, fulfilment, finance, etc.).
- **Tool agents**: Wrap deterministic APIs, RPA flows, or code execution sandboxes with strict input validation.
- **Safety & compliance agents**: Monitor for policy violations, perform content/classification checks, and escalate when risk thresholds are crossed.
- **Evaluator agents**: Score outputs, run regression suites, and gate promotion to production.

### Communication Contract

```typescript
interface AgentEnvelope {
  id: string;
  traceId: string;
  parentId?: string;
  from: AgentId;
  to: AgentId | AgentId[];
  intent: 'plan' | 'act' | 'observe' | 'escalate' | 'complete';
  payload: Payload;                 // typed schema per capability
  policyContext: PolicySnapshot;    // guardrails in effect for this task
  ttlMs: number;                    // prevents runaway loops
  createdAt: string;                // ISO timestamp
}
```

- Messages are immutable; state changes live in the shared event log.
- Every exchange carries the active policy snapshot and evaluation budget.
- Validators reject malformed or policy-violating payloads before dispatch.

## Planning & Execution Patterns
1. **Goal intake**: A human sets intent, success criteria, constraints, and risk classification.
2. **Structured planning**: The orchestrator proposes a plan graph (steps, owners, exit criteria) and seeks approval for medium/high-risk work.
3. **Tool-constrained execution**: Domain agents call approved tools via signed capability tokens; no direct shell access outside sandboxes.
4. **Verification loop**: Evaluator agents and automated tests score intermediate outputs; the orchestrator decides to continue, retry, or escalate.
5. **Handoff & logging**: Completed work ships with provenance data (messages, tool calls, evaluations) to the audit ledger.

## Reliability & Safety Controls
- Require deterministic tool wrappers with schema validation and replay-safe design.
- Enforce planning thresholds: complex work (>N steps or risk ≥ medium) triggers a human checkpoint.
- Budget tokens, tool invocations, and runtime per task; auto-stop on threshold breaches.
- Store chain-of-thought privately and redact external surfaces to avoid leakage.
- Run automated adversarial prompts (prompt injection, policy evasion) against each release candidate.
- Provide safe fallback paths: degrade to deterministic workflows or escalate to humans when confidence < threshold.

## Observability & Telemetry
- Stream structured events (plans, tool calls, errors, evaluations) into the agent data lake with `traceId` correlation.
- Maintain SLOs per agent: task success rate, p95 response time, cost per task, policy violation rate.
- Use distributed tracing to visualise long-running workflows and identify bottlenecks.
- Ship guardrail alerts to PagerDuty/Slack with actionable metadata (agent, policy breached, payload hash).
- Store conversation summaries and evaluation scores in the knowledge base for trend analysis.

## Development Lifecycle

### Build Checklist
- Design doc reviewed (goal, policy boundaries, evaluation plan).
- Capability schema defined using Zod/JSON Schema, including limits and redaction rules.
- Unit + contract tests for planning logic, tool adapters, and failure handling.
- Simulation suite covering nominal, edge, adversarial, and outage scenarios.
- Offline evaluation harness with golden tasks seeded from real-world transcripts.

```bash
# Local agent workflow
pnpm agents:lint
pnpm agents:test               # unit + contract tests
pnpm agents:simulate --suite smoke
pnpm agents:eval --suite regression --model claude-3.5-sonnet
```

### Deployment Pipeline

```yaml
jobs:
  prepare:
    steps:
      - run: pnpm agents:build
      - run: pnpm agents:bundle --signed

  evaluate:
    needs: prepare
    steps:
      - run: pnpm agents:simulate --suite critical
      - run: pnpm agents:eval --suite gated --min-score 0.85

  release:
    needs: evaluate
    if: needs.evaluate.result == 'success'
    steps:
      - run: pnpm agents:deploy --environment staging
      - run: pnpm agents:shadow --source production --percent 10
      - run: pnpm agents:promote --environment production --strategy canary
```

- Shadow deployments capture real traffic in read-only mode before promotion.
- Canary releases monitor policy violations and SLOs for at least one business cycle.

## Security & Compliance
- Classify all inputs/outputs; deny ingestion of restricted data unless approval and data minimisation controls exist.
- Assign least-privilege capability tokens per agent and rotate them automatically.
- Log every tool invocation with hashed payload, result summary, and approver when applicable.
- Provide policy packs for GDPR/CCPA/SOX/HIPAA; safety agents enforce them via pre- and post-conditions.
- Retain audit logs for 18 months with tamper-evident storage.

## Knowledge & Retrieval
- Use retrieval-augmented prompts with fresh embeddings; decouple knowledge source updates from agent releases.
- Track citation coverage for factual responses; outputs without cited sources fail evaluation.
- Periodically purge stale embeddings and re-index data sources to prevent drift.

## Integration Patterns
- Expose agents through the platform API gateway with request signing and rate limiting.
- Publish workflow templates and prompt libraries via the internal design system for reuse.
- Provide human handoff endpoints (Slack, email, ticketing) with context bundles for seamless transitions.

## Continuous Improvement
- Review telemetry weekly for drift, hallucination clusters, or systematic policy hits.
- Run quarterly chaos drills (tool outage, API latency, revoked credential) to validate resilience.
- Share postmortems and micro-learnings in the Agent Guild; roll successful patterns into the starter kits.
- Maintain a shared cookbook of high-performing prompts and update it after each sprint retro.

---

*Last updated: 2025-01. Align future iterations with FlashFusion AI governance and risk policies before rollout.*
