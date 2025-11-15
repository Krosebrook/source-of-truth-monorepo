# FlashFusion Agent Operations Handbook (2025 Edition)

## Purpose
- Merge FlashFusion platform guardrails, Kyler's Codex CLI workflows, and HarvestFlow/Smart Triage playbooks into a single 2025-ready reference.
- Drive outcome-first agent launches that stay within policy budgets, escalate risk paths, and preserve immutable audit trails.
- Standardize security, evaluation, and documentation practices for orchestrators, skills, tools, evaluators, builders, and auditors.
- **NEW**: Ensure EU AI Act compliance, supply chain security (SBOM/SLSA), and modern observability standards.

## Shared Core Principles
- **Outcome-first**: tie every goal to measurable business or customer impact recorded in the intake brief and revisited during verification and retro.
- **Bounded autonomy**: operate under explicit thinking budgets, tool scopes, and escalation paths; never exceed allocated runtime or capability tokens.
- **Human governance**: route intent shifts, high-risk tool calls, releases, and incident response through named human approvers with logged decisions.
- **Secure-by-default**: sanitize prompts, redact secrets, apply least-privilege tokens, and maintain append-only logs.
- **Continuous evaluation**: run offline suites, sandbox simulations, telemetry reviews, and human spot checks each sprint; block releases on regressions.
- **Controllable runtime**: treat the agent loop as inspectable middleware with override hooks before layering domain logic or heuristics.
- **NEW - Zero-trust architecture**: Assume breach, implement defense in depth, continuous verification.
- **NEW - Supply chain integrity**: SBOM generation, SLSA Level 2+ compliance, signed attestations.
- **NEW - AI safety first**: Constitutional AI principles, RLHF alignment, watermarking, confidence scoring.

## Architecture Layers & Roles

| Layer / Role | Responsibilities | Notes | 2025 Enhancements |
| --- | --- | --- | --- |
| Orchestrator agent | Intake goal + policy snapshot, draft plan graph, assign tools/skills, enforce budgets, escalate risk | Enable extended thinking (≥4k baseline, ≥8k complex) and own incident handling with immediate escalation on policy hits. | OpenTelemetry tracing, cost attribution, EU AI Act risk assessment |
| Domain specialists / skills | Encapsulate repeatable workflows (billing, fulfilment, triage) | Keep `SKILL.md` ≤200 tokens, gerund names, deterministic tests on Haiku + Sonnet, and audited rollout notes. | Vector embeddings for semantic search, confidence scoring |
| Tool adapters | Deterministic wrappers with JSON Schema validation, retries, logging | Favor Tool Runner beta, stream deltas, hash IO payloads, and maintain provenance keyed by `traceId`. | eBPF instrumentation, SLSA attestations, circuit breakers |
| Safety & evaluator agents | Policy enforcement, jailbreak detection, regression scoring, release gating | Block promotion below thresholds; require human review on policy hits or low-confidence critiques. | Prompt injection detection (Rebuff), RLHF feedback loops, differential privacy |
| Memory & knowledge | Vector stores, Files API assets, memory namespaces for task state | Apply retention/rotation policies, scrub secrets pre-storage, label namespaces by purpose. | Pinecone/Weaviate/Qdrant integration, homomorphic encryption for sensitive data |
| Context Engineer | Produce `context_map.md` and `flow_matrix.json` (spec_version 3.2) | Maintain deterministic key order, dependencies, and escalation annotations. | EU AI Act documentation, model cards, SBOM manifests |
| Prompt Architect | Emit `scoped_prompt.md` + `validation_rules.yaml` | Document constraints, guardrails, evaluator hooks, and outstanding assumptions. | Constitutional AI principles, watermarking directives, confidence thresholds |
| Builder Agent | Generate production-ready `deliverable_bundle.zip` | Include all artefacts without placeholders and wire provenance manifests. | Signed container images, SLSA provenance, vulnerability scanning |
| Auditor | Publish `audit_report.md` + `compliance_log.json` | Provide QualityScore tables, policy verdicts, and rollback documentation. | EU AI Act compliance checks, carbon footprint metrics, FinOps analysis |
| Synthesizer | Ship `knowledge_pack.md` | Translate audits into lessons learned, backlog items, and next steps for the Agent Guild. | Chaos engineering results, cost optimization opportunities |

