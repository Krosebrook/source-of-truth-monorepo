# MCP Implementation Playbook (2025)

**Quick Reference for Building Production MCP Servers**

---

## TL;DR - Decision Tree

```
Need MCP server?
├─ Local file/shell access? → Use stdio transport (local)
├─ Shared API/database? → Use HTTP/SSE transport (cloud)
└─ Both? → Hybrid architecture (recommended)
```

---

## Quick Start Commands

### Local MCP (5 minutes)

```bash
# Create server
npx @modelcontextprotocol/create-server my-server
cd my-server && npm install

# Configure Claude Desktop
mkdir -p ~/.config/Claude
cat > ~/.config/Claude/claude_desktop_config.json <<EOF
{
  "mcpServers": {
    "my-server": {
      "command": "node",
      "args": ["$(pwd)/build/index.js"]
    }
  }
}
EOF

# Restart Claude Desktop
```

### Cloud MCP (15 minutes)

```bash
# Clone working example
git clone /home/kyler/mcp-cloud-demo my-mcp
cd my-mcp

# Build and deploy
./deploy.sh

# Access locally
./port-forward.sh

# Configure Claude Desktop
cat claude-config.json >> ~/.config/Claude/claude_desktop_config.json

# Restart Claude Desktop
```

---

## Architecture Patterns

### Pattern 1: Hybrid (Recommended)

**Use for:** Most production scenarios

```json
{
  "mcpServers": {
    "filesystem": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-filesystem", "/home/user"]
    },
    "github": {
      "transport": {
        "type": "sse",
        "url": "https://mcp.company.com/github/sse"
      }
    },
    "database": {
      "transport": {
        "type": "sse",
        "url": "https://mcp.company.com/postgres/sse"
      }
    }
  }
}
```

**Why:** Best of both worlds - local for security, cloud for scale

### Pattern 2: Local-Only

**Use for:** Personal productivity, single-user, no sharing

```json
{
  "mcpServers": {
    "filesystem": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-filesystem", "/home/user"]
    },
    "brave-search": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-brave-search"],
      "env": {
        "BRAVE_API_KEY": "BSA..."
      }
    }
  }
}
```

**Why:** Simple, fast, no network dependencies

### Pattern 3: Cloud-Only

**Use for:** Enterprise, team collaboration, centralized compliance

```json
{
  "mcpServers": {
    "platform": {
      "transport": {
        "type": "sse",
        "url": "https://mcp.company.com/sse",
        "headers": {
          "Authorization": "Bearer eyJ..."
        }
      }
    }
  }
}
```

**Why:** Centralized control, shared resources, consistent compliance

---

## Implementation Checklist

### Minimum Viable MCP Server

- [ ] Choose transport type (stdio vs HTTP/SSE)
- [ ] Implement 1-3 core tools
- [ ] Add health check endpoint (if HTTP)
- [ ] Test with Claude Desktop
- [ ] Document tool usage

### Production-Ready MCP Server

- [ ] **Security**
  - [ ] Authentication (API keys or OAuth)
  - [ ] Input validation (Zod schemas)
  - [ ] Rate limiting
  - [ ] Secret management (Vault/K8s secrets)
  
- [ ] **Reliability**
  - [ ] Health checks (liveness + readiness)
  - [ ] Error handling with retry logic
  - [ ] Graceful shutdown
  - [ ] Circuit breakers
  
- [ ] **Observability**
  - [ ] Structured logging (JSON)
  - [ ] Prometheus metrics
  - [ ] Distributed tracing (OpenTelemetry)
  - [ ] Custom dashboards
  
- [ ] **Deployment**
  - [ ] Docker multi-stage build
  - [ ] Kubernetes manifests
  - [ ] Auto-scaling (HPA)
  - [ ] GitOps (ArgoCD/Flux)
  
- [ ] **Compliance**
  - [ ] SBOM generation (Syft)
  - [ ] SLSA Level 2+ attestation
  - [ ] EU AI Act documentation
  - [ ] Audit trails (immutable logs)

---

## Tool Design Patterns

### Pattern: Simple Query

```typescript
server.addTool({
  name: "get_user",
  description: "Retrieve user by ID",
  parameters: z.object({
    user_id: z.string().min(1),
  }),
  execute: async ({ user_id }) => {
    const user = await db.users.findUnique({ where: { id: user_id } });
    return JSON.stringify(user, null, 2);
  },
});
```

### Pattern: Complex Operation

