#!/bin/bash
# Import GitHub repos into Source-of-Truth monorepo
# Enhanced version with batch operations, logging, and resumability
#
# Usage: 
#   ./scripts/import-github-repos.sh [OPTIONS]
#
# Options:
#   -f, --file FILE         Path to repo list file (default: scripts/repo-list.txt)
#   -b, --batch-size N      Number of repos to import per batch (default: 30)
#   -r, --resume            Resume from last checkpoint
#   -e, --exclude-archived  Skip archived/deprecated repos
#   -l, --log-file FILE     Log file path (default: logs/import-TIMESTAMP.log)
#   -h, --help              Show this help message
#
# Repo list format (one per line):
#   org|name|url|target_dir|status
#   Example: krosebrook|FlashFusion|https://github.com/Krosebrook/FlashFusion.git|projects/krosebrook/core/flashfusion|active

set -euo pipefail

# Default configuration
REPO_LIST_FILE="scripts/repo-list.txt"
BATCH_SIZE=30
RESUME=false
EXCLUDE_ARCHIVED=false
CHECKPOINT_FILE=".import-checkpoint"
LOG_DIR="logs"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
LOG_FILE="${LOG_DIR}/import-${TIMESTAMP}.log"

# Parse command line arguments
show_help() {
    grep '^#' "$0" | grep -E '^# (Usage:|Options:|  )' | sed 's/^# //'
    exit 0
}

while [[ $# -gt 0 ]]; do
    case $1 in
        -f|--file)
            REPO_LIST_FILE="$2"
            shift 2
            ;;
        -b|--batch-size)
            BATCH_SIZE="$2"
            shift 2
            ;;
        -r|--resume)
            RESUME=true
            shift
            ;;
        -e|--exclude-archived)
            EXCLUDE_ARCHIVED=true
            shift
            ;;
        -l|--log-file)
            LOG_FILE="$2"
            shift 2
            ;;
        -h|--help)
            show_help
            ;;
        *)
            echo "Unknown option: $1"
            show_help
            ;;
    esac
done

# Initialize logging
mkdir -p "$LOG_DIR"

# Log the start
{
echo "=== FlashFusion SoT GitHub Repo Importer ==="
echo "Started at: $(date)"
echo "Repo list: $REPO_LIST_FILE"
echo "Batch size: $BATCH_SIZE"
echo "Resume mode: $RESUME"
echo "Exclude archived: $EXCLUDE_ARCHIVED"
echo "Log file: $LOG_FILE"
echo ""
} | tee -a "$LOG_FILE"

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Counters
SUCCESS=0
FAILED=0
SKIPPED=0
ARCHIVED=0

# Logging functions
log_success() {
    local msg="$1"
    echo -e "${GREEN}✓ Success${NC}: $msg"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] SUCCESS: $msg" >> "$LOG_FILE"
}

log_error() {
    local msg="$1"
    echo -e "${RED}✗ Failed${NC}: $msg"  
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] ERROR: $msg" >> "$LOG_FILE"
}

log_skip() {
    local msg="$1"
    echo -e "${YELLOW}⊙ Skipped${NC}: $msg"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] SKIPPED: $msg" >> "$LOG_FILE"
}

log_info() {
    local msg="$1"
    echo -e "${BLUE}ℹ${NC} $msg"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] INFO: $msg" >> "$LOG_FILE"
}

# Checkpoint functions
save_checkpoint() {
    local org=$1
    local name=$2
    echo "$org|$name" > "$CHECKPOINT_FILE"
}

load_checkpoint() {
    if [ -f "$CHECKPOINT_FILE" ]; then
        cat "$CHECKPOINT_FILE"
    else
        echo ""
    fi
}

clear_checkpoint() {
    rm -f "$CHECKPOINT_FILE"
}

