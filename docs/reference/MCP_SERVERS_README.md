# MCP Servers Configuration Guide

## Installed MCP Servers

### Core Utilities
1. **filesystem** - Secure filesystem access with directory permissions
2. **memory** - Persistent context management across sessions
3. **sequential-thinking** - Enhanced reasoning capabilities

### Development Tools
4. **github** - Repository management, PRs, issues
5. **chrome-devtools** - Browser debugging and inspection
6. **puppeteer** - Browser automation and web scraping
7. **context7** - Enhanced documentation search

### Databases
8. **postgresql** - PostgreSQL database operations
9. **mongodb** - MongoDB and Atlas cluster access

### Integrations
10. **notion** - Notion workspace management
11. **apify** - Web scraping platform
12. **heroku** - Platform deployment management
13. **sentry** - Error tracking (SSE endpoint)
14. **cloud-k8s** - Kubernetes management (local SSE)

## Configuration Files

### Main Configuration: `~/.mcp.json`
- Primary MCP servers configuration
- Uses environment variables for credentials
- Supports stdio, SSE, and HTTP transports

### Environment Variables: `~/.mcp.env.example`
- Template for required credentials
- Copy to `.env` and fill in values
- Source before running Claude Code

### Project-Specific: `.mcp.json` in project root
- Override global settings per project
- Commit to repos for team consistency

## Usage Examples

### 1. Enable GitHub Integration
```bash
# Create GitHub token at: https://github.com/settings/tokens
# Scopes needed: repo, read:org, read:user
export GITHUB_TOKEN="ghp_your_token_here"
```

### 2. Database Access
```bash
# PostgreSQL
export POSTGRES_CONNECTION_STRING="postgresql://user:pass@localhost:5432/db"

# MongoDB
export MONGODB_CONNECTION_STRING="mongodb://localhost:27017/mydb"
```

### 3. Notion Integration
```bash
# Create integration at: https://www.notion.so/my-integrations
export NOTION_API_KEY="secret_your_key_here"
```

### 4. Using in Claude Code
```bash
# Source environment variables
source ~/.mcp.env

# Start Claude Code (MCP servers auto-load from ~/.mcp.json)
claude

# Or specify custom MCP config
claude --mcp-config ./project/.mcp.json
```

## Available MCP Templates

Additional servers available in plugin marketplace:
- **Browser Automation**: Playwright, Browserbase, Browser-use
- **DevOps**: Terraform, Pulumi, CircleCI, Azure K8s
- **Monitoring**: Grafana, Dynatrace, Logfire
- **Marketing**: Facebook Ads, Google Ads
- **Productivity**: Trello, Monday, Box
- **Testing**: TestSprite, Codacy
- **More**: Stripe, Postman, Webflow, LaunchDarkly, etc.

## Adding New Servers

### Via NPM
```bash
npm install -g package-name
```

### Add to .mcp.json
```json
{
  "mcpServers": {
    "server-name": {
      "command": "npx",
      "args": ["-y", "package-name"],
      "env": {
        "API_KEY": "${YOUR_ENV_VAR}"
      }
    }
  }
}
```

### Via SSE/HTTP
```json
{
  "mcpServers": {
    "remote-server": {
      "url": "https://api.example.com/mcp"
    }
  }
}
```

## Troubleshooting

### Check Installed Packages
```bash
npm list -g --depth=0 | grep mcp
```

### Test MCP Server
```bash
npx @modelcontextprotocol/inspector
```

### View MCP Logs
```bash
# Enable debug mode
export MCP_DEBUG=true
claude --mcp-debug
```

### Common Issues

1. **Server won't start**: Check environment variables are exported
2. **Timeout errors**: Increase `MCP_TIMEOUT` env var (default 10s)
3. **Permission denied**: Verify API tokens and scopes
4. **Tool not found**: Run `npm install -g` for the package

## Best Practices

1. **Environment Variables**: Use `.env` files, never commit credentials
2. **Project Configs**: Share `.mcp.json` in repos for consistency
3. **Security**: Use read-only DB connections when possible
4. **Performance**: Only enable servers you actively need
5. **Updates**: Regularly update packages with `npm update -g`

## Additional Resources

- [MCP Documentation](https://modelcontextprotocol.io)
- [Claude Code Docs](https://docs.claude.com/en/docs/claude-code)
- [MCP Server Registry](https://github.com/modelcontextprotocol/servers)
- [Plugin Marketplace](https://github.com/anthropics/claude-code-plugins)

## Installed Packages Summary

Run to see all installed MCP packages:
```bash
npm list -g | grep -E "mcp|@modelcontextprotocol"
```

Current installations:
- @modelcontextprotocol/server-filesystem
- @modelcontextprotocol/server-memory
- @modelcontextprotocol/server-sequential-thinking
- @modelcontextprotocol/server-everything
- @modelcontextprotocol/server-postgres
- mongodb-mcp-server
- @notionhq/notion-mcp-server
- puppeteer-mcp-server
- chrome-devtools-mcp
- @upstash/context7-mcp
- @apify/actors-mcp-server
- @heroku/mcp-server
