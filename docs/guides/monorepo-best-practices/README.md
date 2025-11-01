# Monorepo Best Practices

> Essential guidelines for developing in the FlashFusion Source-of-Truth monorepo

## Table of Contents

- [Core Principles](#core-principles)
- [Development Workflow](#development-workflow)
- [Code Organization](#code-organization)
- [Dependencies Management](#dependencies-management)
- [Building and Testing](#building-and-testing)
- [Commits and Changesets](#commits-and-changesets)
- [Common Pitfalls](#common-pitfalls)
- [Performance Tips](#performance-tips)

---

## Core Principles

### 1. Single Source of Truth (SoT)

**Rule**: All development happens in this monorepo. Mirror repositories are read-only for external consumers.

✅ **DO**:
- Make all changes in the monorepo
- Create PRs against the monorepo
- Use monorepo for code reviews

❌ **DON'T**:
- Commit directly to mirror repositories
- Create PRs in mirror repos
- Fork mirror repos for development

**Why**: Prevents divergence and ensures all changes flow through proper review processes.

### 2. Workspace-First Thinking

**Rule**: Leverage pnpm workspaces for code sharing and dependency management.

✅ **DO**:
- Share code via workspace dependencies (`workspace:*`)
- Put reusable code in `/shared`
- Use workspace protocols in package.json

❌ **DON'T**:
- Duplicate code across projects
- Use file paths for imports between projects
- Publish internal packages to npm

**Example**:
```json
{
  "dependencies": {
    "@flashfusion/logging": "workspace:*",
    "@flashfusion/contracts": "workspace:*"
  }
}
```

### 3. Atomic Changes

**Rule**: Keep changes atomic and well-scoped.

✅ **DO**:
- Make changes that can be reviewed in one session
- Update related projects in a single PR
- Use changesets to document impact

❌ **DON'T**:
- Mix unrelated changes in one PR
- Make breaking changes without migration path
- Skip changesets for user-facing changes

---

## Development Workflow

### Starting Work

1. **Update your local repository**:
   ```bash
   git checkout main
   git pull origin main
   pnpm install  # Update dependencies
   ```

2. **Create a feature branch**:
   ```bash
   git checkout -b feature/your-feature-name
   ```

3. **Verify your environment**:
   ```bash
   ./scripts/verify-setup.sh
   ```

### Making Changes

1. **Identify affected projects**:
   ```bash
   # See which projects depend on your changes
   pnpm list --filter "...{./projects/your-project}"
   ```

2. **Make your changes** following the patterns in existing code

3. **Build incrementally**:
   ```bash
   # Build just your project and its dependencies
   pnpm --filter your-project build
   ```

4. **Test your changes**:
   ```bash
   # Test your project
   pnpm --filter your-project test
   
   # Test dependent projects
   pnpm --filter "...{./projects/your-project}" test
   ```

### Before Committing

1. **Run linting**:
   ```bash
   pnpm lint
   pnpm format
   ```

2. **Create a changeset** (if user-facing):
   ```bash
   pnpm changeset
   ```
   - Select affected packages
   - Choose version bump type (major/minor/patch)
   - Write clear description

3. **Build all affected projects**:
   ```bash
   pnpm build
   ```

### Creating a PR

1. **Push your branch**:
   ```bash
   git push -u origin feature/your-feature-name
   ```

2. **Create PR** with clear description:
   - What changed?
   - Why was it needed?
   - How to test it?
   - Any breaking changes?

3. **Link related issues**:
   ```
   Fixes #123
   Related to #456
   ```

---

## Code Organization

### Directory Structure

```
source-of-truth-monorepo/
├── projects/           # All project code
│   ├── local/          # Local-only repos (no mirrors)
│   ├── krosebrook/     # Krosebrook org repos
│   ├── flashfusionv1/  # FlashFusionv1 org repos
│   └── chaosclubco/    # ChaosClubCo org repos
├── shared/             # Shared utilities
│   ├── contracts/      # Type definitions & schemas
│   ├── logging/        # Structured logging
│   ├── otel/           # Observability
│   └── workflows/      # CI/CD utilities
├── agents/             # AI agent templates
├── scripts/            # Automation scripts
└── docs/               # Documentation
```

### Where to Put Code

| Type of Code | Location | Example |
|--------------|----------|---------|
| Project-specific | `projects/{org}/{name}/src/` | Feature code |
| Shared utilities | `shared/{category}/` | Logger, validators |
| Agent templates | `agents/{agent-name}/` | Claude prompts |
| Build scripts | `scripts/` | Deploy keys script |
| Documentation | `docs/` | How-to guides |

### Shared Code Guidelines

✅ **DO** create shared code when:
- Used by 3+ projects
- Domain-agnostic (logging, validation, etc.)
- Stable API (not frequently changing)

❌ **DON'T** create shared code:
- For experimental features
- For project-specific logic
- When you can't commit to maintenance

---

## Dependencies Management

### Adding Dependencies

**For a single project**:
```bash
pnpm --filter your-project add package-name
```

**For workspace-wide tools** (linters, builders):
```bash
pnpm add -w -D package-name
```

**For shared packages**:
```bash
pnpm --filter @flashfusion/shared-package add package-name
```

### Using Workspace Dependencies

When depending on another workspace package:

```json
{
  "dependencies": {
    "@flashfusion/contracts": "workspace:*"
  }
}
```

**Benefits**:
- Always uses local version
- No version mismatches
- Instant updates during development

### Dependency Upgrades

✅ **DO**:
- Use Renovate for automated updates
- Review and test updates in CI
- Batch related updates together

❌ **DON'T**:
- Manually update 53 package.json files
- Skip testing after dependency updates
- Ignore security advisories

### Version Pinning

**Rule**: Use exact versions for shared dependencies.

```json
{
  "dependencies": {
    "react": "18.2.0",  // Exact version
    "lodash": "^4.17.21"  // Range for utilities
  }
}
```

---

## Building and Testing

### Turbo Caching

Turbo caches build outputs to speed up CI and local development.

**First build** (cold cache):
```bash
pnpm build  # 10-20 minutes
```

**Subsequent builds** (warm cache):
```bash
pnpm build  # <1 minute if nothing changed
```

**Cache invalidation**:
Turbo automatically invalidates cache when:
- Source files change
- Dependencies change
- Environment variables change

**Manual cache clearing**:
```bash
rm -rf .turbo
pnpm build
```

### Incremental Builds

Build only what changed since last commit:

```bash
pnpm build --filter=...[HEAD^]
```

Build a specific project and its dependencies:

```bash
pnpm --filter your-project build
```

### Testing Strategy

**Unit tests**: Test individual functions/components
```bash
pnpm --filter your-project test
```

**Integration tests**: Test project interactions
```bash
pnpm test
```

**E2E tests**: Test full workflows (if applicable)
```bash
pnpm --filter your-app test:e2e
```

### Parallel Execution

Turbo runs tasks in parallel when possible:

```bash
pnpm build  # Builds all projects in parallel (respecting dependencies)
```

Control parallelism:
```bash
turbo run build --concurrency=4  # Max 4 concurrent tasks
```

---

## Commits and Changesets

### Commit Messages

Follow conventional commits:

```
type(scope): description

[optional body]

[optional footer]
```

**Types**:
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation
- `refactor`: Code refactoring
- `test`: Tests
- `chore`: Maintenance

**Examples**:
```
feat(logging): add structured logging support
fix(contracts): resolve schema validation error
docs(onboarding): update contributor guide
```

### Creating Changesets

For changes affecting published packages:

```bash
pnpm changeset
```

**Answer prompts**:
1. Which packages changed? (select from list)
2. Bump type? (major/minor/patch)
3. Summary? (describe the change)

**Changeset file** created in `.changeset/`:
```markdown
---
"@flashfusion/your-package": minor
---

Add new feature X to improve Y
```

### Versioning Rules

Follow semantic versioning:

- **Major** (1.0.0 → 2.0.0): Breaking changes
- **Minor** (1.0.0 → 1.1.0): New features (backward compatible)
- **Patch** (1.0.0 → 1.0.1): Bug fixes

### Publishing Flow

1. Create changeset: `pnpm changeset`
2. Commit changeset with your changes
3. Merge PR to main
4. CI updates versions: `pnpm changeset version`
5. CI publishes: `pnpm release`

---

## Common Pitfalls

### 1. Forgetting to Build Dependencies

❌ **Problem**:
```bash
pnpm --filter your-project test
# Error: Cannot find module '@flashfusion/contracts'
```

✅ **Solution**:
```bash
pnpm --filter your-project... build  # Builds deps too
pnpm --filter your-project test
```

### 2. Working on Stale Branch

❌ **Problem**: Branch diverged from main, merge conflicts

✅ **Solution**:
```bash
git checkout main
git pull origin main
git checkout your-branch
git rebase main  # Or merge main
pnpm install     # Update dependencies
```

### 3. Skipping Changesets

❌ **Problem**: Changes shipped without version bump

✅ **Solution**: Always create changeset for user-facing changes:
```bash
pnpm changeset
```

### 4. Installing Wrong Scope

❌ **Wrong**:
```bash
pnpm add package-name  # Installs to root by mistake
```

✅ **Right**:
```bash
pnpm --filter your-project add package-name
```

### 5. Circular Dependencies

❌ **Problem**: Project A depends on B, B depends on A

✅ **Solution**: 
- Extract shared code to a third package
- Redesign to remove circular dependency

### 6. Not Testing Dependent Projects

❌ **Problem**: Change breaks dependent projects, not caught until CI

✅ **Solution**:
```bash
# Test all projects that depend on yours
pnpm --filter "...{./projects/your-project}" test
```

---

## Performance Tips

### 1. Use Turbo Filters

**Build only changed projects**:
```bash
pnpm build --filter=...[HEAD^]
```

**Build a specific project**:
```bash
pnpm --filter project-name build
```

### 2. Leverage Cache

Don't clear cache unnecessarily:
```bash
# ❌ Slow
rm -rf .turbo && pnpm build

# ✅ Fast
pnpm build  # Uses cache if nothing changed
```

### 3. Parallel Development

Work on independent projects in parallel:
```bash
# Terminal 1
pnpm --filter project-a dev

# Terminal 2
pnpm --filter project-b dev
```

### 4. Skip Unrelated Checks

If working on docs only:
```bash
git commit -m "docs: update guide" --no-verify  # Skip pre-commit hooks
```

(Use sparingly!)

### 5. Watch Mode for Fast Iteration

```bash
pnpm --filter your-project dev  # Auto-rebuild on changes
```

### 6. Local Package Links

For cross-project development:
```bash
# In dependent project, pnpm automatically links to local workspace package
# Changes in @flashfusion/contracts reflect immediately
```

---

## Quick Reference

### Common Commands

```bash
# Setup
pnpm install                              # Install all dependencies
./scripts/verify-setup.sh                 # Verify environment

# Building
pnpm build                                # Build everything
pnpm --filter project-name build          # Build one project
pnpm build --filter=...[HEAD^]            # Build changed projects

# Testing
pnpm test                                 # Test all
pnpm --filter project-name test           # Test one project

# Linting
pnpm lint                                 # Lint all
pnpm format                               # Format all

# Dependencies
pnpm --filter project-name add pkg        # Add dependency
pnpm -r update pkg                        # Update in all projects

# Versioning
pnpm changeset                            # Create changeset
pnpm changeset version                    # Bump versions

# Utilities
pnpm -r list                              # List all projects
pnpm list --filter "...[HEAD^]"           # List changed projects
```

### Getting Help

- **Documentation**: `/docs/index.md`
- **Issues**: https://github.com/Krosebrook/source-of-truth-monorepo/issues
- **Slack/Discord**: #flashfusion-sot channel

---

**Last updated**: 2025-11-01  
**See also**: [Mirror Repository Best Practices](./mirror-repository-best-practices.md)
