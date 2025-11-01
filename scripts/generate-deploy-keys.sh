#!/bin/bash
# Generate SSH deploy keys for all mirror repositories
# Usage: ./scripts/generate-deploy-keys.sh

set -euo pipefail

KEYS_DIR="${KEYS_DIR:-/tmp/sot-deploy-keys}"
mkdir -p "$KEYS_DIR"

echo "=== FlashFusion SoT Deploy Key Generator ==="
echo ""
echo "Keys will be generated in: $KEYS_DIR"
echo ""

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Counter
GENERATED=0
SKIPPED=0

# List of all mirror repos with their organizations and key names
declare -A REPOS=(
  # Krosebrook Core (10)
  ["krosebrook/FlashFusion"]="MIRROR_SSH_KEY_FLASHFUSION"
  ["krosebrook/Flashfusionwebsite"]="MIRROR_SSH_KEY_FLASHFUSIONWEBSITE"
  ["krosebrook/FlashFusion-Unified"]="MIRROR_SSH_KEY_FLASHFUSION_UNIFIED"
  ["krosebrook/MonoTurboRepo-FlashFusion"]="MIRROR_SSH_KEY_MONO_TURBO_REPO"
  ["krosebrook/theaidashboard"]="MIRROR_SSH_KEY_THEAIDASHBOARD"
  ["krosebrook/INT-Smart-Triage-AI-2.0"]="MIRROR_SSH_KEY_INT_SMART_TRIAGE_2"
  ["krosebrook/Claude-Code-Development-Kit"]="MIRROR_SSH_KEY_CLAUDE_CODE_DEV_KIT"
  ["krosebrook/v0-ai-agent-builder"]="MIRROR_SSH_KEY_V0_AI_AGENT_BUILDER"
  ["krosebrook/Archon"]="MIRROR_SSH_KEY_ARCHON"
  ["krosebrook/Intos"]="MIRROR_SSH_KEY_INTOS"
  
  # Krosebrook Apps (17)
  ["krosebrook/v0-template-evaluation-academy"]="MIRROR_SSH_KEY_V0_TEMPLATE_EVAL"
  ["krosebrook/KinsleysCreativeSuite"]="MIRROR_SSH_KEY_KINSLEYSCREATIVESUITE"
  ["krosebrook/OctaveStudio"]="MIRROR_SSH_KEY_OCTAVESTUDIO"
  ["krosebrook/UniversalWriterAI"]="MIRROR_SSH_KEY_UNIVERSALWRITERAI"
  ["krosebrook/Templateevaluationacademy"]="MIRROR_SSH_KEY_TEMPLATEEVALACADEMY"
  ["krosebrook/MyContextEngine"]="MIRROR_SSH_KEY_MYCONTEXTENGINE"
  ["krosebrook/CreatorStudioLite"]="MIRROR_SSH_KEY_CREATORSTUDIOLITE"
  ["krosebrook/UniversalAIGen"]="MIRROR_SSH_KEY_UNIVERSALAIGEN"
  ["krosebrook/FLashFusion-Learn"]="MIRROR_SSH_KEY_FLASHFUSION_LEARN"
  ["krosebrook/lovable-prompt-artist"]="MIRROR_SSH_KEY_LOVABLE_PROMPT_ARTIST"
  ["krosebrook/analyst-cockpit-ui"]="MIRROR_SSH_KEY_ANALYST_COCKPIT_UI"
  ["krosebrook/flashfusion-lite-ecommerce"]="MIRROR_SSH_KEY_FLASHFUSION_LITE_ECOM"
  ["krosebrook/int-smart-triage-ai-3.0"]="MIRROR_SSH_KEY_INT_SMART_TRIAGE_3"
  ["krosebrook/int-triage-ai.3.0"]="MIRROR_SSH_KEY_INT_TRIAGE_AI_3"
  ["krosebrook/project-nexus"]="MIRROR_SSH_KEY_PROJECT_NEXUS"
  ["krosebrook/saas-validator-suite"]="MIRROR_SSH_KEY_SAAS_VALIDATOR_SUITE"
  ["krosebrook/OpenFlashFusion"]="MIRROR_SSH_KEY_OPEN_FLASHFUSION"
  
  # Krosebrook Tools (7)
  ["krosebrook/claude-code-by-agents"]="MIRROR_SSH_KEY_CLAUDE_CODE_BY_AGENTS"
  ["krosebrook/metamcp"]="MIRROR_SSH_KEY_METAMCP"
  ["krosebrook/playwright-mcp"]="MIRROR_SSH_KEY_PLAYWRIGHT_MCP"
  ["krosebrook/claude-agent-sdk-typescript"]="MIRROR_SSH_KEY_CLAUDE_AGENT_SDK_TS"
  ["krosebrook/mcp-server-docker"]="MIRROR_SSH_KEY_MCP_SERVER_DOCKER"
  ["krosebrook/superpowers"]="MIRROR_SSH_KEY_SUPERPOWERS"
  ["krosebrook/boilerplates"]="MIRROR_SSH_KEY_BOILERPLATES"
  
  # FlashFusionv1 (8)
  ["flashfusionv1/flashfusion-creative-hub"]="MIRROR_SSH_KEY_CREATIVE_HUB"
  ["flashfusionv1/collabnet-visualizer-111"]="MIRROR_SSH_KEY_COLLABNET_VISUALIZER"
  ["flashfusionv1/pulse-robot-template-40849"]="MIRROR_SSH_KEY_PULSE_ROBOT_TEMPLATE"
  ["flashfusionv1/nimble-fab-flow"]="MIRROR_SSH_KEY_NIMBLE_FAB_FLOW"
  ["flashfusionv1/loveable-supabase"]="MIRROR_SSH_KEY_LOVEABLE_SUPABASE"
  ["flashfusionv1/dyad"]="MIRROR_SSH_KEY_DYAD"
  ["flashfusionv1/spec-kit"]="MIRROR_SSH_KEY_SPEC_KIT"
  ["flashfusionv1/open-lovablev1"]="MIRROR_SSH_KEY_OPEN_LOVABLEV1"
  
  # ChaosClubCo (8)
  ["chaosclubco/tiktok-story-ai"]="MIRROR_SSH_KEY_TIKTOK_STORY_AI"
  ["chaosclubco/context7"]="MIRROR_SSH_KEY_CONTEXT7"
  ["chaosclubco/supabase-js"]="MIRROR_SSH_KEY_SUPABASE_JS"
  ["chaosclubco/compose-for-agents"]="MIRROR_SSH_KEY_COMPOSE_FOR_AGENTS"
  ["chaosclubco/flashfusion-ide"]="MIRROR_SSH_KEY_FLASHFUSION_IDE"
  ["chaosclubco/SuperClaude-1"]="MIRROR_SSH_KEY_SUPERCLAUDE_1"
  ["chaosclubco/SuperClaude"]="MIRROR_SSH_KEY_SUPERCLAUDE"
  ["chaosclubco/turborepo-flashfusion"]="MIRROR_SSH_KEY_TURBOREPO_FLASHFUSION"
)

