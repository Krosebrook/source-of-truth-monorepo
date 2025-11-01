# Deploy Keys Activation Guide

> **Quick start guide for activating the mirror repository synchronization system**

**Estimated Time**: 2 hours (one-time setup)  
**Prerequisites**: Admin access to all 50 mirror repositories  
**Status**: Infrastructure ready, awaiting activation

---

## Overview

The deploy keys infrastructure is **fully implemented and ready for activation**. All scripts, documentation, and workflows are in place. This guide walks you through the activation process.

### What's Already Done ✅

- ✅ 50 mirror repositories identified and mapped
- ✅ Subtree-push workflow configured with all mirrors
- ✅ Automated key generation script created
- ✅ Automated secret upload script created
- ✅ Comprehensive documentation written
- ✅ Security best practices documented
- ✅ Key rotation policy defined

### What You Need To Do ⏳

- ⏳ Generate SSH deploy keys
- ⏳ Add public keys to GitHub repositories
- ⏳ Add private keys to GitHub Actions secrets
- ⏳ Enable the workflow
- ⏳ Test and verify

---

## Pre-Flight Checklist

Before starting, ensure you have:

- [ ] Admin access to `Krosebrook/source-of-truth-monorepo`
- [ ] Admin access to all 50 mirror repositories:
  - 34 repositories in `Krosebrook` organization
  - 8 repositories in `FlashFusionv1` organization
  - 8 repositories in `ChaosClubCo` organization
- [ ] GitHub CLI installed and authenticated: `gh auth login`
- [ ] SSH key generation tools: `ssh-keygen` (should be pre-installed)
- [ ] ~2 hours of uninterrupted time

**Validation**: Run `./scripts/validate-setup.sh` to check prerequisites.

---

## Activation Steps

### Step 1: Validate Prerequisites (5 minutes)

```bash
# Run validation script
./scripts/validate-setup.sh
```

This checks:
- GitHub CLI authentication
- Required tools installed
- File structure complete
- Current configuration status

**Expected Output**: Warnings about missing keys and secrets (normal at this stage)

---

### Step 2: Generate Deploy Keys (5 minutes)

```bash
# Generate all 50 SSH key pairs
./scripts/generate-deploy-keys.sh
```

**What this does**:
- Creates 50 ED25519 SSH key pairs
- Stores keys in `/tmp/sot-deploy-keys/`
- Each key is unique to one repository
- Uses secure key generation practices

**Output**: 50 key pairs (100 files total: private + public)

**Verify**:
```bash
ls -l /tmp/sot-deploy-keys/ | wc -l
# Expected: 101 (50 private + 50 public + 1 directory entry)
```

---

### Step 3: Add Public Keys to GitHub Repositories (60-90 minutes)

This is the most time-consuming step. You'll add the public key (`.pub` file) to each of the 50 repositories.

#### Option A: Web UI (Recommended for First-Time Users)

For each repository in the mirror list:

1. **Navigate** to `https://github.com/{org}/{repo}/settings/keys`
2. **Click** "Add deploy key"
3. **Title**: `SoT Monorepo Sync`
4. **Key**: Paste contents of corresponding `.pub` file
5. **✅ CRITICAL**: Check "Allow write access"
6. **Click** "Add key"

**Helper command to view public key**:
```bash
cat /tmp/sot-deploy-keys/mirror_ssh_key_flashfusion.pub
```

#### Option B: GitHub CLI (Faster, for Experienced Users)

```bash
cd /tmp/sot-deploy-keys

# Example for one repository
gh repo deploy-key add mirror_ssh_key_flashfusion.pub \
  --repo Krosebrook/FlashFusion \
  --title "SoT Monorepo Sync" \
  --allow-write
```

**Pro Tip**: Create a script to automate this for all 50 repos:
```bash
# See docs/how-to/configure-deploy-keys.md for complete mapping
```

#### Track Progress

Use the checklist in `docs/how-to/DEPLOY_KEYS_CHECKLIST.md` to track which repositories are complete.

**Verify one repository**:
```bash
gh repo deploy-key list --repo Krosebrook/FlashFusion
```

---

### Step 4: Add Private Keys to GitHub Actions Secrets (10 minutes)

```bash
# Upload all 50 private keys as secrets
./scripts/add-secrets-to-github.sh
```

**What this does**:
- Reads private keys from `/tmp/sot-deploy-keys/`
- Uploads to GitHub Actions secrets in `Krosebrook/source-of-truth-monorepo`
- Creates 50 secrets named `MIRROR_SSH_KEY_*`
- Uses GitHub CLI for secure upload

**Verify**:
```bash
gh secret list --repo Krosebrook/source-of-truth-monorepo | grep MIRROR_SSH_KEY_ | wc -l
# Expected: 50
```

---

### Step 5: Enable the Workflow (5 minutes)

1. **Edit** `.github/workflows/subtree-push.yml`

2. **Find** the commented section (around line 111):
   ```yaml
   # Uncomment when deploy keys are configured:
   # - name: Setup SSH for deploy keys
   ```

3. **Uncomment** lines 111-235 (the entire SSH setup and push logic)

4. **Save** the file

5. **Commit and push**:
   ```bash
   git add .github/workflows/subtree-push.yml
   git commit -m "Enable subtree-push workflow with deploy keys"
   git push
   ```

---

### Step 6: Test the Configuration (15 minutes)

#### Test 1: Single Repository (Manual Trigger)

```bash
# Trigger workflow for one repository
gh workflow run subtree-push.yml \
  --field path="projects/krosebrook/core/flashfusion" \
  --field repo="git@github.com:Krosebrook/FlashFusion.git"

# Watch the workflow
gh run watch
```

