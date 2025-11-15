# GitHub Repository Fetch & Consolidation Execution Plan
**Date**: 2025-11-02  
**Objective**: Clone all 89 repositories from GitHub to local environment for consolidation  
**Scope**: Krosebrook (76) + ChaosClubCo (6) + FlashFusionv1 (7)

---

## Executive Summary

**Goal**: Systematically fetch all GitHub repositories to local machine for audit, consolidation, and migration to source-of-truth-monorepo.

**Total Fetch**: 89 repositories across 3 organizations
- **Public Repos**: 73 (can fetch with read-only access)
- **Private Repos**: 16 (require authentication and permissions)

**Estimated Download Size**: ~2-5 GB (varies by repo history depth)  
**Estimated Time**: 1-2 hours (depends on network speed)

---

## Phase 1: Prerequisites & Environment Setup

### 1.1 Verify GitHub Authentication

```bash
# Check current GitHub CLI authentication
gh auth status

# If not authenticated, login
gh auth login

# Verify access to all organizations
gh api user/orgs --jq '.[].login'
# Expected output: ChaosClubCo, FlashFusionv1, plus any others
```

**Expected Organizations**:
- Personal account: Krosebrook
- Organization 1: ChaosClubCo
- Organization 2: FlashFusionv1

### 1.2 Create Fetch Workspace

```bash
# Create organized directory structure for cloning
mkdir -p ~/github-repos-fetch/{krosebrook,chaosclubco,flashfusionv1}
cd ~/github-repos-fetch

# Create metadata tracking directory
mkdir -p _metadata/logs
mkdir -p _metadata/manifests
```

### 1.3 Disk Space Check

```bash
# Verify available disk space (need at least 10GB)
df -h ~

# If low on space, consider:
# - Cleaning docker images: docker system prune -a
# - Cleaning package caches: sudo apt clean
# - Moving to external drive
```

---

## Phase 2: Repository Discovery & Manifest Generation

### 2.1 Generate Complete Repository Lists

```bash
# Fetch Krosebrook repos (with pagination for all 76)
gh repo list Krosebrook \
  --limit 100 \
  --json name,url,sshUrl,visibility,isPrivate,isArchived,diskUsage,pushedAt \
  > _metadata/manifests/krosebrook-repos.json

# Fetch ChaosClubCo org repos
gh repo list ChaosClubCo \
  --limit 100 \
  --json name,url,sshUrl,visibility,isPrivate,isArchived,diskUsage,pushedAt \
  > _metadata/manifests/chaosclubco-repos.json

# Fetch FlashFusionv1 org repos
gh repo list FlashFusionv1 \
  --limit 100 \
  --json name,url,sshUrl,visibility,isPrivate,isArchived,diskUsage,pushedAt \
  > _metadata/manifests/flashfusionv1-repos.json
```

### 2.2 Verify Counts

```bash
# Count repositories per account
echo "Krosebrook: $(jq '. | length' _metadata/manifests/krosebrook-repos.json)"
echo "ChaosClubCo: $(jq '. | length' _metadata/manifests/chaosclubco-repos.json)"
echo "FlashFusionv1: $(jq '. | length' _metadata/manifests/flashfusionv1-repos.json)"

# Expected: 76 + 6 + 7 = 89 total
```

### 2.3 Generate Clone Scripts

Create automated clone script with progress tracking:

```bash
cat > _metadata/clone-all-repos.sh << 'EOF'
#!/bin/bash

set -e  # Exit on error

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Counters
TOTAL=0
SUCCESS=0
FAILED=0
SKIPPED=0

# Log file
LOG_FILE="_metadata/logs/clone-$(date +%Y%m%d-%H%M%S).log"

# Function to clone a repository
clone_repo() {
    local owner=$1
    local repo=$2
    local target_dir=$3
    local ssh_url=$4
    
    TOTAL=$((TOTAL + 1))
    
    echo -e "${YELLOW}[$TOTAL] Cloning $owner/$repo...${NC}"
    
    if [ -d "$target_dir/$repo" ]; then
        echo -e "${YELLOW}  → Already exists, skipping${NC}"
        SKIPPED=$((SKIPPED + 1))
        return 0
    fi
    
    if git clone "$ssh_url" "$target_dir/$repo" >> "$LOG_FILE" 2>&1; then
        echo -e "${GREEN}  ✓ Success${NC}"
        SUCCESS=$((SUCCESS + 1))
    else
        echo -e "${RED}  ✗ Failed (check log)${NC}"
        FAILED=$((FAILED + 1))
        echo "FAILED: $owner/$repo" >> _metadata/logs/failed-repos.txt
    fi
}

# Clone Krosebrook repos
echo -e "\n${GREEN}=== Cloning Krosebrook Repositories ===${NC}\n"
while IFS= read -r repo; do
    name=$(echo "$repo" | jq -r '.name')
    ssh_url=$(echo "$repo" | jq -r '.sshUrl')
    clone_repo "Krosebrook" "$name" "krosebrook" "$ssh_url"
done < <(jq -c '.[]' _metadata/manifests/krosebrook-repos.json)

# Clone ChaosClubCo repos
echo -e "\n${GREEN}=== Cloning ChaosClubCo Repositories ===${NC}\n"
while IFS= read -r repo; do
    name=$(echo "$repo" | jq -r '.name')
    ssh_url=$(echo "$repo" | jq -r '.sshUrl')
    clone_repo "ChaosClubCo" "$name" "chaosclubco" "$ssh_url"
done < <(jq -c '.[]' _metadata/manifests/chaosclubco-repos.json)

# Clone FlashFusionv1 repos
echo -e "\n${GREEN}=== Cloning FlashFusionv1 Repositories ===${NC}\n"
while IFS= read -r repo; do
    name=$(echo "$repo" | jq -r '.name')
    ssh_url=$(echo "$repo" | jq -r '.sshUrl')
    clone_repo "FlashFusionv1" "$name" "flashfusionv1" "$ssh_url"
done < <(jq -c '.[]' _metadata/manifests/flashfusionv1-repos.json)

# Summary
echo -e "\n${GREEN}=== Clone Summary ===${NC}"
echo "Total Attempted: $TOTAL"
echo -e "${GREEN}Successful: $SUCCESS${NC}"
echo -e "${YELLOW}Skipped (exists): $SKIPPED${NC}"
echo -e "${RED}Failed: $FAILED${NC}"
echo "Log file: $LOG_FILE"

if [ $FAILED -gt 0 ]; then
    echo -e "\n${RED}Failed repositories listed in: _metadata/logs/failed-repos.txt${NC}"
fi
EOF

chmod +x _metadata/clone-all-repos.sh
```

---

## Phase 3: Shallow Clone Strategy (Fast Initial Fetch)

For initial audit, use shallow clones to save time and space:

```bash
cat > _metadata/clone-shallow.sh << 'EOF'
#!/bin/bash

# Shallow clone (--depth 1) for quick initial fetch
# Use when you only need latest code, not full history

set -e

LOG_FILE="_metadata/logs/shallow-clone-$(date +%Y%m%d-%H%M%S).log"

clone_shallow() {
    local owner=$1
    local repo=$2
    local target_dir=$3
    local ssh_url=$4
    
    echo "Cloning $owner/$repo (shallow)..."
    
    if [ -d "$target_dir/$repo" ]; then
        echo "  → Already exists, skipping"
        return 0
    fi
    
    git clone --depth 1 "$ssh_url" "$target_dir/$repo" >> "$LOG_FILE" 2>&1
}

# Krosebrook
while IFS= read -r repo; do
    name=$(echo "$repo" | jq -r '.name')
    ssh_url=$(echo "$repo" | jq -r '.sshUrl')
    clone_shallow "Krosebrook" "$name" "krosebrook" "$ssh_url"
done < <(jq -c '.[]' _metadata/manifests/krosebrook-repos.json)

# ChaosClubCo
while IFS= read -r repo; do
    name=$(echo "$repo" | jq -r '.name')
    ssh_url=$(echo "$repo" | jq -r '.sshUrl')
    clone_shallow "ChaosClubCo" "$name" "chaosclubco" "$ssh_url"
done < <(jq -c '.[]' _metadata/manifests/chaosclubco-repos.json)

# FlashFusionv1
while IFS= read -r repo; do
    name=$(echo "$repo" | jq -r '.name')
    ssh_url=$(echo "$repo" | jq -r '.sshUrl')
    clone_shallow "FlashFusionv1" "$name" "flashfusionv1" "$ssh_url"
done < <(jq -c '.[]' _metadata/manifests/flashfusionv1-repos.json)

echo "Shallow clone complete!"
EOF

chmod +x _metadata/clone-shallow.sh
```