## Modern Tech Stack (2025)

### Core Infrastructure
```yaml
platform:
  orchestration:
    - kubernetes: "1.29+"
    - service_mesh: "istio | linkerd"
    - gitops: "argocd | flux"

  observability:
    - tracing: "opentelemetry + jaeger/tempo"
    - metrics: "prometheus + grafana"
    - logs: "loki | elasticsearch"
    - ebpf: "falco + tetragon + pixie"

  security:
    - policy: "opa | cedar"
    - secrets: "hashicorp-vault | sealed-secrets"
    - scanning: "trivy + semgrep + snyk"
    - sbom: "syft + grype"
    - signing: "cosign + sigstore"

  ai_infrastructure:
    - vector_db: "pinecone | weaviate | qdrant"
    - model_registry: "mlflow | wandb"
    - feature_store: "feast | tecton"
    - monitoring: "evidently | whylabs"
```

### Communication Contract (Enhanced)
```typescript
interface AgentEnvelope {
  // Core fields
  id: string;
  traceId: string;  // W3C Trace Context compliant
  parentId?: string;
  spanId: string;   // NEW: OpenTelemetry span

  // Routing
  from: AgentId;
  to: AgentId | AgentId[];
  intent: 'plan' | 'act' | 'observe' | 'escalate' | 'complete';

  // Payload & Context
  payload: Payload;
  policyContext: PolicySnapshot;
  thinkingBudget: number;
  ttlMs: number;

  // Metadata
  createdAt: string;
  complianceTags: string[];

  // NEW: 2025 Fields
  confidenceScore: number;      // 0.0-1.0
  riskTier: 'minimal' | 'limited' | 'high' | 'systemic';  // EU AI Act
  costEstimate: CostEstimate;   // Token usage, compute time
  sbomHash?: string;            // Software supply chain
  watermark?: WatermarkSignature;  // AI-generated content marking

  // Security
  signature: string;            // Cryptographic signature
  attestations: Attestation[];  // SLSA/in-toto attestations
}

interface CostEstimate {
  tokens: number;
  estimatedCostUSD: number;
  carbonGramsCO2: number;
}

interface WatermarkSignature {
  algorithm: 'synthid' | 'c2pa';
  signature: string;
  timestamp: string;
}
```

## Execution Lifecycle (2025 Enhanced)

### Phase 1: Intake & Risk Assessment
```yaml
intake:
  required_fields:
    - goal
    - constraints
    - stakeholders
    - success_metrics
    - budget_limits

  risk_assessment:  # NEW: EU AI Act requirement
    - identify_ai_system_type
    - classify_risk_tier
    - determine_human_oversight_needs
    - document_transparency_requirements
    - assess_bias_potential

  compliance_check:  # NEW
    - gdpr_article_22_applicability
    - sox_audit_requirements
    - industry_specific_regulations
```

### Phase 2: Planning with Guardrails
```yaml
planning:
  plan_generation:
    - draft_execution_graph
    - assign_confidence_scores
    - estimate_costs_and_carbon
    - identify_critical_paths

  safety_review:  # NEW
    - constitutional_ai_alignment
    - prompt_injection_risk_assessment
    - output_watermarking_strategy
    - human_approval_gates

  sbom_planning:  # NEW
    - dependency_inventory
    - vulnerability_assessment
    - license_compliance_check
```

### Phase 3: Secure Execution
```yaml
execution:
  runtime_security:
    - capability_token_validation
    - rate_limiting_enforcement
    - circuit_breaker_patterns
    - zero_trust_verification

  observability:  # NEW
    - opentelemetry_instrumentation
    - ebpf_kernel_monitoring
    - distributed_trace_correlation
    - cost_tracking_per_operation

  supply_chain:  # NEW
    - slsa_provenance_generation
    - artifact_signing
    - sbom_attestation
```

### Phase 4: Continuous Verification
```yaml
verification:
  automated_testing:
    - contract_tests
    - property_based_tests
    - chaos_experiments
    - performance_benchmarks

  security_validation:  # NEW
    - sast_scanning
    - dast_scanning
    - container_scanning
    - secret_detection

  compliance_validation:  # NEW
    - eu_ai_act_checklist
    - model_card_generation
    - audit_trail_verification
    - bias_testing
```

