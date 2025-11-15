# MCP (Model Context Protocol) Integration Guide

**Date**: 2025-11-15  
**Status**: ✅ Implemented  
**Version**: 1.0.0

## Overview

This monorepo has been configured with comprehensive MCP server support to enhance AI-assisted development workflows. MCP provides standardized interfaces for AI agents to interact with tools, data sources, and services.

## Architecture

### MCP Server Topology

We use a **Hub-and-Spoke (Orchestrator-Worker)** pattern:
- **Central orchestrator**: Claude Code coordinates specialized domain skills
- **Predictable workflows**: Clear governance and audit trails
- **Optimal for regulated industries**: Strict control and traceability

### Installed Servers (14)

#### Core Utilities
1. **filesystem** - Secure filesystem access with directory permissions
2. **memory** - Persistent context management across sessions
3. **sequential-thinking** - Enhanced reasoning and problem-solving
4. **everything** - Comprehensive toolkit combining multiple capabilities

#### Development Tools
5. **github** - Repository management, PRs, issues, commits
6. **chrome-devtools** - Browser debugging and inspection
7. **puppeteer** - Browser automation and web scraping
8. **context7** - Enhanced documentation search and retrieval

#### Databases
9. **postgresql** - PostgreSQL database operations and queries
10. **mongodb** - MongoDB and Atlas cluster access

#### Integrations
11. **notion** - Notion workspace management
12. **apify** - Web scraping platform integration
13. **heroku** - Platform deployment and management
14. **sentry** - Error tracking and performance monitoring (SSE endpoint)

#### Infrastructure
15. **cloud-k8s** - Kubernetes cluster management (local SSE server)

## Configuration Files

### Global Configuration
- **Location**: `~/.mcp.json`
- **Purpose**: User-wide MCP server configuration
- **Format**: JSON with environment variable substitution

### Project Configuration
- **Location**: `.mcp.json` (repository root)
- **Purpose**: Project-specific MCP configuration
- **Committed**: Yes (for team consistency)
- **Priority**: Overrides global settings

### Environment Variables
- **Location**: `.mcp.env.example` (repository root)
- **Purpose**: Template for required credentials
- **Committed**: Yes (as example/template only)
- **Usage**: Copy to `.mcp.env` and configure

## Installation

### Prerequisites
```bash
# Ensure Node.js and npm are installed
node --version  # Should be 20+
npm --version   # Should be 10+
```

### Automated Setup
```bash
# Run the interactive setup script
./scripts/setup-mcp.sh
```

### Manual Installation
```bash
# Install all MCP server packages
npm install -g \
  @modelcontextprotocol/server-filesystem \
  @modelcontextprotocol/server-memory \
  @modelcontextprotocol/server-sequential-thinking \
  @modelcontextprotocol/server-everything \
  @modelcontextprotocol/server-postgres \
  mongodb-mcp-server \
  @notionhq/notion-mcp-server \
  puppeteer-mcp-server \
  chrome-devtools-mcp \
  @upstash/context7-mcp \
  @apify/actors-mcp-server \
  @heroku/mcp-server
```

## Configuration

### 1. Environment Variables

Copy the template and configure:
```bash
cp .mcp.env.example .mcp.env
nano .mcp.env
```

Required variables (optional - servers work without them):
```bash
# GitHub Integration
GITHUB_TOKEN=ghp_your_token_here

# Database Connections
POSTGRES_CONNECTION_STRING=postgresql://user:pass@localhost:5432/dbname
MONGODB_CONNECTION_STRING=mongodb://localhost:27017/mydb

# Notion Integration
NOTION_API_KEY=secret_your_key_here

# Apify Web Scraping
APIFY_API_TOKEN=your_apify_token

# Heroku Platform
HEROKU_API_KEY=your_heroku_key
```

### 2. Load Environment
```bash
# Add to your shell profile (~/.zshrc or ~/.bashrc)
source /path/to/source-of-truth-monorepo/.mcp.env

# Or load for current session
source .mcp.env
```

### 3. Verify Configuration
```bash
# Check installed packages
npm list -g --depth=0 | grep mcp

# Verify environment variables
./scripts/setup-mcp.sh

# Test MCP server
npx @modelcontextprotocol/inspector
```

## Usage

### With Claude Code

#### Global MCP Servers
```bash
# Start Claude Code (auto-loads ~/.mcp.json)
claude

# MCP servers are automatically available
# Use @ to mention resources or invoke tools
```

#### Project-Specific MCP
```bash
# Navigate to project
cd /path/to/source-of-truth-monorepo

# Start Claude Code (loads project .mcp.json)
claude

# Or explicitly specify config
claude --mcp-config ./.mcp.json
```

#### Debug Mode
```bash
# Enable MCP debugging
export MCP_DEBUG=true
claude --mcp-debug
```

### Available Capabilities

#### Filesystem Operations
- Read/write files within allowed directories
- Directory traversal and search
- File metadata and permissions

#### Memory Management
- Store context across sessions
- Retrieve previous conversations
- Build knowledge graphs

#### Enhanced Reasoning
- Step-by-step problem decomposition
- Chain-of-thought reasoning
- Complex decision-making support

