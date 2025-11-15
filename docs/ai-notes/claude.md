# AI Development Partnership Guide (2025 DX Edition)

## 🎯 Core Principle: Ship Fast, Ship Right

We build production‑quality software efficiently.  Decisions and implementations should maximize impact while minimizing complexity.  Every unit of work needs a clear purpose tied to customer or business value.  Do not start until you understand the problem, and do not finish until the solution is verified to meet its goals.  Effective code reviews catch bugs early, reduce tech debt and improve architecture; they also enable mentorship and share domain knowledge.  Good code solves the right problem—reviewers must assess whether a change aligns with real requirements, not just whether it "works".

### FlashFusion Partnership Pillars
- **Human-in-the-loop**: Claude accelerates delivery, but humans remain accountable for approvals, rollouts and sign-off.
- **Safety-first**: Protect customer data, credentials and IP in every prompt, artifact and tool invocation.
- **Evidence over speculation**: Reference source material, test results or explicit reasoning for every recommendation.
- **Incremental delivery**: Ship in small, reversible slices with fast feedback via CI/CD, feature flags and staged rollouts.
- **Continuous learning**: Capture session insights, failure cases and evaluation data to refine prompts, guardrails and playbooks.

## 🚀 Workflow Modes

Work happens in distinct modes.  Switching modes is explicit and announced (e.g. `Switching to RESEARCH mode`).  Each mode has entry/exit criteria:

| Mode        | Purpose                                                | Exit Criteria                                                      |
|------------|--------------------------------------------------------|-------------------------------------------------------------------|
| **RESEARCH** | Explore unknowns, read code, gather context, identify patterns. | Summarise findings and decide next steps; update `FOUND.md`. |
| **PLANNING** | Architect solutions, create strategies, clarify scope, and prepare `Definition of Ready (DoR)` items. | Produce architecture diagrams, ADR draft, and a clear plan; update `DECISIONS.md`. |
| **IMPLEMENT** | Write code, scaffold tests, and execute plans. | All DoR items are addressed; tests and code compile; `make check` passes. |
| **VALIDATE** | Test, verify, review, and ensure quality. | Automated checks (fmt, lint, types, tests, security) pass; manual code review complete; metrics collected. |
| **OPTIMIZE** | Tune performance, refactor, improve usability and maintainability. | Benchmarks recorded, bottlenecks profiled, Big‑O complexity documented. |

### Mode Transitions
- Always announce mode switches and annotate commits with tags like `[MODE:IMPLEMENT][SCOPE:api]` so the flow is auditable.
- Before entering IMPLEMENT mode, ensure the story meets the **Definition of Ready**: clear requirements, acceptance criteria, architectural guidance, and risk analysis.
- Before completing VALIDATE mode, ensure **Definition of Done** is met: code merged behind feature flags, tests written/passing, documentation updated, and no outstanding quality issues.
- Use the **ultrathink** pattern (deep, structured reasoning) for complex decisions and record alternatives in ADRs.
- Spawn parallel agents for orthogonal tasks (e.g. performance profiling vs. UI polish) and explicitly note when work is running concurrently.

### Engagement Mode Cheat Sheet (FlashFusion naming)
- **Discovery Mode** – Clarify requirements, stakeholders, risks and success metrics before converging on a plan. Output: question lists, assumption logs and preliminary risk matrices for human review.
- **Planning Mode** – Propose design options with trade-offs, prioritized backlogs, testing strategy and rollout plan. Humans choose the path and update the source-of-truth plan.
- **Build Mode** – Generate reviewable diffs, explicit TODOs and draft tests that align with the agreed guardrails (style, performance, security). Humans execute tests and own merges.
- **Review Mode** – Produce defect checklists, regression risk notes and coverage gaps to support pre-release audits.
- **Optimize Mode** – Surface anomaly summaries, experiment ideas and hypothesis backlogs using production telemetry and user feedback.

### Tool Selection Matrix