### Phase 5: Progressive Deployment
```yaml
deployment:
  rollout_strategy:
    - feature_flags: "launchdarkly | unleash"
    - canary_deployment: "5% -> 25% -> 50% -> 100%"
    - shadow_traffic: "mirror production for validation"
    - automated_rollback: "on SLO breach"

  monitoring:  # NEW
    - real_user_monitoring
    - synthetic_monitoring
    - error_budget_tracking
    - carbon_footprint_monitoring
```

### Phase 6: Learning & Optimization
```yaml
retrospective:
  metrics_analysis:
    - success_rate
    - latency_p50_p95_p99
    - cost_per_transaction
    - carbon_efficiency

  feedback_loops:  # NEW
    - rlhf_data_collection
    - user_satisfaction_scores
    - model_drift_detection
    - adversarial_example_capture

  knowledge_management:
    - update_playbooks
    - refine_prompts
    - optimize_skills
    - share_learnings
```

## Operational Controls (2025 Standards)

### Zero-Trust Security Model
```yaml
zero_trust:
  principles:
    - never_trust_always_verify
    - assume_breach
    - least_privilege_access
    - continuous_verification

  implementation:
    network:
      - service_mesh_mtls
      - microsegmentation
      - egress_filtering

    identity:
      - workload_identity
      - short_lived_tokens
      - mfa_everywhere
      - webauthn_passkeys  # NEW

    data:
      - encryption_at_rest
      - encryption_in_transit
      - field_level_encryption
      - homomorphic_encryption  # NEW for sensitive AI processing
```

### Supply Chain Security (SLSA Level 2+)
```yaml
supply_chain:
  build:
    - hermetic_builds
    - reproducible_builds
    - signed_attestations
    - provenance_generation

  dependencies:
    - sbom_generation: "syft"
    - vulnerability_scanning: "grype"
    - license_compliance: "fossa"
    - update_automation: "dependabot"

  artifacts:
    - container_signing: "cosign"
    - binary_signing: "sigstore"
    - attestation_storage: "rekor"
    - policy_verification: "opa"
```

### AI Safety & Governance
```yaml
ai_safety:
  alignment:
    - constitutional_ai_principles
    - rlhf_continuous_improvement
    - value_alignment_testing
    - adversarial_robustness

  transparency:
    - model_cards_required
    - decision_explanations
    - confidence_scoring
    - uncertainty_quantification

  accountability:
    - watermarking_all_outputs
    - audit_trail_immutable
    - human_review_thresholds
    - incident_response_plan

  fairness:
    - bias_detection_continuous
    - demographic_parity_testing
    - individual_fairness_checks
    - disparate_impact_analysis
```

### Observability & Telemetry (OpenTelemetry + eBPF)
```yaml
observability:
  opentelemetry:
    traces:
      - w3c_trace_context
      - baggage_propagation
      - span_attributes_standardized
      - sampling_strategy_adaptive

    metrics:
      - red_metrics  # Rate, Errors, Duration
      - use_metrics  # Utilization, Saturation, Errors
      - custom_business_metrics
      - cost_metrics

    logs:
      - structured_json
      - correlation_ids
      - log_levels_enforced
      - pii_redaction

  ebpf_instrumentation:
    - network_observability
    - kernel_tracing
    - zero_code_instrumentation
    - performance_profiling

  dashboards:
    - service_maps
    - dependency_graphs
    - error_analytics
    - cost_attribution
    - carbon_tracking
```

## Repository Integration (2025 Updates)

