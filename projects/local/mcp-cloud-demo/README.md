# Cloud MCP Server

Production-ready Model Context Protocol (MCP) server designed for Kubernetes deployment.

## Features

- ✅ **HTTP/SSE Transport** - Network-accessible for multiple clients
- ✅ **Kubernetes-Ready** - Deployment, Service, Ingress, HPA configs
- ✅ **Health Checks** - Liveness and readiness probes
- ✅ **Observability** - Structured logging, metrics-ready
- ✅ **Security** - Non-root user, read-only filesystem, minimal privileges
- ✅ **Auto-Scaling** - HPA based on CPU/memory
- ✅ **Production Hardened** - Multi-stage Docker build, resource limits

## Quick Start

### 1. Local Development

```bash
# Install dependencies
npm install

# Run in development mode
npm run dev

# Build TypeScript
npm run build

# Run production build
npm start
```

Test the server:
```bash
curl http://localhost:3000/sse
```

### 2. Docker Build & Run

```bash
# Build Docker image
npm run docker:build

# Or manually
docker build -t mcp-cloud-server:latest .

# Run container
docker run -p 3000:3000 mcp-cloud-server:latest

# Test
curl http://localhost:3000/sse
```

### 3. Deploy to Kubernetes

```bash
# Create namespace
kubectl apply -f k8s/namespace.yaml

# Deploy all resources
kubectl apply -f k8s/

# Check status
kubectl get pods -n mcp-servers
kubectl get svc -n mcp-servers
kubectl get ingress -n mcp-servers

# View logs
kubectl logs -n mcp-servers -l app=mcp-cloud-server -f

# Test from within cluster
kubectl run curl --image=curlimages/curl -i --tty --rm -- \
  curl http://mcp-cloud-server.mcp-servers.svc.cluster.local/sse
```

### 4. Configure Claude Desktop

Update `~/.config/Claude/claude_desktop_config.json`:

```json
{
  "mcpServers": {
    "cloud-mcp": {
      "transport": {
        "type": "sse",
        "url": "https://mcp.yourdomain.com/sse"
      }
    }
  }
}
```

For local testing (port-forward):
```bash
kubectl port-forward -n mcp-servers svc/mcp-cloud-server 3000:80
```

Then use `http://localhost:3000/sse` in Claude config.

## Architecture

```
┌─────────────┐
│   Client    │ (Claude Desktop)
└──────┬──────┘
       │ HTTPS
       ▼
┌─────────────┐
│   Ingress   │ (TLS termination)
└──────┬──────┘
       │
       ▼
┌─────────────┐
│   Service   │ (Load balancer)
└──────┬──────┘
       │
       ▼
┌─────────────────────────┐
│  Deployment (2-10 pods) │ (Auto-scaling)
└─────────────────────────┘
```

## Configuration

### Environment Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `NODE_ENV` | `development` | Environment mode |
| `PORT` | `3000` | Server port |
| `HOST` | `0.0.0.0` | Bind address |

### Kubernetes Resources

- **Namespace**: `mcp-servers`
- **Deployment**: 2-10 replicas with auto-scaling
- **Service**: ClusterIP with session affinity
- **Ingress**: NGINX with TLS (cert-manager)
- **HPA**: CPU/memory based scaling

## Available Tools

### 1. health_check
Check server health status
```typescript
// No parameters
```

### 2. echo
Echo back a message
```typescript
{
  message: string
}
```

### 3. get_time
Get current server time
```typescript
{
  timezone?: string  // Default: UTC
}
```

## Security Features

- Non-root container user (UID 1001)
- Read-only root filesystem
- Dropped all capabilities
- Resource limits enforced
- Multi-stage Docker build (smaller attack surface)
- Health check endpoints

## Monitoring

The deployment includes Prometheus annotations:
```yaml
prometheus.io/scrape: "true"
prometheus.io/port: "3000"
prometheus.io/path: "/metrics"
```

View logs:
```bash
# All pods
kubectl logs -n mcp-servers -l app=mcp-cloud-server --tail=100 -f

# Specific pod
kubectl logs -n mcp-servers <pod-name> -f
```

## Scaling

Manual scaling:
```bash
kubectl scale deployment mcp-cloud-server -n mcp-servers --replicas=5
```

Auto-scaling is configured via HPA (k8s/hpa.yaml):
- Min replicas: 2
- Max replicas: 10
- Target CPU: 70%
- Target Memory: 80%

## Troubleshooting

### Check pod status
```bash
kubectl get pods -n mcp-servers -o wide
kubectl describe pod <pod-name> -n mcp-servers
```

### View events
```bash
kubectl get events -n mcp-servers --sort-by='.lastTimestamp'
```

### Debug container
```bash
kubectl exec -it <pod-name> -n mcp-servers -- sh
```

### Port forward for local testing
```bash
kubectl port-forward -n mcp-servers svc/mcp-cloud-server 3000:80
```

## Production Checklist

- [ ] Update `mcp.yourdomain.com` in `k8s/ingress.yaml`
- [ ] Configure TLS with cert-manager
- [ ] Set up proper DNS records
- [ ] Add API keys to Kubernetes secrets
- [ ] Configure resource limits based on load testing
- [ ] Set up monitoring/alerting
- [ ] Configure backup/disaster recovery
- [ ] Review security policies (NetworkPolicy, PodSecurityPolicy)
- [ ] Set up CI/CD pipeline
- [ ] Configure log aggregation

## Next Steps

1. **Add Authentication**: Implement API key or OAuth
2. **Add More Tools**: Extend functionality
3. **Metrics**: Add Prometheus metrics
4. **Tracing**: Add OpenTelemetry
5. **Rate Limiting**: Implement request throttling
6. **Caching**: Add Redis for performance

## License

MIT