Use the following matrix to choose the appropriate tool for common scenarios:

| Scenario               | Tool              | Rationale                                                 |
|------------------------|-------------------|-----------------------------------------------------------|
| Multi‑file search      | Task agent        | Preserves context across many files.                     |
| Bulk file reading      | Batch Read calls  | Processes multiple files in parallel to save time.       |
| Complex refactor       | Multiple agents   | Distributes work across specialized agents concurrently. |
| Simple edit            | Edit/MultiEdit    | Direct execution for small changes.                      |
| Open‑ended exploration | Task agent        | Autonomous discovery of unknown areas.                   |
| Build/test/lint        | Batch Bash        | Runs build, test and lint commands in parallel for faster validation. |

## 🤝 Collaboration Mechanics

### Prompt Packaging
Structure prompts so they are reproducible and auditable. Include objective, context links, constraints, deliverables and any planned verification steps. Tag sessions when relevant so telemetry can be grouped for later analysis.

### Session Hygiene
- Redact secrets, credentials and PII before sharing context.
- Version reusable prompt templates in the shared prompt library.
- Close each session with a short retro: wins, blockers and the next focus area.

### Decision Log
Capture Claude-assisted decisions (including rejected alternatives) in the project log with rationale and final approver. Link to ADRs or tickets so the historical record stays coherent.

## 🔧 Tools, Commands & Environment

A polyglot Makefile and CI pipeline provide a single entry point for all checks:

```make
# Initialize dev environment (install tools, hooks)
make init-dev

# Format, lint, type‑check, test and scan security
make fmt
make lint
make types
make test
make sec

# Aggregate all gates; fails on first error
make check

# Build for production
make build
```

A GitHub Actions workflow runs these targets on every pull request. Branch protection requires make check to succeed before merge.

Sample tree:

```bash
/                # repo root
├── Makefile          # polyglot tasks: fmt/lint/types/tests/sec/build
├── docs/
│   ├── CLAUDE.md     # this file
│   ├── PROJECT.md    # project‑specific context
│   ├── DECISIONS.md  # architectural decisions log
│   ├── FOUND.md      # research findings summaries
│   ├── PROGRESS.md   # current implementation state
│   └── ADR_TEMPLATE.md # template for new ADRs
├── src/              # application source code
│   ├── …
├── tests/            # unit and integration tests
│   └── …
├── .github/workflows/
│   └── ci.yml        # CI pipeline invoking make targets
├── .env.example      # example environment variables (no real secrets)
└── TODO.md           # active tasks & backlog
```

## 📋 Task Management
Use TodoWrite for tasks with three or more steps. Break tasks into 3–5 chunks; longer tasks should be split into subtasks.

Mark items in_progress before starting work and mark complete immediately after finishing. Only one task should be in progress at a time per developer.

Clean stale todos regularly; remove or update tasks that are no longer relevant.

When you see independent tasks, parallelize:

1. Identify parallelizable work.
2. Announce "Executing in parallel for speed".
3. Batch tool calls in a single message.
4. Process results simultaneously and consolidate findings.

### Definition of Ready (DoR)
- User story has clear acceptance criteria and business context.
- Technical approach approved or ADR created.
- Dependencies identified and available.
- Risks and assumptions documented (use R‑A‑I‑N: Risks, Assumptions, Implementation, Next). For example, ask what could go wrong if a feature is misused, check authentication and input validation for APIs, and perform lightweight threat modelling.
- Estimations and metrics agreed upon.

### Definition of Done (DoD)
- All code passes formatting, linting, type checking, tests, and security scans.
- Tests cover critical paths with >80 % coverage; negative tests included.
- Old code deleted; no dual implementations or dead flags remain.
- Documentation (README, docstrings/JSDoc, ADRs) updated.
- Errors are handled gracefully with appropriate messages and context.
- Performance is measured and meets the agreed SLOs (e.g. P95 latency < 500 ms).
- Security review completed; no hardcoded secrets; all inputs validated; encryption where needed.
- Observability hooks, dashboards and alerts cover the new behaviour.
- Feature flagged and disabled by default; ready to be toggled with a documented rollback plan.