#### GitHub Integration
- Repository management
- Issue tracking and creation
- Pull request operations
- Commit history analysis

#### Database Access
- SQL query execution (PostgreSQL)
- NoSQL operations (MongoDB)
- Schema inspection
- Data migration support

#### Browser Automation
- Web scraping and data extraction
- UI testing and validation
- Screenshot capture
- Form automation

#### Documentation Search
- Context-aware documentation retrieval
- Code example discovery
- API reference lookup

## Best Practices

### Security

1. **Environment Variables**: Never commit `.mcp.env` with real credentials
2. **Database Connections**: Use read-only credentials when possible
3. **API Tokens**: Rotate regularly and use minimal required scopes
4. **Filesystem Access**: Restrict to project directories only

### Performance

1. **Selective Loading**: Only enable servers you actively need
2. **Timeout Configuration**: Set `MCP_TIMEOUT` for slow networks (default 10s)
3. **Caching**: Leverage MCP's built-in caching mechanisms
4. **Tool Timeout**: Use `MCP_TOOL_TIMEOUT` for long-running operations

### Team Collaboration

1. **Commit Project Config**: Share `.mcp.json` in repository
2. **Document Secrets**: List required env vars in README
3. **Version Control**: Track MCP server versions in package.json
4. **Consistent Setup**: Use `setup-mcp.sh` for onboarding

## Troubleshooting

### Server Won't Start
```bash
# Check if environment variables are set
echo $GITHUB_TOKEN

# Verify package installation
npm list -g @modelcontextprotocol/server-github

# Test server manually
npx @modelcontextprotocol/server-github
```

### Timeout Errors
```bash
# Increase timeout (default 10s)
export MCP_TIMEOUT=30000

# Increase tool timeout (default 30s)
export MCP_TOOL_TIMEOUT=60000
```

### Permission Denied
```bash
# Check API token scopes
# GitHub requires: repo, read:org, read:user

# Verify database permissions
psql $POSTGRES_CONNECTION_STRING -c "SELECT current_user, current_database();"
```

### Tool Not Found
```bash
# Reinstall specific package
npm install -g @modelcontextprotocol/server-github

# Clear npm cache
npm cache clean --force
```

## Governance & Compliance

### Audit Trail
- All MCP tool invocations are logged by Claude Code
- Enable `--mcp-debug` for detailed logging
- Review logs in `~/.claude/debug/`

### Data Protection
- MCP servers respect `.gitignore` patterns
- Sensitive data redaction via environment configuration
- GDPR-compliant data handling (see EU AI Act compliance)

### Access Control
- Filesystem access restricted by configuration
- Database connections use principle of least privilege
- API tokens scoped to minimum required permissions

## Advanced Topics

### Custom MCP Servers

Create project-specific servers:
```json
{
  "mcpServers": {
    "custom-tool": {
      "command": "node",
      "args": ["./scripts/custom-mcp-server.js"],
      "env": {
        "CUSTOM_CONFIG": "${CUSTOM_VAR}"
      }
    }
  }
}
```

### SSE Servers

Configure Server-Sent Events endpoints:
```json
{
  "mcpServers": {
    "remote-service": {
      "url": "https://api.example.com/mcp"
    }
  }
}
```

### OAuth Integration

Some servers (e.g., Slack) support OAuth:
```json
{
  "mcpServers": {
    "slack": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-slack"],
      "oauth": {
        "authUrl": "https://slack.com/oauth/v2/authorize",
        "tokenUrl": "https://slack.com/api/oauth.v2.access"
      }
    }
  }
}
```

## Migration Guide

### From Claude Desktop MCP Config

Import existing configuration:
```bash
# Automated import
claude mcp add-from-claude-desktop

# Manual migration
# Copy ~/.config/Claude/claude_desktop_config.json mcpServers section
# to .mcp.json
```

### From Legacy Tools

Replace manual tool invocations:
- **GitHub CLI** → MCP GitHub server
- **Database clients** → MCP database servers
- **Web scrapers** → MCP Puppeteer/Apify servers

## Resources

### Documentation
- [MCP Specification](https://modelcontextprotocol.io)
- [Claude Code MCP Guide](https://docs.claude.com/en/docs/claude-code/mcp)
- [Server Registry](https://github.com/modelcontextprotocol/servers)

### Quick References
- [MCP Quick Start](./MCP_QUICK_START.txt)
- [MCP Servers README](./MCP_SERVERS_README.md)
- [Setup Script](../../scripts/setup-mcp.sh)

### Community
- [MCP GitHub Discussions](https://github.com/modelcontextprotocol/discussions)
- [Claude Code Plugins](https://github.com/anthropics/claude-code-plugins)

## Support

### Internal
- Review existing `.mcp.json` configuration
- Run `./scripts/setup-mcp.sh` for diagnostics
- Check `docs/reference/MCP_SERVERS_README.md`

### External
- [MCP Issues](https://github.com/modelcontextprotocol/specification/issues)
- [Claude Code Issues](https://github.com/anthropics/claude-code/issues)

---

**Last Updated**: 2025-11-15  
**Maintainer**: @Krosebrook  
**Related**: [AGENTS.md](../../AGENTS.md), [CLAUDE.md](../../CLAUDE.md)
