# Getting Started with FlashFusion SoT

> Your complete onboarding guide to the Source-of-Truth monorepo

**Time**: 30 minutes
**Level**: All levels
**Goal**: Understand the monorepo, run your first build, know where to go next

---

## Welcome

Welcome to the **FlashFusion Source-of-Truth (SoT) monorepo** - a unified consolidation of 53 repositories across the FlashFusion ecosystem.

**What is this?**
- **One repository** containing **53 projects**
- **One build system** (Turborepo) with intelligent caching
- **One package manager** (pnpm) saving 60% disk space
- **One source of truth** for all FlashFusion development

**Why use this?**
- ✅ Build 53 projects in <1 minute (with cache)
- ✅ Share code across projects with `workspace:*`
- ✅ Never duplicate utility code again
- ✅ Atomic cross-project refactors in one commit

---

## Quick Start (3 Options)

### Option 1: "I just want to build"

```bash
# 1. Clone repo
git clone git@github.com:Krosebrook/source-of-truth-monorepo.git
cd source-of-truth-monorepo

# 2. Install pnpm
npm install -g pnpm@9

# 3. Install & build
pnpm install
pnpm build

# Done! (First build: 10-20 min, subsequent: <1 min with cache)
```

**Jump to**: [Next Steps](#next-steps)

### Option 2: "I want the full tutorial"

Follow the **[15-Minute Quickstart Tutorial](/docs/tutorials/01-quickstart.md)** for a guided walkthrough.

### Option 3: "I want to import more repos"

Skip to **[Importing Repositories](#importing-remaining-repositories)** below.

---

## Understanding the Structure (5 min)

### Projects by Organization

```
projects/
├── local/              # 3 local-only repos (no GitHub remote)
├── krosebrook/         # 34 Krosebrook org repos
│   ├── core/           # Core FlashFusion projects
│   ├── apps/           # Applications
│   └── tools/          # Development tools
├── flashfusionv1/      # 8 flashfusionv1 repos
└── chaosclubco/        # 8 ChaosClubCo repos
```

**Total**: 53 projects (3 local + 50 GitHub)

### Other Directories

- **`/agents/`**: AI agent templates (Claude, Codex, Gemini, GitHub)
- **`/shared/`**: Code shared across all 53 projects
- **`/docs/`**: All documentation (Diátaxis framework)
- **`/scripts/`**: Automation scripts
- **`/.github/`**: CI/CD workflows

**See**: [Workspace Structure Reference](/docs/reference/workspace-structure.md) for complete details.

---

## Core Concepts (5 min)

### 1. SoT Canonical Model

**Rule**: All development happens in this SoT monorepo. Individual repos on GitHub are "mirrors" that receive changes via CI.

```
SoT Monorepo (You are here!)
      ↓
   CI/CD (automated)
      ↓
Mirror Repos (read-only for users)
```

**Why?** No drift, unified reviews, atomic cross-repo changes.

**Learn more**: [SoT Canonical Model Explained](/docs/explanation/sot-canonical-model.md)

### 2. pnpm Workspaces

**Package manager**: pnpm (not npm or yarn)

**Benefits**:
- 60% disk space savings (symlinks to shared store)
- 2-3x faster than npm
- Strict dependency resolution (no phantom deps)

**Learn more**: [ADR-0002: pnpm Package Manager](/docs/adr/0002-pnpm-package-manager.md)

### 3. Turbo Caching

**Build system**: Turborepo

**Magic**: First build = 10-20 min. Subsequent builds (if nothing changed) = <1 second.

**How?** Turbo caches build outputs and only rebuilds what changed.

**Learn more**: [ADR-0003: Turborepo Build System](/docs/adr/0003-turborepo-build-system.md)

---

## Common Commands

### Building

```bash
# Build everything
pnpm build

# Build only changed projects (since last commit)
pnpm build --filter=...[HEAD^]

# Build specific project
pnpm --filter flashfusion-consolidated build
```

### Development

```bash
# Start dev server for specific project
pnpm --filter harvestflow dev

# Or run any project command
pnpm --filter <project-name> <command>
```

### Testing & Linting

```bash
# Run all tests
pnpm test

# Lint all projects
pnpm lint

# Type check
pnpm type-check
```

**See**: [CLI Reference](/docs/reference/cli-reference.md) for all commands.

---

## Importing Remaining Repositories

**Current status**: 3 local repos imported, 50 GitHub repos ready to import.

### Automated Import (Recommended)

```bash
# Run the import script (imports 50 repos from GitHub)
./scripts/import-github-repos.sh
```

**What happens**:
1. Clones 50 repos from Krosebrook, flashfusionv1, ChaosClubCo
2. Flattens them (removes .git history)
3. Organizes into `projects/org/name/`
4. Shows progress (✓ success, ⊙ skipped, ✗ failed)

**Time**: 10-20 minutes depending on network

**Tutorial**: [Importing Repositories](/docs/tutorials/02-importing-repos.md)

### After Import

```bash
# Commit imported repos
git add projects/
git commit -m "feat: Import 50 GitHub repositories"
git push

# Install dependencies
pnpm install

# Build everything
pnpm build
```

---

## Onboarding Checklist

Use this checklist to track your progress:

- [ ] **Clone repo** (`git clone git@github.com:Krosebrook/source-of-truth-monorepo.git`)
- [ ] **Install pnpm** (`npm install -g pnpm@9`)
- [ ] **Install dependencies** (`pnpm install`)
- [ ] **Build everything** (`pnpm build`)
- [ ] **Read [Quickstart Tutorial](/docs/tutorials/01-quickstart.md)**
- [ ] **Understand [SoT Canonical Model](/docs/explanation/sot-canonical-model.md)**
- [ ] **Review [Workspace Structure](/docs/reference/workspace-structure.md)**
- [ ] **Import remaining repos** (`./scripts/import-github-repos.sh`) *(optional)*
- [ ] **Explore documentation** (`/docs/index.md`)
- [ ] **Join team Slack/Discord** *(ask maintainer for invite)*

**Print this**: [Onboarding Checklist PDF](/docs/ONBOARDING_CHECKLIST.md)

---

## Documentation

### Start Here (Learning)

- **[15-Min Quickstart](/docs/tutorials/01-quickstart.md)** - Your first build
- **[Importing Repos](/docs/tutorials/02-importing-repos.md)** - Add new projects
- **[Building Your First Agent](/docs/tutorials/03-building-your-first-agent.md)** - AI integration

### Reference (Lookup)

- **[CLI Reference](/docs/reference/cli-reference.md)** - All commands
- **[Workspace Structure](/docs/reference/workspace-structure.md)** - Directory layout
- **[Configuration Reference](/docs/reference/configuration-reference.md)** - turbo.json, pnpm-workspace.yaml

### Understanding (Concepts)

- **[SoT Canonical Model](/docs/explanation/sot-canonical-model.md)** - Architecture
- **[Turbo Caching](/docs/explanation/turbo-caching-internals.md)** - How builds are fast
- **[Monorepo vs Polyrepo](/docs/explanation/monorepo-vs-polyrepo.md)** - Trade-offs

### Architecture Decisions

- **[All ADRs](/docs/adr/)** - Why we made key choices
  - [ADR-0001: SoT Canonical](/docs/adr/0001-sot-canonical-model.md)
  - [ADR-0002: pnpm](/docs/adr/0002-pnpm-package-manager.md)
  - [ADR-0003: Turborepo](/docs/adr/0003-turborepo-build-system.md)

**Full Documentation**: [/docs/index.md](/docs/index.md)

---

## Next Steps

### For New Contributors

1. Read [Contributing Guidelines](/CONTRIBUTING.md)
2. Join team communication (Slack/Discord)
3. Pick a "good first issue"
4. Make your first PR!

### For Developers

1. **Explore projects**: `ls projects/` to see all 53 repos
2. **Run a project**: `pnpm --filter <name> dev`
3. **Make a change**: Edit code, add changeset, create PR
4. **Publish**: Follow [Publishing Guide](/docs/tutorials/04-publishing-packages.md)

### For Operators

1. Read [Daily Operations Runbook](/docs/runbooks/daily-operations.md)
2. Review [Incident Response](/docs/runbooks/incident-response.md)
3. Set up monitoring and alerts

### For Architects

1. Review all [Architecture Decision Records](/docs/adr/)
2. Understand [System Design](/docs/explanation/)
3. Plan future enhancements

---

## Troubleshooting

### "pnpm: command not found"

```bash
npm install -g pnpm@9
# Or use Corepack (built into Node 20+)
corepack enable
```

### "Build failed"

```bash
# Clear cache and retry
rm -rf .turbo node_modules
pnpm install
pnpm build
```

### "Out of disk space"

pnpm uses symlinks (saves space), but initial install needs ~5GB. Clear some space and retry.

### "Import script failed"

```bash
# Authenticate with GitHub
gh auth login

# Re-run import
./scripts/import-github-repos.sh
```

**Full Troubleshooting**: [How-To Guides](/docs/how-to/)

---

## Support & Community

- **Documentation**: [/docs/index.md](/docs/index.md)
- **Issues**: [GitHub Issues](https://github.com/Krosebrook/source-of-truth-monorepo/issues)
- **Questions**: Open a [Q&A Discussion](https://github.com/Krosebrook/source-of-truth-monorepo/discussions)
- **Email**: krosebrook@flashfusion.co

---

## Current Status

### ✅ Completed

- GitHub repo created (`Krosebrook/source-of-truth-monorepo`)
- Complete monorepo infrastructure
- pnpm workspace + Turbo configured
- CI/CD workflows (CI, Security, Documentation)
- Comprehensive documentation (Diátaxis framework)
- 3 local repositories imported (1.05GB)
- 6 Architecture Decision Records
- 2 tutorials, 2 reference docs, 1 explanation

### 🔄 Next (Optional)

- Import 50 GitHub repositories (`./scripts/import-github-repos.sh`)
- Run `pnpm install` across workspace
- Test builds
- Start developing!

---

**Ready?** Start with the [15-Minute Quickstart](/docs/tutorials/01-quickstart.md) or jump straight to `pnpm install && pnpm build`!

**Questions?** Check [Documentation Index](/docs/index.md) or [open an issue](https://github.com/Krosebrook/source-of-truth-monorepo/issues).

🎉 **Welcome to the FlashFusion SoT Monorepo!**
