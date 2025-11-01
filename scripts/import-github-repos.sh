#!/bin/bash
# Import GitHub repos into Source-of-Truth monorepo
# Usage: ./scripts/import-github-repos.sh

set -euo pipefail

echo "=== FlashFusion SoT GitHub Repo Importer ==="
echo ""

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Counters
SUCCESS=0
FAILED=0
SKIPPED=0

# Function to clone and flatten a repo
import_repo() {
    local org=$1
    local name=$2
    local url=$3
    local target_dir=$4

    echo -e "${BLUE}Importing${NC} $name from $org..."

    # Skip if already exists
    if [ -d "$target_dir" ]; then
        echo -e "${YELLOW}⊙ Skipped${NC} (already exists): $target_dir"
        ((SKIPPED++))
        return
    fi

    # Clone to temp location
    local temp_dir="/tmp/sot-import-$$-$name"
    if git clone --depth 1 "$url" "$temp_dir" 2>/dev/null; then
        # Remove .git directory (flatten)
        rm -rf "$temp_dir/.git"

        # Move to target
        mkdir -p "$(dirname "$target_dir")"
        mv "$temp_dir" "$target_dir"

        echo -e "${GREEN}✓ Success${NC}: $target_dir"
        ((SUCCESS++))
    else
        echo -e "${YELLOW}✗ Failed${NC}: Could not clone $url"
        ((FAILED++))
    fi
}

# Create temp import list
# REPO_LIST_START - marker for parsing (do not remove)
cat > /tmp/sot-import-list.txt <<'EOF'
# Format: org|name|url|target_dir

# Krosebrook Core (10)
krosebrook|FlashFusion|https://github.com/Krosebrook/FlashFusion.git|projects/krosebrook/core/flashfusion
krosebrook|Flashfusionwebsite|https://github.com/Krosebrook/Flashfusionwebsite.git|projects/krosebrook/core/flashfusionwebsite
krosebrook|FlashFusion-Unified|https://github.com/Krosebrook/FlashFusion-Unified.git|projects/krosebrook/core/flashfusion-unified
krosebrook|MonoTurboRepo-FlashFusion|https://github.com/Krosebrook/MonoTurboRepo-FlashFusion.git|projects/krosebrook/core/mono-turbo-repo-flashfusion
krosebrook|theaidashboard|https://github.com/Krosebrook/theaidashboard.git|projects/krosebrook/core/theaidashboard
krosebrook|INT-Smart-Triage-AI-2.0|https://github.com/Krosebrook/INT-Smart-Triage-AI-2.0.git|projects/krosebrook/apps/int-smart-triage-ai-2.0
krosebrook|Claude-Code-Development-Kit|https://github.com/Krosebrook/Claude-Code-Development-Kit.git|projects/krosebrook/tools/claude-code-dev-kit
krosebrook|v0-ai-agent-builder|https://github.com/Krosebrook/v0-ai-agent-builder.git|projects/krosebrook/apps/v0-ai-agent-builder
krosebrook|Archon|https://github.com/Krosebrook/Archon.git|projects/krosebrook/apps/archon
krosebrook|Intos|https://github.com/Krosebrook/Intos.git|projects/krosebrook/apps/intos

# Krosebrook Apps (17)
krosebrook|v0-template-evaluation-academy|https://github.com/Krosebrook/v0-template-evaluation-academy.git|projects/krosebrook/apps/v0-template-evaluation-academy
krosebrook|KinsleysCreativeSuite|https://github.com/Krosebrook/KinsleysCreativeSuite.git|projects/krosebrook/apps/kinsleyscreativesuite
krosebrook|OctaveStudio|https://github.com/Krosebrook/OctaveStudio.git|projects/krosebrook/apps/octavestudio
krosebrook|UniversalWriterAI|https://github.com/Krosebrook/UniversalWriterAI.git|projects/krosebrook/apps/universalwriterai
krosebrook|Templateevaluationacademy|https://github.com/Krosebrook/Templateevaluationacademy.git|projects/krosebrook/apps/templateevaluationacademy
krosebrook|MyContextEngine|https://github.com/Krosebrook/MyContextEngine.git|projects/krosebrook/apps/mycontextengine
krosebrook|CreatorStudioLite|https://github.com/Krosebrook/CreatorStudioLite.git|projects/krosebrook/apps/creatorstudiolite
krosebrook|UniversalAIGen|https://github.com/Krosebrook/UniversalAIGen.git|projects/krosebrook/apps/universalaigen
krosebrook|FLashFusion-Learn|https://github.com/Krosebrook/FLashFusion-Learn.git|projects/krosebrook/apps/flashfusion-learn
krosebrook|lovable-prompt-artist|https://github.com/Krosebrook/lovable-prompt-artist.git|projects/krosebrook/apps/lovable-prompt-artist
krosebrook|analyst-cockpit-ui|https://github.com/Krosebrook/analyst-cockpit-ui.git|projects/krosebrook/apps/analyst-cockpit-ui
krosebrook|flashfusion-lite-ecommerce|https://github.com/Krosebrook/flashfusion-lite-ecommerce.git|projects/krosebrook/apps/flashfusion-lite-ecommerce
krosebrook|int-smart-triage-ai-3.0|https://github.com/Krosebrook/int-smart-triage-ai-3.0.git|projects/krosebrook/apps/int-smart-triage-ai-3.0
krosebrook|int-triage-ai.3.0|https://github.com/Krosebrook/int-triage-ai.3.0.git|projects/krosebrook/apps/int-triage-ai-3.0
krosebrook|project-nexus|https://github.com/Krosebrook/project-nexus.git|projects/krosebrook/apps/project-nexus
krosebrook|saas-validator-suite|https://github.com/Krosebrook/saas-validator-suite.git|projects/krosebrook/apps/saas-validator-suite
krosebrook|OpenFlashFusion|https://github.com/Krosebrook/OpenFlashFusion.git|projects/krosebrook/apps/open-flashfusion

