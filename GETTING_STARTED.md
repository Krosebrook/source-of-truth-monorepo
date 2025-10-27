# Getting Started with FlashFusion SoT

Complete guide to using and extending the Source-of-Truth monorepo.

## Current Status

### ✅ Completed (Phase 1)

- [x] GitHub repo created: `Krosebrook/source-of-truth-monorepo`
- [x] Complete monorepo structure initialized
- [x] pnpm workspace configured (53 projects)
- [x] Turbo build system configured
- [x] CI/CD workflows (CI, Security, Subtree Push)
- [x] Unified configs (TypeScript, ESLint, Prettier)
- [x] Agent contracts and JSON schemas
- [x] Structured logging utilities
- [x] Security configs (Renovate, gitleaks, CODEOWNERS)
- [x] 3 local repositories imported (1.05GB)
  - flashfusion-consolidated (570MB)
  - harvestflow (217MB)
  - int-smart-triage-ai-2.0 (266MB)

### 🔄 Next Steps (Phase 2)

- [ ] Import 50 GitHub repositories (~800MB)
- [ ] Run `pnpm install` across workspace
- [ ] Test builds
- [ ] Generate final REPO_MAP

## Quick Commands

### Import Remaining GitHub Repos

```bash
cd /home/kyler/source-of-truth-monorepo

# Run the automated import script (imports 50 repos)
./scripts/import-github-repos.sh

# This will take 10-20 minutes depending on network speed
# Progress is shown with ✓ (success), ⊙ (skipped), ✗ (failed)
```

### After Import

```bash
# Review what was imported
ls -la projects/krosebrook/
ls -la projects/flashfusionv1/
ls -la projects/chaosclubco/

# Commit imported repos
git add projects/
git commit -m "feat: Import 50 GitHub repositories

Imported from:
- Krosebrook (34 repos)
- flashfusionv1 (8 repos)
- ChaosClubCo (8 repos)

All repos flattened (no git history preserved).

Generated with Claude Code (https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>"

git push
```

### Install Dependencies

```bash
# Install all workspace dependencies (may take 15-30 min)
pnpm install

# This creates a single pnpm-lock.yaml at the root
# and installs deps for all 53 projects
```

### Build All Projects

```bash
# Build everything (first time will take longer)
pnpm build

# Build only changed projects (after first build)
pnpm build --filter=...[HEAD^]

# Build specific project
pnpm --filter @flashfusion/project-name build
```

### Development

```bash
# Start all dev servers (resource-intensive!)
pnpm dev

# Or start specific projects
pnpm --filter flashfusion-consolidated dev
pnpm --filter harvestflow dev
```

## Repository Structure

```
source-of-truth-monorepo/
├── projects/
│   ├── local/                              # ✅ Imported (3 repos, 1.05GB)
│   │   ├── flashfusion-consolidated/
│   │   ├── harvestflow/
│   │   └── int-smart-triage-ai-2.0/
│   ├── krosebrook/                         # 🔄 Ready to import (34 repos)
│   │   ├── core/                           # Core FlashFusion projects
│   │   ├── apps/                           # Applications
│   │   └── tools/                          # Development tools
│   ├── flashfusionv1/                      # 🔄 Ready to import (8 repos)
│   └── chaosclubco/                        # 🔄 Ready to import (8 repos)
├── agents/                                 # ✅ AI agent templates
├── shared/                                 # ✅ Shared utilities
├── scripts/                                # ✅ Automation scripts
│   └── import-github-repos.sh              # ← Run this to import GitHub repos
└── .github/workflows/                      # ✅ CI/CD workflows
```

## Troubleshooting

### Import Script Fails

```bash
# Check GitHub authentication
gh auth status

# If not authenticated
gh auth login

# Re-run import script
./scripts/import-github-repos.sh
```

### pnpm Install Fails

```bash
# Clear cache and retry
rm -rf node_modules pnpm-lock.yaml
pnpm install --no-frozen-lockfile
```

### Build Failures

Some imported projects may have missing dependencies or incompatible configs. This is expected. You can:

1. Fix individual projects as needed
2. Exclude broken projects from build temporarily
3. Run builds selectively

```bash
# Build specific working projects
pnpm --filter flashfusion-consolidated build
pnpm --filter harvestflow build
```

## Architecture Decisions

### Why Flatten (No Git History)?

We removed `.git` directories from imported repos because:
- **Avoids nested git repos** (gitlinks/submodules)
- **Reduces total size** (no duplicate history)
- **Simpler workspace management**
- History is preserved in original repos

### SoT Canonical Model

All development happens in this SoT repo:
- Changes pushed to downstream mirrors via `git subtree split`
- **Never commit directly to mirror repos**
- CI workflow handles syncing (requires deploy key setup)

### Independent Versioning

Projects use Changesets for independent package versioning:
- Each project can have its own version
- Publish only what changed
- No lockstep versioning

## Next Actions After Import

1. **Run pnpm install** - Install all dependencies
2. **Test builds** - Verify projects compile
3. **Update REPO_MAP** - Document final structure
4. **Configure deploy keys** - Enable subtree push to mirrors
5. **Set up remote cache** - Optional Turbo cache (Vercel or self-hosted)

## Performance Tips

### Turbo Caching

After first build, Turbo caches outputs. Rebuilds are much faster:

```bash
# First build: 10-20 minutes
pnpm build

# Subsequent builds (unchanged): <10 seconds
pnpm build
```

### Selective Builds

Only build what changed:

```bash
# Build only projects changed since last commit
pnpm build --filter=...[HEAD^]

# Build only one project + its dependencies
pnpm build --filter=flashfusion-consolidated...
```

### CI Performance

GitHub Actions workflows use:
- pnpm caching (saves 2-3 min)
- Turbo caching (saves 5-10 min)
- Selective execution (only changed projects)

## Support

- **Issues**: https://github.com/Krosebrook/source-of-truth-monorepo/issues
- **Docs**: https://flashfusion.co
- **README**: [README.md](README.md)
- **Repo Map**: [REPO_MAP.md](REPO_MAP.md)

---

Generated with [Claude Code](https://claude.com/claude-code)