```typescript
server.addTool({
  name: "process_payment",
  description: "Process payment with idempotency",
  parameters: z.object({
    amount: z.number().positive(),
    currency: z.enum(['USD', 'EUR', 'GBP']),
    idempotency_key: z.string().min(1),
  }),
  execute: async ({ amount, currency, idempotency_key }) => {
    // Check idempotency
    const existing = await getPayment(idempotency_key);
    if (existing) return JSON.stringify(existing);
    
    // Process with tracing
    return await tracer.startActiveSpan('process_payment', async (span) => {
      try {
        span.setAttribute('amount', amount);
        span.setAttribute('currency', currency);
        
        const payment = await stripe.charges.create({
          amount: amount * 100,
          currency,
          idempotency_key,
        });
        
        await storePayment(idempotency_key, payment);
        
        return JSON.stringify(payment, null, 2);
      } catch (error) {
        span.recordException(error);
        throw error;
      } finally {
        span.end();
      }
    });
  },
});
```

### Pattern: Streaming/Pagination

```typescript
server.addTool({
  name: "list_repositories",
  description: "List GitHub repositories with pagination",
  parameters: z.object({
    page: z.number().int().positive().default(1),
    per_page: z.number().int().min(1).max(100).default(30),
  }),
  execute: async ({ page, per_page }) => {
    const repos = await octokit.repos.listForAuthenticatedUser({
      page,
      per_page,
      sort: 'updated',
    });
    
    return JSON.stringify({
      data: repos.data,
      pagination: {
        page,
        per_page,
        total: repos.data.length,
        has_next: repos.data.length === per_page,
      },
    }, null, 2);
  },
});
```

---

## Common Integrations

### GitHub

```typescript
import { Octokit } from '@octokit/rest';

const octokit = new Octokit({
  auth: process.env.GITHUB_TOKEN,
});

server.addTool({
  name: "create_issue",
  description: "Create GitHub issue",
  parameters: z.object({
    owner: z.string(),
    repo: z.string(),
    title: z.string(),
    body: z.string().optional(),
  }),
  execute: async ({ owner, repo, title, body }) => {
    const issue = await octokit.issues.create({
      owner,
      repo,
      title,
      body,
    });
    return JSON.stringify(issue.data, null, 2);
  },
});
```

### PostgreSQL

```typescript
import { Pool } from 'pg';

const pool = new Pool({
  connectionString: process.env.DATABASE_URL,
  max: 20,
  idleTimeoutMillis: 30000,
});

server.addTool({
  name: "query_database",
  description: "Execute SQL query (read-only)",
  parameters: z.object({
    query: z.string().regex(/^SELECT/i, 'Only SELECT queries allowed'),
  }),
  execute: async ({ query }) => {
    const result = await pool.query(query);
    return JSON.stringify(result.rows, null, 2);
  },
});
```

### Pinecone (Vector Database)

```typescript
import { Pinecone } from '@pinecone-database/pinecone';

const pinecone = new Pinecone({
  apiKey: process.env.PINECONE_API_KEY,
});

const index = pinecone.index('knowledge-base');

server.addTool({
  name: "semantic_search",
  description: "Search knowledge base semantically",
  parameters: z.object({
    query: z.string(),
    top_k: z.number().int().min(1).max(100).default(10),
  }),
  execute: async ({ query, top_k }) => {
    // Generate embedding (assume function exists)
    const embedding = await generateEmbedding(query);
    
    const results = await index.query({
      vector: embedding,
      topK: top_k,
      includeMetadata: true,
    });
    
    return JSON.stringify(results.matches, null, 2);
  },
});
```

### Stripe

```typescript
import Stripe from 'stripe';

const stripe = new Stripe(process.env.STRIPE_SECRET_KEY, {
  apiVersion: '2023-10-16',
});

server.addTool({
  name: "get_customer",
  description: "Retrieve Stripe customer",
  parameters: z.object({
    customer_id: z.string().startsWith('cus_'),
  }),
  execute: async ({ customer_id }) => {
    const customer = await stripe.customers.retrieve(customer_id);
    return JSON.stringify(customer, null, 2);
  },
});
```

---

## Deployment Workflows

### Local Development

```bash
# Terminal 1: Run server
npm run dev

# Terminal 2: Test endpoint
curl http://localhost:3000/sse

# Configure Claude Desktop and restart
```

### Docker

```bash
# Build
docker build -t mcp-server:latest .

# Run
docker run -p 3000:3000 \
  -e DATABASE_URL=postgresql://... \
  -e GITHUB_TOKEN=ghp_... \
  mcp-server:latest

# Test
curl http://localhost:3000/sse
```

### Kubernetes

```bash
# Deploy
kubectl apply -f k8s/

# Check status
kubectl get all -n mcp-servers

# View logs
kubectl logs -n mcp-servers -l app=mcp-server -f

# Port-forward for local testing
kubectl port-forward -n mcp-servers svc/mcp-server 3000:80

# Scale
kubectl scale deployment mcp-server -n mcp-servers --replicas=5
```