**Shallow Clone Benefits**:
- **Speed**: 5-10x faster than full clone
- **Disk Space**: ~80% less storage
- **Use Case**: Initial code audit, dependency analysis

**When to Use Full Clone**:
- Need git history for migration
- Analyzing commit patterns
- Preserving full context for monorepo merge

---

## Phase 4: Priority-Based Fetch Strategy

Clone repositories in order of importance:

```bash
cat > _metadata/clone-priority.sh << 'EOF'
#!/bin/bash

# Clone P0/P1 repositories first (critical path)

set -e

# P0: source-of-truth-monorepo (already local)
echo "P0: source-of-truth-monorepo - Already local at ~/source-of-truth-monorepo"

# P1: Production Critical (fetch immediately)
echo -e "\n=== P1: Production Critical ==="
gh repo clone Krosebrook/flashfusion-ide krosebrook/flashfusion-ide
gh repo clone Krosebrook/turborepo-flashfusion krosebrook/turborepo-flashfusion
gh repo clone Krosebrook/INT-Smart-Triage-AI-2.0 krosebrook/INT-Smart-Triage-AI-2.0
gh repo clone Krosebrook/FlashFusion-Unified krosebrook/FlashFusion-Unified
gh repo clone Krosebrook/project-nexus krosebrook/project-nexus
gh repo clone Krosebrook/Harvestflow krosebrook/Harvestflow
gh repo clone Krosebrook/codex-workspace krosebrook/codex-workspace
gh repo clone ChaosClubCo/FlashFusion chaosclubco/FlashFusion
gh repo clone ChaosClubCo/turborepo-flashfusion chaosclubco/turborepo-flashfusion

# P2: High Value (batch 2)
echo -e "\n=== P2: High Value ==="
gh repo clone Krosebrook/DevChat krosebrook/DevChat
gh repo clone Krosebrook/saas-validator-suite krosebrook/saas-validator-suite
gh repo clone Krosebrook/OpenFlashFusion krosebrook/OpenFlashFusion
gh repo clone Krosebrook/FFKB krosebrook/FFKB
gh repo clone Krosebrook/Flashfusionwebsite krosebrook/Flashfusionwebsite
gh repo clone Krosebrook/int-triage-ai.3.0 krosebrook/int-triage-ai.3.0
gh repo clone Krosebrook/int-smart-triage-ai-3.0 krosebrook/int-smart-triage-ai-3.0
gh repo clone Krosebrook/OAuth krosebrook/OAuth
gh repo clone Krosebrook/FFSignup krosebrook/FFSignup

echo -e "\nP1/P2 repositories cloned. Run full clone script for remaining repos."
EOF

chmod +x _metadata/clone-priority.sh
```

---

## Phase 5: Parallel Clone for Speed

For faster cloning of many repos:

```bash
cat > _metadata/clone-parallel.sh << 'EOF'
#!/bin/bash

# Parallel cloning using GNU parallel or xargs
# Clone up to 5 repos simultaneously

set -e

# Check if GNU parallel is installed
if command -v parallel &> /dev/null; then
    echo "Using GNU parallel for faster cloning..."
    
    # Export function for parallel
    export -f clone_repo
    
    jq -r '.[] | @json' _metadata/manifests/krosebrook-repos.json | \
        parallel -j 5 --bar 'echo {} | jq -r ".sshUrl" | xargs git clone --depth 1 -C krosebrook'
        
else
    echo "GNU parallel not found. Install with: sudo apt install parallel"
    echo "Falling back to sequential clone..."
    ./_metadata/clone-shallow.sh
fi
EOF

chmod +x _metadata/clone-parallel.sh
```

---

## Phase 6: Post-Clone Validation & Analysis

### 6.1 Verify All Repositories Cloned

```bash
cat > _metadata/validate-clones.sh << 'EOF'
#!/bin/bash

# Validate all repositories were cloned successfully

echo "=== Clone Validation Report ==="

# Count cloned repos
KROSEBROOK_COUNT=$(find krosebrook -maxdepth 1 -type d | wc -l)
CHAOSCLUB_COUNT=$(find chaosclubco -maxdepth 1 -type d | wc -l)
FLASHFUSION_COUNT=$(find flashfusionv1 -maxdepth 1 -type d | wc -l)

echo "Krosebrook: $((KROSEBROOK_COUNT - 1)) repos (expected 76)"
echo "ChaosClubCo: $((CHAOSCLUB_COUNT - 1)) repos (expected 6)"
echo "FlashFusionv1: $((FLASHFUSION_COUNT - 1)) repos (expected 7)"

TOTAL=$((KROSEBROOK_COUNT + CHAOSCLUB_COUNT + FLASHFUSION_COUNT - 3))
echo -e "\nTotal: $TOTAL repos (expected 89)"

# Check for git repositories
echo -e "\n=== Validating Git Repositories ==="
find . -name ".git" -type d | wc -l

# List any failed clones
if [ -f _metadata/logs/failed-repos.txt ]; then
    echo -e "\n=== Failed Clones ==="
    cat _metadata/logs/failed-repos.txt
fi
EOF

chmod +x _metadata/validate-clones.sh
```

### 6.2 Generate Size Report

```bash
cat > _metadata/analyze-sizes.sh << 'EOF'
#!/bin/bash

# Analyze disk usage per repository

echo "=== Repository Size Analysis ==="

du -sh krosebrook/* | sort -h > _metadata/reports/krosebrook-sizes.txt
du -sh chaosclubco/* | sort -h > _metadata/reports/chaosclubco-sizes.txt
du -sh flashfusionv1/* | sort -h > _metadata/reports/flashfusionv1-sizes.txt

echo "Total Krosebrook: $(du -sh krosebrook | cut -f1)"
echo "Total ChaosClubCo: $(du -sh chaosclubco | cut -f1)"
echo "Total FlashFusionv1: $(du -sh flashfusionv1 | cut -f1)"
echo "Total All: $(du -sh . | cut -f1)"

echo -e "\nTop 10 Largest Repositories:"
du -sh */* | sort -hr | head -10
EOF

chmod +x _metadata/analyze-sizes.sh
```

### 6.3 Technology Stack Analysis

```bash
cat > _metadata/analyze-tech-stack.sh << 'EOF'
#!/bin/bash

# Analyze technology stacks across all repos

echo "=== Technology Stack Analysis ==="

# Count by primary language (from package.json, requirements.txt, go.mod, etc.)
echo "TypeScript/JavaScript:"
find . -name "package.json" | wc -l

echo "Python:"
find . -name "requirements.txt" -o -name "setup.py" -o -name "pyproject.toml" | wc -l

echo "Go:"
find . -name "go.mod" | wc -l

echo "Rust:"
find . -name "Cargo.toml" | wc -l

echo "Shell:"
find . -name "*.sh" | wc -l

# Detect frameworks
echo -e "\n=== Framework Detection ==="
echo "Next.js: $(grep -rl "\"next\":" . --include="package.json" | wc -l)"
echo "React: $(grep -rl "\"react\":" . --include="package.json" | wc -l)"
echo "Svelte: $(grep -rl "\"svelte\":" . --include="package.json" | wc -l)"
echo "Turborepo: $(find . -name "turbo.json" | wc -l)"
echo "Supabase: $(grep -rl "supabase" . --include="package.json" | wc -l)"
EOF

chmod +x _metadata/analyze-tech-stack.sh
```

