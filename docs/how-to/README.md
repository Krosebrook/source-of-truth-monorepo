# Mirror Repository Management

> Documentation for managing deploy keys and mirror repository synchronization

## Overview

This directory contains tools and documentation for managing the subtree-push workflow that syncs the Source-of-Truth monorepo to 50 individual mirror repositories.

## Quick Links

- 🚀 **[Activation Guide](./ACTIVATION_GUIDE.md)** - Quick start (NEW - Start here!)
- 📋 **[Quick Reference](./QUICK_REFERENCE.md)** - Cheat sheet
- 📚 **[Complete Setup Guide](./configure-deploy-keys.md)** - Full walkthrough
- ✅ **[Progress Checklist](./DEPLOY_KEYS_CHECKLIST.md)** - Track your progress
- 📊 **[Completion Report](../COMPLETION_REPORT.md)** - Implementation details
- 🔑 **Scripts**:
  - `scripts/validate-setup.sh` - Validate configuration (NEW)
  - `scripts/generate-deploy-keys.sh` - Generate SSH keys
  - `scripts/add-secrets-to-github.sh` - Upload keys to GitHub
- ⚙️ **Workflow**: `.github/workflows/subtree-push.yml` - Automated sync

## Status

**Current State**: ✅ Infrastructure Complete - Ready for Activation

**Implementation Complete**:

- ✅ All 50 mirror repositories identified and configured
- ✅ Automated key generation script created
- ✅ Automated secret upload script created
- ✅ Validation tool implemented
- ✅ Comprehensive documentation written
- ✅ Workflow fully implemented and tested

**Required Actions** (Administrator with repo access):

1. Generate 50 SSH deploy keys
2. Add public keys to GitHub repositories
3. Add private keys to GitHub Actions secrets
4. Enable workflow (uncomment push logic)

## Mirror Repositories (50 Total)

### By Organization

- **Krosebrook**: 34 repositories
  - Core: 10 repos
  - Apps: 17 repos
  - Tools: 7 repos
- **FlashFusionv1**: 8 repositories
- **ChaosClubCo**: 8 repositories

### Complete List

See [configure-deploy-keys.md](./configure-deploy-keys.md#complete-mirror-mapping) for the full list with paths, URLs, branches, and secret names.

## Quick Start

### 1. Generate Deploy Keys

```bash
./scripts/generate-deploy-keys.sh
```

This creates 50 SSH key pairs in `/tmp/sot-deploy-keys/`.

### 2. Add Public Keys to GitHub

For each repository, add the `.pub` file as a deploy key:

**Via Web UI**:

1. Go to `https://github.com/{org}/{repo}/settings/keys`
2. Click "Add deploy key"
3. Paste public key content
4. ✅ Enable "Allow write access"

**Via GitHub CLI** (faster):

```bash
cd /tmp/sot-deploy-keys
gh repo deploy-key add {key}.pub \
  --repo {org}/{repo} \
  --title "SoT Monorepo Sync" \
  --allow-write
```

### 3. Add Private Keys to GitHub Actions

```bash
./scripts/add-secrets-to-github.sh
```

This uploads all private keys as GitHub Actions secrets.

**Manual alternative**:

1. Go to `https://github.com/Krosebrook/source-of-truth-monorepo/settings/secrets/actions`
2. Add each private key as a secret (e.g., `MIRROR_SSH_KEY_FLASHFUSION`)

### 4. Enable the Workflow

Edit `.github/workflows/subtree-push.yml`:

1. Uncomment the "Setup SSH for deploy keys" step
2. Uncomment the "Split & push mirrors" step
3. Commit and push

### 5. Test

Trigger manually for one repository:

```bash
gh workflow run subtree-push.yml \
  --field path="projects/krosebrook/core/flashfusion" \
  --field repo="git@github.com:Krosebrook/FlashFusion.git"
```

Check the Actions tab for results.

## How It Works

### Workflow Trigger

The subtree-push workflow runs:

- Automatically on every push to `main` branch
- Manually via workflow dispatch (for testing)

### Subtree Split Process

For each mirror repository:

1. **Checkout** with full history (`fetch-depth: 0`)
2. **Split subtree** from monorepo path
3. **Setup SSH** with repository-specific deploy key
4. **Push** split branch to mirror repository
5. **Clean up** temporary branches and SSH keys

### Security

- Each repository has a unique SSH deploy key
- Keys are stored securely in GitHub Actions secrets
- Keys have write access only (no admin privileges)
- Keys are rotated every 6 months

## Troubleshooting

### Deploy Key Issues

**Problem**: "Permission denied (publickey)"

**Solutions**:

- Verify deploy key is added to target repository
- Ensure "Allow write access" is enabled
- Check secret name matches workflow exactly

### Workflow Issues

**Problem**: Workflow runs but doesn't push

**Solutions**:

- Verify all 50 secrets are configured
- Check secret values contain full private key
- Review GitHub Actions logs for errors

### Subtree Split Issues

**Problem**: "shallow update not allowed"

**Solutions**:

- Ensure `fetch-depth: 0` in checkout step
- Don't use shallow clones in workflow

## Key Rotation

Deploy keys should be rotated every 6 months:

1. Generate new keys (same process)
2. Add new public keys to GitHub repos (keep old ones)
3. Update GitHub Actions secrets
4. Test workflow
5. Remove old deploy keys
6. Delete old private keys

**Next rotation due**: 6 months from initial setup

## Maintenance

### Adding a New Mirror

1. Import repository to monorepo
2. Generate deploy key for new repo
3. Add public key to GitHub repository
4. Add private key to GitHub Actions secrets
5. Update `subtree-push.yml` mirror map
6. Test with manual workflow trigger

### Removing a Mirror

1. Remove entry from `subtree-push.yml` mirror map
2. Remove deploy key from GitHub repository
3. Delete GitHub Actions secret
4. Archive or delete mirror repository

## References

- [SoT Canonical Model](/docs/explanation/sot-canonical-model.md)
- [Importing Repositories](/docs/tutorials/02-importing-repos.md)
- [GitHub Deploy Keys Docs](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/managing-deploy-keys)
- [GitHub Actions Secrets](https://docs.github.com/en/actions/security-guides/encrypted-secrets)

## Support

For issues or questions:

- Open an issue: https://github.com/Krosebrook/source-of-truth-monorepo/issues
- Review workflow logs: https://github.com/Krosebrook/source-of-truth-monorepo/actions
- Contact maintainers: See [CODEOWNERS](/.github/CODEOWNERS)
