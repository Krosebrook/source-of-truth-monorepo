# Agent & MCP Infrastructure Expansion Plan 2025

**Created:** 2025-11-02  
**Owner:** Kyler  
**Status:** Planning Phase  
**Risk Tier:** High (Enterprise Infrastructure)

---

## Executive Summary

This plan expands the current agent and MCP infrastructure into a production-grade, scalable multi-agent ecosystem supporting all current and future projects. Based on 2025 industry best practices from Microsoft, Anthropic, and enterprise deployments.

### Current State Assessment

**Deployed Infrastructure:**
- **MCP Servers:** 2 K8s pods (mcp-cloud-demo) with port-forward access
- **Agent Registry:** 4 agents (Orchestrator, Auditor, Safety Evaluator, Knowledge Synthesizer)
- **Projects:** HarvestFlow, FlashFusion, INT-Smart-Triage-AI-2.0, project-nexus, 18+ MCP servers
- **Transport:** HTTP/SSE on port 3002 (local forward)
- **PM2:** Active daemon, zero managed processes

**Gaps Identified:**
- No unified context store/memory backend
- Agent-to-MCP integration not standardized
- Missing service mesh/discovery layer
- No horizontal autoscaling configured
- Limited observability/telemetry
- Agent prompts not version-controlled with schemas

---

## Strategic Architecture Vision

### Architecture Pattern: Hybrid Multi-Agent + Microservices MCP

```
┌─────────────────────────────────────────────────────────────────────┐
│                        ORCHESTRATION LAYER                          │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐             │
│  │ Orchestrator │◄─┤ Event Bus    │─►│ Agent Router │             │
│  │ (Sonnet 4.5) │  │ (Redis/Kafka)│  │ (Discovery)  │             │
│  └──────┬───────┘  └──────────────┘  └──────────────┘             │
└─────────┼──────────────────────────────────────────────────────────┘
          │
          ▼
┌─────────────────────────────────────────────────────────────────────┐
│                      AGENT SERVICE MESH                             │
│  ┌───────────┐  ┌───────────┐  ┌───────────┐  ┌───────────┐       │
│  │ Domain    │  │ Safety    │  │ Tool      │  │ Knowledge │       │
│  │ Skills    │  │ Evaluator │  │ Adapters  │  │ Synth     │       │
│  └─────┬─────┘  └─────┬─────┘  └─────┬─────┘  └─────┬─────┘       │
└────────┼──────────────┼──────────────┼──────────────┼──────────────┘
         │              │              │              │
         └──────────────┴──────────────┴──────────────┘
                        │
                        ▼
┌─────────────────────────────────────────────────────────────────────┐
│                    CONTEXT & MEMORY LAYER                           │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐             │
│  │ Context      │  │ Vector Store │  │ Session      │             │
│  │ Store (Redis)│  │ (Pinecone)   │  │ State (Cosmo)│             │
│  └──────────────┘  └──────────────┘  └──────────────┘             │
└─────────────────────────────────────────────────────────────────────┘
         │              │              │
         └──────────────┴──────────────┘
                        │
                        ▼
┌─────────────────────────────────────────────────────────────────────┐
│                      MCP SERVER LAYER                               │
│  ┌───────────┐  ┌───────────┐  ┌───────────┐  ┌───────────┐       │
│  │ Figma MCP │  │ GitHub    │  │ AWS       │  │ Database  │       │
│  │ (stdio)   │  │ MCP (SSE) │  │ MCP (SSE) │  │ MCP (SSE) │       │
│  └───────────┘  └───────────┘  └───────────┘  └───────────┘       │
│                                                                     │
│  ┌───────────┐  ┌───────────┐  ┌───────────┐  ┌───────────┐       │
│  │ Notion    │  │ Playwright│  │ MongoDB   │  │ Custom    │       │
│  │ MCP (SSE) │  │ MCP (SSE) │  │ MCP (SSE) │  │ MCP (SSE) │       │
│  └───────────┘  └───────────┘  └───────────┘  └───────────┘       │
└─────────────────────────────────────────────────────────────────────┘
```

---

## Expansion Phases

### Phase 1: Foundation Infrastructure (Weeks 1-3)

#### 1.1 Context Store & Memory Backend
**Objective:** Implement persistent, shared context layer for all agents

