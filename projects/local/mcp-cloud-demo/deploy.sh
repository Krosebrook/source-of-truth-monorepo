#!/bin/bash
# Deploy MCP Cloud Server to Kubernetes

set -e

echo "🔨 Building Docker image..."
docker build -t mcp-cloud-server:latest .

echo ""
echo "☸️  Deploying to Kubernetes..."
kubectl apply -f k8s/namespace.yaml
kubectl apply -f k8s/deployment.yaml
kubectl apply -f k8s/service.yaml

echo ""
echo "⏳ Waiting for pods to be ready..."
kubectl wait --for=condition=ready pod -l app=mcp-cloud-server -n mcp-servers --timeout=60s || true

echo ""
echo "✅ Deployment complete!"
echo ""
kubectl get all -n mcp-servers

echo ""
echo "📝 Next steps:"
echo "1. Run ./port-forward.sh to access the server locally"
echo "2. Add the config from claude-config.json to Claude Desktop"
echo "3. Restart Claude Desktop"
