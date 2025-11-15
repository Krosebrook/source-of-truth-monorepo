# MCP Server Architecture Guide (2025 Edition)

**Last Updated:** November 1, 2025  
**Version:** 1.0.0  
**Compliance:** EU AI Act, SLSA Level 2, Zero-Trust Architecture

---

## Table of Contents

1. [Executive Summary](#executive-summary)
2. [Architecture Overview](#architecture-overview)
3. [Local vs Cloud MCP](#local-vs-cloud-mcp)
4. [Implementation Guide](#implementation-guide)
5. [Security & Compliance](#security--compliance)
6. [Production Deployment](#production-deployment)
7. [Observability & Monitoring](#observability--monitoring)
8. [Troubleshooting](#troubleshooting)
9. [Best Practices](#best-practices)
10. [Reference Architecture](#reference-architecture)

---

## Executive Summary

### What is MCP?

**Model Context Protocol (MCP)** is an open standard for connecting AI assistants (like Claude) to external tools, data sources, and services. Think of it as a universal adapter that lets AI systems safely interact with your infrastructure.

### Key Benefits

- **Standardized Integration**: One protocol for all AI interactions
- **Secure by Design**: Built-in authentication, validation, and audit trails
- **Scalable Architecture**: From local development to enterprise cloud
- **Vendor Agnostic**: Works with any MCP-compliant AI system

### When to Use Each Transport

| Use Case | Transport | Example |
|----------|-----------|---------|
| Local file access | stdio | Filesystem, shell commands |
| Shared APIs | HTTP/SSE | GitHub, Stripe, databases |
| Team collaboration | HTTP/SSE | Vector stores, knowledge bases |
| Production services | HTTP/SSE | Cloud-hosted applications |

---

## Architecture Overview

### Transport Types

#### 1. stdio Transport (Local)

```
┌─────────────────┐
│  Claude Desktop │
└────────┬────────┘
         │ stdin/stdout
         ▼
┌─────────────────┐
│  Local Process  │
│  (MCP Server)   │
└─────────────────┘
```

**Characteristics:**
- Process spawned by Claude Desktop
- Communication via stdin/stdout pipes
- Managed lifecycle (auto start/stop)
- No network overhead
- Single-user only

**Configuration Example:**
```json
{
  "mcpServers": {
    "filesystem": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-filesystem", "/home/user/projects"],
      "env": {
        "LOG_LEVEL": "info"
      }
    }
  }
}
```

#### 2. HTTP/SSE Transport (Cloud)

```
┌─────────────────┐
│  Claude Desktop │
└────────┬────────┘
         │ HTTPS
         ▼
┌─────────────────┐
│     Ingress     │ (TLS, Load Balancer)
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│     Service     │ (ClusterIP)
└────────┬────────┘
         │
    ┌────┴────┐
    ▼         ▼
┌───────┐ ┌───────┐
│ Pod 1 │ │ Pod 2 │ ... (2-10 replicas)
└───────┘ └───────┘
```

**Characteristics:**
- Runs independently as a service
- Communication over HTTP/Server-Sent Events
- Self-managed lifecycle
- Network latency (minimal)
- Multi-user, scalable

**Configuration Example:**
```json
{
  "mcpServers": {
    "cloud-service": {
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

---

## Local vs Cloud MCP

### Decision Matrix

| Factor | Local (stdio) | Cloud (HTTP/SSE) |
|--------|---------------|------------------|
| **Deployment** | Per-user installation | Centralized service |
| **Scaling** | One instance per user | Horizontal auto-scaling |
| **Latency** | <1ms | 10-50ms (network) |
| **Sharing** | Not shareable | Team/org-wide |
| **Updates** | User manages | Deploy once |
| **Security** | Process isolation | TLS + auth tokens |
| **Cost** | Local compute | Shared infrastructure |
| **Monitoring** | Limited | Full observability |
| **Compliance** | Per-machine | Centralized audit |

### Hybrid Architecture (Recommended)

```json
{
  "mcpServers": {
    // LOCAL - Security boundary
    "filesystem": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-filesystem", "/home/user"]
    },
    
    // CLOUD - Shared services
    "github": {
      "transport": {
        "type": "sse",
        "url": "https://mcp.company.com/github/sse"
      }
    },
    "postgres": {
      "transport": {
        "type": "sse",
        "url": "https://mcp.company.com/postgres/sse"
      }
    },
    "vectordb": {
      "transport": {
        "type": "sse",
        "url": "https://mcp.company.com/vectordb/sse"
      }
    }
  }
}
```

**Rule of Thumb:**
- **Local**: Filesystem, shell, personal secrets
- **Cloud**: APIs, databases, shared data, team resources

---

## Implementation Guide

### Quick Start: Local MCP Server

```bash
# Using existing MCP servers
npx @modelcontextprotocol/create-server my-mcp-server
cd my-mcp-server
npm install

# Configure in Claude Desktop
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

### Building a Cloud MCP Server

#### 1. Project Setup

```bash
mkdir mcp-cloud-server
cd mcp-cloud-server
npm init -y
npm install fastmcp zod dotenv cors
npm install --save-dev typescript tsx @types/node @types/cors
```

#### 2. Server Implementation (TypeScript)

```typescript
// src/server.ts
import { FastMCP } from "fastmcp";
import { z } from "zod";

const PORT = parseInt(process.env.PORT || "3000", 10);

const server = new FastMCP({
  name: "Cloud MCP Server",
  version: "1.0.0",
});

// Health check (required for K8s)
server.addTool({
  name: "health_check",
  description: "Check server health status",
  parameters: z.object({}),
  execute: async () => {
    return JSON.stringify({
      status: "healthy",
      timestamp: new Date().toISOString(),
      uptime: process.uptime(),
    });
  },
});

// Example tool
server.addTool({
  name: "echo",
  description: "Echo back a message",
  parameters: z.object({
    message: z.string().describe("Message to echo"),
  }),
  execute: async ({ message }) => {
    return JSON.stringify({ echo: message, timestamp: new Date().toISOString() });
  },
});

// Start server
server.start({
  transportType: "sse",
  sse: {
    port: PORT,
    endpoint: "/sse",
  },
});

console.log(`MCP Server running on http://0.0.0.0:${PORT}/sse`);
```

#### 3. Dockerfile (Multi-stage Build)

```dockerfile
FROM node:20-alpine AS builder
WORKDIR /app
COPY package*.json tsconfig.json ./
RUN npm ci
COPY src ./src
RUN npm run build

FROM node:20-alpine
RUN addgroup -g 1001 -S mcp && adduser -S mcp -u 1001
WORKDIR /app
COPY --from=builder /app/package*.json ./
COPY --from=builder /app/build ./build
COPY --from=builder /app/node_modules ./node_modules
RUN chown -R mcp:mcp /app
USER mcp
EXPOSE 3000
HEALTHCHECK --interval=30s --timeout=3s \
  CMD node -e "fetch('http://localhost:3000/sse').then(r => r.ok ? process.exit(0) : process.exit(1))"
CMD ["node", "build/server.js"]
```

#### 4. Kubernetes Deployment

```yaml
# k8s/deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: mcp-server
  namespace: mcp-servers
spec:
  replicas: 2
  selector:
    matchLabels:
      app: mcp-server
  template:
    metadata:
      labels:
        app: mcp-server
    spec:
      securityContext:
        runAsNonRoot: true
        runAsUser: 1001
      containers:
      - name: mcp-server
        image: mcp-server:latest
        ports:
        - containerPort: 3000
        resources:
          requests:
            memory: "128Mi"
            cpu: "100m"
          limits:
            memory: "256Mi"
            cpu: "500m"
        livenessProbe:
          httpGet:
            path: /sse
            port: 3000
          initialDelaySeconds: 10
          periodSeconds: 30
        readinessProbe:
          httpGet:
            path: /sse
            port: 3000
          initialDelaySeconds: 5
          periodSeconds: 10
```

---

## Security & Compliance

### Zero-Trust Architecture

```yaml
security_principles:
  - never_trust_always_verify
  - assume_breach
  - least_privilege_access
  - defense_in_depth
```

### Authentication & Authorization

#### API Key Authentication

```typescript
// Middleware for API key validation
server.use(async (req, res, next) => {
  const apiKey = req.headers['x-api-key'];
  
  if (!apiKey || !await validateApiKey(apiKey)) {
    return res.status(401).json({ error: 'Unauthorized' });
  }
  
  next();
});
```

#### OAuth 2.0 / OIDC

```typescript
import { OAuth2Client } from 'google-auth-library';

const client = new OAuth2Client(process.env.GOOGLE_CLIENT_ID);

async function verifyToken(token: string) {
  const ticket = await client.verifyIdToken({
    idToken: token,
    audience: process.env.GOOGLE_CLIENT_ID,
  });
  return ticket.getPayload();
}
```

### Secrets Management

```yaml
# k8s/secrets.yaml
apiVersion: v1
kind: Secret
metadata:
  name: mcp-secrets
  namespace: mcp-servers
type: Opaque
stringData:
  github-token: ghp_xxxxx
  database-url: postgresql://user:pass@host/db
  api-key: sk_xxxxx
```

```yaml
# Mount in deployment
containers:
- name: mcp-server
  envFrom:
  - secretRef:
      name: mcp-secrets
```

### EU AI Act Compliance

#### Risk Classification

```yaml
ai_system:
  name: "mcp-cloud-server"
  risk_tier: "limited"  # minimal | limited | high | systemic
  
compliance_requirements:
  transparency:
    - ai_generated_content_labels: true
    - watermarking: "synthid"
    - user_notification: true
  
  documentation:
    - model_card: "docs/model-card.yaml"
    - technical_docs: "docs/architecture.md"
    - risk_assessment: "docs/risk-assessment.md"
  
  human_oversight:
    - approval_required_for: ["high_risk_decisions"]
    - escalation_threshold: 0.85
```

#### Model Card Template

```yaml
# docs/model-card.yaml
model_card:
  version: "1.0"
  model_details:
    name: "mcp-tool-selector"
    version: "2.1.0"
    type: "limited_risk"
    
  intended_use:
    primary: "Tool routing and parameter extraction"
    users: "Internal development team"
    out_of_scope: "Credit decisions, hiring, law enforcement"
    
  performance:
    accuracy: 0.96
    precision: 0.94
    recall: 0.92
    
  limitations:
    - "English language only"
    - "Requires retraining quarterly"
    
  ethical_considerations:
    - "No bias detected in protected categories"
    - "Human review required for ambiguous cases"
    
  compliance:
    eu_ai_act: "compliant"
    gdpr: "compliant"
    audit_trail: "enabled"
```

### SLSA Supply Chain Security

#### Level 2 Compliance

```yaml
# .github/workflows/slsa.yaml
name: SLSA Build
on: [push]

jobs:
  build:
    runs-on: ubuntu-latest
    permissions:
      id-token: write
      contents: read
    steps:
      - uses: actions/checkout@v4
      
      - name: Build
        run: docker build -t mcp-server:${{ github.sha }} .
        
      - name: Generate SBOM
        run: syft . -o spdx-json > sbom.spdx.json
        
      - name: Sign with Cosign
        uses: sigstore/cosign-installer@v3
        run: |
          cosign sign --yes mcp-server:${{ github.sha }}
          cosign attest --yes --predicate sbom.spdx.json
          
      - name: Generate SLSA Provenance
        uses: slsa-framework/slsa-github-generator@v1
        with:
          subject-name: mcp-server
```

---

## Production Deployment

### Kubernetes Production Stack

```yaml
# Complete production deployment
production_stack:
  infrastructure:
    - kubernetes: "1.29+"
    - service_mesh: "istio"
    - ingress: "nginx-ingress"
    - cert_manager: "1.14+"
    
  observability:
    - metrics: "prometheus + grafana"
    - tracing: "jaeger / tempo"
    - logging: "loki / elasticsearch"
    - ebpf: "falco + pixie"
    
  security:
    - secrets: "vault / sealed-secrets"
    - policy: "opa / kyverno"
    - scanning: "trivy + semgrep"
    - runtime: "falco + tetragon"
```

### High Availability Configuration

```yaml
# k8s/deployment-ha.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: mcp-server
spec:
  replicas: 3
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxSurge: 1
      maxUnavailable: 0
  
  template:
    spec:
      affinity:
        podAntiAffinity:
          preferredDuringSchedulingIgnoredDuringExecution:
          - weight: 100
            podAffinityTerm:
              labelSelector:
                matchLabels:
                  app: mcp-server
              topologyKey: kubernetes.io/hostname
      
      containers:
      - name: mcp-server
        resources:
          requests:
            memory: "256Mi"
            cpu: "200m"
          limits:
            memory: "512Mi"
            cpu: "1000m"
```

### Auto-Scaling

```yaml
# k8s/hpa.yaml
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: mcp-server
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: mcp-server
  minReplicas: 3
  maxReplicas: 20
  metrics:
  - type: Resource
    resource:
      name: cpu
      target:
        type: Utilization
        averageUtilization: 70
  - type: Resource
    resource:
      name: memory
      target:
        type: Utilization
        averageUtilization: 80
  behavior:
    scaleUp:
      stabilizationWindowSeconds: 0
      policies:
      - type: Percent
        value: 100
        periodSeconds: 30
    scaleDown:
      stabilizationWindowSeconds: 300
      policies:
      - type: Percent
        value: 50
        periodSeconds: 60
```

### Ingress with TLS

```yaml
# k8s/ingress.yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: mcp-server
  annotations:
    cert-manager.io/cluster-issuer: "letsencrypt-prod"
    nginx.ingress.kubernetes.io/ssl-redirect: "true"
    nginx.ingress.kubernetes.io/rate-limit: "100"
    nginx.ingress.kubernetes.io/proxy-read-timeout: "3600"
spec:
  ingressClassName: nginx
  tls:
  - hosts:
    - mcp.company.com
    secretName: mcp-tls
  rules:
  - host: mcp.company.com
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: mcp-server
            port:
              number: 80
```

---

## Observability & Monitoring

### OpenTelemetry Integration

```typescript
// src/telemetry.ts
import { NodeSDK } from '@opentelemetry/sdk-node';
import { getNodeAutoInstrumentations } from '@opentelemetry/auto-instrumentations-node';
import { PrometheusExporter } from '@opentelemetry/exporter-prometheus';
import { JaegerExporter } from '@opentelemetry/exporter-jaeger';

const sdk = new NodeSDK({
  serviceName: 'mcp-server',
  instrumentations: [getNodeAutoInstrumentations()],
  metricReader: new PrometheusExporter({ port: 9464 }),
  traceExporter: new JaegerExporter({
    endpoint: 'http://jaeger:14250',
  }),
});

sdk.start();
```

### Prometheus Metrics

```yaml
# k8s/servicemonitor.yaml
apiVersion: monitoring.coreos.com/v1
kind: ServiceMonitor
metadata:
  name: mcp-server
spec:
  selector:
    matchLabels:
      app: mcp-server
  endpoints:
  - port: metrics
    interval: 30s
    path: /metrics
```

### Custom Metrics

```typescript
import { Counter, Histogram } from 'prom-client';

const toolCallCounter = new Counter({
  name: 'mcp_tool_calls_total',
  help: 'Total number of tool calls',
  labelNames: ['tool_name', 'status'],
});

const toolDuration = new Histogram({
  name: 'mcp_tool_duration_seconds',
  help: 'Tool execution duration',
  labelNames: ['tool_name'],
  buckets: [0.1, 0.5, 1, 2, 5, 10],
});

// In tool execution
const end = toolDuration.startTimer({ tool_name: 'echo' });
try {
  const result = await executeToolLogic();
  toolCallCounter.inc({ tool_name: 'echo', status: 'success' });
  return result;
} catch (error) {
  toolCallCounter.inc({ tool_name: 'echo', status: 'error' });
  throw error;
} finally {
  end();
}
```

### Logging Best Practices

```typescript
import winston from 'winston';

const logger = winston.createLogger({
  level: process.env.LOG_LEVEL || 'info',
  format: winston.format.combine(
    winston.format.timestamp(),
    winston.format.errors({ stack: true }),
    winston.format.json()
  ),
  defaultMeta: {
    service: 'mcp-server',
    environment: process.env.NODE_ENV,
  },
  transports: [
    new winston.transports.Console(),
  ],
});

// Structured logging
logger.info('Tool executed', {
  tool_name: 'echo',
  duration_ms: 123,
  user_id: 'user-123',
  trace_id: req.headers['x-trace-id'],
});
```

### Distributed Tracing

```typescript
import { trace } from '@opentelemetry/api';

const tracer = trace.getTracer('mcp-server');

async function executeTool(name: string, params: any) {
  return tracer.startActiveSpan(`tool.${name}`, async (span) => {
    try {
      span.setAttribute('tool.name', name);
      span.setAttribute('params', JSON.stringify(params));
      
      const result = await toolLogic(params);
      
      span.setStatus({ code: SpanStatusCode.OK });
      return result;
    } catch (error) {
      span.recordException(error);
      span.setStatus({ code: SpanStatusCode.ERROR });
      throw error;
    } finally {
      span.end();
    }
  });
}
```

---

## Troubleshooting

### Common Issues

#### 1. Connection Refused

**Symptom:** Claude Desktop can't connect to MCP server

**Diagnosis:**
```bash
# Check if server is running
curl http://localhost:3000/sse

# Check port-forward (K8s)
kubectl get pods -n mcp-servers
kubectl port-forward -n mcp-servers svc/mcp-server 3000:80

# Check logs
kubectl logs -n mcp-servers -l app=mcp-server
```

**Solution:**
- Verify URL in Claude config matches server endpoint
- Ensure port-forward is active
- Check firewall rules

#### 2. Tools Not Appearing

**Symptom:** MCP server connects but tools don't show in Claude

**Diagnosis:**
```bash
# Test server capabilities endpoint
curl http://localhost:3000/sse

# Check server logs for registration
kubectl logs -n mcp-servers <pod-name> | grep -i "tool"
```

**Solution:**
- Restart Claude Desktop after config changes
- Verify tool registration in server code
- Check for errors in server logs

#### 3. High Latency

**Symptom:** Slow tool execution

**Diagnosis:**
```bash
# Check pod resources
kubectl top pods -n mcp-servers

# Check metrics
curl http://localhost:9464/metrics | grep mcp_tool_duration

# Distributed tracing
# View Jaeger UI for trace breakdown
```

**Solution:**
- Increase resource limits
- Add caching layer
- Optimize database queries
- Scale horizontally

#### 4. Memory Leaks

**Symptom:** Pods getting OOMKilled

**Diagnosis:**
```bash
# Check memory usage over time
kubectl top pods -n mcp-servers --watch

# Get heap dump (if enabled)
curl http://localhost:9229/heap-profile
```

**Solution:**
```typescript
// Enable garbage collection monitoring
if (global.gc) {
  setInterval(() => {
    const used = process.memoryUsage();
    console.log('Memory:', {
      heapUsed: (used.heapUsed / 1024 / 1024).toFixed(2) + 'MB',
      heapTotal: (used.heapTotal / 1024 / 1024).toFixed(2) + 'MB',
    });
  }, 60000);
}
```

### Debug Mode

```typescript
// Enable debug logging
const DEBUG = process.env.DEBUG === 'true';

server.addTool({
  name: 'echo',
  execute: async ({ message }) => {
    if (DEBUG) {
      console.log('[DEBUG] Tool call:', {
        name: 'echo',
        params: { message },
        timestamp: new Date().toISOString(),
        trace_id: getCurrentTraceId(),
      });
    }
    
    return message;
  },
});
```

### Health Check Endpoint

```typescript
import os from 'os';

server.addTool({
  name: 'system_health',
  description: 'Get detailed system health information',
  parameters: z.object({}),
  execute: async () => {
    return JSON.stringify({
      status: 'healthy',
      timestamp: new Date().toISOString(),
      uptime_seconds: process.uptime(),
      memory: {
        used_mb: (process.memoryUsage().heapUsed / 1024 / 1024).toFixed(2),
        total_mb: (process.memoryUsage().heapTotal / 1024 / 1024).toFixed(2),
        system_mb: (os.totalmem() / 1024 / 1024).toFixed(2),
        free_mb: (os.freemem() / 1024 / 1024).toFixed(2),
      },
      cpu: {
        load_avg: os.loadavg(),
        cores: os.cpus().length,
      },
      node_version: process.version,
      environment: process.env.NODE_ENV,
    }, null, 2);
  },
});
```

---

## Best Practices

### Tool Design

```typescript
// ✅ GOOD: Clear, focused, well-documented
server.addTool({
  name: "get_user_profile",
  description: "Retrieve user profile information by user ID",
  parameters: z.object({
    user_id: z.string()
      .min(1)
      .describe("The unique identifier for the user"),
    include_stats: z.boolean()
      .optional()
      .describe("Whether to include usage statistics"),
  }),
  execute: async ({ user_id, include_stats = false }) => {
    // Input validation
    if (!isValidUserId(user_id)) {
      throw new Error('Invalid user ID format');
    }
    
    // Execution with tracing
    const profile = await db.getProfile(user_id);
    
    if (include_stats) {
      profile.stats = await db.getStats(user_id);
    }
    
    // Structured output
    return JSON.stringify(profile, null, 2);
  },
});

// ❌ BAD: Vague, no validation, poor error handling
server.addTool({
  name: "get_data",
  description: "Gets data",
  parameters: z.object({
    id: z.string(),
  }),
  execute: async ({ id }) => {
    return db.get(id); // No validation, error handling, or formatting
  },
});
```

### Error Handling

```typescript
class ToolError extends Error {
  constructor(
    message: string,
    public code: string,
    public statusCode: number = 500,
    public details?: any
  ) {
    super(message);
    this.name = 'ToolError';
  }
}

server.addTool({
  name: "safe_operation",
  execute: async (params) => {
    try {
      return await riskyOperation(params);
    } catch (error) {
      if (error instanceof ValidationError) {
        throw new ToolError(
          'Invalid input parameters',
          'VALIDATION_ERROR',
          400,
          error.details
        );
      }
      
      if (error instanceof NotFoundError) {
        throw new ToolError(
          'Resource not found',
          'NOT_FOUND',
          404
        );
      }
      
      // Log unexpected errors
      logger.error('Unexpected tool error', {
        tool: 'safe_operation',
        error: error.message,
        stack: error.stack,
      });
      
      throw new ToolError(
        'Internal server error',
        'INTERNAL_ERROR',
        500
      );
    }
  },
});
```

### Rate Limiting

```typescript
import rateLimit from 'express-rate-limit';

const limiter = rateLimit({
  windowMs: 60 * 1000, // 1 minute
  max: 100, // 100 requests per minute
  message: 'Too many requests, please try again later',
  standardHeaders: true,
  legacyHeaders: false,
});

app.use('/sse', limiter);
```

### Caching Strategy

```typescript
import NodeCache from 'node-cache';

const cache = new NodeCache({
  stdTTL: 600, // 10 minutes
  checkperiod: 120, // Check for expired keys every 2 minutes
});

server.addTool({
  name: "get_expensive_data",
  execute: async ({ query }) => {
    const cacheKey = `expensive:${query}`;
    
    // Check cache
    const cached = cache.get(cacheKey);
    if (cached) {
      return cached;
    }
    
    // Compute expensive operation
    const result = await expensiveComputation(query);
    
    // Store in cache
    cache.set(cacheKey, result);
    
    return result;
  },
});
```

### Graceful Shutdown

```typescript
let isShuttingDown = false;

async function gracefulShutdown(signal: string) {
  if (isShuttingDown) return;
  isShuttingDown = true;
  
  console.log(`Received ${signal}, starting graceful shutdown...`);
  
  // Stop accepting new connections
  server.close();
  
  // Wait for in-flight requests
  await new Promise(resolve => setTimeout(resolve, 5000));
  
  // Close database connections
  await db.close();
  
  // Close cache
  cache.close();
  
  console.log('Graceful shutdown complete');
  process.exit(0);
}

process.on('SIGTERM', () => gracefulShutdown('SIGTERM'));
process.on('SIGINT', () => gracefulShutdown('SIGINT'));
```

---

## Reference Architecture

### Production-Ready Stack

```yaml
mcp_production_stack:
  application:
    framework: "fastmcp"
    language: "typescript"
    runtime: "node:20-alpine"
    
  infrastructure:
    platform: "kubernetes 1.29+"
    container_runtime: "containerd"
    service_mesh: "istio 1.20+"
    ingress: "nginx-ingress"
    
  data_layer:
    cache: "redis 7+"
    database: "postgresql 16+"
    vector_db: "pinecone | weaviate | qdrant"
    object_storage: "s3 | gcs"
    
  observability:
    metrics: "prometheus + grafana"
    tracing: "opentelemetry + jaeger"
    logging: "loki + grafana"
    profiling: "pyroscope | pprof"
    ebpf: "pixie | falco"
    
  security:
    secrets: "hashicorp-vault | sealed-secrets"
    policy: "opa | kyverno"
    scanning: "trivy + semgrep + snyk"
    sbom: "syft + grype"
    signing: "cosign + sigstore"
    runtime: "falco + tetragon"
    network: "cilium | calico"
    
  ci_cd:
    pipeline: "github-actions | gitlab-ci"
    gitops: "argocd | flux"
    registry: "harbor | ecr | gcr"
    slsa: "level-2-minimum"
    
  compliance:
    eu_ai_act: "enabled"
    gdpr: "enabled"
    sox: "audit-trails-enabled"
    iso_42001: "documented"
```

### Directory Structure

```
mcp-cloud-server/
├── .github/
│   └── workflows/
│       ├── ci.yaml                 # Build, test, scan
│       ├── security.yaml           # SAST, DAST, secrets
│       ├── slsa.yaml              # SLSA provenance
│       └── deploy.yaml            # GitOps deployment
├── k8s/
│   ├── base/
│   │   ├── namespace.yaml
│   │   ├── deployment.yaml
│   │   ├── service.yaml
│   │   ├── ingress.yaml
│   │   ├── hpa.yaml
│   │   └── servicemonitor.yaml
│   └── overlays/
│       ├── dev/
│       ├── staging/
│       └── production/
├── src/
│   ├── server.ts                  # Main server
│   ├── tools/                     # Tool implementations
│   │   ├── github.ts
│   │   ├── database.ts
│   │   └── vectordb.ts
│   ├── middleware/                # Auth, logging, etc.
│   ├── utils/                     # Helpers
│   └── telemetry.ts               # OpenTelemetry setup
├── tests/
│   ├── unit/
│   ├── integration/
│   └── e2e/
├── docs/
│   ├── architecture.md
│   ├── model-card.yaml
│   ├── risk-assessment.md
│   └── runbook.md
├── scripts/
│   ├── deploy.sh
│   ├── port-forward.sh
│   └── sbom-generate.sh
├── Dockerfile
├── package.json
├── tsconfig.json
└── README.md
```

### Example Makefile

```makefile
# Makefile for MCP Server

.PHONY: help install build test lint security deploy clean

help:
	@echo "MCP Server - Available targets:"
	@echo "  install    - Install dependencies"
	@echo "  build      - Build TypeScript"
	@echo "  test       - Run tests"
	@echo "  lint       - Run linters"
	@echo "  security   - Run security scans"
	@echo "  docker     - Build Docker image"
	@echo "  deploy     - Deploy to Kubernetes"
	@echo "  sbom       - Generate SBOM"
	@echo "  clean      - Clean build artifacts"

install:
	npm install

build:
	npm run build

test:
	npm test

lint:
	npm run lint

security:
	@echo "Running security scans..."
	gitleaks detect --baseline-path=.gitleaks-baseline.json
	semgrep ci --config=auto
	trivy fs . --severity HIGH,CRITICAL
	npm audit --audit-level=moderate

docker:
	docker build -t mcp-server:latest .
	docker tag mcp-server:latest mcp-server:$(VERSION)

sbom:
	syft . -o spdx-json > sbom.spdx.json
	syft . -o cyclonedx-json > sbom.cdx.json
	grype sbom.spdx.json --fail-on high

sbom-sign:
	cosign sign --yes mcp-server:latest
	cosign attest --yes --predicate sbom.spdx.json mcp-server:latest

deploy:
	kubectl apply -f k8s/base/
	kubectl rollout status deployment/mcp-server -n mcp-servers

clean:
	rm -rf build/ node_modules/ *.log
	docker rmi mcp-server:latest || true

check: lint test security
	@echo "✅ All checks passed"
```

---

## Appendix

### Useful Links

- **MCP Specification**: https://modelcontextprotocol.io
- **FastMCP**: https://github.com/punkpeye/fastmcp
- **Anthropic MCP Servers**: https://github.com/modelcontextprotocol/servers
- **EU AI Act**: https://artificialintelligenceact.eu
- **SLSA Framework**: https://slsa.dev
- **OpenTelemetry**: https://opentelemetry.io
- **Kubernetes Best Practices**: https://kubernetes.io/docs/concepts/configuration/overview/

### Configuration Examples

See `/home/kyler/mcp-cloud-demo/` for complete working examples:
- FastMCP server implementation
- Kubernetes manifests
- Docker multi-stage build
- Deployment scripts
- Claude Desktop configuration

### Changelog

**v1.0.0 (2025-11-01)**
- Initial comprehensive documentation
- Cloud vs local architecture comparison
- Production deployment guide
- Security & compliance framework
- Observability & monitoring setup
- Troubleshooting guide
- Best practices and reference architecture

---

**Document Status:** ✅ Complete and validated  
**Next Review:** 2025-12-01  
**Maintained By:** Platform Engineering Team