### 6.4 Dependency Analysis

```bash
cat > _metadata/analyze-dependencies.sh << 'EOF'
#!/bin/bash

# Analyze shared dependencies across repositories

echo "=== Dependency Analysis ==="

# Find all package.json files and extract dependencies
find . -name "package.json" -not -path "*/node_modules/*" -exec jq -r '.dependencies | keys[]' {} \; 2>/dev/null | \
    sort | uniq -c | sort -rn > _metadata/reports/npm-dependencies.txt

echo "Top 20 Most Used NPM Packages:"
head -20 _metadata/reports/npm-dependencies.txt

# Find duplicate dependencies (different versions)
echo -e "\n=== Potential Version Conflicts ==="
# This is a simplified check - full analysis requires more sophisticated tooling
find . -name "package.json" -not -path "*/node_modules/*" -exec grep -H "\"react\":" {} \; | \
    cut -d: -f1,3 | sort | uniq

EOF

chmod +x _metadata/analyze-dependencies.sh
```

---

## Phase 7: Execution Plan

### Option A: Full Clone (Recommended for Migration)

**Best for**: Complete history preservation, accurate migration to monorepo

```bash
cd ~/github-repos-fetch

# Step 1: Generate manifests
gh repo list Krosebrook --limit 100 --json name,url,sshUrl,visibility > _metadata/manifests/krosebrook-repos.json
gh repo list ChaosClubCo --limit 100 --json name,url,sshUrl,visibility > _metadata/manifests/chaosclubco-repos.json
gh repo list FlashFusionv1 --limit 100 --json name,url,sshUrl,visibility > _metadata/manifests/flashfusionv1-repos.json

# Step 2: Run full clone script
./_metadata/clone-all-repos.sh

# Step 3: Validate
./_metadata/validate-clones.sh

# Step 4: Analyze
./_metadata/analyze-sizes.sh
./_metadata/analyze-tech-stack.sh
./_metadata/analyze-dependencies.sh
```

**Estimated Time**: 60-120 minutes  
**Disk Space**: 3-6 GB

### Option B: Shallow Clone (Fast Audit)

**Best for**: Quick code review, dependency analysis, no history needed

```bash
cd ~/github-repos-fetch

# Step 1: Generate manifests (same as above)

# Step 2: Run shallow clone
./_metadata/clone-shallow.sh

# Step 3: Validate & analyze (same as above)
```

**Estimated Time**: 10-20 minutes  
**Disk Space**: 500 MB - 1 GB

### Option C: Priority-First Clone

**Best for**: Start migration immediately while background fetching others

```bash
cd ~/github-repos-fetch

# Step 1: Clone P0/P1 first
./_metadata/clone-priority.sh

# Step 2: Start working on migration

# Step 3: Background fetch remaining repos
nohup ./_metadata/clone-all-repos.sh > clone.log 2>&1 &
```

**Estimated Time**: P1 in 10 mins, full in background  
**Disk Space**: Same as full clone

---

## Phase 8: Handling Private Repositories

### 8.1 Verify Access to Private Repos

```bash
# Check which private repos you have access to
gh repo list Krosebrook --json name,visibility --jq '.[] | select(.visibility=="PRIVATE") | .name'

# Test clone one private repo
gh repo clone Krosebrook/source-of-truth-monorepo /tmp/test-private-clone
```

If clone fails:
1. Check GitHub token permissions: `gh auth status`
2. Refresh token: `gh auth refresh -h github.com -s repo`
3. Verify organization membership: `gh api user/orgs`

### 8.2 SSH Key Setup (Alternative to HTTPS)

