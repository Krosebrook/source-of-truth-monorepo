# Plugin Usage Guide

Guide to using Claude Code plugins from this monorepo.

## Overview

This monorepo contains a complete snapshot of the Claude Code plugin ecosystem. You can use these plugins in several ways:

1. **Reference**: Browse plugin code and configurations
2. **Restore**: Copy plugins back to your local Claude installation
3. **Share**: Team members can use the same plugin configuration
4. **Backup**: Preserve plugin versions and configurations

## Plugin Directory Structure

```
plugins/
├── marketplaces/     # Source repositories (197+ plugins)
├── installed/        # Active installations (4 plugins)
└── config/          # Configuration files
```

## Using Plugins from This Repository

### Method 1: Symlink Entire Plugin Directory (Recommended for local development)

```bash
# Backup your current plugins
mv ~/.claude/plugins ~/.claude/plugins.backup

# Symlink to monorepo plugins
ln -s /absolute/path/to/monorepo/plugins ~/.claude/plugins-from-monorepo

# Or copy instead of symlink
cp -r /path/to/monorepo/plugins ~/.claude/plugins
```

### Method 2: Copy Specific Marketplaces

```bash
# Copy a single marketplace
cp -r plugins/marketplaces/superpowers-marketplace \
      ~/.claude/plugins/marketplaces/

# Copy multiple marketplaces
for marketplace in superpowers-marketplace anthropic-agent-skills genkit-marketplace; do
  cp -r plugins/marketplaces/$marketplace \
        ~/.claude/plugins/marketplaces/
done
```

### Method 3: Copy Installed Plugins Only

```bash
# Copy currently installed versions
cp -r plugins/installed/* \
      ~/.claude/plugins/cache/
```

### Method 4: Restore Configuration

```bash
# Copy plugin configurations
cp plugins/config/installed_plugins.json \
   ~/.claude/plugins/

cp plugins/config/known_marketplaces.json \
   ~/.claude/plugins/

# Merge enabled plugins into settings.json
# (requires manual edit of ~/.claude/settings.json)
```

## Enabling Plugins

### View Currently Enabled Plugins

```bash
cat plugins/config/enabled_plugins.json
```

This file contains 55 enabled plugins extracted from the original `settings.json`.

### Enable Plugins in Your Local Installation

1. **Edit Claude Code settings**:
   ```bash
   code ~/.claude/settings.json
   ```

2. **Add to enabledPlugins section**:
   ```json
   {
     "enabledPlugins": {
       "superpowers:executing-plans": true,
       "superpowers:test-driven-development": true,
       "example-skills:mcp-builder": true
     }
   }
   ```

3. **Restart Claude Code** to load the new plugins

### Plugin Format

Plugins use the format: `marketplace:plugin-name`

Examples:
- `superpowers:executing-plans` - from superpowers-marketplace
- `example-skills:mcp-builder` - from anthropic-agent-skills
- `shell-scripting:bash-defensive-patterns` - from ando-marketplace

## Browsing Available Plugins

### By Marketplace

```bash
# List all marketplaces
ls plugins/marketplaces/

# Browse a specific marketplace
ls -R plugins/marketplaces/superpowers-marketplace/
```

### By Type

```bash
# Find all skills
find plugins/marketplaces -path "*/skills/*" -name "SKILL.md"

# Find all agents
find plugins/marketplaces -path "*/agents/*" -name "*.md"

# Find MCP server plugins
find plugins/marketplaces -name "*mcp*"
```

### Reading Plugin Documentation

Most plugins include documentation:

```bash
# Read skill documentation
cat plugins/marketplaces/superpowers-marketplace/skills/test-driven-development/SKILL.md

# Read plugin metadata
cat plugins/marketplaces/superpowers-marketplace/skills/test-driven-development/plugin.json
```

## Plugin Installation Manifest

The `installed_plugins.json` tracks actively installed plugins:

```json
{
  "schemaVersion": 1,
  "plugins": {
    "superpowers@superpowers-marketplace": {
      "version": "3.4.1",
      "installPath": "/home/kyler/.claude/plugins/cache/superpowers",
      "commit": "02c87670de64b236ffd3239305dd71190983679d"
    }
  }
}
```

This shows:
- Plugin name and marketplace
- Installed version
- Installation location
- Git commit SHA (for version tracking)

## Common Use Cases

