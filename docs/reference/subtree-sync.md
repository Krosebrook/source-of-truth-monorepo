# Subtree Synchronization Reference

> Technical reference for the automated subtree split and push workflow

**Type**: Reference  
**Audience**: Developers, DevOps engineers  
**Last Updated**: 2025-11-01

---

## Overview

The subtree synchronization system automatically pushes changes from the Source-of-Truth (SoT) monorepo to 50
individual mirror repositories using Git's subtree split functionality and GitHub Actions.

**Purpose**: Keep mirror repositories in sync with their corresponding directories in the SoT monorepo.

**Trigger**: Automatically on every push to `main` branch, or manually via workflow dispatch.

---

## Architecture

### High-Level Flow

```text
┌─────────────────────────────────────────────────────────────┐
│                    SoT Monorepo (main)                      │
│  projects/                                                  │
│  ├── krosebrook/core/flashfusion/                          │
│  ├── krosebrook/apps/archon/                               │
│  └── flashfusionv1/dyad/                                   │
└───────────────────┬─────────────────────────────────────────┘
                    │
                    │ Push to main
                    ▼
┌─────────────────────────────────────────────────────────────┐
│          GitHub Actions: subtree-push.yml                   │
│  1. Checkout with full history (fetch-depth: 0)            │
│  2. Load mirror configuration                              │
│  3. For each mirror repository:                            │
│     a. Setup SSH deploy key                                │
│     b. Create subtree split                                │
│     c. Push to mirror repository                           │
│     d. Clean up temporary branches                         │
└───────────────────┬─────────────────────────────────────────┘
                    │
        ┌───────────┴──────────┬──────────────┐
        │                      │              │
        ▼                      ▼              ▼
┌──────────────┐      ┌──────────────┐  ┌──────────────┐
│ Mirror Repo  │      │ Mirror Repo  │  │ Mirror Repo  │
│ FlashFusion  │  ... │    Archon    │  │     Dyad     │
└──────────────┘      └──────────────┘  └──────────────┘
   (Read-only)           (Read-only)       (Read-only)
```text

### Component Breakdown

#### 1. Source of Truth Monorepo

- **Location**: `Krosebrook/source-of-truth-monorepo`
- **Structure**: All 53 projects organized under `projects/`
- **Ownership**: Canonical source - all development happens here

#### 2. Subtree-Push Workflow

- **File**: `.github/workflows/subtree-push.yml`
- **Trigger Events**:
  - Push to `main` branch (automatic)
  - `workflow_dispatch` (manual with optional filters)
- **Permissions**: `contents: write`

#### 3. Mirror Repositories

- **Count**: 50 active mirrors
- **Organizations**: Krosebrook (34), FlashFusionv1 (8), ChaosClubCo (8)
- **Access**: Read-only for end users, write access via deploy keys

---

## Workflow Configuration

### File Location

```text
.github/workflows/subtree-push.yml
```text

### Triggers

#### Automatic Trigger

```yaml
on:
  push:
    branches: [main]
```text

Runs automatically after any commit is merged to the `main` branch.

#### Manual Trigger

```yaml
on:
  workflow_dispatch:
    inputs:
      path:
        description: "Project path (e.g., projects/krosebrook/core/flashfusion)"
        required: false
      repo:
        description: "Target repo URL (e.g., git@github.com:Krosebrook/FlashFusion.git)"
        required: false
```text

**Usage**:

```bash
# Sync specific project
gh workflow run subtree-push.yml \
  --field path="projects/krosebrook/core/flashfusion"

# Sync all projects
gh workflow run subtree-push.yml
```text

---

## Mirror Repository Map

### Configuration Format

Mirror repositories are defined inline in the workflow file:

```text
# Format: project_path|git_url|branch|secret_name
projects/krosebrook/core/flashfusion|git@github.com:Krosebrook/FlashFusion.git|main|MIRROR_SSH_KEY_FLASHFUSION
```text

**Fields**:

- `project_path`: Path in SoT monorepo (e.g., `projects/krosebrook/core/flashfusion`)
- `git_url`: SSH URL of mirror repository
- `branch`: Target branch in mirror (usually `main` or `master`)
- `secret_name`: GitHub Actions secret containing the SSH private key

### Complete Repository List

