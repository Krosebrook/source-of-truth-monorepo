# AI Governance Paths — November 2025 Refresh

## Primary Sources
- **Internal Audit Anchor** — Vidya Peters & Mike Levy, “The Catalyst for Strong AI Governance,” The IIA Global Best Practices, 3 Sep 2025. <https://www.theiia.org/en/content/articles/global-best-practices/2025/the-catalyst-for-strong-ai-governance/>
- **Cross-Functional Operationalization** — Mirantis, “AI Governance: Best Practices and Guide,” 12 Sep 2025. <https://www.mirantis.com/blog/ai-governance-best-practices-and-guide/>
- **Compliance & Observability Fabric** — Austin Chia & Chrissy Kidd, “AI Governance in 2025: A Full Perspective on Governance for Artificial Intelligence,” Splunk, Jan 2025. <https://www.splunk.com/en_us/blog/learn/ai-governance.html>

## Path 1 — Internal Audit as the Governance Anchor (IIA)
- Build and maintain a living inventory for all AI/agentic systems, covering vendors, risk tiers, data lineage, and oversight owners.
- Embed internal audit inside design and deployment reviews for high-risk or customer-facing models to validate segregation of duties and adherence to NIST/ISO/COSO frameworks.
- Audit the distribution of governance responsibilities (decision rights, escalation paths, resourcing) to ensure no orphaned controls.
- Equip auditors with AI tooling for document synthesis, anomaly detection, and bias sniff tests to shorten feedback loops.
- Capture evidence (inventories, test plans, attestations) in the compliance bundle so the board sees line-of-sight across the AI portfolio.

**Success Signals**
- Inventory coverage ≥ 95% of AI workflows, with last-reviewed timestamps.
- Dual-agent review or internal-audit checkpoints logged before production launches of high-risk systems.
- Audit findings/mitigations linked to `docs/compliance/compliance_log.json` entries and SBOM/AI-BOM artefacts.

## Path 2 — Cross-Functional Governance Council (Mirantis)
- Stand up an executive-backed council with legal, security, risk, data science, engineering, compliance, and business stakeholders.
- Align governance OKRs with measurable business outcomes (e.g., reduced review cycle, CSAT uplift, incident MTTR) instead of policy for policy’s sake.
- Codify policies for fairness, transparency, and accountability; wire them directly into data governance (quality, lineage, retention) requirements.
- Define RACI + decision authority (e.g., ethics board vs. domain SMEs) and schedule recurring reviews to assess alignment with regulations (GDPR, EU AI Act, DORA, HIPAA).
- Automate compliance where practical: integrate bias checks, drift detection, and approvals into CI/CD or orchestration pipelines.

**Success Signals**
- Council charter + RACI published, quorum met at least monthly, and minutes linked inside `docs/DECISIONS.md`.
- Policies mapped to implementation tasks (e.g., pipeline gates, telemetry hooks) with backlog hygiene.
- Real-time monitoring catches bias/drift events before customer escalation.

## Path 3 — Compliance & Observability Fabric (Splunk)
- Treat accountability, transparency, fairness, privacy, and security as first-class telemetry domains; emit OpenTelemetry traces/metrics/events for every agent turn and tool call.
- Map regulatory frameworks (EU AI Act, US Executive Order 14179, AI Bill of Rights) to concrete control owners and automated tests.
- Require human-in-the-loop/on-the-loop oversight for high-risk automations, plus watermarking/signature trails for generated artefacts.
- Maintain public-facing and internal narratives: document decision-making, testing, and remediation steps to preserve trust.
- Integrate cybersecurity + legal reviews with AI deployments; ensure credential, data privacy, and watermark controls are enforced via policy-as-code.

**Success Signals**
- Compliance log entries include telemetry references (trace IDs, cosign hashes) and are regenerated after significant AI releases.
- OTEL exporters configured (or simulated) for dev/staging/prod, with anomaly alerts feeding governance dashboards.
- Clear documentation of human oversight boundaries and watermark/tag configurations per deployment.

## Immediate Actions
1. **Inventory Kickoff** — Use the IIA checklist to seed the AI-system inventory (HarvestFlow, FlashFusion consolidated, project-nexus). Link artefacts + owners in `workspace-meta/agents/registry.json`.
2. **Council Charter Draft** — Prepare a 1-page charter + RACI leveraging Mirantis guidance; route through Sponsor for approval and record the decision.
3. **Telemetry Pilot** — Prototype OTEL instrumentation (per Splunk playbook) on one agent workflow, logging trace IDs in `docs/compliance/compliance_log.json`.
4. **Review Cadence** — Schedule a quarterly governance refresh to re-validate these paths against evolving EU AI Act deadlines and US policy updates.