# Function to clone and flatten a repo
import_repo() {
    local org=$1
    local name=$2
    local url=$3
    local target_dir=$4
    local status=${5:-active}

    log_info "Importing $name from $org..."

    # Check if archived and should skip
    if [ "$EXCLUDE_ARCHIVED" = true ] && [[ "$status" =~ ^(archived|deprecated)$ ]]; then
        log_skip "$name (status: $status)"
        ((ARCHIVED++))
        return 0
    fi

    # Skip if already exists
    if [ -d "$target_dir" ]; then
        log_skip "$name (already exists): $target_dir"
        ((SKIPPED++))
        save_checkpoint "$org" "$name"
        return 0
    fi

    # Clone to temp location
    local temp_dir="/tmp/sot-import-$$-$name"
    
    # Clean up any existing temp dir
    rm -rf "$temp_dir"
    
    # Clone with stdin redirected to /dev/null to prevent consuming loop input
    # Quiet mode to avoid verbose output
    if git clone --depth 1 --quiet "$url" "$temp_dir" </dev/null 2>/dev/null; then
        # Remove .git directory (flatten)
        rm -rf "$temp_dir/.git"

        # Move to target
        mkdir -p "$(dirname "$target_dir")"
        mv "$temp_dir" "$target_dir"

        log_success "$name -> $target_dir"
        ((SUCCESS++))
        save_checkpoint "$org" "$name"
        return 0
    else
        log_error "Could not clone $name from $url"
        ((FAILED++))
        # Clean up failed temp directory
        rm -rf "$temp_dir"
        return 1
    fi
}

# Check if repo list file exists
if [ ! -f "$REPO_LIST_FILE" ]; then
    log_error "Repo list file not found: $REPO_LIST_FILE"
    echo ""
    echo "Creating default repo list at: $REPO_LIST_FILE"
    
    # Create scripts directory if it doesn't exist
    mkdir -p "$(dirname "$REPO_LIST_FILE")"
    
    # Create default repo list from embedded data
    cat > "$REPO_LIST_FILE" <<'EOF'
# Format: org|name|url|target_dir|status
# Status can be: active, archived, deprecated
# Lines starting with # are comments and will be ignored

# Krosebrook Core (10)
krosebrook|FlashFusion|https://github.com/Krosebrook/FlashFusion.git|projects/krosebrook/core/flashfusion|active
krosebrook|Flashfusionwebsite|https://github.com/Krosebrook/Flashfusionwebsite.git|projects/krosebrook/core/flashfusionwebsite|active
krosebrook|FlashFusion-Unified|https://github.com/Krosebrook/FlashFusion-Unified.git|projects/krosebrook/core/flashfusion-unified|active
krosebrook|MonoTurboRepo-FlashFusion|https://github.com/Krosebrook/MonoTurboRepo-FlashFusion.git|projects/krosebrook/core/mono-turbo-repo-flashfusion|active
krosebrook|theaidashboard|https://github.com/Krosebrook/theaidashboard.git|projects/krosebrook/core/theaidashboard|active
krosebrook|INT-Smart-Triage-AI-2.0|https://github.com/Krosebrook/INT-Smart-Triage-AI-2.0.git|projects/krosebrook/apps/int-smart-triage-ai-2.0|active
krosebrook|Claude-Code-Development-Kit|https://github.com/Krosebrook/Claude-Code-Development-Kit.git|projects/krosebrook/tools/claude-code-dev-kit|active
krosebrook|v0-ai-agent-builder|https://github.com/Krosebrook/v0-ai-agent-builder.git|projects/krosebrook/apps/v0-ai-agent-builder|active
krosebrook|Archon|https://github.com/Krosebrook/Archon.git|projects/krosebrook/apps/archon|active
krosebrook|Intos|https://github.com/Krosebrook/Intos.git|projects/krosebrook/apps/intos|active