### GitOps (ArgoCD)

```yaml
# argocd/application.yaml
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: mcp-server
  namespace: argocd
spec:
  project: default
  source:
    repoURL: https://github.com/org/mcp-server
    targetRevision: HEAD
    path: k8s/overlays/production
  destination:
    server: https://kubernetes.default.svc
    namespace: mcp-servers
  syncPolicy:
    automated:
      prune: false
      selfHeal: true
```

```bash
# Deploy via ArgoCD
argocd app create -f argocd/application.yaml
argocd app sync mcp-server
argocd app get mcp-server
```

---

## Troubleshooting Quick Reference

### Issue: Can't connect from Claude

```bash
# 1. Check server is running
curl http://localhost:3000/sse

# 2. Check Claude config path
cat ~/.config/Claude/claude_desktop_config.json

# 3. Check Claude logs (varies by OS)
# macOS: ~/Library/Logs/Claude/
# Linux: ~/.config/Claude/logs/
# Windows: %APPDATA%\Claude\logs\

# 4. Restart Claude Desktop
```

### Issue: Tools not appearing

```bash
# 1. Check tool registration in server logs
kubectl logs -n mcp-servers <pod> | grep -i tool

# 2. Verify tool schema
curl http://localhost:3000/sse | jq '.tools'

# 3. Restart Claude Desktop after config changes
```

### Issue: High latency

```bash
# 1. Check pod resources
kubectl top pods -n mcp-servers

# 2. View metrics
curl http://localhost:9464/metrics | grep mcp_tool_duration

# 3. Enable debug logging
kubectl set env deployment/mcp-server DEBUG=true -n mcp-servers

# 4. Scale up
kubectl scale deployment mcp-server --replicas=10 -n mcp-servers
```

### Issue: Memory leaks

```bash
# 1. Monitor memory over time
kubectl top pods -n mcp-servers --watch

# 2. Get heap snapshot (if enabled)
kubectl exec -it <pod> -n mcp-servers -- node --expose-gc --inspect

# 3. Increase memory limits
kubectl set resources deployment mcp-server \
  --limits=memory=512Mi -n mcp-servers
```

---

## Security Hardening

### Checklist

- [ ] **Authentication**
  ```typescript
  // API key middleware
  app.use((req, res, next) => {
    const key = req.headers['x-api-key'];
    if (!key || !validateKey(key)) {
      return res.status(401).json({ error: 'Unauthorized' });
    }
    next();
  });
  ```

- [ ] **Input Validation**
  ```typescript
  // Always use Zod schemas
  parameters: z.object({
    user_id: z.string().uuid(),
    amount: z.number().positive().max(10000),
  })
  ```

- [ ] **Rate Limiting**
  ```typescript
  import rateLimit from 'express-rate-limit';
  
  app.use('/sse', rateLimit({
    windowMs: 60 * 1000,
    max: 100,
  }));
  ```

- [ ] **Secrets Management**
  ```bash
  # Never commit secrets!
  kubectl create secret generic mcp-secrets \
    --from-literal=github-token=$GITHUB_TOKEN \
    --from-literal=db-password=$DB_PASSWORD
  ```

- [ ] **Network Policies**
  ```yaml
  apiVersion: networking.k8s.io/v1
  kind: NetworkPolicy
  metadata:
    name: mcp-server
  spec:
    podSelector:
      matchLabels:
        app: mcp-server
    policyTypes:
    - Ingress
    - Egress
    ingress:
    - from:
      - namespaceSelector:
          matchLabels:
            name: ingress-nginx
    egress:
    - to:
      - namespaceSelector: {}
  ```

---

## Performance Optimization

### Caching

```typescript
import NodeCache from 'node-cache';

const cache = new NodeCache({ stdTTL: 600 });

server.addTool({
  name: "cached_query",
  execute: async ({ query }) => {
    const key = `query:${hash(query)}`;
    
    const cached = cache.get(key);
    if (cached) return cached;
    
    const result = await expensiveQuery(query);
    cache.set(key, result);
    
    return result;
  },
});
```

### Connection Pooling

```typescript
// PostgreSQL
const pool = new Pool({
  max: 20,
  min: 5,
  idleTimeoutMillis: 30000,
  connectionTimeoutMillis: 2000,
});

// Redis
const redis = new Redis({
  host: 'redis',
  maxRetriesPerRequest: 3,
  enableReadyCheck: true,
  lazyConnect: true,
});
```

### Request Batching