## 🔧 Automated Checks & Recovery Protocol
Automated hooks are blocking. If any check fails, follow the recovery protocol:

1. **STOP** current work. Do not continue until the issue is fixed.
2. **FIX** all issues (❌ → ✅): run make fmt, make lint, make types, make test, and make sec locally. If a linter flags an issue, correct the code. If tests fail, debug and fix them. If a security scanner reports vulnerable dependencies, upgrade or patch them.
3. **VERIFY** fixes pass locally with make check. Rerun the failing command until it succeeds. Consider writing a new test to reproduce the bug and prevent regression.
4. **RESUME** the original task only after all checks pass.
5. **MAINTAIN** task awareness: update TODO.md, PROGRESS.md and DECISIONS.md to reflect the interruption and its resolution.

Common checks include:

- Formatting: gofmt, black, prettier, etc.
- Linting: golangci-lint, eslint, ruff.
- Type checking: mypy, tsc.
- Tests: pytest, go test, vitest.
- Security scanning: pip-audit, npm audit, osv-scanner, SAST tools.
- Dependency hygiene: keep dependencies patched and remove unused packages. Running dependency scanners ensures outdated components don't expose vulnerabilities.

### Claude Evaluation Harness
Augment CI with targeted evaluation suites when Claude contributes to critical workflows.

```yaml
ci:
  stages:
    - name: lint-test
      run: pnpm lint && pnpm test
    - name: security
      run: pnpm snyk:test --severity-threshold=medium
    - name: claude-evals
      run: pnpm eval:claude --suite regression --ci
      allow_failure: false
```

Maintain benchmark prompts to detect reasoning regressions and record evaluation scores per release so telemetry can feed into provider reviews and internal guardrails.

## 🧠 Context Management & Decision Logs
- **Batch operations**: group file reads and writes into single tool calls to minimize context switching.
- **Summarize outputs**: extract key findings and record them in FOUND.md (pattern, location, usage, decision). Use bullet lists rather than verbatim dumps. Summaries help maintain a manageable context size.
- **Use agents**: delegate exploratory or non‑blocking research to specialized agents to preserve main context. Document their findings and decisions.
- **Strategic forgetting**: when context exceeds 70 %, archive older information into DECISIONS.md and PROGRESS.md. This keeps the working memory lean.
- **Checkpoints**: every 30 minutes or after a major feature, review this guide and update progress documents. Before starting complex work, clear working memory and re‑load only the essential context.

## 🏗️ Implementation Standards

### General Code Completion Checklist
- [ ] All automated checks pass (make check).
- [ ] Unit and integration tests are written, meaningful, and passing.
- [ ] There are no dual implementations; old code is removed.
- [ ] Documentation is updated (README, docstrings/JSDoc, ADRs).
- [ ] Errors are handled gracefully with appropriate messages and context.
- [ ] Performance is measured and meets the agreed SLOs (e.g. P95 latency < 500 ms).
- [ ] Security review completed; no hardcoded secrets; all inputs validated; encryption where needed.

### Language‑Specific Rules

#### Go
**Forbidden:** interface{}, any{} — use concrete types. Avoid time.Sleep() in production; use channels or context. Do not panic() in libraries; return errors. Remove TODO comments — fix or delete. Avoid global variables.

**Required:** Early returns to reduce nesting; context propagation for cancellation; table‑driven tests for complex logic; structured logging with fields (e.g. logrus/zap); explicit error wrapping (fmt.Errorf("…: %w", err)). Propagate context through APIs and clients.

#### Python
**Forbidden:** eval(), exec() due to security risk; wildcard imports (from module import *); mutable default arguments; print() in production code (use logging). Avoid global state.

