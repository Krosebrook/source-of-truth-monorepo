# Mirror Repository Best Practices

> Guidelines for managing and working with mirror repositories in the SoT model

## Table of Contents

- [Understanding Mirror Repositories](#understanding-mirror-repositories)
- [SoT Canonical Model](#sot-canonical-model)
- [Mirror Synchronization](#mirror-synchronization)
- [Working with Mirrors](#working-with-mirrors)
- [Common Scenarios](#common-scenarios)
- [Troubleshooting](#troubleshooting)

---

## Understanding Mirror Repositories

### What Are Mirror Repositories?

**Mirror repositories** are downstream copies of projects in the Source-of-Truth (SoT) monorepo. They serve as:

- **Distribution points** for individual projects
- **Public interfaces** for external contributors
- **Standalone repositories** for projects that need independent visibility

### Key Characteristics

✅ Mirrors are:
- Automatically synced from the monorepo
- Read-only for external users (unless configured otherwise)
- Contain only a single project's code
- Have independent GitHub issues/PRs (if configured)

❌ Mirrors are NOT:
- The primary development location
- Independent forks with divergent code
- Where changes should be committed directly

---

## SoT Canonical Model

### The One-Way Flow

```
┌─────────────────────────────┐
│  Source-of-Truth Monorepo   │
│  (Primary Development)      │
└──────────────┬──────────────┘
               │
               │ Automated sync (git subtree)
               ▼
     ┌─────────────────────┐
     │  Mirror Repository  │
     │  (Read-only)        │
     └─────────────────────┘
```

### Core Principles

1. **Single Source of Truth**
   - All development happens in the monorepo
   - Mirrors receive changes via automated CI/CD
   - No manual syncing required

2. **Atomic Consistency**
   - Cross-project changes are atomic in monorepo
   - Mirrors update together after merge
   - No partial states

3. **Traceability**
   - All changes originate in monorepo PRs
   - Full history preserved in monorepo
   - Mirror commits reference monorepo commits

---

## Mirror Synchronization

### How Sync Works

The subtree-push workflow automatically syncs changes:

1. **Trigger**: Push to `main` branch in monorepo
2. **Split**: Extract project subtree using `git subtree split`
3. **Push**: Push split to mirror repository
4. **Verify**: Check sync status in GitHub Actions

### Sync Configuration

Each mirror is configured in `.github/workflows/subtree-push.yml`:

```yaml
- path: projects/krosebrook/core/flashfusion
  repo: git@github.com:Krosebrook/FlashFusion.git
  branch: main
  ssh_key_secret: MIRROR_SSH_KEY_FLASHFUSION
```

**Configuration fields**:
- `path`: Path in monorepo
- `repo`: Mirror repository URL
- `branch`: Target branch (usually `main`)
- `ssh_key_secret`: Deploy key secret name

### Deploy Keys

Each mirror requires a unique SSH deploy key:

1. **Generate keys**:
   ```bash
   ./scripts/generate-deploy-keys.sh
   ```

2. **Add public keys to mirrors**:
   ```bash
   # Via GitHub CLI
   gh repo deploy-key add key.pub \
     --repo org/repo \
     --title "SoT Monorepo Sync" \
     --allow-write
   ```

3. **Add private keys to monorepo secrets**:
   ```bash
   ./scripts/add-secrets-to-github.sh
   ```

**See also**: [Configure Deploy Keys Guide](/docs/how-to/configure-deploy-keys.md)

---

## Working with Mirrors

### For Monorepo Contributors

✅ **DO**:
- Make all changes in the monorepo
- Create PRs against the monorepo
- Let CI handle mirror updates
- Reference mirror issues in monorepo PRs

❌ **DON'T**:
- Clone mirror repos for development
- Push directly to mirrors
- Try to manually sync mirrors

**Example workflow**:
```bash
# 1. Work in monorepo
cd source-of-truth-monorepo
git checkout -b feature/new-feature

# 2. Make changes to project
vim projects/krosebrook/core/flashfusion/src/feature.ts

# 3. Test locally
pnpm --filter flashfusion build
pnpm --filter flashfusion test

# 4. Create PR in monorepo
git add .
git commit -m "feat(flashfusion): add new feature"
pnpm changeset
git push origin feature/new-feature

# 5. After PR merge, CI syncs to mirror automatically
```

### For External Contributors

If mirrors accept external contributions:

1. **Check contribution guidelines** in mirror repo
2. **Fork the mirror** (not the monorepo)
3. **Create PR against mirror**
4. **Maintainer syncs to monorepo**:
   ```bash
   cd source-of-truth-monorepo
   git checkout -b external-pr-123
   
   # Apply changes from mirror PR
   cd projects/org/repo
   git cherry-pick <mirror-commit>
   
   # Create monorepo PR
   cd ../../../
   git add projects/org/repo
   git commit -m "feat: external contribution from mirror PR #123"
   ```

### For Mirror Maintainers

**Responsibilities**:
- Keep deploy keys rotated (every 6 months)
- Monitor sync status in GitHub Actions
- Triage issues in mirror repos
- Migrate valuable external PRs to monorepo

**Monthly checklist**:
- [ ] Review failed sync runs
- [ ] Check mirror repository settings
- [ ] Verify deploy keys are valid
- [ ] Update mirror README if needed

---

## Common Scenarios

### Scenario 1: Adding a New Mirror

**Steps**:

1. **Import project to monorepo** (if not already there):
   ```bash
   # Place in appropriate directory
   cp -r /path/to/project projects/org/name/
   ```

2. **Generate deploy key**:
   ```bash
   ssh-keygen -t ed25519 -f mirror-key-name -C "SoT sync for org/name"
   ```

3. **Add public key to mirror repo**:
   ```bash
   gh repo deploy-key add mirror-key-name.pub \
     --repo org/name \
     --title "SoT Monorepo Sync" \
     --allow-write
   ```

4. **Add private key to monorepo secrets**:
   ```bash
   gh secret set MIRROR_SSH_KEY_NAME < mirror-key-name
   ```

5. **Update workflow configuration**:
   ```yaml
   # In .github/workflows/subtree-push.yml
   - path: projects/org/name
     repo: git@github.com:org/name.git
     branch: main
     ssh_key_secret: MIRROR_SSH_KEY_NAME
   ```

6. **Test sync**:
   ```bash
   gh workflow run subtree-push.yml \
     --field path="projects/org/name" \
     --field repo="git@github.com:org/name.git"
   ```

### Scenario 2: Removing a Mirror

**Steps**:

1. **Remove from workflow**:
   ```yaml
   # Delete entry from .github/workflows/subtree-push.yml
   ```

2. **Remove deploy key from mirror**:
   ```bash
   gh repo deploy-key list --repo org/name
   gh repo deploy-key delete <key-id> --repo org/name
   ```

3. **Delete secret from monorepo**:
   ```bash
   gh secret delete MIRROR_SSH_KEY_NAME
   ```

4. **Archive or delete mirror** (if needed):
   ```bash
   gh repo archive org/name
   # or
   gh repo delete org/name
   ```

### Scenario 3: Handling Sync Failures

**Common causes**:
- Deploy key expired or invalid
- Merge conflicts in mirror
- Network issues
- Repository access issues

**Troubleshooting steps**:

1. **Check GitHub Actions logs**:
   ```bash
   gh run list --workflow=subtree-push.yml
   gh run view <run-id> --log
   ```

2. **Verify deploy key**:
   ```bash
   gh repo deploy-key list --repo org/name
   # Check "Allow write access" is enabled
   ```

3. **Test SSH connection**:
   ```bash
   ssh -T git@github.com
   ```

4. **Manual sync** (if automated sync fails):
   ```bash
   git subtree split --prefix=projects/org/name -b temp-split
   git push git@github.com:org/name.git temp-split:main --force
   git branch -D temp-split
   ```

### Scenario 4: Syncing Selective Changes

**Need**: Only sync specific commits to mirror

**Approach**:

1. **Use manual workflow trigger**:
   ```bash
   gh workflow run subtree-push.yml \
     --field path="projects/org/name" \
     --field repo="git@github.com:org/name.git" \
     --field ref="specific-commit-sha"
   ```

2. **Cherry-pick to mirror**:
   ```bash
   # Clone mirror
   git clone git@github.com:org/name.git
   cd name
   
   # Cherry-pick from monorepo
   git remote add monorepo https://github.com/org/monorepo.git
   git fetch monorepo
   git cherry-pick <commit-sha>
   git push origin main
   ```

---

## Troubleshooting

### Problem: "Permission denied (publickey)"

**Cause**: Deploy key not configured or incorrect

**Solution**:
1. Verify deploy key exists in mirror repo settings
2. Check "Allow write access" is enabled
3. Verify secret matches private key exactly
4. Regenerate key if needed

### Problem: "Updates were rejected (non-fast-forward)"

**Cause**: Mirror has diverged from monorepo

**Solution**:
```bash
# Force push (DESTRUCTIVE - use carefully)
git subtree split --prefix=projects/org/name -b temp-split
git push git@github.com:org/name.git temp-split:main --force
git branch -D temp-split
```

**Prevention**: Never commit directly to mirrors

### Problem: "Subtree split failed"

**Cause**: Shallow clone or missing history

**Solution**:
- Ensure `fetch-depth: 0` in workflow checkout
- Don't use shallow clones

### Problem: Mirror is out of sync

**Symptoms**: Mirror is behind monorepo by several commits

**Diagnosis**:
```bash
# Check last sync
gh run list --workflow=subtree-push.yml

# Check mirror commits
git log --oneline origin/main | head
cd projects/org/name
git log --oneline | head
```

**Solution**:
1. Review failed workflow runs
2. Fix underlying issue
3. Manually trigger sync:
   ```bash
   gh workflow run subtree-push.yml
   ```

### Problem: Circular dependency between monorepo and mirror

**Symptoms**: Changes in mirror not syncing to monorepo, and vice versa

**Solution**: This shouldn't happen with proper SoT model. If it does:
1. Determine canonical source (should be monorepo)
2. Force-push monorepo state to mirror
3. Update workflows to prevent direct mirror commits

---

## Best Practices Summary

### ✅ DO

- Develop in monorepo
- Let CI handle syncing
- Keep deploy keys secure and rotated
- Monitor sync status
- Document mirror-specific setup in mirror README

### ❌ DON'T

- Commit directly to mirrors (unless explicitly configured for external contributions)
- Manually sync unless absolutely necessary
- Share deploy keys across mirrors
- Ignore failed sync runs
- Fork mirrors for development

### ⚠️ BE CAREFUL

- Force-pushing to mirrors (destructive)
- Changing mirror branch structure
- Accepting external PRs (requires manual merge to monorepo)
- Disabling sync for long periods

---

## Quick Reference

### Sync Commands

```bash
# Manual sync trigger
gh workflow run subtree-push.yml

# Check sync status
gh run list --workflow=subtree-push.yml

# View sync logs
gh run view <run-id> --log

# Manual subtree split
git subtree split --prefix=projects/org/name -b temp-split
git push git@github.com:org/name.git temp-split:main
git branch -D temp-split
```

### Deploy Key Management

```bash
# Generate key
ssh-keygen -t ed25519 -f mirror-key-name

# Add to mirror
gh repo deploy-key add mirror-key-name.pub \
  --repo org/name \
  --title "SoT Sync" \
  --allow-write

# Add to monorepo secrets
gh secret set MIRROR_SSH_KEY_NAME < mirror-key-name

# List keys
gh repo deploy-key list --repo org/name

# Delete key
gh repo deploy-key delete <key-id> --repo org/name
```

---

## Related Documentation

- [Configure Deploy Keys](/docs/how-to/configure-deploy-keys.md)
- [SoT Canonical Model](/docs/explanation/sot-canonical-model.md)
- [Importing Repositories](/docs/tutorials/02-importing-repos.md)
- [Monorepo Best Practices](./monorepo-best-practices.md)

---

**Last updated**: 2025-11-01  
**Maintained by**: FlashFusion SoT Team
