# Claude Code Plugin Ecosystem

Complete snapshot of Claude Code plugins ecosystem migrated from `/home/kyler/.claude/plugins/` on 2025-11-15.

## Overview

This directory contains the comprehensive Claude Code plugin collection:
- **20 marketplaces** (122MB) - Plugin repositories from various sources
- **4 installed plugins** (7.3MB) - Currently active plugin installations
- **55 enabled plugins** - Actively configured plugins across all marketplaces
- **197+ total plugins** - Available across all marketplaces

## Directory Structure

```
plugins/
├── marketplaces/          # 20 plugin marketplace repositories (source code, no .git)
│   ├── ando-marketplace/  # kivilaid/plugin-marketplace
│   ├── anthropic-agent-skills/  # anthropics/skills
│   ├── awesome-claude-code-plugins/  # ccplugins/awesome-claude-code-plugins
│   └── ... (17 more marketplaces)
│
├── installed/             # 4 actively installed plugins
│   ├── chrome-devtools-mcp/
│   ├── episodic-memory/
│   ├── superpowers/
│   └── superpowers-developing-for-claude-code/
│
├── config/                # Plugin configuration files
│   ├── config.json        # Plugin system configuration
│   ├── installed_plugins.json  # Active installation manifest
│   ├── known_marketplaces.json  # Marketplace registry
│   └── enabled_plugins.json  # User's 55 enabled plugins
│
└── docs/                  # Documentation
    ├── PLUGIN_INVENTORY.md  # Complete plugin listing
    ├── USAGE.md           # How to use plugins
    └── SYNC_GUIDE.md      # How to update plugins
```

## Marketplace Sources

| Marketplace | GitHub Source | Size |
|------------|---------------|------|
| ando-marketplace | kivilaid/plugin-marketplace | 38M |
| claude-code-templates | davila7/claude-code-templates | 34M |
| claude-code-plugins | anthropics-claude/claude-code | 22M |
| taskmaster | eyaltoledano/claude-task-master | 18M |
| genkit-marketplace | amitpatole/claude-genkit-plugin | 13M |
| anthropic-agent-skills | anthropics/skills | 13M |
| aws-claude-code-plugins | aws-solutions-library-samples/... | 6.4M |
| awesome-claude-code-plugins | ccplugins/awesome-claude-code-plugins | 3.7M |
| chrome-devtools-plugins | ChromeDevTools/chrome-devtools-mcp | 3.2M |
| specswarm-marketplace | MartyBonacci/specswarm | 3.0M |
| ccprompts-marketplace | ursisterbtw/ccprompts | 2.7M |
| cc-blueprint-toolkit | croffasia/cc-blueprint-toolkit | 2.1M |
| ai-coding-config | TechNickAI/ai-coding-config | 1.7M |
| mcp-voice-hooks-marketplace | johnmatthewtennant/mcp-voice-hooks | 856K |
| claude-code-settings | feiskyer/claude-code-settings | 704K |
| sub-agents | Toskysun/sub-agents | 520K |
| fradser-dotclaude | FradSer/dotclaude | 468K |
| claudecode-marketplace | henkisdabro/claudecode-marketplace | 432K |
| docker | docker/claude-plugins | 248K |
| superpowers-marketplace | obra/superpowers-marketplace | 212K |

## Migration Details

**Migrated from**: `/home/kyler/.claude/plugins/`
**Migration date**: 2025-11-15
**Migration method**: Direct copy (excluding .git directories)
**Total size**: ~129MB (122MB marketplaces + 7.3MB installed)

### What's Included
- ✅ All plugin source code (skills, agents, commands, hooks)
- ✅ Plugin configurations and manifests
- ✅ Marketplace metadata
- ✅ Currently installed plugin versions

### What's Excluded
- ❌ Git history (.git directories excluded to save space)
- ❌ Credentials (`.credentials.json` never committed)
- ❌ Cache files
- ❌ Node modules (none existed)

## Quick Start

### Using Plugins from This Repository

1. **Symlink to Claude plugins directory**:
   ```bash
   ln -s /path/to/monorepo/plugins ~/.claude/plugins-backup
   ```

2. **Or copy specific marketplaces**:
   ```bash
   cp -r plugins/marketplaces/superpowers-marketplace ~/.claude/plugins/marketplaces/
   ```

3. **Reference config files**:
   ```bash
   cat plugins/config/enabled_plugins.json  # See which plugins are enabled
   cat plugins/config/installed_plugins.json  # See installation details
   ```

## Updating Plugins

See [docs/SYNC_GUIDE.md](docs/SYNC_GUIDE.md) for detailed instructions on:
- Pulling updates from upstream marketplace repositories
- Adding new marketplaces
- Updating installed plugin versions
- Syncing with your local Claude installation

## Documentation

- **[PLUGIN_INVENTORY.md](docs/PLUGIN_INVENTORY.md)** - Complete list of all 197+ plugins
- **[USAGE.md](docs/USAGE.md)** - How to use and configure plugins
- **[SYNC_GUIDE.md](docs/SYNC_GUIDE.md)** - Keeping plugins up-to-date

## Notes

- This is a **snapshot** of the plugin ecosystem as of 2025-11-15
- Plugins are copied **without git history** to reduce repository size
- Original marketplace git URLs are documented in `config/known_marketplaces.json`
- To get updates, you'll need to manually pull from upstream sources (see SYNC_GUIDE.md)

## Security

**IMPORTANT**: This repository does NOT contain:
- `.credentials.json` (excluded via .gitignore)
- API keys or tokens
- Personal authentication data

Always verify `.gitignore` before committing changes to ensure credentials remain excluded.

---

Generated during workspace consolidation migration on 2025-11-15.
