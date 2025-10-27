# ADR-0004: Changesets for Independent Versioning

**Date**: 2025-10-27
**Status**: Accepted
**Deciders**: @Krosebrook, FlashFusion Team

---

## Context

With 53 projects in a monorepo, we needed a versioning strategy that could:
- Version packages independently (not all projects ship together)
- Generate changelogs automatically
- Handle inter-package dependencies
- Support semantic versioning (semver)
- Work with monorepo setup (pnpm workspaces)

---

## Decision

We will use **Changesets** for independent package versioning.

Each project can have its own version and release cadence.

---

## Rationale

### Considered Alternatives

#### 1. **Lockstep Versioning (All Same Version)**
- **Pros**:
  - Simple: all packages always at same version
  - Easy to communicate: "v2.0" means all packages
- **Cons**:
  - ❌ **Forced releases**: Bug fix in one package forces release of all 53
  - ❌ **Confusing versions**: Unchanged packages get version bumps
  - ❌ **Overhead**: Publish 53 packages even if 1 changed

#### 2. **Manual Versioning**
- **Pros**:
  - Full control over versions
  - No automation needed
- **Cons**:
  - ❌ **Error-prone**: Easy to forget to bump versions
  - ❌ **No changelogs**: Must write manually
  - ❌ **Doesn't scale**: 53 packages = 53 manual updates

#### 3. **Lerna + Fixed Mode**
- **Pros**:
  - Automatic version bumping
  - Changelog generation
- **Cons**:
  - ❌ **Lockstep only**: All packages same version (see Alternative 1)
  - ❌ **Maintenance mode**: Lerna less actively maintained

#### 4. **Changesets (Chosen)**
- **Pros**:
  - ✅ **Independent versioning**: Each package has its own version
  - ✅ **Developer-friendly**: Contributors add `.changeset` files in PRs
  - ✅ **Automatic changelogs**: Generated from changeset descriptions
  - ✅ **Dependency updates**: Bumps dependent packages automatically
  - ✅ **Flexible**: Can mix independent + fixed versioning
  - ✅ **Active development**: Maintained by Atlassian
- **Cons**:
  - ⚠️ **Learning curve**: Contributors must remember to add changesets
  - ⚠️ **PR overhead**: Extra step in contribution workflow

### Why Changesets

For 53 projects with varying update frequencies:
- **Flexibility**: Core FlashFusion projects might ship weekly, tools ship monthly
- **Clarity**: Changelog shows exactly what changed per package
- **Automation**: `changeset version` updates all affected packages
- **Integration**: Works seamlessly with pnpm workspaces

---

## Consequences

### Positive

- ✅ **Granular releases**: Only publish what changed
- ✅ **Clear changelogs**: Automatically generated per package
- ✅ **Dependency coordination**: Changesets updates dependents automatically
- ✅ **Contributor-friendly**: Simple workflow (add changeset in PR)
- ✅ **CI integration**: Can automate releases via GitHub Actions

### Negative

- ⚠️ **Extra step**: Contributors must run `pnpm changeset` before PR
- ⚠️ **Education needed**: Team must understand changeset workflow
- ⚠️ **Forgotten changesets**: PRs without changesets don't trigger releases

### Neutral

- ℹ️ **Mixed strategies possible**: Can use lockstep for tightly-coupled packages if needed
- ℹ️ **Optional publish**: Changesets don't auto-publish (we control when)

---

## Implementation

### Setup

```bash
# Install Changesets
pnpm add -Dw @changesets/cli

# Initialize
pnpm changeset init
```

### Workflow

1. **Developer makes changes**:
   ```bash
   # Make code changes
   git add .

   # Add changeset
   pnpm changeset
   # Select packages changed
   # Choose bump type (major/minor/patch)
   # Write description

   git add .changeset/
   git commit -m "feat: new feature with changeset"
   ```

2. **Maintainer releases**:
   ```bash
   # Update versions + changelogs
   pnpm changeset version

   # Install updated deps
   pnpm install

   # Review changes
   git diff

   # Commit
   git add .
   git commit -m "chore: version packages"

   # Publish (if desired)
   pnpm changeset publish
   git push --follow-tags
   ```

### Changeset Format

```markdown
---
"@flashfusion/logging": minor
"@flashfusion/contracts": patch
---

Add structured logging with trace IDs

This change adds support for OpenTelemetry trace IDs in logs.
```

### CI Automation (Optional)

```yaml
# .github/workflows/release.yml
name: Release
on:
  push:
    branches: [main]

jobs:
  release:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: changesets/action@v1
        with:
          publish: pnpm release
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
          NPM_TOKEN: ${{ secrets.NPM_TOKEN }}
```

---

## References

- [Changesets Documentation](https://github.com/changesets/changesets)
- [Changesets Philosophy](https://github.com/changesets/changesets/blob/main/docs/intro-to-using-changesets.md)
- [Versioning Strategies](https://github.com/changesets/changesets/blob/main/docs/decisions.md)
- Related ADRs:
  - [ADR-0002: pnpm Package Manager](./0002-pnpm-package-manager.md)
  - [ADR-0003: Turborepo Build System](./0003-turborepo-build-system.md)

---

## Revision History

| Date | Author | Change |
|------|--------|--------|
| 2025-10-27 | @Krosebrook | Initial version |