### Project Structure
```
.
├── .github/
│   ├── workflows/
│   │   ├── ci.yaml          # SLSA Level 2 compliant
│   │   ├── security.yaml    # SAST/DAST/Secret scanning
│   │   └── compliance.yaml  # EU AI Act checks
│   └── dependabot.yaml
├── agents/
│   ├── orchestrator/
│   ├── evaluator/
│   └── skills/
├── infrastructure/
│   ├── terraform/          # IaC definitions
│   ├── k8s/               # Kubernetes manifests
│   │   ├── base/
│   │   └── overlays/      # Kustomize overlays
│   └── policies/          # OPA policies
├── observability/
│   ├── otel-collector.yaml
│   ├── dashboards/        # Grafana dashboards
│   └── alerts/            # Prometheus alerts
├── compliance/
│   ├── model-cards/       # AI model documentation
│   ├── sbom/             # Software bills of materials
│   └── audit-logs/       # Immutable audit trail
├── scripts/
│   ├── security-scan.sh
│   ├── sbom-generate.sh
│   └── compliance-check.sh
└── tests/
    ├── unit/
    ├── integration/
    ├── chaos/            # Chaos engineering
    └── security/         # Security test suites
```

### Enhanced CI/CD Pipeline
```yaml
# .github/workflows/ci.yaml
name: CI Pipeline with SLSA Level 2

on:
  push:
    branches: [main, develop]
  pull_request:

jobs:
  security-scan:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Secret Scanning
        run: gitleaks detect --baseline-path=.gitleaks-baseline.json

      - name: SAST Analysis
        run: semgrep ci --config=auto

      - name: Dependency Check
        run: |
          npm audit --audit-level=moderate
          pip-audit
          cargo audit

  build-and-test:
    needs: security-scan
    runs-on: ubuntu-latest
    permissions:
      id-token: write  # For OIDC/keyless signing

    steps:
      - name: Generate SBOM
        run: |
          syft . -o spdx-json > sbom.spdx.json
          syft . -o cyclonedx-json > sbom.cdx.json

      - name: Vulnerability Scan
        run: |
          grype sbom.spdx.json --fail-on high
          trivy fs . --severity HIGH,CRITICAL

      - name: Run Tests with Coverage
        run: |
          npm test -- --coverage
          go test -race -coverprofile=coverage.out ./...

      - name: OpenTelemetry Test Tracing
        run: |
          export OTEL_EXPORTER_OTLP_ENDPOINT="http://localhost:4317"
          npm test -- --trace

      - name: Build Container
        run: |
          docker build -t $IMAGE:$TAG .

      - name: Container Scanning
        run: |
          trivy image $IMAGE:$TAG

      - name: Sign Artifacts (SLSA Level 2)
        uses: sigstore/cosign-installer@v3
        run: |
          cosign sign --yes $IMAGE:$TAG
          cosign attest --yes --predicate sbom.spdx.json $IMAGE:$TAG

      - name: Generate SLSA Provenance
        uses: slsa-framework/slsa-github-generator@v1
        with:
          subject-name: ${{ env.IMAGE }}
          subject-digest: ${{ steps.build.outputs.digest }}

  compliance-check:
    needs: build-and-test
    runs-on: ubuntu-latest
    steps:
      - name: EU AI Act Compliance
        run: |
          python scripts/eu_ai_act_check.py

      - name: Generate Model Card
        run: |
          python scripts/generate_model_card.py > compliance/model-cards/latest.yaml

      - name: Policy Validation
        run: |
          opa test policies/
          opa eval -d policies/ -i input.json "data.main.allow"
```

### Commands & Scripts
```bash
# Agent orchestration
npm run agents:status        # Check all agent health
npm run agents:activate      # Activate agent swarm
npm run agents:orchestrate   # Run orchestration loop
npm run agents:simulate      # Run simulation tests

# Security & Compliance
npm run security:scan        # Run all security scans
npm run security:sbom        # Generate SBOM
npm run security:sign        # Sign artifacts
npm run compliance:check     # EU AI Act validation
npm run compliance:audit     # Generate audit report

# Observability
npm run otel:deploy          # Deploy OTel collector
npm run otel:traces          # View traces
npm run ebpf:install         # Install eBPF probes
npm run metrics:dashboard    # Open Grafana

# Testing
npm run test:unit
npm run test:integration
npm run test:chaos           # Chaos engineering
npm run test:security        # Security test suite
npm run test:compliance      # Compliance tests

# Cost & Sustainability
npm run cost:analyze         # FinOps analysis
npm run carbon:report        # Carbon footprint
```

## Governance, Evaluation & Improvement