**Required:** Type hints (-> annotations) for all functions; docstrings for public APIs; context managers (with statements) for resource handling; f‑strings for formatting; pytest for tests; ruff/black for lint/format.

#### TypeScript/JavaScript
**Forbidden:** any type (define interfaces); var keyword (use const/let); == comparison (use ===); unhandled promises (always await/catch); modifying built‑ins.

**Required:** "use strict" at top; interface/type definitions before implementation; error boundaries in React; optional chaining and nullish coalescing; exhaustive switch statements; descriptive variable names; eslint rules enforced.

### Commit & Documentation Conventions
- Use Conventional Commits: feat(api): add user authentication, fix(validation): reject blank usernames, docs: update ADR for caching layer.
- Prefix commits with mode tags and scope (e.g. [MODE:IMPLEMENT][SCOPE:payments] chore: update dependencies).
- ADRs (Architectural Decision Records) capture major design choices. Use the ADR_TEMPLATE.md to document context, decision, alternatives, consequences, and status. Every non‑trivial architectural change must have an ADR.
- FOUND.md entries follow this pattern:

```markdown
## Found
- Pattern: summarised concept or pattern discovered
- Location: file:line or resource
- Usage: how it's used/why it matters

## Decision
Explanation of chosen approach and reasoning.
```

- DECISIONS.md logs one‑line summaries of ADRs with links; PROGRESS.md tracks completed features and current work; TODO.md lists open tasks.
- Update .env.example whenever a new environment variable is needed. Provide placeholder values for local development and note required secrets.

### Response Style & Communication Protocol
- Use status emojis in progress updates: ✓ (Complete), ⚡ (In progress), ❌ (Blocked), 🔄 (Refactoring), 🐛 (Bug found), 🚀 (Deployed).
- Provide direct answers; no unnecessary preambles or closings. When appropriate, one‑word responses are fine.
- Prefer one‑word responses when a short answer suffices.
- Omit preambles (e.g. "I'll help you…") and postambles (e.g. "Let me know if…") and answer directly.
- Show implementation before explanation; follow code with a concise rationale.
- Use bullet points and tables for clarity; do not embed long sentences in tables—keep them for keywords, phrases or numbers.
- If ambiguous, ask targeted questions; otherwise state assumptions explicitly and proceed.

## 🔍 Research & Decision‑Making Patterns
- **Parallel exploration**: spawn agents to investigate different areas (e.g., database schema, API patterns, test coverage). Record each agent's findings in FOUND.md.
- **Depth‑first search**: finish understanding one component before moving on. Resist shallow scanning across many modules.
- **Pattern recognition**: identify conventions early (naming, file structure, service boundaries). Use these patterns to guide new code.
- **Validation first**: verify assumptions with small tests or prototypes before investing in full implementation.
- **Metrics & Checklists**: track inspection rate, defect density and conformance to standards. Checklists make processes repeatable and reliable.
- **Attention to critical paths**: give extra attention to auth, APIs and shared components—these impact more than the immediate change.
- **Respect business context**: ask whether a change maps to an actual requirement or user need; if the rationale is unclear, seek clarification.

### Decision Records
When considering options, document alternatives and their pros/cons. Use the following template:

```
## Options Considered
A. [Approach 1] – Pros: …, Cons: …
B. [Approach 2] – Pros: …, Cons: …

## Recommendation
[Chosen approach] because [reasoning].
```

If multiple viewpoints exist, capture them. When security or performance is at stake, lean toward proven patterns and cite authoritative sources.

## 🚨 Error Handling & Rollback Strategy

### Failure Recovery
1. Capture the full error context (stack trace, input parameters, environment).
2. Identify the root cause, not just the symptom. Ask why this failed and why a similar failure wasn't caught earlier.
3. Fix systematically: patch the bug, write or update a test reproducing it, and refactor underlying issues.
4. Verify the fix resolves the issue with tests and manual checks.
5. Add a regression test to prevent the bug from resurfacing.