# Krosebrook Tools (7)
krosebrook|claude-code-by-agents|https://github.com/Krosebrook/claude-code-by-agents.git|projects/krosebrook/tools/claude-code-by-agents
krosebrook|metamcp|https://github.com/Krosebrook/metamcp.git|projects/krosebrook/tools/metamcp
krosebrook|playwright-mcp|https://github.com/Krosebrook/playwright-mcp.git|projects/krosebrook/tools/playwright-mcp
krosebrook|claude-agent-sdk-typescript|https://github.com/Krosebrook/claude-agent-sdk-typescript.git|projects/krosebrook/tools/claude-agent-sdk-typescript
krosebrook|mcp-server-docker|https://github.com/Krosebrook/mcp-server-docker.git|projects/krosebrook/tools/mcp-server-docker
krosebrook|superpowers|https://github.com/Krosebrook/superpowers.git|projects/krosebrook/tools/superpowers
krosebrook|boilerplates|https://github.com/Krosebrook/boilerplates.git|projects/krosebrook/tools/boilerplates

# FlashFusionv1 (8)
flashfusionv1|flashfusion-creative-hub|https://github.com/FlashFusionv1/flashfusion-creative-hub.git|projects/flashfusionv1/flashfusion-creative-hub
flashfusionv1|collabnet-visualizer-111|https://github.com/FlashFusionv1/collabnet-visualizer-111.git|projects/flashfusionv1/collabnet-visualizer-111
flashfusionv1|pulse-robot-template-40849|https://github.com/FlashFusionv1/pulse-robot-template-40849.git|projects/flashfusionv1/pulse-robot-template-40849
flashfusionv1|nimble-fab-flow|https://github.com/FlashFusionv1/nimble-fab-flow.git|projects/flashfusionv1/nimble-fab-flow
flashfusionv1|loveable-supabase|https://github.com/FlashFusionv1/loveable-supabase.git|projects/flashfusionv1/loveable-supabase
flashfusionv1|dyad|https://github.com/FlashFusionv1/dyad.git|projects/flashfusionv1/dyad
flashfusionv1|spec-kit|https://github.com/FlashFusionv1/spec-kit.git|projects/flashfusionv1/spec-kit
flashfusionv1|open-lovablev1|https://github.com/FlashFusionv1/open-lovablev1.git|projects/flashfusionv1/open-lovablev1

# ChaosClubCo (8)
chaosclubco|tiktok-story-ai|https://github.com/ChaosClubCo/tiktok-story-ai.git|projects/chaosclubco/tiktok-story-ai
chaosclubco|context7|https://github.com/ChaosClubCo/context7.git|projects/chaosclubco/context7
chaosclubco|supabase-js|https://github.com/ChaosClubCo/supabase-js.git|projects/chaosclubco/supabase-js
chaosclubco|compose-for-agents|https://github.com/ChaosClubCo/compose-for-agents.git|projects/chaosclubco/compose-for-agents
chaosclubco|flashfusion-ide|https://github.com/ChaosClubCo/flashfusion-ide.git|projects/chaosclubco/flashfusion-ide
chaosclubco|SuperClaude-1|https://github.com/ChaosClubCo/SuperClaude-1.git|projects/chaosclubco/superclaude-1
chaosclubco|SuperClaude|https://github.com/ChaosClubCo/SuperClaude.git|projects/chaosclubco/superclaude
chaosclubco|turborepo-flashfusion|https://github.com/ChaosClubCo/turborepo-flashfusion.git|projects/chaosclubco/turborepo-flashfusion
EOF

echo "Starting batch import of 50 GitHub repositories..."
echo ""

# Import each repo
while IFS='|' read -r org name url target_dir; do
    # Skip comments and empty lines
    [[ "$org" =~ ^#.*$ ]] && continue
    [[ -z "$org" ]] && continue

    import_repo "$org" "$name" "$url" "$target_dir"

done < /tmp/sot-import-list.txt

# Summary
echo ""
echo "=== Import Summary ==="
echo -e "${GREEN}✓ Success: $SUCCESS${NC}"
echo -e "${YELLOW}⊙ Skipped: $SKIPPED${NC}"
echo -e "✗ Failed: $FAILED"
echo ""

if [ $SUCCESS -gt 0 ]; then
    echo ""
    echo "=== Auto-updating REPO_MAP.md ==="
    if command -v node &> /dev/null; then
        node scripts/generate-repo-map.js
        echo -e "${GREEN}✓ REPO_MAP.md updated${NC}"
    else
        echo -e "${YELLOW}⚠ Node.js not found. Run 'pnpm run generate:repo-map' manually${NC}"
    fi
    
    echo ""
    echo "Next steps:"
    echo "  1. Review imported repos: ls -la projects/"
    echo "  2. Review REPO_MAP.md: cat REPO_MAP.md"
    echo "  3. Commit: git add projects/ REPO_MAP.md && git commit -m 'feat: Import GitHub repos'"
    echo "  4. Push: git push"
    echo "  5. Run: pnpm install"
fi

# Cleanup
rm -f /tmp/sot-import-list.txt