#### Krosebrook Core (10 repos)

| Project Path | Mirror Repository | Branch |
|-------------|-------------------|---------|
| `projects/krosebrook/core/flashfusion` | `Krosebrook/FlashFusion` | main |
| `projects/krosebrook/core/flashfusionwebsite` | `Krosebrook/Flashfusionwebsite` | main |
| `projects/krosebrook/core/flashfusion-unified` | `Krosebrook/FlashFusion-Unified` | master |
| `projects/krosebrook/core/mono-turbo-repo-flashfusion` | `Krosebrook/MonoTurboRepo-FlashFusion` | main |
| `projects/krosebrook/core/theaidashboard` | `Krosebrook/theaidashboard` | main |
| `projects/krosebrook/apps/int-smart-triage-ai-2.0` | `Krosebrook/INT-Smart-Triage-AI-2.0` | main |
| `projects/krosebrook/tools/claude-code-dev-kit` | `Krosebrook/Claude-Code-Development-Kit` | main |
| `projects/krosebrook/apps/v0-ai-agent-builder` | `Krosebrook/v0-ai-agent-builder` | main |
| `projects/krosebrook/apps/archon` | `Krosebrook/Archon` | main |
| `projects/krosebrook/apps/intos` | `Krosebrook/Intos` | main |

#### Krosebrook Apps (17 repos)

| Project Path | Mirror Repository | Branch |
|-------------|-------------------|---------|
| `projects/krosebrook/apps/v0-template-evaluation-academy` | `Krosebrook/v0-template-evaluation-academy` | main |
| `projects/krosebrook/apps/kinsleyscreativesuite` | `Krosebrook/KinsleysCreativeSuite` | main |
| `projects/krosebrook/apps/octavestudio` | `Krosebrook/OctaveStudio` | main |
| `projects/krosebrook/apps/universalwriterai` | `Krosebrook/UniversalWriterAI` | main |
| `projects/krosebrook/apps/templateevaluationacademy` | `Krosebrook/Templateevaluationacademy` | main |
| `projects/krosebrook/apps/mycontextengine` | `Krosebrook/MyContextEngine` | main |
| `projects/krosebrook/apps/creatorstudiolite` | `Krosebrook/CreatorStudioLite` | main |
| `projects/krosebrook/apps/universalaigen` | `Krosebrook/UniversalAIGen` | main |
| `projects/krosebrook/apps/flashfusion-learn` | `Krosebrook/FLashFusion-Learn` | main |
| `projects/krosebrook/apps/lovable-prompt-artist` | `Krosebrook/lovable-prompt-artist` | main |
| `projects/krosebrook/apps/analyst-cockpit-ui` | `Krosebrook/analyst-cockpit-ui` | main |
| `projects/krosebrook/apps/flashfusion-lite-ecommerce` | `Krosebrook/flashfusion-lite-ecommerce` | main |
| `projects/krosebrook/apps/int-smart-triage-ai-3.0` | `Krosebrook/int-smart-triage-ai-3.0` | main |
| `projects/krosebrook/apps/int-triage-ai-3.0` | `Krosebrook/int-triage-ai.3.0` | main |
| `projects/krosebrook/apps/project-nexus` | `Krosebrook/project-nexus` | main |
| `projects/krosebrook/apps/saas-validator-suite` | `Krosebrook/saas-validator-suite` | main |
| `projects/krosebrook/apps/open-flashfusion` | `Krosebrook/OpenFlashFusion` | main |

#### Krosebrook Tools (7 repos)

| Project Path | Mirror Repository | Branch |
|-------------|-------------------|---------|
| `projects/krosebrook/tools/claude-code-by-agents` | `Krosebrook/claude-code-by-agents` | main |
| `projects/krosebrook/tools/metamcp` | `Krosebrook/metamcp` | main |
| `projects/krosebrook/tools/playwright-mcp` | `Krosebrook/playwright-mcp` | main |
| `projects/krosebrook/tools/claude-agent-sdk-typescript` | `Krosebrook/claude-agent-sdk-typescript` | main |
| `projects/krosebrook/tools/mcp-server-docker` | `Krosebrook/mcp-server-docker` | main |
| `projects/krosebrook/tools/superpowers` | `Krosebrook/superpowers` | main |
| `projects/krosebrook/tools/boilerplates` | `Krosebrook/boilerplates` | main |