**Implementation:**
```yaml
# k8s/context-store-deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: context-store
  namespace: mcp-servers
spec:
  replicas: 3
  selector:
    matchLabels:
      app: context-store
  template:
    spec:
      containers:
      - name: redis
        image: redis:7-alpine
        resources:
          requests:
            memory: "512Mi"
            cpu: "250m"
          limits:
            memory: "1Gi"
            cpu: "500m"
        volumeMounts:
        - name: redis-data
          mountPath: /data
      volumes:
      - name: redis-data
        persistentVolumeClaim:
          claimName: context-store-pvc
```

**Actions:**
- [ ] Deploy Redis cluster for context storage
- [ ] Implement context ownership model (read/write/TTL/priority)
- [ ] Add conflict resolution mechanism
- [ ] Create context SDK for agent integration
- [ ] Document context schema v3.2

#### 1.2 Agent Registry Enhancement
**Objective:** Upgrade registry to service-mesh style discovery

**Current:** Static `agents/registry.json`  
**Target:** Dynamic registration with health checks

**Implementation:**
```typescript
// services/agent-registry/src/registry.ts
interface AgentRegistration {
  id: string;
  name: string;
  capabilities: string[];
  embedding: number[];  // For semantic discovery
  purpose: string;
  riskTier: 'low' | 'medium' | 'high';
  owner: string;
  healthEndpoint: string;
  mcpServers: string[];  // Associated MCPs
  confidenceThreshold: number;
  metadata: Record<string, any>;
  lastHeartbeat: Date;
  status: 'active' | 'degraded' | 'offline';
}

class AgentRegistry {
  async register(agent: AgentRegistration): Promise<void>
  async deregister(agentId: string): Promise<void>
  async discover(capabilities: string[]): Promise<AgentRegistration[]>
  async healthCheck(agentId: string): Promise<HealthStatus>
  async updateStatus(agentId: string, status: Status): Promise<void>
}
```

**Actions:**
- [ ] Create agent-registry service (Node.js/TypeScript)
- [ ] Deploy to K8s with persistent storage
- [ ] Implement gRPC API for registration/discovery
- [ ] Add Prometheus metrics export
- [ ] Create agent SDK for self-registration
- [ ] Migrate existing 4 agents to new registry

#### 1.3 MCP Server Standardization
**Objective:** Standardize all MCP servers with production patterns

**Best Practices (2025):**
- Modular, workflow-complete tools (not single API calls)
- Stateless, idempotent operations
- Request ID correlation
- Comprehensive error handling
- Schema validation (Zod)
- Health/readiness probes

**Actions:**
- [ ] Audit 18+ existing MCP servers
- [ ] Create MCP server template from best practices
- [ ] Standardize on Streamable HTTP transport
- [ ] Add OpenTelemetry instrumentation
- [ ] Configure HPA (2-10 pods per server)
- [ ] Document tool schemas

---

### Phase 2: Agent Ecosystem Expansion (Weeks 4-6)

#### 2.1 New Agent Roles

**Financial Agent** (Domain Skill)
- Purpose: Billing, invoicing, payment processing
- Risk Tier: High
- Model: Claude Haiku 4.5
- MCPs: Stripe, QuickBooks, database
- Confidence: 0.9

**Data Pipeline Agent** (Domain Skill)
- Purpose: ETL, data validation, transformations
- Risk Tier: Medium
- Model: Claude Sonnet 3.7
- MCPs: AWS S3, MongoDB, PostgreSQL
- Confidence: 0.85

**Security Agent** (Safety Evaluator)
- Purpose: Vulnerability scanning, secret detection, compliance checks
- Risk Tier: High
- Model: Claude Opus
- MCPs: GitHub, Semgrep, Trivy, Gitleaks
- Confidence: 0.95

**DevOps Agent** (Tool Adapter)
- Purpose: CI/CD orchestration, deployment, rollback
- Risk Tier: High
- Model: Claude Sonnet 4.5
- MCPs: GitHub Actions, K8s, Docker, AWS
- Confidence: 0.9

**Customer Support Agent** (Domain Skill)
- Purpose: Triage, escalation, knowledge retrieval
- Risk Tier: Medium
- Model: Claude Haiku 4.5
- MCPs: Notion, GitHub Issues, Database
- Confidence: 0.85

#### 2.2 Agent Template & SDK