```bash
# Check if SSH key exists
ls -la ~/.ssh/id_*.pub

# If not, generate SSH key
ssh-keygen -t ed25519 -C "your-email@example.com"

# Add to SSH agent
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519

# Copy public key and add to GitHub
cat ~/.ssh/id_ed25519.pub
# Go to: github.com/settings/keys
```

---

## Phase 9: Duplicate Detection After Clone

```bash
cat > _metadata/detect-duplicates.sh << 'EOF'
#!/bin/bash

# Detect duplicate repositories across organizations

echo "=== Duplicate Repository Detection ==="

# Find repos with same name across organizations
comm -12 \
    <(ls krosebrook | sort) \
    <(ls chaosclubco | sort) \
    > _metadata/reports/duplicates-krosebrook-chaosclubco.txt

comm -12 \
    <(ls krosebrook | sort) \
    <(ls flashfusionv1 | sort) \
    > _metadata/reports/duplicates-krosebrook-flashfusionv1.txt

comm -12 \
    <(ls chaosclubco | sort) \
    <(ls flashfusionv1 | sort) \
    > _metadata/reports/duplicates-chaosclubco-flashfusionv1.txt

echo "Duplicates found:"
echo "Krosebrook ↔ ChaosClubCo:"
cat _metadata/reports/duplicates-krosebrook-chaosclubco.txt

echo -e "\nKrosebrook ↔ FlashFusionv1:"
cat _metadata/reports/duplicates-krosebrook-flashfusionv1.txt

echo -e "\nChaosClubCo ↔ FlashFusionv1:"
cat _metadata/reports/duplicates-chaosclubco-flashfusionv1.txt
EOF

chmod +x _metadata/detect-duplicates.sh
```

---

## Phase 10: Post-Fetch Consolidation Prep

### 10.1 Create Consolidation Workspace

```bash
# Prepare workspace for monorepo consolidation
mkdir -p ~/consolidation-workspace/{staging,backups,scripts}

# Symlink cloned repos for easy access
ln -s ~/github-repos-fetch ~/consolidation-workspace/source-repos
```

### 10.2 Backup Before Migration

```bash
# Create immutable backup before any changes
cd ~/github-repos-fetch
tar -czf ~/consolidation-workspace/backups/github-repos-backup-$(date +%Y%m%d).tar.gz .

# Verify backup
tar -tzf ~/consolidation-workspace/backups/github-repos-backup-*.tar.gz | head
```

### 10.3 Generate Migration Scripts

```bash
# Will be created in next phase based on your answers to 5 clarifying questions
# See COMPLETE_REPOSITORY_CATALOG.md for consolidation strategy
```

---

## Phase 11: Troubleshooting

### Issue: Authentication Fails

```bash
# Symptom: "remote: Repository not found" or "Permission denied"

# Solution 1: Refresh GitHub token
gh auth login --web

# Solution 2: Check token scopes
gh auth status

# Solution 3: Use SSH instead of HTTPS
# Edit clone scripts to use sshUrl instead of url
```

### Issue: Disk Space Full

```bash
# Symptom: "No space left on device"

# Solution 1: Check space
df -h ~

# Solution 2: Clean up
docker system prune -a  # Clean Docker
sudo apt clean          # Clean package cache
rm -rf ~/.cache/*       # Clean user cache

# Solution 3: Use shallow clones
./_metadata/clone-shallow.sh  # 80% less space
```

### Issue: Clone Timeout/Slow

```bash
# Symptom: Clone hangs or very slow

# Solution 1: Increase timeout
git config --global http.postBuffer 524288000

# Solution 2: Use shallow clone
git clone --depth 1 <url>

# Solution 3: Clone during off-peak hours
```

### Issue: Private Repo Access Denied

```bash
# Symptom: "Repository not found" for known private repo

# Solution: Verify organization membership
gh api orgs/ChaosClubCo/memberships/$USER
gh api orgs/FlashFusionv1/memberships/$USER

# Request access if needed
# Contact organization admin to add you
```

---

## Recommended Execution Sequence

