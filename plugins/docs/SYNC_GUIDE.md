# Plugin Sync and Update Guide

Guide for keeping the monorepo plugin ecosystem synchronized with upstream sources.

## Overview

This monorepo contains a **snapshot** of the Claude Code plugin ecosystem as of 2025-11-15. The plugins were copied **without git history** (.git directories excluded) to reduce repository size. This guide explains how to update plugins from upstream sources.

## Update Strategies

### Strategy 1: Manual Update (Recommended)

Since plugins were copied without .git directories, updates require manual steps:

1. **Clone upstream marketplace temporarily**:
   ```bash
   cd /tmp
   git clone https://github.com/obra/superpowers-marketplace.git
   ```

2. **Copy updated files to monorepo**:
   ```bash
   rsync -av --delete --exclude='.git' \
     /tmp/superpowers-marketplace/ \
     /path/to/monorepo/plugins/marketplaces/superpowers-marketplace/
   ```

3. **Verify and commit changes**:
   ```bash
   cd /path/to/monorepo
   git status
   git add plugins/marketplaces/superpowers-marketplace
   git commit -m "Update superpowers-marketplace to latest version"
   ```

4. **Clean up temporary clone**:
   ```bash
   rm -rf /tmp/superpowers-marketplace
   ```

### Strategy 2: Automated Update Script

Create a script to automate marketplace updates:

```bash
#!/bin/bash
# update-marketplace.sh

MARKETPLACE_NAME=$1
MONOREPO_PATH="/path/to/monorepo"
TMP_DIR="/tmp/marketplace-update-$$"

# Get marketplace URL from known_marketplaces.json
REPO_URL=$(jq -r ".repositories[] | select(.marketplace == \"$MARKETPLACE_NAME\") | .url" \
  "$MONOREPO_PATH/plugins/config/known_marketplaces.json")

if [ -z "$REPO_URL" ]; then
  echo "Error: Marketplace '$MARKETPLACE_NAME' not found in known_marketplaces.json"
  exit 1
fi

# Clone to temp directory
echo "Cloning $REPO_URL to $TMP_DIR..."
git clone "$REPO_URL" "$TMP_DIR"

# Get latest commit SHA
cd "$TMP_DIR"
COMMIT_SHA=$(git rev-parse HEAD)
COMMIT_DATE=$(git log -1 --format=%ci)

# Sync to monorepo (excluding .git)
echo "Syncing to monorepo..."
rsync -av --delete --exclude='.git' \
  "$TMP_DIR/" \
  "$MONOREPO_PATH/plugins/marketplaces/$MARKETPLACE_NAME/"

# Update metadata
cd "$MONOREPO_PATH"
echo "Updated $MARKETPLACE_NAME to commit $COMMIT_SHA ($COMMIT_DATE)"

# Clean up
rm -rf "$TMP_DIR"

echo "Update complete. Review changes with 'git status' and commit if satisfied."
```

Usage:
```bash
chmod +x update-marketplace.sh
./update-marketplace.sh superpowers-marketplace
```

### Strategy 3: Convert to Git Submodules (Advanced)

If you prefer automatic updates via git submodules:

```bash
# Remove copied directory
rm -rf plugins/marketplaces/superpowers-marketplace

# Add as submodule
git submodule add https://github.com/obra/superpowers-marketplace.git \
  plugins/marketplaces/superpowers-marketplace

# Future updates
git submodule update --remote plugins/marketplaces/superpowers-marketplace
```

**Trade-offs**:
- ✅ Automatic updates via `git submodule update --remote`
- ✅ Full git history available
- ❌ Repository size increases (~37MB for all marketplaces)
- ❌ More complex for contributors (submodule initialization)

## Updating Specific Marketplaces

### Update Single Marketplace

```bash
# 1. Check current version info in known_marketplaces.json
cat plugins/config/known_marketplaces.json | jq '.repositories[] | select(.marketplace == "superpowers-marketplace")'

# 2. Clone latest version
git clone https://github.com/obra/superpowers-marketplace.git /tmp/superpowers-update

# 3. Copy to monorepo
rsync -av --delete --exclude='.git' \
  /tmp/superpowers-update/ \
  plugins/marketplaces/superpowers-marketplace/

# 4. Record new commit SHA
cd /tmp/superpowers-update
git rev-parse HEAD > /tmp/new-commit-sha.txt

# 5. Commit update
cd /path/to/monorepo
git add plugins/marketplaces/superpowers-marketplace
git commit -m "Update superpowers-marketplace to $(cat /tmp/new-commit-sha.txt)"

# 6. Clean up
rm -rf /tmp/superpowers-update /tmp/new-commit-sha.txt
```