cd "$KEYS_DIR"

echo "Generating ${#REPOS[@]} deploy key pairs..."
echo ""

for repo in "${!REPOS[@]}"; do
  secret_name="${REPOS[$repo]}"
  # Use secret name as filename (lowercase)
  key_file=$(echo "$secret_name" | tr '[:upper:]' '[:lower:]')
  
  if [ -f "$key_file" ]; then
    echo -e "${YELLOW}⊙ Skipped${NC}: $repo (key already exists)"
    ((SKIPPED++))
  else
    ssh-keygen -t ed25519 -C "sot-deploy-$(echo $repo | tr '/' '-')" -f "$key_file" -N "" >/dev/null 2>&1
    echo -e "${GREEN}✓ Generated${NC}: $repo -> $key_file"
    ((GENERATED++))
  fi
done

echo ""
echo "=== Summary ==="
echo -e "${GREEN}✓ Generated: $GENERATED${NC}"
echo -e "${YELLOW}⊙ Skipped: $SKIPPED${NC}"
echo ""
echo "Keys stored in: $KEYS_DIR"
echo ""
echo "Next steps:"
echo "  1. Add public keys (.pub files) to GitHub repositories"
echo "  2. Add private keys to GitHub Actions secrets"
echo "  3. See: docs/how-to/configure-deploy-keys.md"
echo ""
echo "⚠️  SECURITY WARNING:"
echo "  - Keep private keys secure"
echo "  - Never commit keys to version control"
echo "  - Delete keys after adding to GitHub secrets"