**Agent Starter Template:**
```typescript
// packages/agent-sdk/templates/domain-skill/
import { AgentSDK, Context, Tool } from '@agents/sdk';

export class DomainSkillAgent {
  private sdk: AgentSDK;
  
  constructor(config: AgentConfig) {
    this.sdk = new AgentSDK({
      id: config.id,
      registry: config.registryUrl,
      contextStore: config.contextStoreUrl,
      mcpServers: config.mcpServers
    });
  }

  async initialize() {
    await this.sdk.register({
      capabilities: this.getCapabilities(),
      healthCheck: () => this.healthCheck()
    });
  }

  async execute(task: Task, context: Context): Promise<Result> {
    // Execution logic with context sharing
    const sharedContext = await this.sdk.context.get(task.contextId);
    const result = await this.process(task, sharedContext);
    await this.sdk.context.update(task.contextId, result);
    return result;
  }

  async healthCheck(): Promise<HealthStatus> {
    return { status: 'healthy', timestamp: new Date() };
  }
}
```

**Actions:**
- [ ] Create `@agents/sdk` package
- [ ] Build agent templates (orchestrator, domain-skill, evaluator)
- [ ] Document SDK usage patterns
- [ ] Create example agents for each role
- [ ] Publish to internal npm registry

---

### Phase 3: Project Integration (Weeks 7-10)

#### 3.1 Per-Project Agent Teams

**HarvestFlow Agents:**
- Context Engineer → migrate existing
- Prompt Architect → migrate existing
- Builder Agent → migrate existing
- Auditor → migrate existing
- Synthesizer → migrate existing
- **New:** DevOps Agent for deployment
- **New:** Security Agent for compliance

**FlashFusion Agents:**
- Orchestrator → coordinate 16 microservices
- **New:** Data Pipeline Agent for ETL
- **New:** Financial Agent for billing
- **New:** Customer Support Agent for users
- Security Agent → SOC 2/GDPR compliance

**INT-Smart-Triage-AI-2.0:**
- Orchestrator → intake routing
- **New:** Customer Support Agent (primary)
- Safety Evaluator → policy compliance
- Knowledge Synthesizer → training data

**project-nexus:**
- Orchestrator → monorepo coordination
- Builder Agent → frontend/backend
- DevOps Agent → deployment pipeline
- Auditor → code quality

#### 3.2 MCP Server Assignments

**Project-MCP Matrix:**
```yaml
HarvestFlow:
  - github-mcp
  - database-mcp
  - aws-s3-mcp
  - notion-mcp

FlashFusion:
  - stripe-mcp
  - database-mcp
  - aws-mcp
  - github-mcp
  - analytics-mcp

INT-Triage:
  - notion-mcp
  - github-issues-mcp
  - database-mcp
  - slack-mcp

project-nexus:
  - github-mcp
  - playwright-mcp
  - database-mcp
```

**Actions:**
- [ ] Map all projects to required MCPs
- [ ] Deploy project-specific MCP clusters
- [ ] Configure RBAC per project
- [ ] Create project config manifests

---

### Phase 4: Orchestration & Workflow (Weeks 11-13)

#### 4.1 Multi-Agent Orchestration Patterns

**Implement Microsoft's recommended patterns:**

**Pattern: Sequential Handoff**
```typescript
// For: Document processing pipeline
Context Engineer → Prompt Architect → Builder → Auditor → Synthesizer
```

**Pattern: Reflection (Quality Loop)**
```typescript
// For: Code generation
Builder Agent → Safety Evaluator → Builder Agent (refine) → Auditor
```

**Pattern: Magnetic (Collaborative)**
```typescript
// For: Complex problem solving
Orchestrator coordinates:
  - Domain Skill 1 (parallel)
  - Domain Skill 2 (parallel)
  - Domain Skill 3 (parallel)
  → Aggregator → Evaluator
```

**Pattern: Event-Driven**
```typescript
// For: Real-time monitoring
GitHub Webhook → Event Bus → Triage Agent → [DevOps | Security | Support]
```

#### 4.2 Workflow Engine

**LangGraph Integration:**
```typescript
// workflows/code-review-workflow.ts
import { StateGraph } from "@langchain/langgraph";

const workflow = new StateGraph({
  channels: {
    code: { default: null },
    review: { default: null },
    securityScan: { default: null }
  }
});

workflow
  .addNode("fetch_pr", fetchPRNode)
  .addNode("security_scan", securityAgentNode)
  .addNode("code_review", reviewAgentNode)
  .addNode("approve", approvalNode)
  .addEdge("fetch_pr", "security_scan")
  .addEdge("fetch_pr", "code_review")
  .addEdge(["security_scan", "code_review"], "approve");

const app = workflow.compile();
```

**Actions:**
- [ ] Install LangGraph for workflow orchestration
- [ ] Define standard workflow patterns
- [ ] Implement checkpointing for fault tolerance
- [ ] Add workflow monitoring dashboard
- [ ] Create workflow templates library

