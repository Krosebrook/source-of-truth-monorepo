#!/bin/bash
# Add deploy keys to GitHub Actions secrets
# Usage: ./scripts/add-secrets-to-github.sh
# Requires: GitHub CLI (gh) authenticated with appropriate permissions

set -euo pipefail

KEYS_DIR="${KEYS_DIR:-/tmp/sot-deploy-keys}"
REPO="Krosebrook/source-of-truth-monorepo"

echo "=== FlashFusion SoT GitHub Secrets Uploader ==="
echo ""
echo "Repository: $REPO"
echo "Keys directory: $KEYS_DIR"
echo ""

# Check if gh is installed
if ! command -v gh &> /dev/null; then
  echo "❌ Error: GitHub CLI (gh) is not installed"
  echo "Install: https://cli.github.com/"
  exit 1
fi

# Check if authenticated
if ! gh auth status &> /dev/null; then
  echo "❌ Error: Not authenticated with GitHub CLI"
  echo "Run: gh auth login"
  exit 1
fi

# Check if keys directory exists
if [ ! -d "$KEYS_DIR" ]; then
  echo "❌ Error: Keys directory not found: $KEYS_DIR"
  echo "Run: ./scripts/generate-deploy-keys.sh first"
  exit 1
fi

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Counters
ADDED=0
FAILED=0

# List of secret names (must match generate-deploy-keys.sh)
SECRETS=(
  # Krosebrook Core (10)
  "MIRROR_SSH_KEY_FLASHFUSION"
  "MIRROR_SSH_KEY_FLASHFUSIONWEBSITE"
  "MIRROR_SSH_KEY_FLASHFUSION_UNIFIED"
  "MIRROR_SSH_KEY_MONO_TURBO_REPO"
  "MIRROR_SSH_KEY_THEAIDASHBOARD"
  "MIRROR_SSH_KEY_INT_SMART_TRIAGE_2"
  "MIRROR_SSH_KEY_CLAUDE_CODE_DEV_KIT"
  "MIRROR_SSH_KEY_V0_AI_AGENT_BUILDER"
  "MIRROR_SSH_KEY_ARCHON"
  "MIRROR_SSH_KEY_INTOS"
  
  # Krosebrook Apps (17)
  "MIRROR_SSH_KEY_V0_TEMPLATE_EVAL"
  "MIRROR_SSH_KEY_KINSLEYSCREATIVESUITE"
  "MIRROR_SSH_KEY_OCTAVESTUDIO"
  "MIRROR_SSH_KEY_UNIVERSALWRITERAI"
  "MIRROR_SSH_KEY_TEMPLATEEVALACADEMY"
  "MIRROR_SSH_KEY_MYCONTEXTENGINE"
  "MIRROR_SSH_KEY_CREATORSTUDIOLITE"
  "MIRROR_SSH_KEY_UNIVERSALAIGEN"
  "MIRROR_SSH_KEY_FLASHFUSION_LEARN"
  "MIRROR_SSH_KEY_LOVABLE_PROMPT_ARTIST"
  "MIRROR_SSH_KEY_ANALYST_COCKPIT_UI"
  "MIRROR_SSH_KEY_FLASHFUSION_LITE_ECOM"
  "MIRROR_SSH_KEY_INT_SMART_TRIAGE_3"
  "MIRROR_SSH_KEY_INT_TRIAGE_AI_3"
  "MIRROR_SSH_KEY_PROJECT_NEXUS"
  "MIRROR_SSH_KEY_SAAS_VALIDATOR_SUITE"
  "MIRROR_SSH_KEY_OPEN_FLASHFUSION"
  
  # Krosebrook Tools (7)
  "MIRROR_SSH_KEY_CLAUDE_CODE_BY_AGENTS"
  "MIRROR_SSH_KEY_METAMCP"
  "MIRROR_SSH_KEY_PLAYWRIGHT_MCP"
  "MIRROR_SSH_KEY_CLAUDE_AGENT_SDK_TS"
  "MIRROR_SSH_KEY_MCP_SERVER_DOCKER"
  "MIRROR_SSH_KEY_SUPERPOWERS"
  "MIRROR_SSH_KEY_BOILERPLATES"
  
  # FlashFusionv1 (8)
  "MIRROR_SSH_KEY_CREATIVE_HUB"
  "MIRROR_SSH_KEY_COLLABNET_VISUALIZER"
  "MIRROR_SSH_KEY_PULSE_ROBOT_TEMPLATE"
  "MIRROR_SSH_KEY_NIMBLE_FAB_FLOW"
  "MIRROR_SSH_KEY_LOVEABLE_SUPABASE"
  "MIRROR_SSH_KEY_DYAD"
  "MIRROR_SSH_KEY_SPEC_KIT"
  "MIRROR_SSH_KEY_OPEN_LOVABLEV1"
  
  # ChaosClubCo (8)
  "MIRROR_SSH_KEY_TIKTOK_STORY_AI"
  "MIRROR_SSH_KEY_CONTEXT7"
  "MIRROR_SSH_KEY_SUPABASE_JS"
  "MIRROR_SSH_KEY_COMPOSE_FOR_AGENTS"
  "MIRROR_SSH_KEY_FLASHFUSION_IDE"
  "MIRROR_SSH_KEY_SUPERCLAUDE_1"
  "MIRROR_SSH_KEY_SUPERCLAUDE"
  "MIRROR_SSH_KEY_TURBOREPO_FLASHFUSION"
)

echo "Adding ${#SECRETS[@]} secrets to GitHub Actions..."
echo ""

for secret_name in "${SECRETS[@]}"; do
  key_file=$(echo "$secret_name" | tr '[:upper:]' '[:lower:]')
  key_path="$KEYS_DIR/$key_file"
  
  if [ ! -f "$key_path" ]; then
    echo -e "${RED}✗ Failed${NC}: $secret_name (key file not found: $key_file)"
    ((FAILED++))
    continue
  fi
  
  # Add secret using GitHub CLI (read from file via stdin for safety)
  ERROR_MSG=$(gh secret set "$secret_name" --repo "$REPO" < "$key_path" 2>&1)
  if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ Added${NC}: $secret_name"
    ((ADDED++))
  else
    echo -e "${RED}✗ Failed${NC}: $secret_name"
    echo "   Error: $ERROR_MSG"
    ((FAILED++))
  fi
done

echo ""
echo "=== Summary ==="
echo -e "${GREEN}✓ Added: $ADDED${NC}"
echo -e "${RED}✗ Failed: $FAILED${NC}"
echo ""

if [ $ADDED -gt 0 ]; then
  echo "Secrets successfully added to: $REPO"
  echo ""
  echo "Verify with: gh secret list --repo $REPO"
  echo ""
  echo "Next steps:"
  echo "  1. Update .github/workflows/subtree-push.yml"
  echo "  2. Test workflow with manual trigger"
  echo "  3. Delete local keys: rm -rf $KEYS_DIR"
fi

if [ $FAILED -gt 0 ]; then
  echo ""
  echo "⚠️  Some secrets failed to upload. Check:"
  echo "  - GitHub CLI authentication (gh auth status)"
  echo "  - Repository permissions (admin access required)"
  echo "  - Key files exist in: $KEYS_DIR"
fi