### Update All Marketplaces

```bash
#!/bin/bash
# update-all-marketplaces.sh

MONOREPO_PATH="/path/to/monorepo"
MARKETPLACES_JSON="$MONOREPO_PATH/plugins/config/known_marketplaces.json"

# Read each marketplace
jq -c '.repositories[]' "$MARKETPLACES_JSON" | while read -r marketplace; do
  NAME=$(echo "$marketplace" | jq -r '.marketplace')
  URL=$(echo "$marketplace" | jq -r '.url')

  echo "Updating $NAME..."

  # Clone
  TMP_DIR="/tmp/marketplace-update-$NAME-$$"
  git clone "$URL" "$TMP_DIR"

  # Sync
  rsync -av --delete --exclude='.git' \
    "$TMP_DIR/" \
    "$MONOREPO_PATH/plugins/marketplaces/$NAME/"

  # Record commit
  cd "$TMP_DIR"
  COMMIT=$(git rev-parse HEAD)
  echo "  → Updated to $COMMIT"

  # Clean up
  rm -rf "$TMP_DIR"
done

echo "All marketplaces updated. Review with 'git status' and commit."
```

## Updating Installed Plugins

Installed plugins are snapshots of specific versions. To update:

### Method 1: Reinstall via Claude Code

```bash
# 1. In Claude Code, reinstall plugin
/plugin install superpowers@superpowers-marketplace

# 2. Copy updated version from ~/.claude/plugins/cache/ to monorepo
cp -r ~/.claude/plugins/cache/superpowers \
      /path/to/monorepo/plugins/installed/

# 3. Update installed_plugins.json with new version/commit
code plugins/config/installed_plugins.json
```

### Method 2: Manual Update

```bash
# 1. Find plugin source in marketplace
ls -la plugins/marketplaces/superpowers-marketplace/

# 2. Copy to installed/
cp -r plugins/marketplaces/superpowers-marketplace/skills/some-skill \
      plugins/installed/superpowers/skills/

# 3. Update version in installed_plugins.json
```

## Syncing with Local Claude Installation

### Push from Monorepo to Local Claude

```bash
# Copy marketplaces
rsync -av --delete \
  /path/to/monorepo/plugins/marketplaces/ \
  ~/.claude/plugins/marketplaces/

# Copy installed plugins
rsync -av --delete \
  /path/to/monorepo/plugins/installed/ \
  ~/.claude/plugins/cache/

# Copy configuration
cp /path/to/monorepo/plugins/config/installed_plugins.json \
   ~/.claude/plugins/

cp /path/to/monorepo/plugins/config/known_marketplaces.json \
   ~/.claude/plugins/

# Manually merge enabled plugins into ~/.claude/settings.json
# (See USAGE.md for details)
```

### Pull from Local Claude to Monorepo

```bash
# Copy marketplaces
rsync -av --delete --exclude='.git' \
  ~/.claude/plugins/marketplaces/ \
  /path/to/monorepo/plugins/marketplaces/

# Copy installed plugins
rsync -av --delete \
  ~/.claude/plugins/cache/ \
  /path/to/monorepo/plugins/installed/

# Copy configuration
cp ~/.claude/plugins/installed_plugins.json \
   /path/to/monorepo/plugins/config/

cp ~/.claude/plugins/known_marketplaces.json \
   /path/to/monorepo/plugins/config/

# Extract enabled plugins from settings.json
jq '.enabledPlugins' ~/.claude/settings.json > \
  /path/to/monorepo/plugins/config/enabled_plugins.json

# Commit changes
cd /path/to/monorepo
git add plugins/
git commit -m "Sync plugins from local Claude installation"
```

## Adding New Marketplaces

### Manual Addition

