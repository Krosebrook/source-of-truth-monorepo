# Quickstart: Your First 15 Minutes

> Get up and running with the FlashFusion SoT monorepo in 15 minutes

**Time**: 15 minutes
**Level**: Beginner
**Prerequisites**: Git, Node.js 20+, basic terminal knowledge

---

## What You'll Learn

By the end of this tutorial, you'll:
- Clone the monorepo
- Install all dependencies
- Build all 53 projects
- Run a specific project
- Understand the monorepo structure

---

## Step 1: Clone the Repository (2 min)

```bash
git clone git@github.com:Krosebrook/source-of-truth-monorepo.git
cd source-of-truth-monorepo
```

**What this does**: Downloads the entire SoT monorepo (~2GB) to your machine.

**Tip**: This is the ONLY repo you need to clone. All 53 projects are inside.

---

## Step 2: Install pnpm (1 min)

```bash
# Install pnpm globally
npm install -g pnpm@9

# Verify installation
pnpm --version
# Should show: 9.x.x
```

**Why pnpm?**: Saves 60% disk space and installs 2-3x faster than npm. See [ADR-0002](/docs/adr/0002-pnpm-package-manager.md).

---

## Step 3: Install Dependencies (5 min)

```bash
# Install all workspace dependencies
pnpm install
```

**What's happening**:
- pnpm reads `pnpm-workspace.yaml`
- Discovers all 53 projects
- Installs dependencies for each
- Creates symlinks for shared packages

**Expected output**:
```
Progress: resolved 1234, reused 1100, downloaded 134, added 1234
Done in 45s
```

---

## Step 4: Build Everything (First Time: 5 min)

```bash
# Build all 53 projects
pnpm build
```

**What's happening**:
- Turbo reads `turbo.json`
- Determines dependency order
- Builds projects in parallel
- Caches outputs in `.turbo/`

**Expected output**:
```
>>> flashfusion-consolidated:build: cached
>>> harvestflow:build: cached
>>> int-smart-triage-ai-2.0:build: cached
...
Tasks:    53 successful, 53 total
Time:     12.5s
```

**Subsequent builds**: Turbo cache makes this <1 second if nothing changed!

---

## Step 5: Explore the Structure (2 min)

```bash
# List all workspace projects
pnpm -r list

# See the directory structure
ls -la projects/
```

**Structure**:
```
projects/
├── local/              # 3 local-only repos
│   ├── flashfusion-consolidated/
│   ├── harvestflow/
│   └── int-smart-triage-ai-2.0/
├── krosebrook/         # 34 Krosebrook org repos
│   ├── core/           # Core FlashFusion projects
│   ├── apps/           # Applications
│   └── tools/          # Development tools
├── flashfusionv1/      # 8 flashfusionv1 repos
└── chaosclubco/        # 8 ChaosClubCo repos
```

---

## Step 6: Run a Specific Project (Optional)

```bash
# Run dev server for harvestflow
pnpm --filter harvestflow dev

# Or run build for specific project
pnpm --filter flashfusion-consolidated build
```

**Tip**: `--filter` targets a specific workspace project.

---

## Verification

Check that everything works:

```bash
# Validate documentation
pnpm docs:validate
# ✅ All validation passed

# Check progress tracker
pnpm docs:status

# Lint code (may have warnings, that's ok)
pnpm lint
```

---

## What You Learned

- ✅ Cloned the SoT monorepo
- ✅ Installed pnpm (package manager)
- ✅ Installed all dependencies (`pnpm install`)
- ✅ Built all 53 projects (`pnpm build`)
- ✅ Understand structure (projects/org/name)
- ✅ Run specific projects (`pnpm --filter`)

---

## Next Steps

**Continue Learning**:
- [Importing Repositories](/docs/tutorials/02-importing-repos.md) - Add new repos
- [Building Your First Agent](/docs/tutorials/03-building-your-first-agent.md) - Create an AI agent
- [Publishing Packages](/docs/tutorials/04-publishing-packages.md) - Release with Changesets

**Reference Documentation**:
- [Workspace Structure](/docs/reference/workspace-structure.md) - Detailed layout
- [CLI Reference](/docs/reference/cli-reference.md) - All commands

**Conceptual Understanding**:
- [SoT Canonical Model](/docs/explanation/sot-canonical-model.md) - Why this architecture
- [Turbo Caching](/docs/explanation/turbo-caching-internals.md) - How builds are fast

---

## Troubleshooting

### "pnpm: command not found"

```bash
# Install pnpm globally
npm install -g pnpm@9

# Or use Corepack (built into Node 20+)
corepack enable
corepack prepare pnpm@9.0.0 --activate
```

### "Build failed"

```bash
# Clear cache and retry
rm -rf .turbo node_modules
pnpm install
pnpm build
```

### "Out of disk space"

pnpm uses symlinks to save space, but initial install needs ~5GB. Clear some space and retry.

---

**Need help?** [Open an issue](https://github.com/Krosebrook/source-of-truth-monorepo/issues)