---

### Phase 5: Observability & Governance (Weeks 14-16)

#### 5.1 Monitoring Stack

**OpenTelemetry Integration:**
```yaml
# All agents/MCPs emit:
- Traces (request flows)
- Metrics (latency, errors, throughput)
- Logs (structured JSON)

# Stack:
- Collector: OpenTelemetry Collector
- Storage: Prometheus + Loki
- Visualization: Grafana
- Alerting: AlertManager
```

**Key Metrics:**
- Agent availability (uptime %)
- Context operations (read/write latency)
- Tool execution time (p50, p95, p99)
- Error rates by agent/MCP
- Token consumption by agent
- Workflow completion rate

**Dashboards:**
- Agent Health Overview
- MCP Server Performance
- Workflow Execution Status
- Cost & Token Analytics
- Security & Compliance

#### 5.2 Compliance & Audit

**EU AI Act Compliance:**
- Risk classification per agent
- Model cards for all LLM agents
- Human oversight documentation
- Transparency notices
- Bias testing results

**SBOM & Supply Chain:**
```bash
# Per agent/MCP
make sbom          # Generate SBOM
cosign sign        # Sign artifacts
make sbom-verify   # Verify signatures
```

**Audit Trail:**
- All agent decisions logged
- Context changes tracked
- Tool invocations recorded
- Escalations documented
- Compliance violations flagged

**Actions:**
- [ ] Deploy OpenTelemetry Collector
- [ ] Configure Prometheus/Loki/Grafana
- [ ] Create standard dashboards
- [ ] Implement alerting rules
- [ ] Generate model cards for agents
- [ ] Automate SBOM generation
- [ ] Create compliance checklist template

---

## Infrastructure Requirements

### Kubernetes Resources

**Namespace Structure:**
```yaml
- mcp-servers       # MCP server deployments
- agents            # Agent service deployments
- infrastructure    # Redis, monitoring, registries
- workflows         # Workflow engine pods
```

**Resource Estimates (Production):**
```yaml
MCP Servers (18 servers × avg 3 pods):
  CPU: 54 cores (requests) / 108 cores (limits)
  Memory: 54 GB (requests) / 108 GB (limits)

Agents (10 agents × avg 2 pods):
  CPU: 20 cores (requests) / 40 cores (limits)
  Memory: 40 GB (requests) / 80 GB (limits)

Infrastructure:
  Context Store: 6 cores / 12 GB
  Agent Registry: 2 cores / 4 GB
  Monitoring: 8 cores / 16 GB
  Workflow Engine: 4 cores / 8 GB

Total Cluster:
  CPU: 94 cores (requests) / 188 cores (limits)
  Memory: 124 GB (requests) / 248 GB (limits)
```

### External Services

**Required:**
- Redis (Context Store) - Managed service or K8s StatefulSet
- Vector DB (Pinecone/Weaviate) - For semantic search
- PostgreSQL (Agent metadata) - Managed or StatefulSet
- Object Storage (S3/GCS) - Audit logs, artifacts
- Secret Manager (Vault/AWS Secrets) - Credentials

**Optional:**
- Kafka/RabbitMQ - Event-driven workflows
- Cosmos DB - Session persistence
- Datadog/New Relic - Enhanced observability

---

## PM2 Process Management

### Suggested PM2 Configuration

```javascript
// ecosystem.config.js
module.exports = {
  apps: [
    {
      name: 'agent-registry',
      script: './services/agent-registry/dist/server.js',
      instances: 2,
      exec_mode: 'cluster',
      env: {
        NODE_ENV: 'production',
        PORT: 4000
      }
    },
    {
      name: 'orchestrator-agent',
      script: './agents/orchestrator/dist/agent.js',
      instances: 1,
      env: {
        AGENT_ID: 'orchestrator',
        REGISTRY_URL: 'http://localhost:4000'
      }
    },
    {
      name: 'workflow-engine',
      script: './services/workflow-engine/dist/server.js',
      instances: 2,
      exec_mode: 'cluster',
      env: {
        PORT: 4001
      }
    },
    {
      name: 'context-api',
      script: './services/context-api/dist/server.js',
      instances: 2,
      exec_mode: 'cluster',
      env: {
        REDIS_URL: 'redis://localhost:6379',
        PORT: 4002
      }
    }
  ]
};
```

**Usage:**
```bash
pm2 start ecosystem.config.js
pm2 save
pm2 startup
```

---

## Migration Strategy

### Existing Agents → New Architecture