#### FlashFusionv1 (8 repos)

| Project Path | Mirror Repository | Branch |
|-------------|-------------------|---------|
| `projects/flashfusionv1/flashfusion-creative-hub` | `FlashFusionv1/flashfusion-creative-hub` | main |
| `projects/flashfusionv1/collabnet-visualizer-111` | `FlashFusionv1/collabnet-visualizer-111` | main |
| `projects/flashfusionv1/pulse-robot-template-40849` | `FlashFusionv1/pulse-robot-template-40849` | main |
| `projects/flashfusionv1/nimble-fab-flow` | `FlashFusionv1/nimble-fab-flow` | main |
| `projects/flashfusionv1/loveable-supabase` | `FlashFusionv1/loveable-supabase` | main |
| `projects/flashfusionv1/dyad` | `FlashFusionv1/dyad` | main |
| `projects/flashfusionv1/spec-kit` | `FlashFusionv1/spec-kit` | main |
| `projects/flashfusionv1/open-lovablev1` | `FlashFusionv1/open-lovablev1` | main |

#### ChaosClubCo (8 repos)

| Project Path | Mirror Repository | Branch |
|-------------|-------------------|---------|
| `projects/chaosclubco/tiktok-story-ai` | `ChaosClubCo/tiktok-story-ai` | main |
| `projects/chaosclubco/context7` | `ChaosClubCo/context7` | main |
| `projects/chaosclubco/supabase-js` | `ChaosClubCo/supabase-js` | main |
| `projects/chaosclubco/compose-for-agents` | `ChaosClubCo/compose-for-agents` | main |
| `projects/chaosclubco/flashfusion-ide` | `ChaosClubCo/flashfusion-ide` | main |
| `projects/chaosclubco/superclaude-1` | `ChaosClubCo/SuperClaude-1` | main |
| `projects/chaosclubco/superclaude` | `ChaosClubCo/SuperClaude` | main |
| `projects/chaosclubco/turborepo-flashfusion` | `ChaosClubCo/turborepo-flashfusion` | main |

---

## Git Subtree Operations

### What is Git Subtree Split?

Git subtree split extracts a subdirectory's history into a separate branch, as if that subdirectory was always
a standalone repository.

**Command**:

```bash
git subtree split --prefix=<path> -b <branch>
```text

**Example**:

```bash
git subtree split --prefix=projects/krosebrook/core/flashfusion -b split-flashfusion
```text

**Result**: Creates branch `split-flashfusion` containing only:

- Files from `projects/krosebrook/core/flashfusion/`
- Commit history touching those files
- As if the project was always at the repository root

### Workflow Steps (Per Mirror)

```bash
# 1. Create subtree split
SPLIT_BRANCH="split-$(echo $path | tr '/' '-')-$(date +%s)"
git subtree split --prefix="$path" -b "$SPLIT_BRANCH"

# 2. Push to mirror repository
git push "$repo_url" "$SPLIT_BRANCH:$branch" --force-with-lease

# 3. Clean up split branch
git branch -D "$SPLIT_BRANCH"
```text

### Why `--force-with-lease`?

```yaml
git push ... --force-with-lease
```text

**Purpose**: Safely force-push to mirror repositories.

**How it works**:

- Updates mirror only if remote matches expected state
- Prevents overwriting unexpected changes
- Safer than plain `--force`

**Why force push?**: Mirror repositories must exactly match SoT, so we overwrite their history.

---

## Authentication & Security

### Deploy Keys

Each mirror repository has a unique SSH deploy key:

**Generation**:

```bash
ssh-keygen -t ed25519 -C "sot-deploy-<repo>" -f <repo>_deploy_key -N ""
```text

**Storage**:

- **Public key**: Added to mirror repository settings (Settings → Deploy keys)
- **Private key**: Stored in GitHub Actions secrets

### GitHub Actions Secrets

**Naming convention**: `MIRROR_SSH_KEY_<PROJECT_NAME>`

**Examples**:

- `MIRROR_SSH_KEY_FLASHFUSION`
- `MIRROR_SSH_KEY_ARCHON`
- `MIRROR_SSH_KEY_DYAD`

