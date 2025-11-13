# Deploy Keys Setup Checklist

> Track progress for configuring deploy keys and enabling mirror repository sync

**Date Started**: _________________  
**Completed By**: _________________  
**Date Completed**: _________________

---

## Phase 1: Preparation

- [ ] Review [configure-deploy-keys.md](./configure-deploy-keys.md) documentation
- [ ] Confirm admin access to all 50 mirror repositories
- [ ] Confirm admin access to `Krosebrook/source-of-truth-monorepo`
- [ ] Install GitHub CLI (`gh`) and authenticate
- [ ] Install SSH key tools (`ssh-keygen`)

---

## Phase 2: Generate Deploy Keys

- [ ] Run `./scripts/generate-deploy-keys.sh`
- [ ] Verify 50 key pairs created in `/tmp/sot-deploy-keys/`
- [ ] Backup keys to secure location (temporary, until added to GitHub)
- [ ] Document key storage location: _________________

**Generated Keys Count**: ______ / 50

---

## Phase 3: Add Public Keys to GitHub Repositories

Track which repositories have deploy keys configured:

### Krosebrook Core (10)

- [ ] FlashFusion
- [ ] Flashfusionwebsite
- [ ] FlashFusion-Unified
- [ ] MonoTurboRepo-FlashFusion
- [ ] theaidashboard
- [ ] INT-Smart-Triage-AI-2.0
- [ ] Claude-Code-Development-Kit
- [ ] v0-ai-agent-builder
- [ ] Archon
- [ ] Intos

### Krosebrook Apps (17)

- [ ] v0-template-evaluation-academy
- [ ] KinsleysCreativeSuite
- [ ] OctaveStudio
- [ ] UniversalWriterAI
- [ ] Templateevaluationacademy
- [ ] MyContextEngine
- [ ] CreatorStudioLite
- [ ] UniversalAIGen
- [ ] FLashFusion-Learn
- [ ] lovable-prompt-artist
- [ ] analyst-cockpit-ui
- [ ] flashfusion-lite-ecommerce
- [ ] int-smart-triage-ai-3.0
- [ ] int-triage-ai.3.0
- [ ] project-nexus
- [ ] saas-validator-suite
- [ ] OpenFlashFusion

### Krosebrook Tools (7)

- [ ] claude-code-by-agents
- [ ] metamcp
- [ ] playwright-mcp
- [ ] claude-agent-sdk-typescript
- [ ] mcp-server-docker
- [ ] superpowers
- [ ] boilerplates

### FlashFusionv1 (8)

- [ ] flashfusion-creative-hub
- [ ] collabnet-visualizer-111
- [ ] pulse-robot-template-40849
- [ ] nimble-fab-flow
- [ ] loveable-supabase
- [ ] dyad
- [ ] spec-kit
- [ ] open-lovablev1

### ChaosClubCo (8)

- [ ] tiktok-story-ai
- [ ] context7
- [ ] supabase-js
- [ ] compose-for-agents
- [ ] flashfusion-ide
- [ ] SuperClaude-1
- [ ] SuperClaude
- [ ] turborepo-flashfusion

**Public Keys Added**: ______ / 50

**Verification Command**:
```bash
gh repo deploy-key list --repo {org}/{repo}
```

---

## Phase 4: Add Private Keys to GitHub Actions Secrets

- [ ] Run `./scripts/add-secrets-to-github.sh`
- [ ] Verify all 50 secrets added successfully
- [ ] Check secret names match workflow configuration

**Secrets Added**: ______ / 50

**Verification Command**:
```bash
gh secret list --repo Krosebrook/source-of-truth-monorepo | grep MIRROR_SSH_KEY | wc -l
```

**Expected Output**: `50`

### Secret Names Checklist

Quick verification that all required secrets exist:

#### Krosebrook Core
- [ ] MIRROR_SSH_KEY_FLASHFUSION
- [ ] MIRROR_SSH_KEY_FLASHFUSIONWEBSITE
- [ ] MIRROR_SSH_KEY_FLASHFUSION_UNIFIED
- [ ] MIRROR_SSH_KEY_MONO_TURBO_REPO
- [ ] MIRROR_SSH_KEY_THEAIDASHBOARD
- [ ] MIRROR_SSH_KEY_INT_SMART_TRIAGE_2
- [ ] MIRROR_SSH_KEY_CLAUDE_CODE_DEV_KIT
- [ ] MIRROR_SSH_KEY_V0_AI_AGENT_BUILDER
- [ ] MIRROR_SSH_KEY_ARCHON
- [ ] MIRROR_SSH_KEY_INTOS

#### Krosebrook Apps
- [ ] MIRROR_SSH_KEY_V0_TEMPLATE_EVAL
- [ ] MIRROR_SSH_KEY_KINSLEYSCREATIVESUITE
- [ ] MIRROR_SSH_KEY_OCTAVESTUDIO
- [ ] MIRROR_SSH_KEY_UNIVERSALWRITERAI
- [ ] MIRROR_SSH_KEY_TEMPLATEEVALACADEMY
- [ ] MIRROR_SSH_KEY_MYCONTEXTENGINE
- [ ] MIRROR_SSH_KEY_CREATORSTUDIOLITE
- [ ] MIRROR_SSH_KEY_UNIVERSALAIGEN
- [ ] MIRROR_SSH_KEY_FLASHFUSION_LEARN
- [ ] MIRROR_SSH_KEY_LOVABLE_PROMPT_ARTIST
- [ ] MIRROR_SSH_KEY_ANALYST_COCKPIT_UI
- [ ] MIRROR_SSH_KEY_FLASHFUSION_LITE_ECOM
- [ ] MIRROR_SSH_KEY_INT_SMART_TRIAGE_3
- [ ] MIRROR_SSH_KEY_INT_TRIAGE_AI_3
- [ ] MIRROR_SSH_KEY_PROJECT_NEXUS
- [ ] MIRROR_SSH_KEY_SAAS_VALIDATOR_SUITE
- [ ] MIRROR_SSH_KEY_OPEN_FLASHFUSION