### Rollback & Resilience
- Create a restoration point (Git tag or branch) before major changes. Use git diff to review differences.
- Test changes in isolation; avoid mixing unrelated changes in the same pull request.
- For big changes, roll out gradually behind a feature flag. Monitor metrics and errors. If issues arise, toggle off the flag.
- Maintain idempotent migrations and scripts so they can run repeatedly without side effects.

## 📊 Performance Guidelines
- **Measure first**: do not optimize prematurely. Use profilers (go test -bench, cProfile, node --prof) to identify hot spots.
- **Profile bottlenecks**: focus on the 10 % of code consuming 90 % of time or memory.
- **Batch operations**: minimize I/O calls by batching reads/writes and network requests.
- **Cache strategically**: weigh memory usage against computation cost. Use TTLs and invalidation strategies.
- **Async when possible**: use asynchronous patterns (goroutines, async/await) to avoid blocking threads.
- **Document complexity**: note Big‑O complexity for new algorithms; avoid accidental quadratic loops.

### Performance checklist
Ensure benchmarks are recorded before and after changes; memory usage is profiled; DB queries are optimized (indexes, prepared statements); network calls are minimized or compressed.

## 🔐 Security Standards
Security must be built in from the start—not bolted on later. Developers should design code to handle untrusted input safely, protect sensitive data and enforce correct logic flows. Input validation, secrets management, authentication, output encoding and dependency hygiene are fundamental.

### Always Required
- **Input Validation & Sanitization**: validate all inputs on the server using allow‑lists for types, ranges and lengths. Disallow or escape meta‑characters. Reject invalid input early. Use centralized validation routines.
- **Output Encoding**: encode untrusted data for the target context (HTML, SQL, OS commands).
- **Authentication & Authorization**: require authentication for all resources except those explicitly public. Use central authentication services; enforce multi‑factor for sensitive accounts; store credentials securely; rotate and expire secrets.
- **Session Management**: use secure session identifiers; set appropriate cookie attributes; enforce short session lifetimes; regenerate sessions after login.
- **Parameterized Queries & Prepared Statements**: never concatenate SQL; always use parameterized queries to prevent injection.
- **Secret Management**: never hardcode secrets; load them from environment variables or secret managers; commit only .env.example with placeholder values.
- **Secure Randomness**: use cryptographically secure random functions for tokens, IDs and session keys.
- **HTTPS Everywhere**: use TLS/SSL; avoid plain HTTP in production.
- **Rate Limiting & Throttling**: protect API endpoints from abuse.
- **Shift‑Left Security**: during sprint planning, ask what could go wrong if the feature is misused; while designing APIs, check authentication, validate input and understand what data is collected or shown; perform lightweight threat modelling by asking how an attacker might break the system.
- **Team Responsibility**: rotate security reviewers; add security checks to CI/CD; celebrate developers who identify vulnerabilities.

### Security Review Checklist
- [ ] No hardcoded secrets or credentials in the codebase.
- [ ] All inputs (including file uploads, query parameters and headers) are sanitized and validated.
- [ ] Authorization checks are enforced on every action; least privilege is applied.
- [ ] Sensitive data (passwords, tokens, personal data) is encrypted at rest and in transit.
- [ ] Audit logging is enabled; logs include request_id, user_id, operation and outcome. Logs must not contain sensitive data such as passwords or tokens.
- [ ] Dependencies are up to date; run pip-audit, npm audit and osv-scanner regularly.
- [ ] External services are called through authenticated channels and with timeouts.
- [ ] Business logic is reviewed for edge cases; ensure functions cannot be misused (e.g. verifying a cart was paid before confirming orders).

### FlashFusion Governance Additions
- **Data minimization**: share only the context required for the task; scrub PII and regulated data before prompting.
- **Secret handling**: never paste secrets, tokens or certificates; use secret references or mock values during collaboration.
- **IP stewardship**: attribute external snippets, confirm license compatibility and run license scanners as part of CI.
- **Auditability**: store prompt/response pairs for regulated projects in the encrypted prompt vault following retention policies.
- **Access controls**: scope Claude access to approved repos and knowledge bases with least-privilege API keys.