**Priority 1: Core Orchestrator**
1. Wrap existing Orchestrator with SDK
2. Register in new registry
3. Connect to context store
4. Test with current workflows

**Priority 2: HarvestFlow Agents**
1. Migrate Context Engineer
2. Migrate Prompt Architect
3. Migrate Builder, Auditor, Synthesizer
4. Test end-to-end pipeline

**Priority 3: New Domain Agents**
1. Deploy Financial Agent
2. Deploy Security Agent
3. Deploy Customer Support Agent
4. Integrate with projects

**Priority 4: MCP Standardization**
1. Audit top 10 used MCPs
2. Refactor to best practices
3. Deploy with autoscaling
4. Migrate client configs

---

## Security Considerations

### Defense in Depth

**Layer 1: Network**
- K8s NetworkPolicies (deny-all default)
- Ingress TLS termination
- Service mesh (Istio/Linkerd)

**Layer 2: Identity & Access**
- RBAC per agent/MCP
- ServiceAccounts with least privilege
- Secret rotation (30 days)
- API key per client

**Layer 3: Application**
- Input validation (Zod schemas)
- Output sanitization
- Rate limiting (per agent/tool)
- Circuit breakers

**Layer 4: Data**
- Encryption at rest (context store)
- Encryption in transit (TLS)
- PII redaction before storage
- Audit logging (immutable)

**Layer 5: Monitoring**
- Anomaly detection
- Failed auth tracking
- Compliance violation alerts

---

## Success Metrics

### Phase 1 (Foundation)
- [ ] Context store operational (99.9% uptime)
- [ ] Agent registry serving discovery
- [ ] 3+ MCPs migrated to new patterns

### Phase 2 (Expansion)
- [ ] 5+ new agents deployed
- [ ] Agent SDK published
- [ ] All agents self-registering

### Phase 3 (Integration)
- [ ] 3+ projects integrated
- [ ] MCP-project matrix complete
- [ ] RBAC configured per project

### Phase 4 (Orchestration)
- [ ] Workflow engine operational
- [ ] 3+ workflow patterns implemented
- [ ] Checkpointing functional

### Phase 5 (Observability)
- [ ] Dashboards live
- [ ] Alerting configured
- [ ] Compliance audit passed

### Overall Success
- **Availability:** 99.9% agent uptime
- **Latency:** p95 < 2s for agent responses
- **Scalability:** 10+ concurrent workflows
- **Cost:** Token spend < $X/month
- **Compliance:** 100% audit trail coverage

---

## Next Steps (Immediate Actions)

### Week 1
1. **Review & Approve Plan** - Stakeholder sign-off
2. **Provision Infrastructure** - K8s cluster sizing, external services
3. **Create Project Repo** - `agent-ecosystem` monorepo
4. **Deploy Context Store** - Redis cluster + PVC
5. **Start Agent Registry** - Scaffold service

### Week 2
1. **Build Agent SDK** - Core functionality
2. **Migrate Orchestrator** - First agent on new stack
3. **Standardize 3 MCPs** - GitHub, Database, Notion
4. **Setup Monitoring** - Prometheus + Grafana basics
5. **Documentation** - Architecture docs, runbooks

### Week 3
1. **Deploy 2 New Agents** - Security + DevOps
2. **Integrate HarvestFlow** - Migrate all 5 agents
3. **Workflow Engine PoC** - Simple handoff pattern
4. **Security Audit** - NetworkPolicies, RBAC
5. **Checkpoint Review** - Assess progress, adjust plan

---

## References

### Industry Best Practices
- Microsoft Multi-Agent Reference Architecture
- Anthropic Building Effective Agents
- NIST AI Risk Management Framework
- EU AI Act Compliance Requirements
- Model Context Protocol Spec (2025)
- LangGraph Production Patterns
- Kubernetes Autoscaling Guide

### Internal Documentation
- `AGENTS.md` - Current agent playbook
- `CLAUDE.md` - Claude partnership charter
- `SBOM_SLSA_SECURITY.md` - Security controls
- `EU_AI_ACT_COMPLIANCE.md` - Compliance framework
- `mcp-cloud-demo/MCP_PLAYBOOK.md` - MCP patterns

---

## Approvals

- [ ] **Kyler** (Owner) - Plan approval
- [ ] **Security Lead** - Security review
- [ ] **Compliance** - Regulatory sign-off
- [ ] **Finance** - Budget approval
- [ ] **Engineering** - Technical feasibility

---

**Version:** 1.0  
**Last Updated:** 2025-11-02  
**Next Review:** 2025-11-09
