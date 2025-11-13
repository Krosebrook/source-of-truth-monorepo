# Git Subtree Explained

> Deep dive into how Git subtree works and why we use it for mirror synchronization

**Type**: Explanation  
**Audience**: Advanced developers, architects  
**Last Updated**: 2025-11-01

---

## What is Git Subtree?

Git subtree is a Git command that allows you to extract a subdirectory's history into a separate branch, or merge
a separate repository into a subdirectory. It's part of the core Git distribution (unlike submodules which require
special handling).

### The Two Main Operations

#### 1. Subtree Split (What We Use)

Extract a subdirectory as if it was always a standalone repository:

```bash
git subtree split --prefix=path/to/directory -b new-branch
```

#### 2. Subtree Add/Merge (Not Used in SoT)

Merge an external repository into a subdirectory:

```bash
git subtree add --prefix=path/to/directory repo-url branch
```

**For SoT monorepo**: We only use `split` to create mirror repositories from subdirectories.

---

## How Subtree Split Works

### The Problem It Solves

You have a monorepo like this:

```text
source-of-truth-monorepo/
├── projects/
│   ├── flashfusion/
│   │   ├── src/
│   │   ├── tests/
│   │   └── package.json
│   └── archon/
│       ├── app/
│       └── README.md
└── shared/
    └── utils/
```

You want to create a standalone repository for `flashfusion` that:

- Contains only `flashfusion/` files (not `archon/` or `shared/`)
- Has complete git history for those files
- Shows commits as if `flashfusion` was always at the root
- Doesn't include commits that never touched `flashfusion/`

**Git subtree split** does exactly this.

### The Technical Process

#### Step 1: Identify Relevant Commits

```bash
git subtree split --prefix=projects/flashfusion -b flashfusion-split
```

Git walks through the entire commit history and identifies commits that:

- Modified files in `projects/flashfusion/`
- Have ancestors that modified those files
- Are reachable from the current branch

**Example**:

```text
Monorepo history:
A - B - C - D - E - F - G (main)
    │   │       │   │
    │   │       │   └─ Changes archon/
    │   │       └───── Changes flashfusion/
    │   └─────────────  Changes shared/
    └─────────────────  Changes flashfusion/

Commits touching flashfusion: B, E

Result branch (flashfusion-split):
B' - E' (only flashfusion commits, renumbered)
```

#### Step 2: Rewrite Paths

For each identified commit, Git rewrites the file paths:

**Original commit B**:

```text
Modified files:
  - projects/flashfusion/src/main.ts
  - projects/flashfusion/package.json
```

**Split commit B'**:

```text
Modified files:
  - src/main.ts
  - package.json
```

The `projects/flashfusion/` prefix is removed, making it appear as if these files were always at the repository root.

#### Step 3: Preserve Commit Metadata

The split commits retain:

- Original commit messages
- Original author and date
- Original commit relationships (parent/child)

But get new:

- Commit SHAs (because file paths changed)
- Tree objects (new directory structure)

#### Step 4: Create New Branch

The result is a new branch (`flashfusion-split`) containing:

- Only commits affecting `projects/flashfusion/`
- With paths rewritten to be root-relative
- With a new, independent commit history

---

## Under the Hood: The Algorithm

### Simplified Pseudocode

```python
def subtree_split(prefix, target_branch):
    relevant_commits = []

    # Walk all commits in current branch
    for commit in git_log():
        files_changed = commit.get_changed_files()

        # Check if any changed files are in our prefix
        if any(file.startswith(prefix) for file in files_changed):
            # Create new commit with paths rewritten
            new_commit = rewrite_commit(commit, prefix)
            relevant_commits.append(new_commit)

    # Create branch pointing to the new commit chain
    git_branch(target_branch, relevant_commits[-1])

    return target_branch

def rewrite_commit(original_commit, prefix):
    # Remove prefix from all file paths
    new_files = {}
    for path, content in original_commit.files.items():
        if path.startswith(prefix + '/'):
            new_path = path[len(prefix) + 1:]  # Remove "prefix/"
            new_files[new_path] = content

    # Create new commit with same metadata, new paths
    return Commit(
        files=new_files,
        message=original_commit.message,
        author=original_commit.author,
        date=original_commit.date,
        parents=[rewrite_commit(p, prefix) for p in original_commit.parents]
    )
```

### Real Implementation

Git's actual implementation is more sophisticated:

- Uses tree objects and blobs efficiently
- Handles merge commits correctly
- Optimizes using commit grafts
- Caches intermediate results

---

## Example: Real Split Operation

### Before Split

**Monorepo structure**:

```text
source-of-truth-monorepo/
└── projects/
    └── flashfusion/
        ├── src/
        │   └── main.ts
        └── package.json
```

**Commit history**:

```text
commit abc123 "Add new feature to flashfusion"
  Modified: projects/flashfusion/src/main.ts

commit def456 "Update shared utilities"
  Modified: shared/utils/logger.ts

commit ghi789 "Initialize flashfusion project"
  Modified: projects/flashfusion/package.json
```

### Execute Split

```bash
git subtree split --prefix=projects/flashfusion -b flashfusion-split
```

### After Split

**Split branch structure**:

```text
flashfusion-split/
├── src/
│   └── main.ts
└── package.json
```

**Split branch history**:

```text
commit xyz123 "Add new feature to flashfusion"
  Modified: src/main.ts

commit uvw456 "Initialize flashfusion project"
  Modified: package.json
```

**Note**: Commit `def456` (shared utilities) was excluded because it didn't touch `projects/flashfusion/`.

---

## Subtree Split vs Other Approaches

### Subtree Split vs Filter-Branch

#### Filter-Branch

```bash
git filter-branch --subdirectory-filter projects/flashfusion
```

**Similarities**:

- Both extract subdirectory history
- Both rewrite paths

**Differences**:

- **filter-branch**: Modifies current branch (destructive)
- **subtree split**: Creates new branch (non-destructive)
- **filter-branch**: Slower, rewrites all refs
- **subtree split**: Faster, targeted operation

**Why subtree**: Non-destructive, faster, designed for this use case.

### Subtree Split vs Submodules

#### Submodules

```bash
git submodule add git@github.com:Org/FlashFusion.git projects/flashfusion
```

**Submodules approach**:

- External repo linked into monorepo
- Monorepo contains pointer to specific commit
- Updates require explicit sync

**Subtree approach (SoT model)**:

- External repos are mirrors of monorepo subdirectories
- Monorepo is source of truth
- Updates automatic via CI

**Why subtree**: Unidirectional flow matches SoT canonical model.

### Subtree Split vs Mono-Repo Tools (Nx, Turborepo)

**Mono-repo tools**:

- Build/test orchestration
- Dependency graphs
- Caching strategies
- **Don't** extract standalone repositories

**Subtree split**:

- Extracts standalone repositories
- Maintains git history
- **Doesn't** help with builds/tests

**SoT uses both**: Turborepo for builds, subtree for mirrors.

---

## Why We Use Subtree Split

### Requirements for SoT Mirror Sync

1. ✅ **Preserve history**: Mirror repos need full git history
2. ✅ **Standalone repos**: Mirrors must work without monorepo
3. ✅ **Automated**: Must run in CI without manual intervention
4. ✅ **Root-level paths**: Mirror files at root (not nested)
5. ✅ **Read-only mirrors**: Overwrite mirrors on each sync

### How Subtree Meets Requirements

| Requirement       | How Subtree Satisfies                                |
| ----------------- | ---------------------------------------------------- |
| Preserve history  | Split includes all commits touching the subdirectory |
| Standalone repos  | Rewritten paths make it appear as standalone repo    |
| Automated         | Single command, no interaction needed                |
| Root-level paths  | `--prefix` removes monorepo directory nesting        |
| Read-only mirrors | Can force-push split branch to overwrite mirror      |

### Alternative Approaches Considered

#### 1. Manual Copying

```bash
cp -r projects/flashfusion/ /tmp/flashfusion
cd /tmp/flashfusion
git init
git add .
git commit -m "Sync from monorepo"
git push mirror
```

**Problems**:

- ❌ Loses git history
- ❌ Each sync is a single commit
- ❌ Can't track changes over time

#### 2. Git Subtree Add + Reverse

```bash
# In mirror repo
git subtree pull ../monorepo main --prefix=projects/flashfusion
```

**Problems**:

- ❌ Mirror becomes source of changes
- ❌ Violates SoT canonical model
- ❌ Requires bidirectional sync

#### 3. Sparse Checkout

```bash
git clone --filter=blob:none monorepo
git sparse-checkout set projects/flashfusion
```

**Problems**:

- ❌ Still contains full monorepo metadata
- ❌ Files remain under `projects/flashfusion/`
- ❌ Not truly standalone

**Winner**: Subtree split is the only approach that meets all requirements.

---

## Advanced Topics

### Subtree Split with Rejoin

For bidirectional sync (not used in SoT), subtree supports "rejoin":

```bash
# Split
git subtree split --prefix=projects/flashfusion -b flashfusion-split

# Push to external repo
git push external-repo flashfusion-split:main

# Later: Pull changes back from external repo
git subtree pull --prefix=projects/flashfusion external-repo main
```

