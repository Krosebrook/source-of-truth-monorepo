# CLI Reference

> Complete command reference for the FlashFusion SoT monorepo

**Type**: Reference
**Audience**: All developers
**Last Updated**: 2025-10-27

---

## Package Management (pnpm)

### Installation

```bash
# Install all workspace dependencies
pnpm install

# Install with frozen lockfile (CI)
pnpm install --frozen-lockfile

# Install for specific project
pnpm --filter <project-name> install
```

### Workspace Commands

```bash
# List all workspace projects
pnpm -r list

# Run command in all projects
pnpm -r <command>

# Run command in specific project
pnpm --filter <project-name> <command>
```

---

## Build System (Turbo)

### Building

```bash
# Build all projects
pnpm build

# Build only changed projects (since HEAD^)
pnpm build --filter=...[HEAD^]

# Build specific project + dependencies
pnpm build --filter=<project-name>...

# Build with dependencies (upstream)
pnpm build --filter=...<project-name>

# Dry run (show what would build)
pnpm build --dry-run
```

### Development

```bash
# Start all dev servers (resource-intensive!)
pnpm dev

# Start specific project
pnpm --filter <project-name> dev

# Start multiple projects
pnpm --filter '{project1,project2}' dev
```

### Testing

```bash
# Run all tests
pnpm test

# Run tests for changed projects
pnpm test --filter=...[HEAD^]

# Run tests for specific project
pnpm --filter <project-name> test
```

### Linting

```bash
# Lint all projects
pnpm lint

# Lint specific project
pnpm --filter <project-name> lint

# Auto-fix lint issues
pnpm --filter <project-name> lint --fix
```

### Type Checking

```bash
# Type check all projects
pnpm type-check

# Type check specific project
pnpm --filter <project-name> type-check
```

### Cleaning

```bash
# Clean build artifacts (all projects)
pnpm clean

# Clean specific project
pnpm --filter <project-name> clean

# Clean Turbo cache
rm -rf .turbo

# Clean node_modules
rm -rf node_modules
pnpm install
```

---

## Turbo-Specific Commands

### Cache Management

```bash
# Clear Turbo cache
pnpm turbo run build --force

# Run without cache
pnpm turbo run build --no-cache

# Show cache status
pnpm turbo run build --summarize
```

### Dependency Graph

```bash
# Show dependency graph (requires graphviz)
pnpm turbo run build --graph

# Output graph as JSON
pnpm turbo run build --graph=graph.json
```

---

## Documentation

### Status & Progress

```bash
# Check documentation progress
pnpm docs:status

# Resume documentation work
pnpm docs:resume

# Validate documentation files
pnpm docs:validate

# Lint markdown
pnpm docs:lint
```

---

## Versioning (Changesets)

### Creating Changesets

```bash
# Add a changeset
pnpm changeset

# Add changeset with message
pnpm changeset add

# Check changeset status
pnpm changeset status
```

### Versioning & Publishing

```bash
# Update package versions
pnpm changeset version

# Publish packages
pnpm changeset publish

# Combined release (version + install + publish)
pnpm release
```

---

## Git Operations

### Repository Import

```bash
# Import all GitHub repositories
./scripts/import-github-repos.sh

# Manual import (local repo)
cp -r /path/to/repo projects/local/repo-name
rm -rf projects/local/repo-name/.git
git add projects/local/repo-name
git commit -m "feat: import repo-name"
```

### Subtree Operations (Mirrors)

```bash
# Push changes to mirror (automated in CI)
git subtree split --prefix=projects/org/name -b temp
git push git@github.com:org/name.git temp:main --force
git branch -D temp
```

**Note**: Subtree push happens automatically in CI. Don't run manually unless needed.

---

## Filtering Patterns

### Basic Filters

```bash
# Single project
pnpm --filter flashfusion-consolidated <cmd>

# Multiple projects (glob)
pnpm --filter 'projects/krosebrook/*' <cmd>

# Multiple projects (list)
pnpm --filter '{project1,project2}' <cmd>
```

### Dependency Filters

```bash
# Project + dependencies (upstream)
pnpm --filter ...flashfusion-consolidated <cmd>

# Project + dependents (downstream)
pnpm --filter flashfusion-consolidated... <cmd>

# Only dependencies (exclude project itself)
pnpm --filter ...flashfusion-consolidated^ <cmd>
```

### Git-Based Filters