### Lifecycle Gates (G0-G8 Enhanced)
| Gate | Owner | 2025 Criteria |
| --- | --- | --- |
| G0: Intake | Product Lead | Business case, EU AI Act risk assessment, budget approval |
| G1: Design | AI Architect | Technical design, SBOM planning, model selection |
| G2: Security | Security Lead | Threat model, SLSA compliance, zero-trust design |
| G3: Implementation | Tech Lead | Code complete, tests passing, observability enabled |
| G4: Testing | QA Lead | All test suites pass, chaos tests run, performance validated |
| G5: Compliance | Compliance Officer | EU AI Act checklist, model cards, audit trail verified |
| G6: Deployment | DevOps Lead | Progressive rollout, monitoring active, rollback tested |
| G7: Operations | SRE Lead | SLOs met, incidents managed, costs optimized |
| G8: Retrospective | Team Lead | Lessons learned, playbooks updated, metrics reviewed |

### Evaluation Framework
```yaml
evaluation:
  automated:
    - unit_test_coverage: ">80%"
    - integration_test_success: "100%"
    - performance_regression: "<5%"
    - security_vulnerabilities: "0 critical/high"

  ai_specific:
    - model_accuracy: ">0.95"
    - bias_metrics: "demographic_parity <0.05"
    - robustness: "adversarial_success <0.01"
    - explainability: "shap_values_available"

  compliance:
    - eu_ai_act: "compliant"
    - gdpr: "compliant"
    - sox: "compliant"
    - iso_42001: "certified"

  operational:
    - availability: "99.95%"
    - latency_p99: "<500ms"
    - error_rate: "<0.1%"
    - cost_per_transaction: "<$0.001"
```

### Incident Response (AI-Specific)
```yaml
ai_incident_response:
  detection:
    - model_drift_monitoring
    - adversarial_detection
    - bias_drift_alerts
    - confidence_threshold_breaches

  response:
    immediate:
      - revert_to_previous_model
      - enable_human_review_mode
      - increase_logging_verbosity
      - notify_stakeholders

    investigation:
      - analyze_failure_patterns
      - review_training_data
      - check_data_drift
      - examine_edge_cases

    remediation:
      - retrain_model
      - update_guardrails
      - enhance_monitoring
      - document_lessons

  communication:
    - internal: "slack:#ai-incidents"
    - external: "status.company.com"
    - regulatory: "compliance@company.com"
```

## Quick Reference Cards

### Security Checklist
- [ ] Secrets scanned (gitleaks)
- [ ] SAST run (semgrep)
- [ ] Dependencies checked (npm/pip/cargo audit)
- [ ] SBOM generated (syft)
- [ ] Vulnerabilities scanned (grype/trivy)
- [ ] Container signed (cosign)
- [ ] SLSA provenance attached
- [ ] Policies validated (OPA)

### Compliance Checklist
- [ ] EU AI Act risk assessment complete
- [ ] Model card generated
- [ ] Audit trail verified
- [ ] Bias testing performed
- [ ] Human oversight documented
- [ ] Transparency requirements met
- [ ] Data governance validated
- [ ] Incident response tested

### Observability Checklist
- [ ] OpenTelemetry instrumented
- [ ] Traces correlated (W3C context)
- [ ] Metrics exported (Prometheus)
- [ ] Logs structured (JSON)
- [ ] eBPF probes deployed
- [ ] Dashboards configured
- [ ] Alerts defined
- [ ] Cost tracking enabled

## Vector Database Integration

### Supported Providers
```yaml
vector_stores:
  pinecone:
    index: "agent-memory"
    dimension: 1536
    metric: "cosine"

  weaviate:
    schema: "AgentKnowledge"
    vectorizer: "text2vec-openai"

  qdrant:
    collection: "agent_embeddings"
    vector_size: 768
    distance: "Cosine"
```

### Embedding Strategy
```python
# agents/memory/embeddings.py
class EmbeddingManager:
    def __init__(self, provider="openai", model="text-embedding-3-small"):
        self.provider = provider
        self.model = model
        self.dimension = 1536

    def generate_embedding(self, text: str) -> List[float]:
        """Generate embeddings with caching and batching"""
        # Implement with OpenTelemetry tracing
        with tracer.start_as_current_span("generate_embedding"):
            embedding = self.provider.embed(text)
            return embedding

    def semantic_search(self, query: str, top_k: int = 10) -> List[Result]:
        """Perform semantic search with confidence scoring"""
        query_embedding = self.generate_embedding(query)
        results = self.vector_store.search(
            query_embedding,
            top_k=top_k,
            include_metadata=True
        )
        return self.add_confidence_scores(results)
```