**SoT doesn't use this**: Our mirrors are read-only, so we never pull changes back.

### Subtree Split Performance

**Time complexity**: O(n) where n = total commits in monorepo

**Optimizations**:

- Git caches split results
- Subsequent splits reuse cached data
- Only recomputes if new commits exist

**Typical performance**:

```text
Monorepo: 10,000 commits, 50 projects
Split operation: 5-10 seconds per project
Total sync (50 projects): 4-8 minutes
```

### Subtree Split Depth Limit

You can limit history depth:

```bash
git subtree split --prefix=projects/flashfusion --rejoin --onto=<commit>
```

**Use case**: Faster splits for mirrors that don't need full history.

**SoT doesn't use this**: We want complete history in mirrors.

---

## Common Gotchas

### 1. Subtree Split Doesn't Change Working Directory

```bash
git subtree split --prefix=projects/flashfusion -b split-branch
# Your working directory is UNCHANGED
# Only split-branch is created
```

To see the split result:

```bash
git checkout split-branch
```

### 2. Subtree Split Doesn't Push

```bash
git subtree split --prefix=projects/flashfusion -b split-branch
# This creates a local branch only
# Does NOT push to remote
```

To push:

```bash
git push mirror-repo split-branch:main
```

### 3. Empty Directories Are Ignored

Git doesn't track empty directories:

```bash
projects/flashfusion/
└── empty-dir/    # This won't appear in split

projects/flashfusion/
└── empty-dir/
    └── .gitkeep  # This will appear in split
```

### 4. Large Binary Files

Subtree split includes entire history:

```bash
projects/flashfusion/
└── large-file.bin (100 MB, changed 50 times)

Split result: Includes all 50 versions = 5 GB
```

**Solution**: Use Git LFS or avoid committing large binaries to monorepo.

### 5. Merge Commits

Subtree split preserves merge structure:

```text
Monorepo:
A - B - C - M - D
     \     /
      E - F

Split (if B,C,E,F touch projects/flashfusion):
A' - B' - C' - M' - D'
      \      /
       E' - F'
```

This is correct behavior, but can result in complex history.

---

## Debugging Subtree Operations

### Verify Split Contents

```bash
# Create split
git subtree split --prefix=projects/flashfusion -b test-split

# List files in split
git ls-tree -r test-split --name-only

# Expected: Files without "projects/flashfusion/" prefix
src/main.ts
package.json
README.md

# Not expected: Files from other projects
```

### Verify Split History

```bash
# View split commit history
git log test-split --oneline

# Compare with original
git log main -- projects/flashfusion/ --oneline

# Should have same commits (different SHAs)
```

### Verify Split Produces Standalone Repo

```bash
# Create temporary clone from split
git clone --bare . /tmp/test-repo.git
cd /tmp/test-repo.git
git symbolic-ref HEAD refs/heads/test-split

# Clone to verify
cd /tmp
git clone test-repo.git flashfusion-test
cd flashfusion-test

# Should see files at root level
ls -la
# src/ package.json README.md
```

### Debug Split Failures

**Common error**: "Could not create subtree split"

**Cause 1**: No commits touch the specified prefix

```bash
# Check if any commits touch the path
git log --all -- projects/flashfusion/

# If empty, the path has never been committed
```

**Cause 2**: Path doesn't exist

```bash
# Verify path exists
ls -la projects/flashfusion/

# Check current branch
git branch --show-current
```

---

## Best Practices

### 1. Always Use Full History

```bash
# Good: Include full history
git subtree split --prefix=projects/flashfusion -b split

# Avoid: Shallow split (unless you have a specific reason)
git subtree split --prefix=projects/flashfusion --shallow -b split
```

**Why**: Mirrors should have complete history for debugging and git blame.

### 2. Use Descriptive Branch Names

```bash
# Good: Include timestamp and path
BRANCH="split-$(echo projects/flashfusion | tr '/' '-')-$(date +%s)"
git subtree split --prefix=projects/flashfusion -b "$BRANCH"

# Avoid: Reusing branch names
git subtree split --prefix=projects/flashfusion -b split
```

**Why**: Unique names prevent conflicts in automated workflows.

### 3. Clean Up Temporary Branches

```bash
git subtree split --prefix=projects/flashfusion -b temp
git push mirror-repo temp:main
git branch -D temp  # Always clean up
```

**Why**: Prevents branch accumulation in CI runners.

### 4. Use --force-with-lease for Safety

```bash
# Good: Safe force push
git push mirror-repo split:main --force-with-lease

# Avoid: Unconditional force push
git push mirror-repo split:main --force
```