### Day 1: Setup & P1 Fetch (60 mins)

```bash
# 1. Setup workspace (5 mins)
mkdir -p ~/github-repos-fetch/{krosebrook,chaosclubco,flashfusionv1,_metadata/{logs,manifests,reports,scripts}}
cd ~/github-repos-fetch

# 2. Verify authentication (5 mins)
gh auth status
gh auth refresh -h github.com -s repo

# 3. Generate manifests (5 mins)
gh repo list Krosebrook --limit 100 --json name,url,sshUrl,visibility,isPrivate,diskUsage > _metadata/manifests/krosebrook-repos.json
gh repo list ChaosClubCo --limit 100 --json name,url,sshUrl,visibility,isPrivate,diskUsage > _metadata/manifests/chaosclubco-repos.json
gh repo list FlashFusionv1 --limit 100 --json name,url,sshUrl,visibility,isPrivate,diskUsage > _metadata/manifests/flashfusionv1-repos.json

# 4. Create scripts (copy from this document) (10 mins)
# - clone-all-repos.sh
# - clone-priority.sh
# - validate-clones.sh
# - analyze-*.sh scripts

# 5. Clone P0/P1 repos first (30 mins)
./_metadata/clone-priority.sh

# 6. Begin migration planning while full fetch runs in background
nohup ./_metadata/clone-all-repos.sh > _metadata/logs/clone-$(date +%Y%m%d).log 2>&1 &
```

### Day 2: Validate & Analyze (30 mins)

```bash
# 7. Validate all clones completed
./_metadata/validate-clones.sh

# 8. Run analysis scripts
./_metadata/analyze-sizes.sh
./_metadata/analyze-tech-stack.sh
./_metadata/analyze-dependencies.sh
./_metadata/detect-duplicates.sh

# 9. Review reports
cat _metadata/reports/*.txt
```

### Day 3+: Begin Migration

```bash
# 10. Create backup
tar -czf ~/github-repos-backup-$(date +%Y%m%d).tar.gz ~/github-repos-fetch

# 11. Start consolidation (based on COMPLETE_REPOSITORY_CATALOG.md)
# Follow migration phases P1 → P6
```

---

## Success Criteria

**Fetch Complete When**:
- [ ] All 89 repositories cloned to local machine
- [ ] Zero authentication errors
- [ ] All .git directories present and valid
- [ ] Validation script shows 89/89 repos
- [ ] Size analysis report generated
- [ ] Dependency analysis complete
- [ ] Duplicate detection report reviewed
- [ ] Backup created and verified

---

## Next Actions After Fetch

1. **Answer 5 Clarifying Questions** (from COMPLETE_REPOSITORY_CATALOG.md)
2. **Review duplicate detection report** (prioritize consolidation targets)
3. **Validate private repo access** (ensure all 16 are accessible)
4. **Create detailed migration plan** (based on your answers)
5. **Begin P1 consolidation** (critical production repos first)

---

## Appendix: Quick Reference Commands

```bash
# Fetch all repos (full clone)
cd ~/github-repos-fetch && ./_metadata/clone-all-repos.sh

# Fetch all repos (shallow/fast)
cd ~/github-repos-fetch && ./_metadata/clone-shallow.sh

# Fetch P1 only (start migration immediately)
cd ~/github-repos-fetch && ./_metadata/clone-priority.sh

# Validate fetch
./_metadata/validate-clones.sh

# Check progress (if running in background)
tail -f _metadata/logs/clone-*.log

# Stop background fetch
pkill -f clone-all-repos.sh

# Resume failed clones
grep FAILED _metadata/logs/failed-repos.txt | xargs -I {} gh repo clone {}

# Check total disk usage
du -sh ~/github-repos-fetch

# Clean up (DANGER: only after migration complete)
rm -rf ~/github-repos-fetch
```

---

**Document Version**: 1.0.0  
**Created**: 2025-11-02  
**Ready to Execute**: Yes  
**Estimated Total Time**: 2-3 hours (setup + fetch + validation)

