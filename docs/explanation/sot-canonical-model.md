# Understanding the SoT Canonical Model

> Conceptual explanation of the Source-of-Truth architecture

**Type**: Explanation
**Audience**: Developers, architects
**Last Updated**: 2025-10-27

---

## The Problem: Repository Drift

Before the SoT monorepo, we had **53 repositories** across 4 GitHub organizations:

- Krosebrook (100+ repos)
- flashfusionv1 (15 repos)
- ChaosClubCo (34 repos)
- Local repositories (no GitHub remote)

### What Went Wrong

1. **Drift**: Changes in one repo weren't reflected in others
2. **Duplication**: Same utility code copy-pasted across repos
3. **Review chaos**: PRs scattered across 53 repos
4. **Version confusion**: No way to know "what's deployed together"
5. **Slow fixes**: Bug fix in shared code = 53 PRs

**Example scenario**:

```
Day 1: Fix logging bug in flashfusion repo
Day 2: Discover same bug in dashboard repo
Day 3: Discover same bug in 10 other repos
Day 4: Give up, live with bugs
```

---

## The Solution: Source-of-Truth Canonical

**One repository is authoritative (the "SoT")**. All others are read-only "mirrors" that receive changes via automation.

```
     ┌────────────────────────┐
     │  SoT Monorepo (Main)   │ ← All development happens here
     │  53 projects unified   │
     └───────────┬────────────┘
                 │
        ┌────────┴────────┐
        │   git subtree   │ (automated in CI)
        │      split      │
        └────────┬────────┘
                 │
     ┌───────────┴────────────────┐
     │                            │
     ▼                            ▼
┌─────────┐               ┌──────────┐
│ Mirror  │               │ Mirror   │
│ Repo 1  │      ...      │ Repo 53  │
└─────────┘               └──────────┘
(Read-only for users)     (Read-only)
```

### Key Principles

1. **Single source of truth**: The SoT monorepo is authoritative
2. **Unidirectional flow**: Changes flow SoT → mirrors (never mirror → SoT)
3. **Automated sync**: CI pushes to mirrors on merge to `main`
4. **Read-only mirrors**: Downstream users can clone mirrors, but can't commit
5. **Force-push mirrors**: Mirrors always match SoT exactly

---

## How It Works

### Development Workflow

```bash
# 1. Developer clones SoT
git clone git@github.com:Krosebrook/source-of-truth-monorepo.git

# 2. Make changes anywhere in the monorepo
cd projects/krosebrook/core/flashfusion
# ... edit code ...

# 3. Create PR to SoT
git add .
git commit -m "feat: new feature"
git push
gh pr create

# 4. After merge, CI automatically pushes to mirror
# (happens in GitHub Actions)
```

### Mirror Synchronization (Automated)

```yaml
# .github/workflows/subtree-push.yml
on:
  push:
    branches: [main]

jobs:
  sync-mirrors:
    runs-on: ubuntu-latest
    steps:
      # For each project, split and push to mirror
      - name: Push to flashfusion mirror
        run: |
          git subtree split --prefix=projects/krosebrook/core/flashfusion -b temp
          git push git@github.com:Krosebrook/FlashFusion.git temp:main --force
          git branch -D temp
```

**Result**: Mirror repos always match SoT exactly.

---

## Why This Model?

### Advantages

#### 1. **No Drift**

Impossible for repos to diverge. Mirrors always match SoT.

#### 2. **Atomic Cross-Repo Changes**

Refactor shared utility → affects all 53 projects in one commit:

```bash
# Before SoT: 53 PRs
PR #1: Update logging in flashfusion
PR #2: Update logging in dashboard
... (51 more PRs)

# With SoT: 1 PR
PR #1: Update logging in shared/logging/ (affects all 53 projects)
```

#### 3. **Unified Review**

All code reviews in one repo with CODEOWNERS:

```
# .github/CODEOWNERS
/projects/krosebrook/core/flashfusion/ @Krosebrook
/shared/ @Krosebrook
```

#### 4. **Turbo Caching**