**Why**: Detects unexpected changes in mirror (e.g., manual commits).

---

## Workflow Integration

### In GitHub Actions

```yaml
- name: Create subtree split
  run: |
    SPLIT_BRANCH="split-flashfusion-${{ github.run_number }}"
    git subtree split --prefix=projects/flashfusion -b "$SPLIT_BRANCH"

    # Push to mirror
    git push git@github.com:Org/FlashFusion.git \
      "$SPLIT_BRANCH:main" \
      --force-with-lease

    # Clean up
    git branch -D "$SPLIT_BRANCH"
```

### With SSH Deploy Keys

```yaml
- name: Configure SSH
  run: |
    mkdir -p ~/.ssh
    echo "${{ secrets.DEPLOY_KEY }}" > ~/.ssh/deploy_key
    chmod 600 ~/.ssh/deploy_key

    export GIT_SSH_COMMAND="ssh -i ~/.ssh/deploy_key"

    # Now subtree push will use this key
    git subtree split --prefix=projects/flashfusion -b split
    git push git@github.com:Org/FlashFusion.git split:main
```

---

## Performance Characteristics

### Time Complexity

| Operation                 | Complexity        | Typical Time |
| ------------------------- | ----------------- | ------------ |
| First split               | O(n) commits      | 5-15 seconds |
| Subsequent split (cached) | O(m) new commits  | 1-5 seconds  |
| Force push                | O(k) size of repo | 2-10 seconds |

### Space Complexity

**Temporary storage**: Split branch requires space for rewritten commits.

**Estimate**:

```bash
Split size ≈ (number of commits touching path) × (average commit size)

Example:
1000 commits × 50 KB = 50 MB temporary storage
```

**CI Impact**: Minimal - runners have sufficient disk space.

### Optimization Techniques

#### 1. Cache Split Results (Git Does This Automatically)

```bash
# First split: slow
git subtree split --prefix=projects/flashfusion -b split1

# Second split: fast (uses cache)
git subtree split --prefix=projects/flashfusion -b split2
```

#### 2. Limit Split Depth (Not Recommended)

```bash
# Only include last 100 commits
git subtree split --prefix=projects/flashfusion --rejoin --onto=HEAD~100 -b split
```

#### 3. Parallelize Multiple Splits

```yaml
strategy:
  matrix:
    project: [flashfusion, archon, dyad]

steps:
  - run: git subtree split --prefix=projects/${{ matrix.project }} -b split
```

---

## Related Commands

### git filter-repo (Alternative)

Modern alternative to filter-branch:

```bash
git filter-repo --subdirectory-filter projects/flashfusion
```

**When to use**: One-time repository extractions.  
**Why not for SoT**: Requires extra installation, subtree is built-in.

### git read-tree (Low-level)

Used internally by subtree:

```bash
git read-tree --prefix=projects/flashfusion external-repo/main
```

**When to use**: Advanced tree manipulation.  
**Why not for SoT**: Too low-level, subtree is higher-level abstraction.

---

## Further Reading

### Git Documentation

- [git-subtree(1) Manual Page](https://git-scm.com/docs/git-subtree)
- [Git Subtree Tutorial](https://www.atlassian.com/git/tutorials/git-subtree)

### Related SoT Documentation

- [Subtree Sync Reference](/docs/reference/subtree-sync.md) - Workflow implementation
- [SoT Canonical Model](/docs/explanation/sot-canonical-model.md) - Architecture
- [How to Configure Deploy Keys](/docs/how-to/configure-deploy-keys.md) - Setup guide

### External Resources

- [Git Subtree vs Submodule](https://stackoverflow.com/questions/31769820/differences-between-git-submodule-and-subtree)
- [Git Internals - Tree Objects](https://git-scm.com/book/en/v2/Git-Internals-Git-Objects)

---

## Summary

**Git subtree split**:

- Extracts subdirectory history into standalone branch
- Rewrites paths to be root-relative
- Preserves commits, authors, dates, messages
- Non-destructive (creates new branch)
- Designed for creating mirror repositories

**Perfect for SoT because**:

- Automated (one command, no interaction)
- Preserves full git history
- Creates truly standalone repositories
- Supports force-push (mirrors are read-only)
- Built into Git (no extra dependencies)

**In practice**:

```bash
# The core operation powering our 50 mirror repos
git subtree split --prefix=projects/org/repo -b split
git push mirror-url split:main --force-with-lease
git branch -D split
```

---

**Last Updated**: 2025-11-01  
**Maintainer**: @Krosebrook  
**Complexity**: Advanced