## 📝 Documentation Levels
- **CLAUDE.md**: this partnership guide. Read it every 30 minutes or when context exceeds 50 %.
- **PROJECT.md**: project‑specific context, scope and stakeholders.
- **PROGRESS.md**: current implementation state; summarise major accomplishments and remaining work. Update after each feature.
- **DECISIONS.md**: succinct log of architectural decisions; cross‑link to ADRs. Update whenever an ADR is created or updated.
- **FOUND.md**: summarise research findings with patterns, locations, usages and decisions.
- **TODO.md**: active tasks and backlog. Use checkboxes and mark in_progress as tasks start.
- **ADR_TEMPLATE.md**: template for new ADRs; includes context, decision, alternatives, consequences and status.
- **README.md**: setup, testing and deployment instructions. Include environment setup, make commands and how to run locally and in production.
- **.env.example**: example environment variables for local development. Provide sample values but no real secrets. Document each variable's purpose.
- **diagrams/ folder**: architecture diagrams, sequence diagrams, data flows. Keep these up to date.

### Documentation Standards
- **Public APIs**: Provide full docstrings or JSDoc comments describing behavior, inputs and outputs.
- **Complex logic**: Include inline explanations or comments to aid future maintainers.
- **Business rules**: Document business rules and domain logic in a separate file or within PROJECT.md or a dedicated business_rules.md.
- **Setup steps**: Write all environment setup, installation and deployment instructions in README.md.
- **Architecture**: Place system architecture, sequence and data flow diagrams in the diagrams/ folder and keep them synchronized with the code.

## 🎮 Advanced Techniques

### Agent Delegation Patterns:
- **Parallel Research**: spawn agents for database schema, API patterns and test coverage simultaneously. Each agent writes findings to FOUND.md.
- **Distributed Implementation**: delegate backend changes, frontend updates and test creation to specialized agents. Track progress separately and merge once all are ready.

### Speculative Execution
- Read files that might be relevant, prepare multiple approaches and test assumptions early. Fail fast on wrong paths.

### Smart Batching
- Batch file reads and API calls instead of sequential loops. For example, use read_all(files) instead of reading files one by one; this reduces context switching and speeds up processing.

**Implementation note**: The patterns described above outline how to leverage agents effectively. The actual agent implementations (for example, code that reads files or orchestrates backend and frontend tasks) should live in the codebase (e.g. under src/agents/) rather than in this Markdown guide. This document focuses on principles and patterns for using agents; it is not the place to define or embed agent code.

## 🧠 Cognitive Load Management
- Break tasks into manageable chunks; tackle one complex problem at a time.
- Draw system boundaries and identify key abstractions before coding. Use diagrams to solidify the mental model.
- Track state changes—know what variables or services are mutated at each step.
- Validate assumptions frequently. If you assume an API behaves a certain way, write a small test to confirm.
- Document decisions immediately to avoid forgetting reasoning.
- Simplify before optimizing. Remove unnecessary layers and abstractions.

## 🔄 Continuous Improvement & Feedback Loops
1. Write code following best practices and language rules.
2. Run automated checks (make check).
3. Fix issues identified by tools.
4. Validate behavior manually and with tests.
5. Refactor if needed to improve readability, performance or security.
6. Document learnings in PROGRESS.md and DECISIONS.md.
7. Seek peer review; incorporate feedback respectfully and constructively.

### Tooling & Observability
- Use the `flashfusion claude:session` CLI to create, tag and archive conversations while streaming telemetry (prompt size, completion time, evaluation results) to the Ops data lake.
- Enforce guardrail policies (token budgets, disallowed content, approved tools) via version-controlled configuration and run automated red-team suites to probe for jailbreak or prompt-injection weaknesses.
- Capture prompt/response provenance with trace IDs so long-running workflows stay debuggable and auditable.
- Review session analytics weekly for drift or failure clusters, maintain a high-performing prompt cookbook and share notable wins or misses in the monthly AI guild sync.

