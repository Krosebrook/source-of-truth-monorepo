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
# View help and available options
./scripts/import-github-repos.sh --help
```

The enhanced script supports:

- **Batch operations**: Process repos in configurable batches (20-50 repos)
- **Custom repo lists**: Use external files instead of hardcoded lists
- **Resume capability**: Continue from last checkpoint after failures
- **Logging**: Detailed logs saved to `logs/import-TIMESTAMP.log`
- **Filtering**: Exclude archived/deprecated repositories

### Step 2: Prepare Your Repo List

The script uses `scripts/repo-list.txt` by default. Format:

```
org|name|url|target_dir|status

# Example entries:
krosebrook|FlashFusion|https://github.com/Krosebrook/FlashFusion.git|projects/krosebrook/core/flashfusion|active
krosebrook|OldProject|https://github.com/Krosebrook/OldProject.git|projects/krosebrook/archived/oldproject|archived
```

If the file doesn't exist, the script will create a default one with 50 repos.

### Step 3: Run the Import (Basic)

```bash
# Import all repos with defaults (batch size: 30)
./scripts/import-github-repos.sh
```

### Step 4: Advanced Usage Examples

**Import with custom batch size:**

```bash
# Process 20 repos at a time (good for rate limiting)
./scripts/import-github-repos.sh --batch-size 20
```

**Use a custom repo list:**

```bash
# Create your own list
cat > my-repos.txt <<EOF
myorg|repo1|https://github.com/myorg/repo1.git|projects/myorg/repo1|active
myorg|repo2|https://github.com/myorg/repo2.git|projects/myorg/repo2|active
EOF

# Import from custom list
./scripts/import-github-repos.sh --file my-repos.txt --batch-size 10
```

**Exclude archived repositories:**

```bash
# Skip any repos marked as 'archived' or 'deprecated'
./scripts/import-github-repos.sh --exclude-archived
```

**Resume from checkpoint:**

```bash
# If import fails partway through, resume from last success
./scripts/import-github-repos.sh --resume
```

**Custom log location:**

```bash
# Save logs to specific file
./scripts/import-github-repos.sh --log-file my-import.log
```

**Complete example (310+ repos):**

```bash
# Import 310 repos in batches of 25, excluding archived ones
./scripts/import-github-repos.sh \
  --file scripts/repo-list.txt \
  --batch-size 25 \
  --exclude-archived \
  --log-file logs/bulk-import.log
```

### Step 5: Monitor Progress

**What happens**:

1. Script reads repository list from file
2. Processes repos in batches (default: 30 at a time)
3. Clones each repo (--depth 1 for speed)
4. Removes .git directory (flattens)
5. Moves to target directory
6. Saves checkpoint after each successful import
7. Shows progress with colored output
8. Logs everything to file

**Expected output**:

```
=== FlashFusion SoT GitHub Repo Importer ===
Started at: 2025-11-01 12:00:00
Repo list: scripts/repo-list.txt
Batch size: 30
Resume mode: false
Exclude archived: false
Log file: logs/import-20251101_120000.log

ℹ Total repositories to process: 310

ℹ Importing FlashFusion from krosebrook...
✓ Success: FlashFusion -> projects/krosebrook/core/flashfusion

ℹ Importing Flashfusionwebsite from krosebrook...
✓ Success: Flashfusionwebsite -> projects/krosebrook/core/flashfusionwebsite

...

ℹ Completed batch 1 (30 repos)
ℹ Pausing for 2 seconds before next batch...

...

=== Import Summary ===
Completed at: 2025-11-01 14:30:00
✓ Success: 285
⊙ Skipped: 20
✗ Failed: 5
Total processed: 310

Log file: logs/import-20251101_120000.log
```

### Step 6: Handle Failures

If some imports fail:

```bash
# Review the log file for errors
cat logs/import-20251101_120000.log | grep ERROR

# Resume from the last successful import
./scripts/import-github-repos.sh --resume

# The script will skip already-imported repos and continue
```

### Step 7: Commit Imported Repos

```bash
git add projects/
git status  # Review what was imported

git commit -m "feat: Import GitHub repositories (batch 1)

Imported 285 repositories from:
- Krosebrook (200+ repos)
- flashfusionv1 (40+ repos)
- ChaosClubCo (45+ repos)

All repos flattened (no git history).
See logs/import-20251101_120000.log for details.

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

### Import script hangs or times out

```bash
# Reduce batch size to avoid rate limiting
./scripts/import-github-repos.sh --batch-size 10

# Or add delays between batches by editing the script
```

### Need to restart import from scratch

```bash
# Remove checkpoint file
rm -f .import-checkpoint

# Start fresh
./scripts/import-github-repos.sh
```

### Review logs for specific errors

```bash
# View all errors
grep ERROR logs/import-*.log

# View last import log
ls -t logs/import-*.log | head -1 | xargs cat

# Count successes and failures
grep -c SUCCESS logs/import-20251101_120000.log
grep -c ERROR logs/import-20251101_120000.log
```

---

**Need help?** [Open an issue](https://github.com/Krosebrook/source-of-truth-monorepo/issues) or see [Troubleshooting Guide](/docs/how-to/troubleshoot-workspace-issues.md)
