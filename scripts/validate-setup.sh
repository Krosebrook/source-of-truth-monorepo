#!/bin/bash
# Validate deploy keys setup and configuration
# Usage: ./scripts/validate-setup.sh

set -euo pipefail

echo "=== FlashFusion Deploy Keys Setup Validator ==="
echo ""

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

CHECKS_PASSED=0
CHECKS_FAILED=0
CHECKS_WARNING=0

check_pass() {
  echo -e "${GREEN}✓${NC} $1"
  CHECKS_PASSED=$((CHECKS_PASSED + 1))
}

check_fail() {
  echo -e "${RED}✗${NC} $1"
  CHECKS_FAILED=$((CHECKS_FAILED + 1))
}

check_warn() {
  echo -e "${YELLOW}⚠${NC} $1"
  CHECKS_WARNING=$((CHECKS_WARNING + 1))
}

check_info() {
  echo -e "${BLUE}ℹ${NC} $1"
}

echo "Phase 1: Prerequisites"
echo "======================"

# Check if gh CLI is installed
if command -v gh &> /dev/null; then
  check_pass "GitHub CLI (gh) installed"
  check_info "GitHub CLI authentication check skipped (may require interactive session)"
else
  check_fail "GitHub CLI (gh) not installed (https://cli.github.com/)"
fi

# Check if ssh-keygen is available
if command -v ssh-keygen &> /dev/null; then
  check_pass "ssh-keygen available"
else
  check_fail "ssh-keygen not found"
fi

echo ""
echo "Phase 2: File Structure"
echo "======================="

# Check if workflow file exists
if [ -f ".github/workflows/subtree-push.yml" ]; then
  check_pass "Workflow file exists"
  
  # Check if workflow is enabled (uncommented)
  if grep -q "^      - name: Split & push mirrors" .github/workflows/subtree-push.yml; then
    check_pass "Workflow push logic is enabled"
  else
    check_warn "Workflow push logic is commented out (enable after keys are configured)"
  fi
else
  check_fail "Workflow file not found"
fi

# Check if documentation exists
if [ -f "docs/how-to/configure-deploy-keys.md" ]; then
  check_pass "Setup documentation exists"
else
  check_fail "Setup documentation not found"
fi

# Check if scripts exist
if [ -f "scripts/generate-deploy-keys.sh" ] && [ -x "scripts/generate-deploy-keys.sh" ]; then
  check_pass "Key generation script exists and is executable"
else
  check_fail "Key generation script missing or not executable"
fi

if [ -f "scripts/add-secrets-to-github.sh" ] && [ -x "scripts/add-secrets-to-github.sh" ]; then
  check_pass "Secret upload script exists and is executable"
else
  check_fail "Secret upload script missing or not executable"
fi

echo ""
echo "Phase 3: Deploy Keys"
echo "===================="

KEYS_DIR="/tmp/sot-deploy-keys"
if [ -d "$KEYS_DIR" ]; then
  KEY_COUNT=$(find "$KEYS_DIR" -type f -name "mirror_ssh_key_*" ! -name "*.pub" 2>/dev/null | wc -l)
  if [ "$KEY_COUNT" -eq 50 ]; then
    check_pass "All 50 deploy keys generated"
  elif [ "$KEY_COUNT" -gt 0 ]; then
    check_warn "Found $KEY_COUNT/50 deploy keys (run: ./scripts/generate-deploy-keys.sh)"
  else
    check_warn "No deploy keys found (run: ./scripts/generate-deploy-keys.sh)"
  fi
else
  check_warn "Keys directory not found (run: ./scripts/generate-deploy-keys.sh)"
fi

echo ""
echo "Phase 4: GitHub Actions Secrets"
echo "================================"

REPO="${DEPLOY_KEYS_REPO:-Krosebrook/source-of-truth-monorepo}"

# Skip interactive gh commands in non-interactive environments
check_warn "GitHub Actions secrets check requires authenticated GitHub CLI session"
check_info "To manually verify: gh secret list --repo $REPO | grep MIRROR_SSH_KEY_"

echo ""
echo "Phase 5: Repository Access"
echo "=========================="

check_info "Checking access to mirror repositories requires admin permissions"
check_info "Manual verification required for deploy key installation"

echo ""
echo "=== Summary ==="
echo -e "${GREEN}Passed: $CHECKS_PASSED${NC}"
if [ $CHECKS_WARNING -gt 0 ]; then
  echo -e "${YELLOW}Warnings: $CHECKS_WARNING${NC}"
fi
if [ $CHECKS_FAILED -gt 0 ]; then
  echo -e "${RED}Failed: $CHECKS_FAILED${NC}"
fi

echo ""

if [ $CHECKS_FAILED -eq 0 ] && [ $CHECKS_WARNING -eq 0 ]; then
  echo -e "${GREEN}✓ All checks passed! Ready for deployment.${NC}"
  echo ""
  echo "Next steps:"
  echo "  1. Review mirror repositories have deploy keys installed"
  echo "  2. Test workflow: gh workflow run subtree-push.yml"
  echo "  3. Monitor: gh run watch"
  exit 0
elif [ $CHECKS_FAILED -eq 0 ]; then
  echo -e "${YELLOW}⚠ Setup in progress. Address warnings to complete.${NC}"
  echo ""
  echo "Common next steps:"
  echo "  1. Generate keys: ./scripts/generate-deploy-keys.sh"
  echo "  2. Add secrets: ./scripts/add-secrets-to-github.sh"
  echo "  3. Enable workflow: Edit .github/workflows/subtree-push.yml"
  exit 1
else
  echo -e "${RED}✗ Setup incomplete. Fix failed checks before proceeding.${NC}"
  echo ""
  echo "Review documentation: docs/how-to/configure-deploy-keys.md"
  exit 2
fi
