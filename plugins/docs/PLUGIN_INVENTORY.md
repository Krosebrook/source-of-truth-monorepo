# Claude Code Plugin Inventory

Complete inventory of all plugins in the monorepo plugin ecosystem.

**Total Plugins**: 197+
**Marketplaces**: 20
**Installed**: 4
**Enabled**: 55

Last updated: 2025-11-15

## Currently Installed Plugins (4)

These are the actively installed plugin versions in `plugins/installed/`:

| Plugin | Marketplace | Version | Size |
|--------|-------------|---------|------|
| **superpowers** | superpowers-marketplace | 3.4.1 | 812K |
| **episodic-memory** | superpowers-marketplace | 1.0.9 | 5.4M |
| **chrome-devtools-mcp** | chrome-devtools-plugins | latest | 3.3M |
| **superpowers-developing-for-claude-code** | superpowers-marketplace | 0.2.0 | 1.2M |

## Enabled Plugins (55)

Extracted from `plugins/config/enabled_plugins.json`. These plugins are configured to load in Claude Code:

### Superpowers Marketplace
- `superpowers:executing-plans`
- `superpowers:brainstorming`
- `superpowers:sharing-skills`
- `superpowers:condition-based-waiting`
- `superpowers:using-superpowers`
- `superpowers:dispatching-parallel-agents`
- `superpowers:finishing-a-development-branch`
- `superpowers:test-driven-development`
- `superpowers:testing-skills-with-subagents`
- `superpowers:using-git-worktrees`
- `superpowers:requesting-code-review`
- `superpowers:writing-plans`
- `superpowers:defense-in-depth`
- `superpowers:subagent-driven-development`
- `superpowers:receiving-code-review`
- `superpowers:verification-before-completion`
- `superpowers:writing-skills`
- `superpowers:root-cause-tracing`
- `superpowers:systematic-debugging`
- `superpowers:testing-anti-patterns`
- `superpowers-developing-for-claude-code:working-with-claude-code`
- `superpowers-developing-for-claude-code:developing-claude-code-plugins`

### Example Skills (Anthropic)
- `example-skills:skill-creator`
- `example-skills:mcp-builder`
- `example-skills:canvas-design`
- `example-skills:algorithmic-art`
- `example-skills:internal-comms`
- `example-skills:webapp-testing`
- `example-skills:artifacts-builder`
- `example-skills:slack-gif-creator`
- `example-skills:theme-factory`
- `example-skills:brand-guidelines`

### Episodic Memory
- `episodic-memory:remembering-conversations`

### Shell Scripting (Ando Marketplace)
- `shell-scripting:bash-defensive-patterns`
- `shell-scripting:bats-testing-patterns`
- `shell-scripting:shellcheck-configuration`

## Marketplace Plugin Distribution

Breakdown of plugins by marketplace:

### 1. awesome-claude-code-plugins (236 plugins)
Largest collection of community-contributed plugins covering diverse use cases.

**Categories**:
- Development tools
- AI assistants
- Integration plugins
- Workflow automation
- Documentation generators

### 2. ando-marketplace (155 plugins)
Comprehensive collection from kivilaid including advanced development workflows.

**Notable plugins**:
- Shell scripting tools
- DevOps automation
- Testing frameworks
- CI/CD integrations

### 3. genkit-marketplace (75 plugins)
Google Firebase Genkit integrations for Claude Code.

**Focus areas**:
- AI workflows
- Content generation
- Firebase integrations
- Vector databases

### 4. aws-claude-code-plugins (45 plugins)
Official AWS solutions library plugins for Claude Code.

**Services**:
- Amazon Bedrock
- AWS Lambda
- S3 integrations
- CloudFormation

### 5. ai-coding-config (32 plugins)
TechNickAI's coding configuration and best practices.

**Includes**:
- Code quality tools
- Linting configs
- Formatting standards
- Project templates

### 6. claude-code-templates (22 plugins)
Project templates and boilerplates.

### 7. claude-code-plugins (16 plugins)
Official Anthropic Claude Code plugins.

### 8. taskmaster (13 plugins)
Task management and workflow orchestration by eyaltoledano.

### 9. Other Marketplaces (38 plugins combined)
- fradser-dotclaude (8)
- mcp-voice-hooks-marketplace (7)
- ccprompts-marketplace (6)
- specswarm-marketplace (6)
- cc-blueprint-toolkit (4)
- claude-code-settings (4)
- claudecode-marketplace (4)
- docker (4)
- sub-agents (4)
- anthropic-agent-skills (2)
- chrome-devtools-plugins (2)
- superpowers-marketplace (2)

## Plugin Types

Plugins are organized into several categories:

### Skills
Reusable capabilities that extend Claude Code functionality:
- Development workflows (TDD, code review, git)
- Content creation (documentation, diagrams, art)
- Integration (MCP servers, APIs)
- Specialized domains (AWS, Firebase, Docker)

### Agents
Autonomous agents for specific tasks:
- AI orchestration
- Code architecture
- DevOps automation
- Testing specialists

### Commands
Custom slash commands for quick actions:
- Project scaffolding
- Code generation
- Documentation updates
- Build/deploy automation

### Hooks
Event handlers that run on specific triggers:
- Pre-commit checks
- Post-edit validation
- CI/CD integration
- Voice command hooks

### MCP Servers
Model Context Protocol servers for external integrations:
- Chrome DevTools
- AlphaVantage (financial data)
- Firecrawl (web scraping)
- Playwright (browser automation)
- N8N (workflow automation)

## Finding Specific Plugins

To find plugins in this repository:

### By Name
```bash
find plugins/marketplaces -name "*keyword*" -type d
```

### By Type
```bash
# Find all skills
find plugins/marketplaces -path "*/skills/*" -name "plugin.json"

# Find all agents
find plugins/marketplaces -path "*/agents/*" -name "plugin.json"

# Find all MCP servers
find plugins/marketplaces -name "*mcp*" -type d
```

### By Marketplace
```bash
# List all plugins in a specific marketplace
ls -R plugins/marketplaces/superpowers-marketplace/
```

### View Plugin Metadata
```bash
# View plugin details
cat plugins/marketplaces/superpowers-marketplace/skills/test-driven-development/plugin.json
```

## Updating the Inventory

To regenerate this inventory after adding new plugins:

```bash
# Count total plugins
find plugins/marketplaces -name "plugin.json" | wc -l

# List all plugin.json files
find plugins/marketplaces -name "plugin.json" -exec dirname {} \;

# Get sizes
du -sh plugins/marketplaces/*/
```

## Notes

- Plugin counts may include duplicates across marketplaces
- Some plugins may be in development/experimental status
- Not all listed plugins are compatible with current Claude Code version
- Refer to individual plugin READMEs for usage instructions

---

For usage instructions, see [USAGE.md](USAGE.md)
For sync/update procedures, see [SYNC_GUIDE.md](SYNC_GUIDE.md)