```bash
# 1. Clone new marketplace
git clone https://github.com/username/new-marketplace.git /tmp/new-marketplace

# 2. Copy to monorepo (without .git)
rsync -av --exclude='.git' \
  /tmp/new-marketplace/ \
  /path/to/monorepo/plugins/marketplaces/new-marketplace/

# 3. Update known_marketplaces.json
code plugins/config/known_marketplaces.json
```

Add entry:
```json
{
  "marketplace": "new-marketplace",
  "url": "https://github.com/username/new-marketplace.git",
  "lastSynced": "2025-11-15T00:00:00Z"
}
```

```bash
# 4. Update documentation
echo "- new-marketplace (username/new-marketplace)" >> plugins/README.md

# 5. Commit
git add plugins/
git commit -m "Add new-marketplace plugin repository"

# 6. Clean up
rm -rf /tmp/new-marketplace
```

### Automated Addition

```bash
#!/bin/bash
# add-marketplace.sh

MARKETPLACE_NAME=$1
REPO_URL=$2
MONOREPO_PATH="/path/to/monorepo"

# Clone
TMP_DIR="/tmp/marketplace-add-$$"
git clone "$REPO_URL" "$TMP_DIR"

# Copy to monorepo
rsync -av --exclude='.git' \
  "$TMP_DIR/" \
  "$MONOREPO_PATH/plugins/marketplaces/$MARKETPLACE_NAME/"

# Update known_marketplaces.json
cd "$MONOREPO_PATH"
jq ".repositories += [{
  \"marketplace\": \"$MARKETPLACE_NAME\",
  \"url\": \"$REPO_URL\",
  \"lastSynced\": \"$(date -u +%Y-%m-%dT%H:%M:%SZ)\"
}]" plugins/config/known_marketplaces.json > /tmp/known_marketplaces_new.json

mv /tmp/known_marketplaces_new.json plugins/config/known_marketplaces.json

# Clean up
rm -rf "$TMP_DIR"

echo "Added $MARKETPLACE_NAME. Review and commit changes."
```

Usage:
```bash
./add-marketplace.sh new-marketplace https://github.com/username/new-marketplace.git
```

## Tracking Plugin Versions

### Recording Commit SHAs

When updating plugins, record the upstream commit SHA for version tracking:

```bash
# In the temporary clone
cd /tmp/marketplace-update
git rev-parse HEAD > /tmp/commit-sha.txt
git log -1 --format=%ci > /tmp/commit-date.txt

# In commit message
git commit -m "Update superpowers-marketplace to $(cat /tmp/commit-sha.txt)

Updated on: $(cat /tmp/commit-date.txt)
Source: https://github.com/obra/superpowers-marketplace.git"
```

### Version Manifest

Create a version manifest to track all plugin versions:

```bash
# generate-version-manifest.sh
#!/bin/bash

MONOREPO_PATH="/path/to/monorepo"
OUTPUT="$MONOREPO_PATH/plugins/config/version_manifest.json"

echo "{" > "$OUTPUT"
echo "  \"generated\": \"$(date -u +%Y-%m-%dT%H:%M:%SZ)\"," >> "$OUTPUT"
echo "  \"marketplaces\": {" >> "$OUTPUT"

# For each marketplace, try to determine version/commit
# (This would require additional metadata tracking)

echo "  }" >> "$OUTPUT"
echo "}" >> "$OUTPUT"
```

## Automation Best Practices

### Scheduled Updates

Use cron to check for updates weekly:

```bash
# Add to crontab
0 2 * * 0 /path/to/update-all-marketplaces.sh && \
  cd /path/to/monorepo && \
  git add plugins/ && \
  git commit -m "Weekly plugin update $(date +%Y-%m-%d)" && \
  git push
```

### Pre-commit Verification

Verify plugin integrity before committing:

```bash
#!/bin/bash
# verify-plugins.sh

# Check all plugin.json files are valid
find plugins/marketplaces -name "plugin.json" | while read -r file; do
  if ! jq empty "$file" 2>/dev/null; then
    echo "Invalid JSON: $file"
    exit 1
  fi
done

# Check configuration files
for config in plugins/config/*.json; do
  if ! jq empty "$config" 2>/dev/null; then
    echo "Invalid JSON: $config"
    exit 1
  fi
done

echo "All plugin files validated successfully"
```

## Troubleshooting

### Marketplace URL Changed

If a marketplace moved repositories:

