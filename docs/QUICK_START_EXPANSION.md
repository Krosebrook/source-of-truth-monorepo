# Quick Start: Agent & MCP Infrastructure Expansion

**5-Minute Action Plan**

## Today (Next 2 Hours)

### 1. Review the Plan
```bash
cat /home/kyler/docs/AGENT_MCP_EXPANSION_PLAN_2025.md
```

### 2. Verify Current Infrastructure
```bash
# Check K8s MCP pods
kubectl get pods -n mcp-servers

# Check PM2
pm2 list

# Check Docker
docker ps | grep mcp

# Test MCP connection
curl http://localhost:3002/sse
```

### 3. Create Project Structure
```bash
mkdir -p ~/agent-ecosystem/{agents,mcp-servers,services,packages,workflows,docs}
cd ~/agent-ecosystem
git init
```

## This Week (Next 7 Days)

### Day 1: Infrastructure Setup
- [ ] Provision Redis for context store
- [ ] Create `agent-registry` service scaffold
- [ ] Deploy context store to K8s
- [ ] Configure persistent volumes

### Day 2: Agent SDK
- [ ] Create `@agents/sdk` package
- [ ] Build registration client
- [ ] Build context store client
- [ ] Write tests

### Day 3: Registry Service
- [ ] Implement agent registration API
- [ ] Add health check endpoints
- [ ] Deploy to K8s
- [ ] Test with existing orchestrator

### Day 4: MCP Standardization
- [ ] Audit github-mcp, database-mcp, notion-mcp
- [ ] Refactor to best practices
- [ ] Add OpenTelemetry
- [ ] Redeploy with HPA

### Day 5: First New Agent
- [ ] Deploy Security Agent
- [ ] Configure Semgrep/Trivy/Gitleaks MCPs
- [ ] Integrate with HarvestFlow
- [ ] Test vulnerability scanning

### Day 6: Monitoring
- [ ] Deploy Prometheus
- [ ] Deploy Grafana
- [ ] Create agent health dashboard
- [ ] Configure alerts

### Day 7: Review & Plan Week 2
- [ ] Checkpoint meeting
- [ ] Update metrics
- [ ] Adjust timeline
- [ ] Document learnings

## Commands Cheat Sheet

### K8s Management
```bash
# Context store
kubectl apply -f k8s/context-store/
kubectl logs -n infrastructure -l app=context-store -f

# Agent registry
kubectl apply -f k8s/agent-registry/
kubectl port-forward -n infrastructure svc/agent-registry 4000:80

# MCP servers
kubectl get pods -n mcp-servers
kubectl scale deployment github-mcp -n mcp-servers --replicas=5
```

### PM2 Management
```bash
# Start ecosystem
pm2 start ecosystem.config.js

# Monitor
pm2 monit

# Logs
pm2 logs agent-registry

# Restart
pm2 restart all
```

### Agent SDK Usage
```bash
# Install
npm install @agents/sdk

# Use in agent
import { AgentSDK } from '@agents/sdk';
const sdk = new AgentSDK({ id: 'my-agent', registryUrl: 'http://localhost:4000' });
await sdk.register({ capabilities: ['code-review'] });
```

### Testing
```bash
# Test agent registration
curl -X POST http://localhost:4000/api/agents/register \
  -H "Content-Type: application/json" \
  -d '{"id":"test-agent","capabilities":["test"]}'

# Test context store
redis-cli -h localhost -p 6379 ping

# Test MCP server
curl http://localhost:3002/sse
```

## Immediate Decisions Needed

1. **K8s Cluster:** Existing or new? Size?
2. **Context Store:** Managed Redis or self-hosted?
3. **Vector DB:** Pinecone vs Weaviate vs pgVector?
4. **Budget:** Monthly cloud spend allocation?
5. **Timeline:** Follow 16-week plan or accelerate?

## Quick Wins (Low Effort, High Impact)

1. **Standardize 3 MCPs** - Immediate quality improvement
2. **Deploy Security Agent** - Automated vulnerability scanning
3. **Add Prometheus** - Instant visibility
4. **PM2 Ecosystem** - Process management for local services
5. **Agent Templates** - Accelerate future agent development

## Resources

- Full Plan: `/home/kyler/docs/AGENT_MCP_EXPANSION_PLAN_2025.md`
- Current Registry: `/home/kyler/agents/registry.json`
- MCP Demo: `/home/kyler/mcp-cloud-demo/`
- Agent Prompts: `/home/kyler/agents/prompts/`

## Get Help

- Microsoft Multi-Agent Ref: https://github.com/microsoft/multi-agent-reference-architecture
- MCP Best Practices: https://modelcontextprotocol.info/docs/best-practices/
- LangGraph Docs: https://langchain-ai.github.io/langgraph/
- Anthropic Agents Guide: https://www.anthropic.com/research/building-effective-agents

