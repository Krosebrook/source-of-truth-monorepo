# Tutorial: Importing Repositories

> Learn how to add new repositories to the SoT monorepo

**Time**: 20 minutes
**Level**: Intermediate
**Prerequisites**: [Quickstart Tutorial](/docs/tutorials/01-quickstart.md)

---

## What You'll Learn

- How to import a GitHub repository
- How to import a local repository
- How the automated import script works
- How to handle import conflicts

---

## Two Import Methods

### Method 1: Automated Script (GitHub Repos)

Best for: Importing multiple GitHub repositories

### Method 2: Manual Import (Local Repos)

Best for: Importing local directories or single repos

---

## Method 1: Automated Import (GitHub)

### Step 1: Review the Import Script

```bash
cat scripts/import-github-repos.sh
```

The script imports 50 repositories from GitHub organizations.

### Step 2: Run the Import

```bash
cd /home/kyler/source-of-truth-monorepo
./scripts/import-github-repos.sh
```

**What happens**:
1. Script reads repository list from embedded config
2. Clones each repo (--depth 1 for speed)
3. Removes .git directory (flattens)
4. Moves to `projects/org/name/`
5. Shows progress (✓ success, ⊙ skipped, ✗ failed)

**Expected output**:
```
=== FlashFusion SoT GitHub Repo Importer ===

Importing FlashFusion from krosebrook...
✓ Success: projects/krosebrook/core/flashfusion

Importing Flashfusionwebsite from krosebrook...
✓ Success: projects/krosebrook/core/flashfusionwebsite

...

=== Import Summary ===
✓ Success: 50
⊙ Skipped: 0
✗ Failed: 0
```

### Step 3: Commit Imported Repos

```bash
git add projects/
git status  # Review what was imported

git commit -m "feat: Import 50 GitHub repositories

Imported from:
- Krosebrook (34 repos)
- flashfusionv1 (8 repos)
- ChaosClubCo (8 repos)

All repos flattened (no git history).

🤖 Generated with Claude Code (https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>"

git push
```

---

## Method 2: Manual Import (Local/Single Repo)

### Step 1: Clone or Locate Repository

```bash
# For GitHub repos
git clone --depth 1 https://github.com/org/repo.git /tmp/repo-to-import

# For local repos, just note the path
# Example: /home/user/my-local-project
```

### Step 2: Remove Git History (Flatten)

```bash
# Remove .git directory
rm -rf /tmp/repo-to-import/.git

# Or for local repo
rm -rf /home/user/my-local-project/.git
```

**Why flatten?** See [ADR-0005: Flattened Repos](/docs/adr/0005-flattened-repos.md)
- Smaller .git folder (200x smaller)
- Faster clones
- No nested repo confusion

### Step 3: Copy to SoT

```bash
# Decide where it goes in the structure:
# projects/local/      - Local-only repos
# projects/krosebrook/ - Krosebrook org repos
# projects/org-name/   - Other orgs

# Example: Import to local
cp -r /tmp/repo-to-import projects/local/my-new-project

# Or move instead of copy
mv /tmp/repo-to-import projects/local/my-new-project
```

### Step 4: Clean Up Large Files

```bash
cd projects/local/my-new-project

# Remove node_modules (if present)
rm -rf node_modules

# Remove build artifacts
rm -rf dist build out .next

# Remove IDE files (optional)
rm -rf .vscode .idea
```

### Step 5: Verify Structure

```bash
# Check package.json exists
ls projects/local/my-new-project/package.json

# Check no .git directory
ls -la projects/local/my-new-project/ | grep -v ".git"
```

### Step 6: Commit to SoT

```bash
git add projects/local/my-new-project
git commit -m "feat: Import my-new-project (local)

Imported from: /home/user/my-local-project
Flattened: yes (no git history)
Size: 150MB"

git push
```

---

## Handling Import Conflicts

### Conflict: Repo Already Exists

```bash
# The import script will skip automatically
⊙ Skipped (already exists): projects/org/repo
```

### Conflict: Large Binary Files

```bash
# After import, check for large files
find projects/org/repo -type f -size +10M

# Remove or move to Git LFS
# (Future enhancement: automatic LFS detection)
```

### Conflict: Different Package Manager

If imported repo uses npm/yarn:

```bash
# Remove old lockfiles
find projects/org/repo -name "package-lock.json" -delete
find projects/org/repo -name "yarn.lock" -delete

# pnpm will create pnpm-lock.yaml on next install
```

---

## Adding to Workspace

After import, the repo is automatically part of the workspace:

```bash
# Verify it's recognized
pnpm -r list | grep my-new-project

# Install its dependencies
pnpm install

# Build it
pnpm --filter my-new-project build
```

**Note**: `pnpm-workspace.yaml` uses `projects/**/*` which catches all subdirectories.

---

## Verification

```bash
# Check workspace includes new project
pnpm -r list

# Try building it
pnpm --filter my-new-project build

# Check Turbo recognizes it
pnpm build --dry-run --filter=my-new-project
```

---

## What You Learned

- ✅ Imported repos with automated script (`./scripts/import-github-repos.sh`)
- ✅ Manually imported single repo (clone, flatten, copy, commit)
- ✅ Handled conflicts (skip existing, clean large files)
- ✅ Verified workspace inclusion (`pnpm -r list`)

---

## Next Steps

- [Publishing Packages](/docs/tutorials/04-publishing-packages.md) - Release imported projects
- [How to Configure CI/CD](/docs/how-to/configure-ci-cd.md) - Add CI for new projects
- [Workspace Structure](/docs/reference/workspace-structure.md) - Understand layout

---

## Troubleshooting

### "Permission denied" on import script

```bash
chmod +x scripts/import-github-repos.sh
./scripts/import-github-repos.sh
```

### "fatal: could not read Username for GitHub"

```bash
# Authenticate with GitHub CLI
gh auth login

# Or use SSH keys
git config --global user.name "Your Name"
git config --global user.email "your@email.com"
```

### "Project not recognized by pnpm"

```bash
# Reinstall to rebuild workspace links
pnpm install

# Verify pnpm-workspace.yaml includes the path
cat pnpm-workspace.yaml
```

---

**Need help?** [Open an issue](https://github.com/Krosebrook/source-of-truth-monorepo/issues) or see [Troubleshooting Guide](/docs/how-to/troubleshoot-workspace-issues.md)
