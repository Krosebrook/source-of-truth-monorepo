#!/bin/bash
# Port-forward MCP server from Kubernetes to local machine

echo "🚀 Starting port-forward for MCP Cloud Server..."
echo "📍 Kubernetes: mcp-servers/mcp-cloud-server"
echo "🌐 Local URL: http://localhost:3002/sse"
echo ""
echo "Add this to ~/.config/Claude/claude_desktop_config.json:"
echo ""
cat claude-config.json
echo ""
echo "Press Ctrl+C to stop"
echo ""

kubectl port-forward -n mcp-servers svc/mcp-cloud-server 3002:80