#### Krosebrook Tools
- [ ] MIRROR_SSH_KEY_CLAUDE_CODE_BY_AGENTS
- [ ] MIRROR_SSH_KEY_METAMCP
- [ ] MIRROR_SSH_KEY_PLAYWRIGHT_MCP
- [ ] MIRROR_SSH_KEY_CLAUDE_AGENT_SDK_TS
- [ ] MIRROR_SSH_KEY_MCP_SERVER_DOCKER
- [ ] MIRROR_SSH_KEY_SUPERPOWERS
- [ ] MIRROR_SSH_KEY_BOILERPLATES

#### FlashFusionv1
- [ ] MIRROR_SSH_KEY_CREATIVE_HUB
- [ ] MIRROR_SSH_KEY_COLLABNET_VISUALIZER
- [ ] MIRROR_SSH_KEY_PULSE_ROBOT_TEMPLATE
- [ ] MIRROR_SSH_KEY_NIMBLE_FAB_FLOW
- [ ] MIRROR_SSH_KEY_LOVEABLE_SUPABASE
- [ ] MIRROR_SSH_KEY_DYAD
- [ ] MIRROR_SSH_KEY_SPEC_KIT
- [ ] MIRROR_SSH_KEY_OPEN_LOVABLEV1

#### ChaosClubCo
- [ ] MIRROR_SSH_KEY_TIKTOK_STORY_AI
- [ ] MIRROR_SSH_KEY_CONTEXT7
- [ ] MIRROR_SSH_KEY_SUPABASE_JS
- [ ] MIRROR_SSH_KEY_COMPOSE_FOR_AGENTS
- [ ] MIRROR_SSH_KEY_FLASHFUSION_IDE
- [ ] MIRROR_SSH_KEY_SUPERCLAUDE_1
- [ ] MIRROR_SSH_KEY_SUPERCLAUDE
- [ ] MIRROR_SSH_KEY_TURBOREPO_FLASHFUSION

---

## Phase 5: Update Workflow Configuration

- [ ] Edit `.github/workflows/subtree-push.yml`
- [ ] Verify mirror map contains all 50 repositories
- [ ] Uncomment "Setup SSH for deploy keys" step (line ~51)
- [ ] Uncomment "Split & push mirrors" step (line ~58)
- [ ] Verify all secret names in `env:` section match GitHub secrets
- [ ] Commit changes to workflow file
- [ ] Push to repository

---

## Phase 6: Testing

### Test SSH Connectivity

- [ ] Test GitHub SSH: `ssh -T git@github.com`
- [ ] Test with deploy key: `ssh -i {key_file} -T git@github.com`

### Test Workflow (Single Repository)

- [ ] Trigger manual workflow for one repo:
  ```bash
  gh workflow run subtree-push.yml \
    --field path="projects/krosebrook/core/flashfusion" \
    --field repo="git@github.com:Krosebrook/FlashFusion.git"
  ```
- [ ] Monitor workflow in GitHub Actions
- [ ] Verify successful completion
- [ ] Check mirror repository for pushed changes

**Test Repository**: _________________  
**Test Date**: _________________  
**Result**: ✅ Success / ❌ Failed  
**Notes**: _________________

### Test Workflow (All Repositories)

- [ ] Make a small change to main branch
- [ ] Push to trigger automatic workflow
- [ ] Monitor workflow execution
- [ ] Verify all 50 repositories receive updates
- [ ] Check for any failures or errors

**Full Test Date**: _________________  
**Successful Pushes**: ______ / 50  
**Failed Pushes**: ______  
**Failure Details**: _________________

---

## Phase 7: Security & Cleanup

- [ ] Delete local copies of private keys: `rm -rf /tmp/sot-deploy-keys`
- [ ] Verify keys are deleted from local filesystem
- [ ] Document key rotation schedule in calendar
- [ ] Set reminder for key rotation (6 months from now)
- [ ] Review GitHub Actions audit logs
- [ ] Enable GitHub Actions notifications for workflow failures

**Key Rotation Date**: _________________

---

## Phase 8: Documentation

- [ ] Update README.md with current status
- [ ] Document any deviations from standard process
- [ ] Record troubleshooting notes for future reference
- [ ] Share completion status with team

**Documentation Updated**: ✅ Yes / ❌ No  
**Team Notified**: ✅ Yes / ❌ No

---

## Troubleshooting Log

Use this section to document any issues encountered:

| Date | Issue | Resolution | Time Spent |
|------|-------|------------|------------|
|      |       |            |            |
|      |       |            |            |
|      |       |            |            |

---

## Sign-off

**Setup Completed By**: _________________  
**Signature**: _________________  
**Date**: _________________

**Verified By**: _________________  
**Signature**: _________________  
**Date**: _________________

---

## Next Steps After Completion

- [ ] Monitor workflow runs for one week
- [ ] Address any failures promptly
- [ ] Set up alerts for workflow failures
- [ ] Schedule first key rotation (6 months)
- [ ] Update team documentation

---

**Status**: 
- ⏸️ Not Started
- 🟡 In Progress
- ✅ Completed
- ❌ Blocked

**Current Phase**: _________________  
**Overall Progress**: ______ %