# Krosebrook Apps (17)
krosebrook|v0-template-evaluation-academy|https://github.com/Krosebrook/v0-template-evaluation-academy.git|projects/krosebrook/apps/v0-template-evaluation-academy|active
krosebrook|KinsleysCreativeSuite|https://github.com/Krosebrook/KinsleysCreativeSuite.git|projects/krosebrook/apps/kinsleyscreativesuite|active
krosebrook|OctaveStudio|https://github.com/Krosebrook/OctaveStudio.git|projects/krosebrook/apps/octavestudio|active
krosebrook|UniversalWriterAI|https://github.com/Krosebrook/UniversalWriterAI.git|projects/krosebrook/apps/universalwriterai|active
krosebrook|Templateevaluationacademy|https://github.com/Krosebrook/Templateevaluationacademy.git|projects/krosebrook/apps/templateevaluationacademy|active
krosebrook|MyContextEngine|https://github.com/Krosebrook/MyContextEngine.git|projects/krosebrook/apps/mycontextengine|active
krosebrook|CreatorStudioLite|https://github.com/Krosebrook/CreatorStudioLite.git|projects/krosebrook/apps/creatorstudiolite|active
krosebrook|UniversalAIGen|https://github.com/Krosebrook/UniversalAIGen.git|projects/krosebrook/apps/universalaigen|active
krosebrook|FLashFusion-Learn|https://github.com/Krosebrook/FLashFusion-Learn.git|projects/krosebrook/apps/flashfusion-learn|active
krosebrook|lovable-prompt-artist|https://github.com/Krosebrook/lovable-prompt-artist.git|projects/krosebrook/apps/lovable-prompt-artist|active
krosebrook|analyst-cockpit-ui|https://github.com/Krosebrook/analyst-cockpit-ui.git|projects/krosebrook/apps/analyst-cockpit-ui|active
krosebrook|flashfusion-lite-ecommerce|https://github.com/Krosebrook/flashfusion-lite-ecommerce.git|projects/krosebrook/apps/flashfusion-lite-ecommerce|active
krosebrook|int-smart-triage-ai-3.0|https://github.com/Krosebrook/int-smart-triage-ai-3.0.git|projects/krosebrook/apps/int-smart-triage-ai-3.0|active
krosebrook|int-triage-ai.3.0|https://github.com/Krosebrook/int-triage-ai.3.0.git|projects/krosebrook/apps/int-triage-ai-3.0|active
krosebrook|project-nexus|https://github.com/Krosebrook/project-nexus.git|projects/krosebrook/apps/project-nexus|active
krosebrook|saas-validator-suite|https://github.com/Krosebrook/saas-validator-suite.git|projects/krosebrook/apps/saas-validator-suite|active
krosebrook|OpenFlashFusion|https://github.com/Krosebrook/OpenFlashFusion.git|projects/krosebrook/apps/open-flashfusion|active

# Krosebrook Tools (7)
krosebrook|claude-code-by-agents|https://github.com/Krosebrook/claude-code-by-agents.git|projects/krosebrook/tools/claude-code-by-agents|active
krosebrook|metamcp|https://github.com/Krosebrook/metamcp.git|projects/krosebrook/tools/metamcp|active
krosebrook|playwright-mcp|https://github.com/Krosebrook/playwright-mcp.git|projects/krosebrook/tools/playwright-mcp|active
krosebrook|claude-agent-sdk-typescript|https://github.com/Krosebrook/claude-agent-sdk-typescript.git|projects/krosebrook/tools/claude-agent-sdk-typescript|active
krosebrook|mcp-server-docker|https://github.com/Krosebrook/mcp-server-docker.git|projects/krosebrook/tools/mcp-server-docker|active
krosebrook|superpowers|https://github.com/Krosebrook/superpowers.git|projects/krosebrook/tools/superpowers|active
krosebrook|boilerplates|https://github.com/Krosebrook/boilerplates.git|projects/krosebrook/tools/boilerplates|active

# FlashFusionv1 (8)
flashfusionv1|flashfusion-creative-hub|https://github.com/FlashFusionv1/flashfusion-creative-hub.git|projects/flashfusionv1/flashfusion-creative-hub|active
flashfusionv1|collabnet-visualizer-111|https://github.com/FlashFusionv1/collabnet-visualizer-111.git|projects/flashfusionv1/collabnet-visualizer-111|active
flashfusionv1|pulse-robot-template-40849|https://github.com/FlashFusionv1/pulse-robot-template-40849.git|projects/flashfusionv1/pulse-robot-template-40849|active
flashfusionv1|nimble-fab-flow|https://github.com/FlashFusionv1/nimble-fab-flow.git|projects/flashfusionv1/nimble-fab-flow|active
flashfusionv1|loveable-supabase|https://github.com/FlashFusionv1/loveable-supabase.git|projects/flashfusionv1/loveable-supabase|active
flashfusionv1|dyad|https://github.com/FlashFusionv1/dyad.git|projects/flashfusionv1/dyad|active
flashfusionv1|spec-kit|https://github.com/FlashFusionv1/spec-kit.git|projects/flashfusionv1/spec-kit|active
flashfusionv1|open-lovablev1|https://github.com/FlashFusionv1/open-lovablev1.git|projects/flashfusionv1/open-lovablev1|active