Build cache shared across all 53 projects. First build: 20 min. Cached: <1 min.

#### 5. **Easier Refactors**

Move code between projects without losing git history (all in one repo).

### Trade-offs

#### 1. **Larger Clone**

~2GB initial download vs individual repos (50-200MB each).

**Mitigation**: pnpm sparse checkout (future enhancement).

#### 2. **Force-Push Risk**

Direct commits to mirrors are overwritten.

**Mitigation**: Branch protection + CI warnings.

#### 3. **Learning Curve**

Team must adopt "never commit to mirrors" discipline.

**Mitigation**: Clear documentation (this guide!).

---

## Alternative Models (Why Not These?)

### 1. Polyrepo (Separate Repos)

```
flashfusion repo ←→ dashboard repo ←→ tools repo
(drift continues)
```

**Why not**: Drift problem remains unsolved.

### 2. Leaf-Authoritative (Repos Pull to SoT)

```
flashfusion repo → SoT ← dashboard repo
(SoT pulls from 53 sources)
```

**Why not**: Merge conflicts from 53 repos are unmanageable.

### 3. Git Submodules

```
SoT repo
├── projects/flashfusion/ (git submodule)
├── projects/dashboard/   (git submodule)
└── ... (51 more submodules)
```

**Why not**: Submodules are fragile, poor DX, complex updates.

---

## Common Questions

### Q: What if I need to hotfix a mirror?

**A**: Don't commit to the mirror. Commit to SoT and push immediately:

```bash
# 1. Commit to SoT
git add projects/org/repo
git commit -m "hotfix: critical bug"
git push

# 2. Manually trigger mirror sync (or wait for CI)
gh workflow run subtree-push.yml
```

### Q: Can I clone just one mirror repo?

**A**: Yes! Mirrors are normal GitHub repos. Downstream users can clone them without knowing about SoT.

```bash
# User who just wants flashfusion
git clone git@github.com:Krosebrook/FlashFusion.git
```

They get a working repo, but if they commit, changes will be overwritten on next SoT sync.

### Q: What if I accidentally commit to a mirror?

**A**: The commit will be overwritten on next SoT sync. To preserve it:

1. Cherry-pick to SoT:
   ```bash
   git cherry-pick <commit-hash>
   ```
2. Push to SoT
3. Next mirror sync will include your change

### Q: How do I know which repo is SoT vs mirror?

**A**: README in each mirror repo states:

```markdown
# FlashFusion

> 🔁 This is a mirror of the SoT monorepo
> All development happens at: github.com/Krosebrook/source-of-truth-monorepo
> Do not commit directly to this repo.
```

---

## Real-World Analogy

Think of SoT like **Wikipedia**:

- **Wikipedia (SoT)**: The authoritative source. All edits happen here.
- **Mirror sites**: Read-only copies for fast access in different regions.

If you edit a mirror, your changes disappear on next sync (because Wikipedia is the source of truth).

---

## Implementation Details

### Git Subtree Split

```bash
# Extract one project's history into a branch
git subtree split --prefix=projects/org/repo -b temp-branch

# Push to mirror repo
git push git@github.com:org/repo.git temp-branch:main --force

# Clean up
git branch -D temp-branch
```

**What this does**:

- Creates a branch containing only files from `projects/org/repo/`
- As if the project was always a standalone repo
- Pushes to mirror, replacing its entire history

### Why Force Push?

```bash
git push --force
```

**Because**: Mirrors must exactly match SoT. No merge, no negotiation.

**Safety**: Mirrors are read-only for users, so force-push is safe.

---

## See Also

- [ADR-0001: SoT Canonical Model](/docs/adr/0001-sot-canonical-model.md) - The decision
- [Git Subtree Explained](/docs/explanation/git-subtree-explained.md) - Technical deep-dive
- [Monorepo vs Polyrepo](/docs/explanation/monorepo-vs-polyrepo.md) - Comparisons
- [Workspace Structure](/docs/reference/workspace-structure.md) - How SoT is organized

---

**Last Updated**: 2025-10-27 | **Maintainer**: @Krosebrook