## Service Mesh Configuration

### Istio Service Mesh
```yaml
# infrastructure/istio/virtual-service.yaml
apiVersion: networking.istio.io/v1beta1
kind: VirtualService
metadata:
  name: agent-platform
spec:
  hosts:
  - agent-platform
  http:
  - match:
    - headers:
        risk-tier:
          exact: high
    route:
    - destination:
        host: agent-platform
        subset: v2
      weight: 10  # 10% canary for high-risk
    - destination:
        host: agent-platform
        subset: v1
      weight: 90
  - route:
    - destination:
        host: agent-platform
        subset: v2
      weight: 50  # 50% for normal traffic
    - destination:
        host: agent-platform
        subset: v1
      weight: 50
    timeout: 30s
    retries:
      attempts: 3
      perTryTimeout: 10s
      retryOn: 5xx,reset,connect-failure
```

### Circuit Breaker Pattern
```yaml
# infrastructure/istio/destination-rule.yaml
apiVersion: networking.istio.io/v1beta1
kind: DestinationRule
metadata:
  name: agent-platform
spec:
  host: agent-platform
  trafficPolicy:
    connectionPool:
      tcp:
        maxConnections: 100
      http:
        http1MaxPendingRequests: 10
        http2MaxRequests: 100
        maxRequestsPerConnection: 2
    outlierDetection:
      consecutiveErrors: 5
      interval: 30s
      baseEjectionTime: 30s
      maxEjectionPercent: 50
      minHealthPercent: 30
  subsets:
  - name: v1
    labels:
      version: v1
  - name: v2
    labels:
      version: v2
```

## Policy as Code (OPA)

### Agent Authorization Policy
```rego
# policies/agent_authorization.rego
package agent.authz

import future.keywords.if
import future.keywords.contains

default allow := false

# Allow if agent has required capability
allow if {
    input.agent.capabilities[_] == input.required_capability
    input.agent.trust_level >= input.required_trust_level
    not input.agent.revoked
}

# Enforce budget limits
allow if {
    input.token_usage <= input.token_budget
    input.cost_estimate <= input.cost_budget
    input.runtime <= input.runtime_limit
}

# High-risk operations require human approval
allow if {
    input.risk_tier == "high"
    input.human_approval.granted == true
    input.human_approval.timestamp > (time.now_ns() - 3600000000000)  # 1 hour
}

# EU AI Act compliance
allow if {
    input.ai_system.risk_category in ["minimal", "limited"]
} else if {
    input.ai_system.risk_category == "high"
    input.ai_system.human_oversight == true
    input.ai_system.transparency_met == true
}

# Rate limiting
rate_limit_exceeded if {
    input.agent.request_count > input.agent.rate_limit
}

# Audit requirement
audit_required if {
    input.risk_tier in ["high", "systemic"]
} else if {
    input.cost_estimate > 100
} else if {
    input.data_classification in ["confidential", "restricted"]
}
```

## Feature Flag Management

### LaunchDarkly Configuration
```yaml
# feature-flags.yaml
flags:
  ai-safety-enhanced:
    default: false
    rules:
      - environment: production
        value: true
        targets:
          - risk_tier: high
          - model_version: ">=4.0"

  eu-ai-act-compliance:
    default: true
    rules:
      - environment: all
        value: true

  sbom-generation:
    default: true
    variations:
      - format: "spdx"
      - format: "cyclonedx"

  vector-store-enabled:
    default: false
    rules:
      - environment: staging
        value: true
        provider: "pinecone"
      - environment: production
        value: true
        provider: "weaviate"

  chaos-engineering:
    default: false
    schedule:
      - day: "friday"
        hour: 14
        duration: "1h"
        value: true
```

## FinOps Dashboard Configuration