**Total secrets**: 50 (one per mirror repository)

### SSH Configuration

The workflow dynamically configures SSH for each push:

```bash
# Write SSH key to temporary file
KEY_FILE="/tmp/deploy_key_${CURRENT}"
echo "$SSH_KEY" > "$KEY_FILE"
chmod 600 "$KEY_FILE"

# Configure Git to use this key
export GIT_SSH_COMMAND="ssh -i $KEY_FILE -o StrictHostKeyChecking=no"

# Push to mirror
git push ...

# Clean up key file
rm -f "$KEY_FILE"
```text

**Security notes**:

- Keys exist only in memory during workflow execution
- Temporary key files deleted after each push
- Each key limited to single repository write access
- No persistent key storage on runner

---

## Workflow Execution

### Normal Execution Flow

```text
1. Trigger: Push to main branch
   ↓
2. Checkout: Full repository history (fetch-depth: 0)
   ↓
3. Git Config: Set user name/email for commits
   ↓
4. Load Mirror Map: Parse /tmp/mirrors.txt
   ↓
5. For Each Mirror (50 iterations):
   a. Check if project directory exists
   b. Load SSH deploy key from secrets
   c. Write key to temporary file
   d. Configure Git SSH command
   e. Create subtree split
   f. Push to mirror repository
   g. Clean up split branch
   h. Clean up SSH key file
   ↓
6. Complete: All mirrors synchronized
```text

### Execution Time

**Typical duration**: 15-25 minutes

- ~20-30 seconds per repository
- 50 repositories total
- Sequential processing (one at a time)

**Factors affecting duration**:

- Repository size
- Number of commits since last sync
- GitHub Actions runner performance

### Output Example

```text
=== [1/50] Processing: projects/krosebrook/core/flashfusion
    Target: git@github.com:Krosebrook/FlashFusion.git (branch: main)
  → Creating subtree split...
  → Pushing to git@github.com:Krosebrook/FlashFusion.git...
✓ Success: Pushed to git@github.com:Krosebrook/FlashFusion.git

=== [2/50] Processing: projects/krosebrook/apps/archon
    Target: git@github.com:Krosebrook/Archon.git (branch: main)
  → Creating subtree split...
  → Pushing to git@github.com:Krosebrook/Archon.git...
✓ Success: Pushed to git@github.com:Krosebrook/Archon.git

...

=== Subtree push complete ===
```text

---

## Error Handling

### Common Errors

#### 1. Directory Not Exists

```text
⊙ Skipped: Directory does not exist
```

**Cause**: Project path in mirror map doesn't exist in repository.

**Resolution**: 

- Remove entry from mirror map if project was deleted
- Fix path if typo in configuration

#### 2. Secret Not Found

```text
✗ Failed: Secret MIRROR_SSH_KEY_XXX not found
```

**Cause**: GitHub Actions secret not configured.

**Resolution**: Add secret via Settings → Secrets and variables → Actions

#### 3. Push Failed

```text
✗ Failed: Could not push to git@github.com:Org/Repo.git
```

**Causes**:

- Deploy key not added to mirror repository
- Deploy key doesn't have write access
- Network/connectivity issue
- Mirror repository doesn't exist

**Resolution**:

1. Verify deploy key is added to mirror repository
2. Ensure "Allow write access" is checked
3. Check repository exists and URL is correct

#### 4. Subtree Split Failed

```text
✗ Failed: Could not create subtree split
```

**Cause**: No commits affecting the specified path.

**Resolution**: Ensure at least one commit touches files in the project directory

---

## Monitoring & Debugging

### GitHub Actions Logs

**Access**:

```text
Repository → Actions → Subtree Push workflow → Run details
```

**What to check**:

- Which repositories succeeded/failed
- Error messages for failures
- Execution time per repository

### Manual Testing

**Test single repository**:

```bash
gh workflow run subtree-push.yml \
  --field path="projects/krosebrook/core/flashfusion"
```

**View run status**:

```bash
gh run list --workflow=subtree-push.yml
gh run view <run-id>
```

### Local Testing (Advanced)

```bash
# Clone SoT monorepo
git clone git@github.com:Krosebrook/source-of-truth-monorepo.git
cd source-of-truth-monorepo

# Test subtree split locally
git subtree split --prefix=projects/krosebrook/core/flashfusion -b test-split

# Verify split branch
git log test-split --oneline

# Clean up
git branch -D test-split
```

