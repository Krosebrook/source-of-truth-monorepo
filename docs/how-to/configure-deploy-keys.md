# How to Configure Deploy Keys for Mirror Repositories

> Complete guide to setting up deploy keys and access tokens for the subtree-push workflow

**Time**: 60 minutes  
**Level**: Advanced  
**Prerequisites**: GitHub admin access to all mirror repositories

---

## Overview

This guide walks through configuring deploy keys and GitHub Actions secrets to enable the automated subtree-push workflow. This workflow syncs changes from the Source-of-Truth monorepo to individual mirror repositories.

**What you'll do**:

- Generate SSH deploy keys for each mirror repository
- Add deploy keys to GitHub repositories
- Configure GitHub Actions secrets
- Update the subtree-push workflow
- Test the configuration

---

## Prerequisites

- Admin access to:
  - `Krosebrook/source-of-truth-monorepo` (this repo)
  - All 50 mirror repositories (see [Mirror Repository List](#mirror-repository-list))
- GitHub CLI installed (`gh`) or web access
- SSH key generation tools (`ssh-keygen`)

---

## Step 1: Generate Deploy Keys

For each mirror repository, you'll need to generate a unique SSH key pair.

### Generate Keys in Batch

```bash
# Create a directory to store keys temporarily
mkdir -p /tmp/sot-deploy-keys
cd /tmp/sot-deploy-keys

# Generate keys for each mirror (example for first few)
ssh-keygen -t ed25519 -C "sot-deploy-flashfusion" -f flashfusion_deploy_key -N ""
ssh-keygen -t ed25519 -C "sot-deploy-website" -f flashfusionwebsite_deploy_key -N ""
ssh-keygen -t ed25519 -C "sot-deploy-unified" -f flashfusion_unified_deploy_key -N ""
ssh-keygen -t ed25519 -C "sot-deploy-dashboard" -f theaidashboard_deploy_key -N ""
ssh-keygen -t ed25519 -C "sot-deploy-creative" -f flashfusion_creative_hub_deploy_key -N ""

# Continue for all 50 repositories...
```

**Output**: For each repo, you'll have:

- `{repo}_deploy_key` (private key) - Keep secret!
- `{repo}_deploy_key.pub` (public key) - Add to GitHub repo

### Automated Key Generation Script

For convenience, use this script to generate all 50 keys at once:

```bash
#!/bin/bash
# File: scripts/generate-deploy-keys.sh

set -euo pipefail

KEYS_DIR="/tmp/sot-deploy-keys"
mkdir -p "$KEYS_DIR"
cd "$KEYS_DIR"

# List of all mirror repos
REPOS=(
  "flashfusion"
  "flashfusionwebsite"
  "flashfusion-unified"
  "mono-turbo-repo-flashfusion"
  "theaidashboard"
  "int-smart-triage-ai-2.0"
  "claude-code-dev-kit"
  "v0-ai-agent-builder"
  "archon"
  "intos"
  "v0-template-evaluation-academy"
  "kinsleyscreativesuite"
  "octavestudio"
  "universalwriterai"
  "templateevaluationacademy"
  "mycontextengine"
  "creatorstudiolite"
  "universalaigen"
  "flashfusion-learn"
  "lovable-prompt-artist"
  "analyst-cockpit-ui"
  "flashfusion-lite-ecommerce"
  "int-smart-triage-ai-3.0"
  "int-triage-ai-3.0"
  "project-nexus"
  "saas-validator-suite"
  "open-flashfusion"
  "claude-code-by-agents"
  "metamcp"
  "playwright-mcp"
  "claude-agent-sdk-typescript"
  "mcp-server-docker"
  "superpowers"
  "boilerplates"
  "flashfusion-creative-hub"
  "collabnet-visualizer-111"
  "pulse-robot-template-40849"
  "nimble-fab-flow"
  "loveable-supabase"
  "dyad"
  "spec-kit"
  "open-lovablev1"
  "tiktok-story-ai"
  "context7"
  "supabase-js"
  "compose-for-agents"
  "flashfusion-ide"
  "superclaude-1"
  "superclaude"
  "turborepo-flashfusion"
)

echo "Generating deploy keys for ${#REPOS[@]} repositories..."

for repo in "${REPOS[@]}"; do
  KEY_NAME="${repo}_deploy_key"
  if [ -f "$KEY_NAME" ]; then
    echo "⊙ Skipped: $KEY_NAME (already exists)"
  else
    ssh-keygen -t ed25519 -C "sot-deploy-$repo" -f "$KEY_NAME" -N "" >/dev/null 2>&1
    echo "✓ Generated: $KEY_NAME"
  fi
done

echo ""
echo "Keys generated in: $KEYS_DIR"
echo "Next: Add public keys to GitHub repositories"
```

---

## Step 2: Add Deploy Keys to GitHub Repositories

For each mirror repository, add the **public key** as a deploy key with **write access**.

### Option A: Using GitHub Web UI

For each repository:

1. Navigate to `https://github.com/{org}/{repo}/settings/keys`
2. Click "Add deploy key"
3. **Title**: `SoT Monorepo Sync`
4. **Key**: Paste contents of `{repo}_deploy_key.pub`
5. ✅ Check "Allow write access"
6. Click "Add key"

Repeat for all 50 repositories.

### Option B: Using GitHub CLI (Faster)

```bash
#!/bin/bash
# Add deploy keys via GitHub CLI

cd /tmp/sot-deploy-keys

# Example for one repo
gh repo deploy-key add flashfusion_deploy_key.pub \
  --repo Krosebrook/FlashFusion \
  --title "SoT Monorepo Sync" \
  --allow-write

# Repeat for all repos...
```

### Verification

After adding all keys:

```bash
# Verify keys are added
gh repo deploy-key list --repo Krosebrook/FlashFusion
```

---

## Step 3: Add Private Keys to GitHub Actions Secrets

Now add the **private keys** as GitHub Actions secrets in the SoT monorepo.

### Secret Naming Convention

Format: `MIRROR_SSH_KEY_{REPO_NAME_UPPER}`

Examples:

- `MIRROR_SSH_KEY_FLASHFUSION`
- `MIRROR_SSH_KEY_WEBSITE`
- `MIRROR_SSH_KEY_UNIFIED`
- `MIRROR_SSH_KEY_DASHBOARD`

### Add Secrets via Web UI

1. Navigate to `https://github.com/Krosebrook/source-of-truth-monorepo/settings/secrets/actions`
2. Click "New repository secret"
3. **Name**: `MIRROR_SSH_KEY_FLASHFUSION`
4. **Value**: Paste entire contents of `flashfusion_deploy_key` (private key)
5. Click "Add secret"

Repeat for all 50 repositories.

### Add Secrets via GitHub CLI (Faster)

```bash
#!/bin/bash
# Add all deploy keys as GitHub Actions secrets

cd /tmp/sot-deploy-keys

# Helper function
add_secret() {
  local key_file=$1
  local secret_name=$2
  local repo="Krosebrook/source-of-truth-monorepo"

  # Use stdin redirection for safer file handling
  gh secret set "$secret_name" \
    --repo "$repo" \
    < "$key_file"
}

# Add all secrets
add_secret "flashfusion_deploy_key" "MIRROR_SSH_KEY_FLASHFUSION"
add_secret "flashfusionwebsite_deploy_key" "MIRROR_SSH_KEY_WEBSITE"
add_secret "flashfusion_unified_deploy_key" "MIRROR_SSH_KEY_UNIFIED"
add_secret "theaidashboard_deploy_key" "MIRROR_SSH_KEY_DASHBOARD"
add_secret "flashfusion_creative_hub_deploy_key" "MIRROR_SSH_KEY_CREATIVE"

# Continue for all 50 repos...
```

### Verification

```bash
# List all secrets (names only, not values)
gh secret list --repo Krosebrook/source-of-truth-monorepo
```

You should see 50 secrets named `MIRROR_SSH_KEY_*`.

---

## Step 4: Update Subtree-Push Workflow

Update `.github/workflows/subtree-push.yml` with the complete mirror mapping.

See the [Complete Mirror Mapping](#complete-mirror-mapping) section below for the full list.

The workflow has been updated with all 50 mirror repositories and their corresponding deploy key secrets.

---

## Step 5: Test the Configuration

### Dry Run Test

Before enabling the workflow, test SSH connectivity:

```bash
# Test SSH connection to GitHub (should succeed)
ssh -T git@github.com

# Test with a specific deploy key
ssh -i /tmp/sot-deploy-keys/flashfusion_deploy_key -T git@github.com
```

### Enable the Workflow

Once all keys are configured:

1. Edit `.github/workflows/subtree-push.yml`
2. Uncomment the "Split & push mirrors" step (lines 51-58)
3. Commit and push

### Test Push (Manual Trigger)

```bash
# Trigger workflow manually for one repo
gh workflow run subtree-push.yml \
  --field path="projects/krosebrook/core/flashfusion" \
  --field repo="git@github.com:Krosebrook/FlashFusion.git"
```

Check GitHub Actions logs to verify successful push.

---

## Complete Mirror Mapping

Below is the complete list of all 50 mirror repositories with their configurations.

### Format

```
{project_path}|{git_url}|{branch}|{secret_name}
```

### Krosebrook Core (10 repos)

```
projects/krosebrook/core/flashfusion|git@github.com:Krosebrook/FlashFusion.git|main|MIRROR_SSH_KEY_FLASHFUSION
projects/krosebrook/core/flashfusionwebsite|git@github.com:Krosebrook/Flashfusionwebsite.git|main|MIRROR_SSH_KEY_FLASHFUSIONWEBSITE
projects/krosebrook/core/flashfusion-unified|git@github.com:Krosebrook/FlashFusion-Unified.git|master|MIRROR_SSH_KEY_FLASHFUSION_UNIFIED
projects/krosebrook/core/mono-turbo-repo-flashfusion|git@github.com:Krosebrook/MonoTurboRepo-FlashFusion.git|main|MIRROR_SSH_KEY_MONO_TURBO_REPO
projects/krosebrook/core/theaidashboard|git@github.com:Krosebrook/theaidashboard.git|main|MIRROR_SSH_KEY_THEAIDASHBOARD
projects/krosebrook/apps/int-smart-triage-ai-2.0|git@github.com:Krosebrook/INT-Smart-Triage-AI-2.0.git|main|MIRROR_SSH_KEY_INT_SMART_TRIAGE_2
projects/krosebrook/tools/claude-code-dev-kit|git@github.com:Krosebrook/Claude-Code-Development-Kit.git|main|MIRROR_SSH_KEY_CLAUDE_CODE_DEV_KIT
projects/krosebrook/apps/v0-ai-agent-builder|git@github.com:Krosebrook/v0-ai-agent-builder.git|main|MIRROR_SSH_KEY_V0_AI_AGENT_BUILDER
projects/krosebrook/apps/archon|git@github.com:Krosebrook/Archon.git|main|MIRROR_SSH_KEY_ARCHON
projects/krosebrook/apps/intos|git@github.com:Krosebrook/Intos.git|main|MIRROR_SSH_KEY_INTOS
```

### Krosebrook Apps (17 repos)

```
projects/krosebrook/apps/v0-template-evaluation-academy|git@github.com:Krosebrook/v0-template-evaluation-academy.git|main|MIRROR_SSH_KEY_V0_TEMPLATE_EVAL
projects/krosebrook/apps/kinsleyscreativesuite|git@github.com:Krosebrook/KinsleysCreativeSuite.git|main|MIRROR_SSH_KEY_KINSLEYSCREATIVESUITE
projects/krosebrook/apps/octavestudio|git@github.com:Krosebrook/OctaveStudio.git|main|MIRROR_SSH_KEY_OCTAVESTUDIO
projects/krosebrook/apps/universalwriterai|git@github.com:Krosebrook/UniversalWriterAI.git|main|MIRROR_SSH_KEY_UNIVERSALWRITERAI
projects/krosebrook/apps/templateevaluationacademy|git@github.com:Krosebrook/Templateevaluationacademy.git|main|MIRROR_SSH_KEY_TEMPLATEEVALACADEMY
projects/krosebrook/apps/mycontextengine|git@github.com:Krosebrook/MyContextEngine.git|main|MIRROR_SSH_KEY_MYCONTEXTENGINE
projects/krosebrook/apps/creatorstudiolite|git@github.com:Krosebrook/CreatorStudioLite.git|main|MIRROR_SSH_KEY_CREATORSTUDIOLITE
projects/krosebrook/apps/universalaigen|git@github.com:Krosebrook/UniversalAIGen.git|main|MIRROR_SSH_KEY_UNIVERSALAIGEN
projects/krosebrook/apps/flashfusion-learn|git@github.com:Krosebrook/FLashFusion-Learn.git|main|MIRROR_SSH_KEY_FLASHFUSION_LEARN
projects/krosebrook/apps/lovable-prompt-artist|git@github.com:Krosebrook/lovable-prompt-artist.git|main|MIRROR_SSH_KEY_LOVABLE_PROMPT_ARTIST
projects/krosebrook/apps/analyst-cockpit-ui|git@github.com:Krosebrook/analyst-cockpit-ui.git|main|MIRROR_SSH_KEY_ANALYST_COCKPIT_UI
projects/krosebrook/apps/flashfusion-lite-ecommerce|git@github.com:Krosebrook/flashfusion-lite-ecommerce.git|main|MIRROR_SSH_KEY_FLASHFUSION_LITE_ECOM
projects/krosebrook/apps/int-smart-triage-ai-3.0|git@github.com:Krosebrook/int-smart-triage-ai-3.0.git|main|MIRROR_SSH_KEY_INT_SMART_TRIAGE_3
projects/krosebrook/apps/int-triage-ai-3.0|git@github.com:Krosebrook/int-triage-ai.3.0.git|main|MIRROR_SSH_KEY_INT_TRIAGE_AI_3
projects/krosebrook/apps/project-nexus|git@github.com:Krosebrook/project-nexus.git|main|MIRROR_SSH_KEY_PROJECT_NEXUS
projects/krosebrook/apps/saas-validator-suite|git@github.com:Krosebrook/saas-validator-suite.git|main|MIRROR_SSH_KEY_SAAS_VALIDATOR_SUITE
projects/krosebrook/apps/open-flashfusion|git@github.com:Krosebrook/OpenFlashFusion.git|main|MIRROR_SSH_KEY_OPEN_FLASHFUSION
```

### Krosebrook Tools (7 repos)

```
projects/krosebrook/tools/claude-code-by-agents|git@github.com:Krosebrook/claude-code-by-agents.git|main|MIRROR_SSH_KEY_CLAUDE_CODE_BY_AGENTS
projects/krosebrook/tools/metamcp|git@github.com:Krosebrook/metamcp.git|main|MIRROR_SSH_KEY_METAMCP
projects/krosebrook/tools/playwright-mcp|git@github.com:Krosebrook/playwright-mcp.git|main|MIRROR_SSH_KEY_PLAYWRIGHT_MCP
projects/krosebrook/tools/claude-agent-sdk-typescript|git@github.com:Krosebrook/claude-agent-sdk-typescript.git|main|MIRROR_SSH_KEY_CLAUDE_AGENT_SDK_TS
projects/krosebrook/tools/mcp-server-docker|git@github.com:Krosebrook/mcp-server-docker.git|main|MIRROR_SSH_KEY_MCP_SERVER_DOCKER
projects/krosebrook/tools/superpowers|git@github.com:Krosebrook/superpowers.git|main|MIRROR_SSH_KEY_SUPERPOWERS
projects/krosebrook/tools/boilerplates|git@github.com:Krosebrook/boilerplates.git|main|MIRROR_SSH_KEY_BOILERPLATES
```

### FlashFusionv1 (8 repos)

```
projects/flashfusionv1/flashfusion-creative-hub|git@github.com:FlashFusionv1/flashfusion-creative-hub.git|main|MIRROR_SSH_KEY_CREATIVE_HUB
projects/flashfusionv1/collabnet-visualizer-111|git@github.com:FlashFusionv1/collabnet-visualizer-111.git|main|MIRROR_SSH_KEY_COLLABNET_VISUALIZER
projects/flashfusionv1/pulse-robot-template-40849|git@github.com:FlashFusionv1/pulse-robot-template-40849.git|main|MIRROR_SSH_KEY_PULSE_ROBOT_TEMPLATE
projects/flashfusionv1/nimble-fab-flow|git@github.com:FlashFusionv1/nimble-fab-flow.git|main|MIRROR_SSH_KEY_NIMBLE_FAB_FLOW
projects/flashfusionv1/loveable-supabase|git@github.com:FlashFusionv1/loveable-supabase.git|main|MIRROR_SSH_KEY_LOVEABLE_SUPABASE
projects/flashfusionv1/dyad|git@github.com:FlashFusionv1/dyad.git|main|MIRROR_SSH_KEY_DYAD
projects/flashfusionv1/spec-kit|git@github.com:FlashFusionv1/spec-kit.git|main|MIRROR_SSH_KEY_SPEC_KIT
projects/flashfusionv1/open-lovablev1|git@github.com:FlashFusionv1/open-lovablev1.git|main|MIRROR_SSH_KEY_OPEN_LOVABLEV1
```

### ChaosClubCo (8 repos)

```
projects/chaosclubco/tiktok-story-ai|git@github.com:ChaosClubCo/tiktok-story-ai.git|main|MIRROR_SSH_KEY_TIKTOK_STORY_AI
projects/chaosclubco/context7|git@github.com:ChaosClubCo/context7.git|main|MIRROR_SSH_KEY_CONTEXT7
projects/chaosclubco/supabase-js|git@github.com:ChaosClubCo/supabase-js.git|main|MIRROR_SSH_KEY_SUPABASE_JS
projects/chaosclubco/compose-for-agents|git@github.com:ChaosClubCo/compose-for-agents.git|main|MIRROR_SSH_KEY_COMPOSE_FOR_AGENTS
projects/chaosclubco/flashfusion-ide|git@github.com:ChaosClubCo/flashfusion-ide.git|main|MIRROR_SSH_KEY_FLASHFUSION_IDE
projects/chaosclubco/superclaude-1|git@github.com:ChaosClubCo/SuperClaude-1.git|main|MIRROR_SSH_KEY_SUPERCLAUDE_1
projects/chaosclubco/superclaude|git@github.com:ChaosClubCo/SuperClaude.git|main|MIRROR_SSH_KEY_SUPERCLAUDE
projects/chaosclubco/turborepo-flashfusion|git@github.com:ChaosClubCo/turborepo-flashfusion.git|main|MIRROR_SSH_KEY_TURBOREPO_FLASHFUSION
```

---

## Key Rotation Policy

### Rotation Schedule

- **Regular rotation**: Every 6 months
- **Incident rotation**: Immediately if key is compromised
- **Automated reminder**: Set calendar reminder 2 weeks before rotation

### Rotation Process

1. Generate new deploy keys (use same process as Step 1)
2. Add new public keys to GitHub repos (don't remove old ones yet)
3. Update GitHub Actions secrets with new private keys
4. Test workflow with new keys
5. Remove old deploy keys from GitHub repos
6. Securely delete old private keys

### Security Best Practices

- ✅ Never commit private keys to version control
- ✅ Use unique keys for each repository
- ✅ Restrict keys to write access only (no admin)
- ✅ Monitor GitHub Actions logs for unauthorized access
- ✅ Enable GitHub Actions audit log review
- ✅ Delete local copies of keys after setup

---

## Troubleshooting

### "Permission denied (publickey)"

**Cause**: Deploy key not added to GitHub repo, or wrong key used.

**Fix**:

1. Verify deploy key is added: `gh repo deploy-key list --repo {org}/{repo}`
2. Verify "Allow write access" is checked
3. Test SSH connection: `ssh -i {key_file} -T git@github.com`

### "Host key verification failed"

**Cause**: GitHub's host key not in known_hosts.

**Fix**: Add to workflow:

```yaml
- name: Setup SSH
  run: |
    mkdir -p ~/.ssh
    ssh-keyscan github.com >> ~/.ssh/known_hosts
```

### "Remote rejected (shallow update not allowed)"

**Cause**: Shallow clone conflict with subtree split.

**Fix**: Ensure `fetch-depth: 0` in checkout step.

### Workflow runs but doesn't push

**Cause**: Secret name mismatch or key not configured.

**Fix**:

1. Verify secret exists: `gh secret list --repo {org}/source-of-truth-monorepo`
2. Check secret name matches workflow file exactly
3. Verify secret contains full private key (including headers)

---

## Checklist

Use this checklist to track progress:

**Setup Phase**:

- [ ] Review mirror repository list (50 repos)
- [ ] Generate 50 SSH key pairs
- [ ] Store private keys securely (temporarily)

**GitHub Configuration**:

- [ ] Add public keys to all 50 GitHub repos (with write access)
- [ ] Verify deploy keys are added and write-enabled

**GitHub Actions Secrets**:

- [ ] Add 50 private keys as GitHub Actions secrets
- [ ] Verify secret naming follows convention
- [ ] Test secret access in workflow

**Workflow Configuration**:

- [ ] Update subtree-push.yml with complete mirror list
- [ ] Verify all paths, URLs, branches, and secret names
- [ ] Uncomment push logic

**Testing**:

- [ ] Test SSH connectivity
- [ ] Run manual workflow trigger (one repo)
- [ ] Verify successful push to mirror
- [ ] Enable automatic push on main branch

**Security**:

- [ ] Delete local copies of private keys
- [ ] Document rotation schedule
- [ ] Set calendar reminder for rotation
- [ ] Review GitHub Actions audit logs

---

## Next Steps

- Review [Subtree Push Workflow](/.github/workflows/subtree-push.yml)
- Read [SoT Canonical Model](/docs/explanation/sot-canonical-model.md)
- Monitor [GitHub Actions](https://github.com/Krosebrook/source-of-truth-monorepo/actions)

---

**Need help?** Open an issue or contact the repository maintainers.
