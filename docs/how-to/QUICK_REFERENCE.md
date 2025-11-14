# Deploy Keys Quick Reference

**Status**: ✅ Infrastructure Complete | ⏳ Awaiting Activation  
**Time to Activate**: ~2 hours | **Mirror Repos**: 50

---

## Validation

```bash
./scripts/validate-setup.sh
```

---

## Activation (One-Time Setup)

### 1. Generate Keys (5 min)

```bash
./scripts/generate-deploy-keys.sh
```

### 2. Add Public Keys to GitHub (60-90 min)

For each of 50 repos:

- Go to `https://github.com/{org}/{repo}/settings/keys`
- Add deploy key
- ✅ Enable "Allow write access"

**Or use GitHub CLI**:

```bash
gh repo deploy-key add {key}.pub --repo {org}/{repo} --title "SoT Monorepo Sync" --allow-write
```

### 3. Upload Secrets (10 min)

```bash
./scripts/add-secrets-to-github.sh
```

### 4. Enable Workflow (5 min)

- Edit `.github/workflows/subtree-push.yml`
- Uncomment lines 111-235
- Commit and push

### 5. Test (15 min)

```bash
gh workflow run subtree-push.yml --field path="projects/krosebrook/core/flashfusion"
gh run watch
```

### 6. Cleanup

```bash
rm -rf /tmp/sot-deploy-keys/
```

---

## Verification

```bash
# Check secrets (should be 50)
gh secret list --repo Krosebrook/source-of-truth-monorepo | grep MIRROR_SSH_KEY_ | wc -l

# Check deploy keys
gh repo deploy-key list --repo Krosebrook/FlashFusion

# Verify workflow
gh run list --workflow=subtree-push.yml --limit 5
```

---

## Maintenance

- **Weekly**: Monitor workflow runs
- **Monthly**: Review audit logs
- **Every 6 months**: Rotate keys

---

## Documentation

| Document                                               | Purpose                 |
| ------------------------------------------------------ | ----------------------- |
| [ACTIVATION_GUIDE.md](./ACTIVATION_GUIDE.md)           | Step-by-step activation |
| [configure-deploy-keys.md](./configure-deploy-keys.md) | Comprehensive setup     |
| [DEPLOY_KEYS_CHECKLIST.md](./DEPLOY_KEYS_CHECKLIST.md) | Progress tracking       |
| [COMPLETION_REPORT.md](../COMPLETION_REPORT.md)        | Implementation details  |

---

## Mirror Organizations

- **Krosebrook**: 34 repos (10 core + 17 apps + 7 tools)
- **FlashFusionv1**: 8 repos
- **ChaosClubCo**: 8 repos

---

## Troubleshooting

**"Permission denied"**: Deploy key missing or no write access  
**"Shallow update"**: Already fixed (fetch-depth: 0)  
**No push**: Secret missing or name mismatch

**Full guide**: [configure-deploy-keys.md](./configure-deploy-keys.md#troubleshooting)

---

## Support

- **Workflow Logs**: https://github.com/Krosebrook/source-of-truth-monorepo/actions
- **Issues**: https://github.com/Krosebrook/source-of-truth-monorepo/issues
- **Validation Tool**: `./scripts/validate-setup.sh`