---

## Maintenance

### Adding New Mirror Repository

1. **Add entry to workflow file** (`.github/workflows/subtree-push.yml`):

   ```text
   projects/org/new-project|git@github.com:Org/NewProject.git|main|MIRROR_SSH_KEY_NEW_PROJECT
   ```

2. **Generate deploy key**:

   ```bash
   ssh-keygen -t ed25519 -C "sot-deploy-new-project" -f new_project_deploy_key -N ""
   ```

3. **Add public key to mirror repository**:
   - Navigate to mirror repo Settings → Deploy keys
   - Click "Add deploy key"
   - Paste public key content
   - Check "Allow write access"

4. **Add private key to GitHub Actions**:
   - Navigate to SoT repo Settings → Secrets → Actions
   - Click "New repository secret"
   - Name: `MIRROR_SSH_KEY_NEW_PROJECT`
   - Value: Private key content

5. **Add secret to workflow env** (`.github/workflows/subtree-push.yml`):

   ```yaml
   env:
     MIRROR_SSH_KEY_NEW_PROJECT: ${{ secrets.MIRROR_SSH_KEY_NEW_PROJECT }}
   ```

6. **Test**:

   ```bash
   gh workflow run subtree-push.yml --field path="projects/org/new-project"
   ```

### Removing Mirror Repository

1. **Delete entry from workflow file**
2. **Remove secret from workflow env**
3. **Optionally**: Delete GitHub Actions secret
4. **Optionally**: Archive or delete mirror repository

### Rotating Deploy Keys

**Frequency**: Every 6 months (recommended)

**Process**:

1. Generate new key pair
2. Add new public key to mirror repository
3. Update GitHub Actions secret with new private key
4. Test workflow
5. Remove old public key from mirror repository

---

## Performance Optimization

### Current Limitations

- **Sequential processing**: One mirror at a time
- **Full history**: Every split processes full repository history
- **No caching**: Split operations don't benefit from caching

### Future Improvements

1. **Parallel execution**:

   ```yaml
   strategy:
     matrix:
       mirror: [repo1, repo2, ..., repo50]
   ```

2. **Conditional sync**:
   - Only sync mirrors with changed files
   - Use `git diff-tree` to detect changes

3. **Shallow splits**:
   - Limit history depth for faster splits
   - Trade-off: Mirror loses full history

---

## Related Documentation

- [SoT Canonical Model](/docs/explanation/sot-canonical-model.md) - Architecture overview
- [Git Subtree Explained](/docs/explanation/git-subtree-explained.md) - Deep dive into Git subtree
- [How to Configure Deploy Keys](/docs/how-to/configure-deploy-keys.md) - Setup guide
- [Workspace Structure](/docs/reference/workspace-structure.md) - Repository organization

---

## Quick Reference

### Commands

| Action | Command |
|--------|---------|
| Trigger workflow (all) | `gh workflow run subtree-push.yml` |
| Trigger workflow (one repo) | `gh workflow run subtree-push.yml --field path="projects/org/repo"` |
| View workflow runs | `gh run list --workflow=subtree-push.yml` |
| View run details | `gh run view <run-id>` |
| Test split locally | `git subtree split --prefix=<path> -b test` |

### Files

| Path | Purpose |
|------|---------|
| `.github/workflows/subtree-push.yml` | Main workflow definition |
| `docs/how-to/configure-deploy-keys.md` | Deploy keys setup guide |
| `scripts/generate-deploy-keys.sh` | Batch key generation |
| `scripts/add-secrets-to-github.sh` | Batch secret upload |

### Secrets

| Organization | Count | Naming Pattern |
|-------------|-------|----------------|
| Krosebrook | 34 | `MIRROR_SSH_KEY_<PROJECT>` |
| FlashFusionv1 | 8 | `MIRROR_SSH_KEY_<PROJECT>` |
| ChaosClubCo | 8 | `MIRROR_SSH_KEY_<PROJECT>` |

---

**Last Updated**: 2025-11-01  
**Maintainer**: @Krosebrook  
**Workflow Status**: Configured, pending deploy key setup
