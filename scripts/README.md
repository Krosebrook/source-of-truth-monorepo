# Scripts Directory

Automation scripts for the FlashFusion Source-of-Truth monorepo.

## Available Scripts

### `generate-repo-map.js`

Generates the comprehensive REPO_MAP.md file at the repository root.

**Usage:**

```bash
# Using npm script (recommended)
pnpm run generate:repo-map

# Direct execution
node scripts/generate-repo-map.js
```

**Features:**

- Parses `import-github-repos.sh` to extract all target repositories
- Scans `projects/` directory to detect imported repositories
- Generates sync status (✅ Imported / ⏳ Pending)
- Includes metadata: path, GitHub URL, maintainer, last sync date
- Organizes repos by organization and category
- Links to `.progress.yaml` for task tracking

**Output:**

- Creates/updates `REPO_MAP.md` in repository root
- Includes summary statistics and progress percentage
- Auto-timestamped for tracking updates

### `import-github-repos.sh`

Batch imports GitHub repositories into the monorepo structure.

**Usage:**

```bash
./scripts/import-github-repos.sh
```

**Features:**

- Clones repositories from defined list
- Flattens repositories (removes .git directories)
- Organizes by owner: Krosebrook, FlashFusionv1, ChaosClubCo
- Auto-updates REPO_MAP.md after successful imports
- Tracks success, skipped, and failed imports

**Repository List:**
The script contains an embedded list of 50 target repositories organized by:

- **Krosebrook/Core** (5 repos): FlashFusion, websites, dashboards
- **Krosebrook/Apps** (21 repos): Applications and tools
- **Krosebrook/Tools** (8 repos): Development tools and SDKs
- **FlashFusionv1** (8 repos): FlashFusion v1 projects
- **ChaosClubCo** (8 repos): ChaosClubCo projects

**Adding New Repositories:**

1. Edit the import list in `import-github-repos.sh`
2. Add line: `org|name|url|target_dir`
3. Run the import script
4. REPO_MAP.md will auto-update

## Workflows

### Initial Repository Import

```bash
# 1. Run import script
./scripts/import-github-repos.sh

# 2. Review imported repositories
ls -la projects/

# 3. Review REPO_MAP.md
cat REPO_MAP.md

# 4. Commit changes
git add projects/ REPO_MAP.md
git commit -m "feat: Import GitHub repos"
git push

# 5. Install dependencies
pnpm install
```

### Adding More Repositories

```bash
# 1. Edit import-github-repos.sh to add new repos

# 2. Run import script
./scripts/import-github-repos.sh

# 3. REPO_MAP.md updates automatically
# Review and commit
git add projects/ REPO_MAP.md
git commit -m "feat: Import additional repos"
```

### Updating REPO_MAP.md Manually

```bash
# If you need to regenerate the map without importing
pnpm run generate:repo-map

# Review
cat REPO_MAP.md

# Commit if needed
git add REPO_MAP.md
git commit -m "docs: Update REPO_MAP.md"
```

## Automation

### Auto-Update on Import

The `import-github-repos.sh` script automatically runs `generate-repo-map.js` after successful imports. This ensures REPO_MAP.md is always up-to-date.

### Manual Trigger

You can also trigger regeneration manually:

- After manually copying repositories to `projects/`
- After updating the import script's repository list
- To refresh timestamps and statistics

## File Structure

```
scripts/
├── generate-repo-map.js     # REPO_MAP.md generator
├── import-github-repos.sh   # Batch repository importer
└── README.md                # This file
```

## Maintenance

### Updating the Generator

The generator script is modular with these key functions:

- `parseImportScript()` - Extracts repo definitions from import script
- `getRepoMetadata()` - Checks if repo is imported and gathers metadata
- `groupReposByOrg()` - Organizes repos by organization
- `categorizeKrosebrookRepos()` - Separates Krosebrook repos into Core/Apps/Tools
- `getLocalRepos()` - Finds local-only repositories
- `generateRepoMap()` - Main function that builds the markdown

To modify output format, edit the template strings in `generateRepoMap()`.

### Troubleshooting

**Issue**: Script doesn't detect imported repos

- **Solution**: Check that repos are in correct `projects/` subdirectories
- Verify paths match those in import script

**Issue**: REPO_MAP.md shows 0% progress

- **Solution**: Run `./scripts/import-github-repos.sh` to import repos
- Or manually copy repos to `projects/` and regenerate map

**Issue**: Auto-update doesn't run after import

- **Solution**: Ensure Node.js is installed: `node --version`
- Or run manually: `pnpm run generate:repo-map`

## Related Documentation

- [REPO_MAP.md](../REPO_MAP.md) - Generated repository map
- [.progress.yaml](../docs/.progress.yaml) - Task tracking
- [README.md](../README.md) - Main repository documentation