```bash
# 1. Update known_marketplaces.json with new URL
jq '.repositories |= map(
  if .marketplace == "old-marketplace"
  then .url = "https://github.com/new-owner/new-repo.git"
  else . end
)' plugins/config/known_marketplaces.json > /tmp/updated.json

mv /tmp/updated.json plugins/config/known_marketplaces.json

# 2. Re-clone from new URL
rm -rf plugins/marketplaces/old-marketplace
./update-marketplace.sh old-marketplace
```

### Plugin Conflicts After Update

If updates cause conflicts:

```bash
# 1. Stash local changes
git stash

# 2. Review differences
git diff stash@{0} plugins/

# 3. Apply selectively
git stash pop
# Resolve conflicts manually
```

### Large Update Size

If updates are too large:

```bash
# Update only specific plugins instead of entire marketplace
rsync -av --delete \
  /tmp/marketplace-update/skills/specific-skill/ \
  plugins/marketplaces/marketplace/skills/specific-skill/
```

## Version Control Best Practices

1. **Branch per update**: Create feature branch for each major plugin update
   ```bash
   git checkout -b update/plugins-2025-11-20
   ```

2. **Detailed commit messages**: Include marketplace, commit SHA, and changes
   ```bash
   git commit -m "Update superpowers-marketplace to abc1234

   - Added new skill: test-driven-development
   - Updated existing: systematic-debugging
   - Fixed: Issue with git-worktrees skill

   Source commit: abc1234567890
   Date: 2025-11-20"
   ```

3. **Tag stable snapshots**: Tag known-good plugin configurations
   ```bash
   git tag -a plugins-stable-2025-11-20 -m "Stable plugin snapshot"
   git push --tags
   ```

4. **Review before merging**: Always review plugin updates before merging to main
   ```bash
   # Create PR for review
   gh pr create --title "Update plugins - 2025-11-20" \
                --body "Updates multiple marketplaces to latest versions"
   ```

## Monitoring for Updates

### GitHub Watch

Set up GitHub notifications for marketplace repositories:
1. Visit each marketplace repository on GitHub
2. Click "Watch" → "Custom" → "Releases"
3. Get notified when new versions are released

### RSS Feeds

Subscribe to marketplace commit feeds:
```
https://github.com/obra/superpowers-marketplace/commits/main.atom
```

### Automated Checks

Script to check if marketplaces have updates:

```bash
#!/bin/bash
# check-for-updates.sh

jq -c '.repositories[]' plugins/config/known_marketplaces.json | while read -r repo; do
  NAME=$(echo "$repo" | jq -r '.marketplace')
  URL=$(echo "$repo" | jq -r '.url')

  # Clone and check latest commit
  TMP="/tmp/check-$NAME-$$"
  git clone --depth 1 "$URL" "$TMP" &>/dev/null

  LATEST=$(cd "$TMP" && git rev-parse HEAD)

  # Compare with recorded version (if you maintain one)
  echo "$NAME: $LATEST"

  rm -rf "$TMP"
done
```

## Team Collaboration

### Shared Plugin Configuration

To share plugin configuration across team:

```bash
# Team member clones monorepo
git clone https://github.com/your-org/source-of-truth-monorepo.git

# Install plugins to local Claude
rsync -av monorepo/plugins/marketplaces/ ~/.claude/plugins/marketplaces/
rsync -av monorepo/plugins/installed/ ~/.claude/plugins/cache/

# Merge enabled plugins
# Manually edit ~/.claude/settings.json based on
# monorepo/plugins/config/enabled_plugins.json
```

### Contributing Updates

```bash
# 1. Update local plugins
/plugin update superpowers@superpowers-marketplace

# 2. Sync to monorepo fork
rsync -av ~/.claude/plugins/cache/superpowers \
      ~/monorepo-fork/plugins/installed/

# 3. Create PR
git checkout -b update/superpowers-3.5.0
git add plugins/installed/superpowers
git commit -m "Update superpowers plugin to v3.5.0"
gh pr create
```

## Further Reading

- [PLUGIN_INVENTORY.md](PLUGIN_INVENTORY.md) - Complete plugin listing
- [USAGE.md](USAGE.md) - How to use plugins from monorepo
- [Official Claude Code Plugin Documentation](https://docs.claude.com)

---

Generated for source-of-truth-monorepo on 2025-11-15