```bash
# Changed since HEAD^
pnpm --filter ...[HEAD^] <cmd>

# Changed since main branch
pnpm --filter ...[origin/main] <cmd>

# Changed files (specific commit)
pnpm --filter ...[abc123] <cmd>
```

---

## Environment Variables

### pnpm

```bash
# Custom store location
export PNPM_HOME=/custom/path

# Skip install scripts
export PNPM_SKIP_INSTALL_SCRIPTS=true
```

### Turbo

```bash
# Remote caching (optional)
export TURBO_API=https://your-cache-server.com
export TURBO_TOKEN=your-token
export TURBO_TEAM=your-team

# Force no cache
export TURBO_FORCE=true
```

### Documentation

```bash
# Trace ID for logging
export TRACE_ID=unique-trace-id

# Workflow ID
export WORKFLOW_ID=workflow-123
```

---

## Debugging

### pnpm Debugging

```bash
# Verbose output
pnpm install --loglevel debug

# Show dependency tree
pnpm why <package-name>

# List outdated packages
pnpm outdated

# Update packages
pnpm update
```

### Turbo Debugging

```bash
# Show task summary
pnpm build --summarize

# Verbose logs
pnpm build --verbosity=2

# Show task timings
pnpm build --profile
```

---

## Common Workflows

### New Contributor Setup

```bash
# 1. Clone repo
git clone git@github.com:Krosebrook/source-of-truth-monorepo.git
cd source-of-truth-monorepo

# 2. Install pnpm
npm install -g pnpm@9

# 3. Install dependencies
pnpm install

# 4. Build everything
pnpm build

# 5. Verify
pnpm docs:validate
```

### Making a Change

```bash
# 1. Create branch
git checkout -b feature/my-change

# 2. Make changes
# ... edit code ...

# 3. Add changeset
pnpm changeset

# 4. Test locally
pnpm --filter affected-project test
pnpm --filter affected-project build

# 5. Commit
git add .
git commit -m "feat: describe change"

# 6. Push & create PR
git push -u origin feature/my-change
gh pr create
```

### Releasing Packages

```bash
# 1. Version packages
pnpm changeset version

# 2. Update lockfile
pnpm install

# 3. Review changes
git diff

# 4. Commit version bump
git add .
git commit -m "chore: version packages"

# 5. Publish (if desired)
pnpm changeset publish

# 6. Push with tags
git push --follow-tags
```

---

## Scripts Reference

### Root `package.json` Scripts

| Script | Command | Purpose |
|--------|---------|---------|
| `build` | `turbo run build` | Build all projects |
| `dev` | `turbo run dev` | Start all dev servers |
| `lint` | `turbo run lint` | Lint all projects |
| `test` | `turbo run test --if-present` | Run all tests |
| `type-check` | `turbo run type-check --if-present` | Type check all |
| `clean` | `turbo run clean --if-present` | Clean artifacts |
| `release` | `changeset version && pnpm i -r && changeset publish` | Release flow |
| `format` | `prettier --write "**/*.{ts,tsx,js,jsx,json,md}"` | Format code |
| `format:check` | `prettier --check "**/*.{ts,tsx,js,jsx,json,md}"` | Check formatting |
| `docs:status` | `cat docs/.progress.yaml \| grep -A 5 'current'` | Doc progress |
| `docs:resume` | `tail -30 docs/SESSION_LOG.md` | Resume docs |
| `docs:lint` | `markdownlint '**/*.md' --ignore node_modules` | Lint markdown |
| `docs:validate` | `test -f .llms.txt && test -f docs/mcp.json` | Validate docs |

---

## Aliases (Shortcuts)

Add to your `~/.bashrc` or `~/.zshrc`:

```bash
# pnpm shortcuts
alias pn='pnpm'
alias pnb='pnpm build'
alias pnd='pnpm dev'
alias pnt='pnpm test'
alias pni='pnpm install'

# Turbo shortcuts
alias tb='pnpm turbo run build'
alias td='pnpm turbo run dev'

# Filter shortcuts
alias pnf='pnpm --filter'
alias pnfc='pnpm --filter ...[HEAD^]'  # Changed
```

---

## See Also

- [Quickstart Tutorial](/docs/tutorials/01-quickstart.md) - Get started
- [Workspace Structure](/docs/reference/workspace-structure.md) - Directory layout
- [Turbo Caching](/docs/explanation/turbo-caching-internals.md) - How caching works
- [pnpm Documentation](https://pnpm.io/)
- [Turborepo Documentation](https://turborepo.com/)

---

**Last Updated**: 2025-10-27 | **Maintainer**: @Krosebrook