Quality gates include pre‑commit hooks (formatting, linting), CI/CD validation, code review checklist, performance benchmarks, security scanning and user acceptance testing. All gates must pass before merging.

## 💬 Problem‑Solving Protocol

### When stuck:
1. **Stop**: Don't spiral into complexity.
2. **Breathe**: Step back from the problem.
3. **Simplify**: Reduce to the core issue; isolate the failing component.
4. **Research**: Check similar solutions, previous decisions or patterns; consult FOUND.md.
5. **Ask**: Present options A vs B with pros/cons and ask for input if necessary.
6. **Iterate**: Take small steps towards a solution; verify each change.

### Decision Making
Document options, pros/cons and your recommendation. Base choices on clear reasoning and cite authoritative sources. Prioritize maintainability, security and performance over cleverness. When in doubt, choose the simpler solution.

## 🎯 Success Metrics
- **Code Quality**: zero linting errors; tests cover >80 % of critical paths; P95 response time < 500 ms; no known security vulnerabilities; dependency tree is free of unused packages.
- **Development Velocity**: features complete on first submission; minimal rework; automated checks pass on the first run; clear documentation accompanies every PR; cycle time from PR open to merge measured and improved.
- **Reliability**: uptime meets SLOs; error budgets are respected; incident frequency decreases; mean time to recovery is short.

## 🚀 Quick Reference Commands

```bash
# Initialize development environment
make init-dev

# Run formatting, linting, type checking, tests and security scans
make check

# Format code only
make fmt

# Run linter
make lint

# Run static type checks
make types

# Run tests with coverage
make test

# Run security scanners
make sec

# Run performance benchmarks (Go example)
go test -bench . -benchmem

# Run Node/TS tests with coverage
npm test -- --coverage

# Validation suite (format + test + lint)
make fmt && make test && make lint

# Full build (clean and compile, then run tests)
make clean build test

# Audit dependencies
pip-audit
npm audit fix

# Full build
make build
```

## ⚠️ Emergency Procedures

### System Down
1. Check logs and metrics for error messages and spikes.
2. Verify dependencies (database connection, external services, configuration). Ensure secrets are loaded correctly.
3. Test components in isolation; reproduce the issue locally if possible.
4. Roll back to the last known good version using the feature flag or restoration point.
5. Communicate status to stakeholders.

### Performance Crisis
1. Profile immediately to identify bottlenecks.
2. Prioritize quick fixes (e.g. index a missing column, add caching) to restore service.
3. Implement a durable solution (e.g. redesign algorithm, partition data) after stabilizing.
4. Document lessons learned.

### Security Breach
1. Isolate affected systems; disable compromised credentials.
2. Audit access logs to determine scope and impact.
3. Patch vulnerabilities; rotate secrets; enforce multi‑factor authentication.
4. Reset credentials and tokens; notify impacted users if required.
5. Conduct a post‑mortem; update security practices and add tests to prevent recurrence.

## 🔔 Reminders
- This guide applies to feature branches; backward compatibility is not required unless specified.
- Delete old code; do not keep dual implementations.
- Prefer simple solutions over cleverness. Clarity beats complexity.
- Measure everything; decisions should be data‑driven.
- Ship iteratively; release in small, working increments.
- Re‑read this file whenever context exceeds 50 % or every 30 minutes of active work.
- When in doubt, choose the simpler solution and document why.

This guide is intended to be comprehensive. If you discover new best practices or gaps, update this document and create a companion ADR describing the rationale. Secure coding is a continual learning process: writing software with security built in from the start protects users and systems from vulnerabilities. Always treat untrusted input carefully and involve the whole team in security, quality and performance.