```typescript
import DataLoader from 'dataloader';

const userLoader = new DataLoader(async (ids) => {
  const users = await db.users.findMany({
    where: { id: { in: ids } },
  });
  return ids.map(id => users.find(u => u.id === id));
});

server.addTool({
  name: "get_users",
  execute: async ({ user_ids }) => {
    const users = await Promise.all(
      user_ids.map(id => userLoader.load(id))
    );
    return JSON.stringify(users, null, 2);
  },
});
```

---

## Monitoring Dashboards

### Grafana Dashboard (JSON)

```json
{
  "dashboard": {
    "title": "MCP Server Metrics",
    "panels": [
      {
        "title": "Tool Call Rate",
        "targets": [
          {
            "expr": "rate(mcp_tool_calls_total[5m])"
          }
        ]
      },
      {
        "title": "Tool Duration (p95)",
        "targets": [
          {
            "expr": "histogram_quantile(0.95, mcp_tool_duration_seconds_bucket)"
          }
        ]
      },
      {
        "title": "Error Rate",
        "targets": [
          {
            "expr": "rate(mcp_tool_calls_total{status='error'}[5m])"
          }
        ]
      }
    ]
  }
}
```

### Prometheus Alerts

```yaml
groups:
- name: mcp-alerts
  rules:
  - alert: HighErrorRate
    expr: rate(mcp_tool_calls_total{status="error"}[5m]) > 0.1
    for: 5m
    annotations:
      summary: "High error rate in MCP server"
      
  - alert: HighLatency
    expr: histogram_quantile(0.95, mcp_tool_duration_seconds_bucket) > 5
    for: 5m
    annotations:
      summary: "High latency in tool execution"
      
  - alert: PodCrashLooping
    expr: rate(kube_pod_container_status_restarts_total{namespace="mcp-servers"}[15m]) > 0
    annotations:
      summary: "MCP server pod is crash looping"
```

---

## Testing Strategies

### Unit Tests

```typescript
import { describe, it, expect } from 'vitest';

describe('echo tool', () => {
  it('should echo message', async () => {
    const result = await server.executeTool('echo', {
      message: 'hello',
    });
    
    expect(result).toContain('hello');
  });
  
  it('should validate parameters', async () => {
    await expect(
      server.executeTool('echo', {})
    ).rejects.toThrow('message is required');
  });
});
```

### Integration Tests

```typescript
import { afterAll, beforeAll, describe, it } from 'vitest';

describe('MCP Server Integration', () => {
  let server;
  
  beforeAll(async () => {
    server = await startTestServer();
  });
  
  afterAll(async () => {
    await server.close();
  });
  
  it('should connect via SSE', async () => {
    const response = await fetch('http://localhost:3000/sse');
    expect(response.status).toBe(200);
    expect(response.headers.get('content-type')).toBe('text/event-stream');
  });
});
```

### Load Tests (k6)

```javascript
import http from 'k6/http';
import { check, sleep } from 'k6';

export const options = {
  vus: 100,
  duration: '5m',
};

export default function () {
  const res = http.post('http://mcp-server/sse', JSON.stringify({
    method: 'tools/call',
    params: {
      name: 'echo',
      arguments: { message: 'test' },
    },
  }));
  
  check(res, {
    'status is 200': (r) => r.status === 200,
    'response time < 500ms': (r) => r.timings.duration < 500,
  });
  
  sleep(1);
}
```

---

## Cost Optimization

### FinOps Best Practices

```yaml
cost_optimization:
  compute:
    - use_spot_instances: true
    - right_size_pods: true
    - enable_autoscaling: true
    - scale_to_zero_dev: true
    
  storage:
    - use_lifecycle_policies: true
    - compress_logs: true
    - retention_days: 30
    
  network:
    - use_cdn: true
    - enable_compression: true
    - minimize_egress: true
    
  monitoring:
    - track_cost_per_request: true
    - set_budget_alerts: true
    - review_monthly: true
```

### Resource Rightsizing

```bash
# Analyze actual usage
kubectl top pods -n mcp-servers

# Adjust based on p95 usage
kubectl set resources deployment mcp-server \
  --requests=cpu=100m,memory=128Mi \
  --limits=cpu=500m,memory=256Mi \
  -n mcp-servers
```

---

## Next Steps

1. **Start Simple**: Deploy example from `/home/kyler/mcp-cloud-demo`
2. **Add Real Tools**: Integrate with GitHub, databases, APIs
3. **Harden Security**: Add auth, secrets management, rate limiting
4. **Enable Observability**: OpenTelemetry, metrics, dashboards
5. **Automate Deployment**: GitOps with ArgoCD
6. **Document Everything**: Model cards, runbooks, architecture diagrams

---

**Reference Implementation:** `/home/kyler/mcp-cloud-demo/`  
**Full Architecture Guide:** `MCP_ARCHITECTURE_GUIDE.md`  
**Maintained By:** Platform Engineering Team