# ChaosClubCo (8)
chaosclubco|tiktok-story-ai|https://github.com/ChaosClubCo/tiktok-story-ai.git|projects/chaosclubco/tiktok-story-ai|active
chaosclubco|context7|https://github.com/ChaosClubCo/context7.git|projects/chaosclubco/context7|active
chaosclubco|supabase-js|https://github.com/ChaosClubCo/supabase-js.git|projects/chaosclubco/supabase-js|active
chaosclubco|compose-for-agents|https://github.com/ChaosClubCo/compose-for-agents.git|projects/chaosclubco/compose-for-agents|active
chaosclubco|flashfusion-ide|https://github.com/ChaosClubCo/flashfusion-ide.git|projects/chaosclubco/flashfusion-ide|active
chaosclubco|SuperClaude-1|https://github.com/ChaosClubCo/SuperClaude-1.git|projects/chaosclubco/superclaude-1|active
chaosclubco|SuperClaude|https://github.com/ChaosClubCo/SuperClaude.git|projects/chaosclubco/superclaude|active
chaosclubco|turborepo-flashfusion|https://github.com/ChaosClubCo/turborepo-flashfusion.git|projects/chaosclubco/turborepo-flashfusion|active
EOF
    
    echo "Default repo list created. Edit $REPO_LIST_FILE to customize."
    echo ""
fi

# Determine start position for resume mode
RESUME_FROM=""
if [ "$RESUME" = true ]; then
    RESUME_FROM=$(load_checkpoint)
    if [ -n "$RESUME_FROM" ]; then
        log_info "Resuming from checkpoint: $RESUME_FROM"
    else
        log_info "No checkpoint found, starting from beginning"
        RESUME=false
    fi
fi

# Count total repos
TOTAL_REPOS=$(grep -v '^#' "$REPO_LIST_FILE" | grep -v '^[[:space:]]*$' | wc -l)
log_info "Total repositories to process: $TOTAL_REPOS"
echo ""

# Process repos in batches
CURRENT_BATCH=0
BATCH_COUNT=0
FOUND_RESUME_POINT=false

while IFS='|' read -r org name url target_dir status; do
    # Skip comments and empty lines
    [[ "$org" =~ ^#.*$ ]] && continue
    [[ -z "$org" ]] && continue
    
    # Handle resume mode - skip until we find the checkpoint
    if [ "$RESUME" = true ] && [ "$FOUND_RESUME_POINT" = false ]; then
        if [ "$org|$name" = "$RESUME_FROM" ]; then
            FOUND_RESUME_POINT=true
            log_info "Found resume point, continuing from next repo"
            continue
        else
            ((SKIPPED++))
            continue
        fi
    fi
    
    # Batch management
    if [ $BATCH_COUNT -ge $BATCH_SIZE ]; then
        ((CURRENT_BATCH++))
        log_info "Completed batch $CURRENT_BATCH ($BATCH_SIZE repos)"
        log_info "Pausing for 2 seconds before next batch..."
        sleep 2
        BATCH_COUNT=0
        echo ""
    fi
    
    # Import the repo (with error handling to continue on failure)
    import_repo "$org" "$name" "$url" "$target_dir" "${status:-active}" || true
    
    ((BATCH_COUNT++))
    
done < "$REPO_LIST_FILE"


# Summary
{
echo ""
echo "=== Import Summary ==="
echo "Completed at: $(date)"
echo -e "${GREEN}✓ Success: $SUCCESS${NC}"
echo -e "${YELLOW}⊙ Skipped: $SKIPPED${NC}"
if [ $EXCLUDE_ARCHIVED = true ]; then
    echo -e "⊙ Archived/Deprecated: $ARCHIVED"
fi
echo -e "${RED}✗ Failed: $FAILED${NC}"
echo "Total processed: $((SUCCESS + SKIPPED + FAILED + ARCHIVED))"
echo ""
echo "Log file: $LOG_FILE"

# Clear checkpoint if all successful
if [ $FAILED -eq 0 ]; then
    clear_checkpoint
    echo ""
    if [ $SUCCESS -gt 0 ]; then
        echo "Next steps:"
        echo "  1. Review imported repos: ls -la projects/"
        echo "  2. Commit: git add projects/ && git commit -m 'feat: Import GitHub repos'"
        echo "  3. Push: git push"
        echo "  4. Run: pnpm install"
    fi
else
    echo ""
    echo "⚠️  Some imports failed. Review the log file for details."
    echo "   To resume from the last successful import, run:"
    echo "   $0 --resume"
fi

echo ""
} | tee -a "$LOG_FILE"

# Exit with appropriate code
if [ $FAILED -gt 0 ]; then
    exit 1
else
    exit 0
fi