### Use Case 1: Developer Onboarding

New team member needs the same plugin configuration:

```bash
# Clone monorepo
git clone <monorepo-url>

# Copy plugins to local Claude installation
cp -r plugins/marketplaces/* ~/.claude/plugins/marketplaces/
cp -r plugins/installed/* ~/.claude/plugins/cache/

# Copy configuration
cp plugins/config/installed_plugins.json ~/.claude/plugins/

# Manually merge enabled plugins into ~/.claude/settings.json
```

### Use Case 2: Plugin Exploration

Browse available plugins before installing:

```bash
# List all available plugins
find plugins/marketplaces -name "plugin.json" -exec dirname {} \;

# Read plugin documentation
cat plugins/marketplaces/superpowers-marketplace/skills/*/SKILL.md

# View plugin inventory
cat plugins/docs/PLUGIN_INVENTORY.md
```

### Use Case 3: Backup and Restore

Backup current configuration:

```bash
# Already backed up in this monorepo!
# See plugins/config/ for all configuration files
```

Restore to a previous state:

```bash
# Copy saved configuration back
cp plugins/config/* ~/.claude/plugins/
```

### Use Case 4: Selective Plugin Installation

Install only specific plugins you need:

```bash
# Install just the superpowers marketplace
cp -r plugins/marketplaces/superpowers-marketplace \
      ~/.claude/plugins/marketplaces/

# Enable specific skills in settings.json
# Add to enabledPlugins:
# "superpowers:test-driven-development": true
```

## Verifying Plugin Installation

After copying plugins:

1. **Check plugin directory**:
   ```bash
   ls ~/.claude/plugins/marketplaces/
   ```

2. **Verify plugin cache**:
   ```bash
   ls ~/.claude/plugins/cache/
   ```

3. **Check configuration**:
   ```bash
   cat ~/.claude/plugins/installed_plugins.json
   ```

4. **Restart Claude Code** and verify plugins load

5. **Test a plugin**:
   - Use a skill command (e.g., `/skill test-driven-development`)
   - Check that agents appear in agent selection
   - Verify MCP servers are accessible

## Troubleshooting

### Plugin Not Loading

1. **Check enabled in settings**:
   ```bash
   grep -A 10 '"enabledPlugins"' ~/.claude/settings.json
   ```

2. **Verify plugin exists**:
   ```bash
   find ~/.claude/plugins/marketplaces -name "plugin.json" | grep <plugin-name>
   ```

3. **Check plugin.json format**:
   ```bash
   cat <path-to-plugin>/plugin.json
   ```

4. **Restart Claude Code**

### Marketplace Not Recognized

1. **Check marketplace registry**:
   ```bash
   cat ~/.claude/plugins/known_marketplaces.json
   ```

2. **Add marketplace if missing**:
   Edit `~/.claude/plugins/known_marketplaces.json` to include the marketplace

### Plugin Conflicts

If plugins conflict:

1. Disable conflicting plugins in `settings.json`
2. Check for duplicate plugin names across marketplaces
3. Prefer official/maintained versions

## Best Practices

1. **Version Control**: Keep track of which plugin versions you're using via `installed_plugins.json`
2. **Selective Installation**: Only install marketplaces/plugins you actually use
3. **Regular Backups**: Periodically backup your `~/.claude/` directory
4. **Documentation**: Document which plugins your team uses in project README
5. **Updates**: Check SYNC_GUIDE.md for updating plugins from upstream sources

## Plugin Development

To develop custom plugins:

1. **Create plugin directory**:
   ```bash
   mkdir -p ~/.claude/plugins/marketplaces/custom/skills/my-skill
   ```

2. **Add plugin.json**:
   ```json
   {
     "name": "my-skill",
     "version": "1.0.0",
     "description": "My custom skill"
   }
   ```

3. **Add SKILL.md** with skill instructions

4. **Enable in settings.json**:
   ```json
   "enabledPlugins": {
     "custom:my-skill": true
   }
   ```

5. **Test** by restarting Claude Code

## Further Reading

- [PLUGIN_INVENTORY.md](PLUGIN_INVENTORY.md) - Complete plugin listing
- [SYNC_GUIDE.md](SYNC_GUIDE.md) - Updating and syncing plugins
- [Official Claude Code Plugin Documentation](https://docs.claude.com)

---

Generated for source-of-truth-monorepo on 2025-11-15
