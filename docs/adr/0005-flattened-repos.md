# ADR-0005: Flattened Repository Imports

**Date**: 2025-10-27
**Status**: Accepted
**Deciders**: @Krosebrook, FlashFusion Team

---

## Context

When importing 53 repositories into the SoT monorepo, we had to decide: **preserve full git history or flatten (remove .git)?**

### The Trade-off

- **With git history**: git subtree maintains commits, blame works per-repo
- **Without git history** (flattened): cleaner structure, no nested repos, smaller size

---

## Decision

We will **flatten repositories on import** - remove `.git` directories and import as regular directories.

Git history is **not preserved** in the SoT monorepo, but remains accessible in original repositories.

---

## Rationale

### Considered Alternatives

#### 1. **Git Submodules (Keep Full History)**
- **Pros**:
  - Full git history preserved
  - Can still track individual repo commits
- **Cons**:
  - ❌ **Complex**: Nested .git repos are confusing
  - ❌ **Fragile**: Submodules break easily
  - ❌ **Poor DX**: Developers forget to update submodules
  - ❌ **No unified history**: Can't see cross-repo changes in one commit

#### 2. **Git Subtree (Preserve History)**
- **Pros**:
  - Git history preserved in SoT
  - `git log` shows all commits from original repos
  - `git blame` works for original code
- **Cons**:
  - ❌ **Huge .git folder**: 53 repos × full history = 10-20GB .git
  - ❌ **Slow clones**: Initial clone takes 10+ minutes
  - ❌ **Messy history**: 53 repos of commit history mixed together
  - ❌ **Merge conflicts**: Pulling updates from 53 repos creates conflicts

#### 3. **Flattened Import (Chosen)**
- **Pros**:
  - ✅ **Clean structure**: No nested .git folders
  - ✅ **Fast clones**: .git folder stays small (~100MB vs 10GB)
  - ✅ **Simple workflow**: Just copy code, no git subtree complexity
  - ✅ **No merge conflicts**: Can't pull from source (one-way sync only)
  - ✅ **Unified history**: New commits in SoT show cross-repo changes
- **Cons**:
  - ⚠️ **History loss**: Can't `git blame` to see original commits
  - ⚠️ **One-time decision**: Hard to re-introduce history later

### Why Flattened

For 53 repositories:
- **Size**: .git with full history = 10-20GB, flattened = ~100MB (200x smaller)
- **Speed**: Clone time 15 min → 2 min (7.5x faster)
- **Simplicity**: No git subtree merge conflicts
- **Trade-off acceptable**: Original history still accessible in source repos

**History preservation strategy**:
- Original repos remain on GitHub with full history
- Developers can reference original commits if needed
- SoT focuses on *future* development, not archeology

---

## Consequences

### Positive

- ✅ **200x smaller .git**: Faster clones, less disk space
- ✅ **No nested repos**: Simpler mental model (one repo, one .git)
- ✅ **No merge conflicts**: Can't accidentally pull from source repos
- ✅ **Cleaner history**: SoT commits show unified cross-repo changes
- ✅ **Simpler imports**: Just `cp -r` instead of `git subtree add`

### Negative

- ⚠️ **No git blame**: Can't trace code back to original commits
- ⚠️ **No per-repo history**: `git log project/name/` only shows SoT commits
- ⚠️ **Reference required**: Must link to original repo for historical context

### Neutral

- ℹ️ **Workaround exists**: Add comments with original commit SHAs if needed
- ℹ️ **Can document**: README per project can link to original repo

---

## Implementation

### Import Process

```bash
# Clone original repo
git clone https://github.com/org/repo.git /tmp/repo

# Remove .git (flatten)
rm -rf /tmp/repo/.git

# Copy to SoT
cp -r /tmp/repo projects/org/repo

# Commit to SoT
git add projects/org/repo
git commit -m "feat: import org/repo (flattened)"
```

### Automated Script

```bash
# scripts/import-github-repos.sh
import_repo() {
    local url=$1
    local target=$2

    git clone --depth 1 "$url" "/tmp/import"
    rm -rf "/tmp/import/.git"
    mv "/tmp/import" "$target"

    echo "✓ Imported: $target (flattened)"
}
```

### Documentation Strategy

For each imported project, add `README.md`:

```markdown
# Project Name

> Originally from: https://github.com/org/repo

**History**: See original repo for commit history pre-2025-10-27
**Current**: All new development happens in SoT monorepo
```

---

## References

- [Git Subtree vs Submodule](https://git-scm.com/book/en/v2/Git-Tools-Subtrees)
- [Monorepo History Trade-offs](https://monorepo.tools/)
- Related ADRs:
  - [ADR-0001: SoT Canonical Model](./0001-sot-canonical-model.md)
  - [ADR-0003: Turborepo Build System](./0003-turborepo-build-system.md)

---

## Revision History

| Date | Author | Change |
|------|--------|--------|
| 2025-10-27 | @Krosebrook | Initial version |