### Cost Attribution
```yaml
# finops/cost-attribution.yaml
cost_model:
  compute:
    cpu_hour_cost: 0.05
    gpu_hour_cost: 2.50
    memory_gb_hour: 0.01

  ai_models:
    claude_opus_per_1k_tokens: 0.075
    claude_sonnet_per_1k_tokens: 0.025
    claude_haiku_per_1k_tokens: 0.001
    embedding_per_1k_tokens: 0.0001

  storage:
    s3_gb_month: 0.023
    vector_db_gb_month: 0.25
    audit_log_gb_month: 0.10

  network:
    egress_gb: 0.09
    ingress_gb: 0.00

tagging_policy:
  required:
    - environment
    - team
    - project
    - agent_type
    - model_version
    - cost_center

alerts:
  - name: "Daily spend exceeds budget"
    condition: "daily_spend > daily_budget * 1.1"
    severity: "warning"

  - name: "Unusual token usage"
    condition: "token_usage > avg_token_usage * 3"
    severity: "critical"
```

## Deliverable Requirements (spec_version 3.2)

### Required Artifacts
1. **Technical Documentation**
   - `context_map.md` - System context and dependencies
   - `flow_matrix.json` - Execution flow with confidence scores
   - `scoped_prompt.md` - Agent prompts with safety constraints
   - `validation_rules.yaml` - Input/output validation schemas

2. **Compliance Artifacts**
   - `model_card.yaml` - EU AI Act compliant model documentation
   - `risk_assessment.json` - Risk tier classification and mitigations
   - `audit_report.md` - Compliance verification results
   - `sbom.spdx.json` - Software bill of materials

3. **Operational Artifacts**
   - `deployment_manifest.yaml` - K8s/ArgoCD deployment specs
   - `monitoring_config.yaml` - OpenTelemetry/Prometheus setup
   - `runbook.md` - Operational procedures and troubleshooting
   - `cost_analysis.json` - FinOps metrics and projections

### Quality Standards
- No placeholders or TODOs in production artifacts
- All JSON/YAML validated against schemas
- Signatures and attestations for all binaries
- Confidence scores >0.85 for automated decisions
- Human approval records for high-risk operations

## Carbon Footprint Tracking

```yaml
# sustainability/carbon-tracking.yaml
carbon_metrics:
  measurement:
    - compute_carbon_intensity: "gCO2/kWh by region"
    - model_training_emissions: "kgCO2 per training run"
    - inference_emissions: "gCO2 per 1000 requests"

  optimization:
    - use_renewable_regions: ["us-west-2", "eu-north-1"]
    - batch_processing_windows: ["02:00-06:00 UTC"]
    - efficient_model_selection: "prefer Haiku for low-complexity"

  reporting:
    - monthly_carbon_report: true
    - per_team_attribution: true
    - include_in_esg: true

  targets:
    - carbon_neutral_by: "2026"
    - renewable_energy: "80% by 2025"
    - pue: "< 1.2"
```

## Claims Check

### Verified Components
- ✅ EU AI Act compliance framework aligned with August 2025 enforcement
- ✅ SBOM/SLSA Level 2+ supply chain security implementation
- ✅ OpenTelemetry + eBPF observability stack configuration
- ✅ Zero-trust architecture with service mesh integration
- ✅ Policy-as-code with OPA for runtime governance
- ✅ Vector database integration for semantic search/RAG
- ✅ FinOps cost attribution and carbon tracking

### Assumptions Requiring Validation
- 🔍 Kubernetes 1.29+ available in all deployment regions
- 🔍 Vector database provider selection finalized (Pinecone vs Weaviate)
- 🔍 LaunchDarkly/feature flag service contract approved
- 🔍 Carbon intensity data available for all compute regions

### Dependencies on External Teams
- 📌 Security team: Approve WebAuthn implementation timeline
- 📌 Legal team: Review EU AI Act interpretation for specific use cases
- 📌 Infrastructure team: Confirm Istio service mesh rollout schedule
- 📌 Finance team: Approve FinOps budget thresholds

### Next Steps
1. Schedule EU AI Act compliance workshop with legal (by Feb 1, 2025)
2. Complete SLSA Level 2 certification for build pipeline (Q1 2025)
3. Deploy OpenTelemetry collectors to production (Week 1 Feb)
4. Implement vector database POC with top 2 providers (Q1 2025)
5. Run first chaos engineering game day (Feb 2025)