# Installation Guide

## Quick Installation

### Option 1: Automatic Installation

```bash
cd /home/kyler/claude-custom-setup

# Copy all skills
cp -r skills/* ~/.claude/skills/ 2>/dev/null || mkdir -p ~/.claude/skills && cp -r skills/* ~/.claude/skills/

# Copy all agents
cp -r agents/* ~/.claude/agents/ 2>/dev/null || mkdir -p ~/.claude/agents && cp -r agents/* ~/.claude/agents/

echo "✅ Installation complete! Please restart Claude Code."
```

### Option 2: Manual Installation

1. **Locate your Claude Code configuration directory:**
   - Linux/WSL: `~/.claude/`
   - macOS: `~/.claude/`
   - Windows: `%USERPROFILE%\.claude\`

2. **Create directories if they don't exist:**
   ```bash
   mkdir -p ~/.claude/skills
   mkdir -p ~/.claude/agents
   ```

3. **Copy skills:**
   ```bash
   cp -r /home/kyler/claude-custom-setup/skills/* ~/.claude/skills/
   ```

4. **Copy agents:**
   ```bash
   cp -r /home/kyler/claude-custom-setup/agents/* ~/.claude/agents/
   ```

5. **Restart Claude Code**

## Verification

```bash
# Check skills installed
ls ~/.claude/skills/
# Should show 10 directories

# Check agents installed
ls ~/.claude/agents/
# Should show 8 .md files

# Count skills
find ~/.claude/skills -name "SKILL.md" | wc -l
# Should output: 10

# Count agents
ls ~/.claude/agents/*.md | wc -l
# Should output: 8
```

## Project-Specific Installation

To use skills in a specific project only:

```bash
cd /path/to/your/project

# Create project-specific skills directory
mkdir -p .claude/skills
mkdir -p .claude/agents

# Copy specific skills you need
cp -r /home/kyler/claude-custom-setup/skills/turbo-monorepo-expert .claude/skills/
cp -r /home/kyler/claude-custom-setup/skills/nextjs-fastapi-fullstack .claude/skills/

# Copy specific agents you need
cp /home/kyler/claude-custom-setup/agents/fullstack-developer.md .claude/agents/
```

## Uninstallation

```bash
# Remove all custom skills
rm -rf ~/.claude/skills/turbo-monorepo-expert
rm -rf ~/.claude/skills/mcp-server-generator
rm -rf ~/.claude/skills/pydantic-ai-agent-builder
rm -rf ~/.claude/skills/nextjs-fastapi-fullstack
rm -rf ~/.claude/skills/docker-kubernetes-orchestrator
rm -rf ~/.claude/skills/aws-azure-multicloud
rm -rf ~/.claude/skills/typescript-type-safety
rm -rf ~/.claude/skills/ai-workflow-orchestrator
rm -rf ~/.claude/skills/enterprise-erp-consultant
rm -rf ~/.claude/skills/git-advanced-workflow

# Remove all custom agents
rm ~/.claude/agents/monorepo-architect.md
rm ~/.claude/agents/fullstack-developer.md
rm ~/.claude/agents/ai-orchestrator.md
rm ~/.claude/agents/microservices-engineer.md
rm ~/.claude/agents/cloud-deployer.md
rm ~/.claude/agents/testing-specialist.md
rm ~/.claude/agents/erp-consultant.md
rm ~/.claude/agents/api-designer.md
```

## Troubleshooting

### Skills Not Showing Up

1. **Check file location:**
   ```bash
   ls -la ~/.claude/skills/
   ```

2. **Verify SKILL.md files exist:**
   ```bash
   find ~/.claude/skills -name "SKILL.md"
   ```

3. **Check file permissions:**
   ```bash
   chmod -R 755 ~/.claude/skills
   ```

4. **Restart Claude Code completely**

### Agents Not Being Invoked

1. **Check agent files exist:**
   ```bash
   ls -la ~/.claude/agents/
   ```

2. **Verify YAML frontmatter is valid:**
   ```bash
   head -10 ~/.claude/agents/fullstack-developer.md
   # Should show valid YAML frontmatter
   ```

3. **Check file permissions:**
   ```bash
   chmod 644 ~/.claude/agents/*.md
   ```

4. **Use explicit invocation:**
   ```
   User: "Invoke the fullstack-developer agent to build authentication"
   ```

### Skills Not Loading

If skills aren't automatically loading:

1. **Check YAML syntax:**
   ```bash
   # Ensure frontmatter is valid
   head -15 ~/.claude/skills/turbo-monorepo-expert/SKILL.md
   ```

2. **Verify allowed-tools format:**
   ```yaml
   allowed-tools:
     - Read
     - Write
     - Edit
   ```

3. **Restart Claude Code** - Skills are loaded at startup

## Updates

To update to new versions:

```bash
# Backup current setup
cp -r ~/.claude/skills ~/.claude/skills.backup
cp -r ~/.claude/agents ~/.claude/agents.backup

# Install new versions
cp -r /home/kyler/claude-custom-setup/skills/* ~/.claude/skills/
cp -r /home/kyler/claude-custom-setup/agents/* ~/.claude/agents/

# Restart Claude Code
```

## Configuration

### Disable Specific Skills

To temporarily disable a skill without deleting it:

```bash
# Rename directory
mv ~/.claude/skills/typescript-type-safety ~/.claude/skills/typescript-type-safety.disabled
```

### Disable Specific Agents

```bash
# Rename file
mv ~/.claude/agents/erp-consultant.md ~/.claude/agents/erp-consultant.md.disabled
```

### Re-enable

```bash
# Remove .disabled extension
mv ~/.claude/skills/typescript-type-safety.disabled ~/.claude/skills/typescript-type-safety
mv ~/.claude/agents/erp-consultant.md.disabled ~/.claude/agents/erp-consultant.md
```

---

**Installation complete!** Proceed to USAGE_GUIDE.md for examples.
