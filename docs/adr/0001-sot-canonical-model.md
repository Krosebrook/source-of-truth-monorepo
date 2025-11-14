# ADR-0001: SoT Canonical Model

**Date**: 2025-10-27
**Status**: Accepted
**Deciders**: @Krosebrook, FlashFusion Team

---

## Context

We needed to consolidate 53 repositories across 4 GitHub organizations (Krosebrook, flashfusionv1, ChaosClubCo, and local repos) into a unified development workflow. The question was: where should the source of truth live, and how should changes flow between the consolidated monorepo and the individual repositories?

### The Problem

- **Drift**: Changes made in individual repos weren't reflected in others
- **Duplication**: Same code existed in multiple places with inconsistencies
- **No single source of truth**: Unclear which repo was authoritative
- **Review chaos**: PRs spread across 53 repositories
- **Version confusion**: No unified versioning strategy

---

## Decision

We will adopt the **SoT (Source-of-Truth) Canonical Model** where:

1. **All development happens in the SoT monorepo** (`Krosebrook/source-of-truth-monorepo`)
2. **Individual repos become "mirrors"** that receive changes via `git subtree split`
3. **No direct commits to mirrors** - they are read-only for downstream users
4. **Changes flow unidirectionally**: SoT → mirrors

---

## Rationale

### Considered Alternatives

#### 1. **Polyrepo (Keep Separate Repos)**

- **Pros**:
  - Simple to understand
  - No migration needed
  - Each team owns their repo
- **Cons**:
  - **Drift continues**: No way to keep repos in sync
  - **Duplicate work**: Fixes not shared across repos
  - **No unified CI/CD**: Each repo has separate workflows
  - **Hard to refactor**: Cross-repo changes require multiple PRs

#### 2. **Git Submodules**

- **Pros**:
  - Each repo maintains full git history
  - Well-known pattern
- **Cons**:
  - **Complex**: Nested repos are hard to manage
  - **Fragile**: Easy to get into broken states
  - **Poor DX**: Developers frequently forget to update submodules
  - **No unified builds**: Still separate CI per submodule

#### 3. **Leaf-Authoritative (Repos Pull to SoT)**

- **Pros**:
  - Preserves individual repo autonomy
  - Teams can work independently
- **Cons**:
  - **Drift still possible**: Individual repos can diverge
  - **Merge conflicts**: Pulling from 53 sources creates conflicts
  - **No unified review**: PRs scattered across repos
  - **Slow synchronization**: Batch pulls are infrequent

#### 4. **SoT Canonical (Chosen)**

- **Pros**:
  - ✅ **Single source of truth**: All changes in one place
  - ✅ **Unified review**: All PRs reviewed in SoT
  - ✅ **No drift**: Mirrors always match SoT
  - ✅ **Atomic changes**: Cross-project refactors in one commit
  - ✅ **Unified CI/CD**: One pipeline for all projects
  - ✅ **Turbo caching**: Shared build cache across all 53 projects
- **Cons**:
  - ⚠️ **Learning curve**: Team must learn monorepo workflow
  - ⚠️ **Force-push to mirrors**: Can overwrite uncommitted changes
  - ⚠️ **Larger initial clone**: ~2GB vs individual repos

### Why SoT Canonical

1. **Eliminates drift**: Impossible for repos to diverge
2. **Centralized governance**: All code reviews in one place (CODEOWNERS)
3. **Faster CI**: Turbo caching means rebuilding only what changed
4. **Atomic cross-repo changes**: Refactors that touch multiple projects = one PR
5. **Unified tooling**: One tsconfig, one eslint config, one prettier config
6. **Better DX**: Clone once, build everything, test everything

---

## Consequences

### Positive

- ✅ **No more drift**: Mirrors always match SoT
- ✅ **Faster reviews**: All PRs in one repo with CODEOWNERS
- ✅ **Unified CI/CD**: GitHub Actions workflows apply to all 53 projects
- ✅ **Turbo caching**: First build 10-20 min, subsequent <1 min
- ✅ **Easier refactors**: Change shared utilities once, affects all projects
- ✅ **Better onboarding**: New contributors clone once, see everything

### Negative

- ⚠️ **Workflow change**: Team must adopt "never commit to mirrors"
- ⚠️ **Larger clone**: ~2GB initial download (but pnpm sparse checkouts possible)
- ⚠️ **Force-push risk**: Direct commits to mirrors will be overwritten
- ⚠️ **Learning curve**: Git subtree less familiar than submodules

### Neutral

- ℹ️ **Deploy keys required**: Each mirror needs SSH key for CI push
- ℹ️ **Documentation needed**: Clear guide on SoT workflow (this ADR!)

---

## Implementation

### Git Subtree Strategy

```bash
# Import a repo (one-time)
git subtree add --prefix=projects/org/name \
  git@github.com:org/name.git main --squash

# Push changes to mirror (automated in CI)
git subtree split --prefix=projects/org/name -b temp-branch
git push git@github.com:org/name.git temp-branch:main --force
git branch -D temp-branch
```

### Workflow Rules

1. **All PRs to SoT**: Developers open PRs against `source-of-truth-monorepo`
2. **CI pushes to mirrors**: On merge to `main`, GitHub Actions runs subtree split + push
3. **Mirrors are read-only**: Downstream users clone mirrors but don't commit
4. **Emergency hotfixes**: If needed, commit to SoT then push mirror immediately

### Protection Mechanisms

- Branch protection on mirrors (prevent direct commits)
- CI check: detect divergent commits before force-push (warn if present)
- Webhook alerts: notify if someone commits directly to mirror

---

## References

- [Git Subtree Documentation](https://git-scm.com/book/en/v2/Git-Tools-Subtrees)
- [Monorepo Tools Comparison](https://monorepo.tools/)
- [Turborepo Docs](https://turborepo.com/)
- Related ADRs:
  - [ADR-0003: Turborepo Build System](./0003-turborepo-build-system.md)
  - [ADR-0005: Flattened Repos](./0005-flattened-repos.md)

---

## Revision History

| Date       | Author      | Change          |
| ---------- | ----------- | --------------- |
| 2025-10-27 | @Krosebrook | Initial version |