**What to check**:
- ✅ Workflow completes successfully
- ✅ No SSH authentication errors
- ✅ Subtree split succeeds
- ✅ Push to mirror succeeds

**If it fails**: Check GitHub Actions logs for error messages. Common issues:
- Deploy key not added to repository
- "Allow write access" not enabled
- Secret name mismatch

#### Test 2: Automatic Trigger (Full Integration)

Make a small change and push to `main`:

```bash
# Make a trivial change
echo "# Deploy keys activated $(date)" >> docs/.deployment-notes.md
git add docs/.deployment-notes.md
git commit -m "Test: Verify subtree-push workflow"
git push origin main

# Monitor workflow
gh run watch
```

**What to check**:
- ✅ Workflow triggers automatically on push to main
- ✅ All 50 repositories process (some may skip if no changes)
- ✅ No failures in the logs

---

### Step 7: Security Cleanup (5 minutes)

**CRITICAL**: Delete local copies of private keys after verification.

```bash
# Delete all keys from local filesystem
rm -rf /tmp/sot-deploy-keys/

# Verify deletion
ls /tmp/sot-deploy-keys/
# Expected: "No such file or directory"
```

**Why**: Private keys are now safely stored in GitHub Actions secrets. Local copies are no longer needed and pose a security risk.

---

### Step 8: Final Validation (5 minutes)

```bash
# Run validation script again
./scripts/validate-setup.sh
```

**Expected output**: All checks passed ✅

**Document completion**:
- Fill out `docs/how-to/DEPLOY_KEYS_CHECKLIST.md`
- Add completion date to checklist
- Set calendar reminder for key rotation (6 months from now)

---

## Verification Checklist

After activation, verify:

- [ ] All 50 secrets exist in GitHub Actions
  ```bash
  gh secret list --repo Krosebrook/source-of-truth-monorepo | grep MIRROR_SSH_KEY_ | wc -l
  # Should output: 50
  ```

- [ ] All 50 repositories have deploy keys with write access
  ```bash
  # Check one example
  gh repo deploy-key list --repo Krosebrook/FlashFusion
  ```

- [ ] Workflow is enabled (uncommitted in subtree-push.yml)
  ```bash
  grep -q "^      - name: Split & push mirrors" .github/workflows/subtree-push.yml && echo "Enabled ✓"
  ```

- [ ] Manual workflow trigger succeeds
  ```bash
  # Recent workflow runs
  gh run list --workflow=subtree-push.yml --limit 5
  ```

- [ ] Automatic workflow trigger succeeds (on push to main)

- [ ] Local private keys deleted
  ```bash
  [ ! -d /tmp/sot-deploy-keys ] && echo "Cleaned up ✓"
  ```

---

## Post-Activation Monitoring

### First Week

Monitor workflow runs daily:
```bash
gh run list --workflow=subtree-push.yml --limit 10
```

Address any failures immediately. Common issues:
- Repository doesn't exist in monorepo → Skip is normal
- Permission denied → Check deploy key configuration
- Branch mismatch → Verify target branch in workflow

### Ongoing

- **Weekly**: Review workflow run history for failures
- **Monthly**: Review GitHub Actions audit logs
- **Quarterly**: Review mirror repositories for sync issues
- **Semi-annually**: Rotate deploy keys (see Key Rotation section)

---

## Key Rotation (Every 6 Months)

Set a calendar reminder for 6 months from activation date.

**Rotation process**:

1. Generate new keys: `./scripts/generate-deploy-keys.sh`
2. Add new public keys to GitHub repos (keep old ones temporarily)
3. Update secrets: `./scripts/add-secrets-to-github.sh`
4. Test workflow with new keys
5. Remove old deploy keys from GitHub repos
6. Clean up local keys: `rm -rf /tmp/sot-deploy-keys/`

**Next rotation date**: _____________ (fill in after activation)

---

## Troubleshooting

### Issue: "Permission denied (publickey)"

**Cause**: Deploy key not added or missing write access

**Fix**:
1. Verify deploy key exists: `gh repo deploy-key list --repo {org}/{repo}`
2. Check "Allow write access" is enabled in GitHub UI
3. Verify secret name in workflow matches actual secret

---

### Issue: "Shallow update not allowed"

**Cause**: Checkout depth is shallow

**Fix**: Already fixed in workflow (`fetch-depth: 0`)

---

### Issue: Workflow runs but no push happens

**Cause**: Secret not found or misconfigured

**Fix**:
1. Check secret exists: `gh secret list --repo Krosebrook/source-of-truth-monorepo`
2. Verify secret name matches workflow exactly
3. Re-upload secret: `./scripts/add-secrets-to-github.sh`

---

### Issue: Some repositories succeed, others fail

**Cause**: Inconsistent deploy key configuration

**Fix**:
1. Identify failing repos from workflow logs
2. Verify each has deploy key with write access
3. Check secret names match workflow configuration

---

## Need Help?

- **Documentation**: `docs/how-to/configure-deploy-keys.md`
- **Checklist**: `docs/how-to/DEPLOY_KEYS_CHECKLIST.md`
- **Validation**: `./scripts/validate-setup.sh`
- **Issues**: https://github.com/Krosebrook/source-of-truth-monorepo/issues
- **Workflow Logs**: https://github.com/Krosebrook/source-of-truth-monorepo/actions

---

## Success! 🎉

Once all steps are complete:

✅ Infrastructure activated  
✅ All 50 mirrors configured  
✅ Automatic synchronization enabled  
✅ Security best practices implemented  

**Your monorepo is now live!** Changes pushed to `main` will automatically sync to all mirror repositories.

---

**Activation Date**: _____________  
**Activated By**: _____________  
**Next Key Rotation**: _____________ (6 months from activation)
