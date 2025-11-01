#!/bin/bash

###############################################################################
# Environment Verification Script
# 
# This script verifies that the development environment is properly configured
# for contributing to the FlashFusion Source-of-Truth monorepo.
#
# Usage: ./scripts/verify-setup.sh
###############################################################################

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_header() {
  echo -e "\n${BLUE}========================================${NC}"
  echo -e "${BLUE}$1${NC}"
  echo -e "${BLUE}========================================${NC}\n"
}

print_success() {
  echo -e "${GREEN}✓ $1${NC}"
}

print_error() {
  echo -e "${RED}✗ $1${NC}"
}

print_warning() {
  echo -e "${YELLOW}⚠ $1${NC}"
}

print_info() {
  echo -e "${BLUE}ℹ $1${NC}"
}

CHECKS_PASSED=0
CHECKS_FAILED=0
CHECKS_WARNING=0

check_pass() {
  CHECKS_PASSED=$((CHECKS_PASSED + 1))
  print_success "$1"
}

check_fail() {
  CHECKS_FAILED=$((CHECKS_FAILED + 1))
  print_error "$1"
}

check_warn() {
  CHECKS_WARNING=$((CHECKS_WARNING + 1))
  print_warning "$1"
}

print_header "FlashFusion SoT Environment Verification"

# Check 1: Node.js version
print_info "Checking Node.js..."
if command -v node &> /dev/null; then
  NODE_VERSION=$(node --version | sed 's/v//')
  MAJOR_VERSION=$(echo "$NODE_VERSION" | cut -d. -f1)
  if [ "$MAJOR_VERSION" -ge 20 ]; then
    check_pass "Node.js version: $NODE_VERSION (>= 20.0.0)"
  else
    check_fail "Node.js version $NODE_VERSION is too old (need >= 20.0.0)"
  fi
else
  check_fail "Node.js is not installed"
fi

# Check 2: pnpm version
print_info "Checking pnpm..."
if command -v pnpm &> /dev/null; then
  PNPM_VERSION=$(pnpm --version)
  MAJOR_VERSION=$(echo "$PNPM_VERSION" | cut -d. -f1)
  if [ "$MAJOR_VERSION" -ge 9 ]; then
    check_pass "pnpm version: $PNPM_VERSION (>= 9.0.0)"
  else
    check_fail "pnpm version $PNPM_VERSION is too old (need >= 9.0.0)"
  fi
else
  check_fail "pnpm is not installed"
fi

# Check 3: Git version
print_info "Checking Git..."
if command -v git &> /dev/null; then
  GIT_VERSION=$(git --version | awk '{print $3}')
  check_pass "Git version: $GIT_VERSION"
else
  check_fail "Git is not installed"
fi

# Check 4: Repository structure
print_info "Checking repository structure..."
if [ -f "package.json" ] && [ -f "pnpm-workspace.yaml" ]; then
  check_pass "Repository structure is valid"
else
  check_fail "Invalid repository structure (missing package.json or pnpm-workspace.yaml)"
fi

# Check 5: Dependencies installed
print_info "Checking dependencies..."
if [ -d "node_modules" ] && [ -f "node_modules/.modules.yaml" ]; then
  check_pass "Dependencies are installed"
else
  check_fail "Dependencies are not installed (run 'pnpm install')"
fi

# Check 6: Turbo cache
print_info "Checking Turbo setup..."
if [ -d ".turbo" ] || command -v turbo &> /dev/null; then
  check_pass "Turbo is configured"
else
  check_warn "Turbo cache not initialized (will be created on first build)"
fi

# Check 7: Git configuration
print_info "Checking Git configuration..."
GIT_NAME=$(git config user.name 2>/dev/null || echo "")
GIT_EMAIL=$(git config user.email 2>/dev/null || echo "")

if [ -n "$GIT_NAME" ] && [ -n "$GIT_EMAIL" ]; then
  check_pass "Git configured: $GIT_NAME <$GIT_EMAIL>"
else
  check_warn "Git user.name or user.email not configured"
  echo "  Run: git config --global user.name 'Your Name'"
  echo "  Run: git config --global user.email 'your.email@example.com'"
fi

# Check 8: Workspace projects
print_info "Checking workspace projects..."
if [ -d "projects" ]; then
  PROJECT_COUNT=$(find projects -mindepth 1 -maxdepth 3 -name "package.json" 2>/dev/null | wc -l)
  if [ "$PROJECT_COUNT" -gt 0 ]; then
    check_pass "Found $PROJECT_COUNT workspace project(s)"
  else
    check_warn "No workspace projects found in 'projects/' directory"
  fi
else
  check_fail "'projects/' directory not found"
fi

# Check 9: Documentation files
print_info "Checking documentation..."
DOC_FILES=("README.md" "GETTING_STARTED.md" "docs/ONBOARDING_CHECKLIST.md" "docs/index.md")
MISSING_DOCS=()

for doc in "${DOC_FILES[@]}"; do
  if [ ! -f "$doc" ]; then
    MISSING_DOCS+=("$doc")
  fi
done

if [ ${#MISSING_DOCS[@]} -eq 0 ]; then
  check_pass "Core documentation files present"
else
  check_warn "Missing documentation: ${MISSING_DOCS[*]}"
fi

# Check 10: Scripts
print_info "Checking scripts..."
SCRIPT_FILES=("scripts/import-github-repos.sh" "scripts/generate-deploy-keys.sh" "scripts/onboard-contributor.sh")
MISSING_SCRIPTS=()

for script in "${SCRIPT_FILES[@]}"; do
  if [ ! -f "$script" ]; then
    MISSING_SCRIPTS+=("$script")
  elif [ ! -x "$script" ]; then
    check_warn "$script is not executable (run 'chmod +x $script')"
  fi
done

if [ ${#MISSING_SCRIPTS[@]} -eq 0 ]; then
  check_pass "Core scripts present"
else
  check_warn "Missing scripts: ${MISSING_SCRIPTS[*]}"
fi

# Check 11: Build artifacts
print_info "Checking build status..."
if [ -d ".turbo/cache" ] && [ "$(ls -A .turbo/cache 2>/dev/null)" ]; then
  check_pass "Build cache exists (project has been built)"
else
  check_warn "No build cache found (run 'pnpm build' to build projects)"
fi

# Check 12: Optional tools
print_info "Checking optional tools..."

if command -v gh &> /dev/null; then
  check_pass "GitHub CLI (gh) is installed"
else
  check_warn "GitHub CLI (gh) not installed (optional but recommended)"
fi

if command -v code &> /dev/null; then
  check_pass "VS Code is installed"
else
  check_warn "VS Code not installed (optional)"
fi

# Summary
print_header "Verification Summary"

echo -e "${GREEN}✓ Passed: $CHECKS_PASSED${NC}"
if [ $CHECKS_WARNING -gt 0 ]; then
  echo -e "${YELLOW}⚠ Warnings: $CHECKS_WARNING${NC}"
fi
if [ $CHECKS_FAILED -gt 0 ]; then
  echo -e "${RED}✗ Failed: $CHECKS_FAILED${NC}"
fi

echo ""

if [ $CHECKS_FAILED -gt 0 ]; then
  print_error "Some checks failed. Please address the issues above."
  echo ""
  echo "For help, see:"
  echo "  - GETTING_STARTED.md"
  echo "  - docs/ONBOARDING_CHECKLIST.md"
  echo "  - https://github.com/Krosebrook/source-of-truth-monorepo/issues"
  exit 1
elif [ $CHECKS_WARNING -gt 0 ]; then
  print_warning "Setup is functional but has some warnings."
  echo ""
  echo "You can start developing, but consider addressing the warnings above."
  exit 0
else
  print_success "All checks passed! Your environment is ready. 🎉"
  echo ""
  echo "Next steps:"
  echo "  - Read GETTING_STARTED.md to learn the basics"
  echo "  - Run 'pnpm build' to build all projects"
  echo "  - Run 'pnpm --filter <project> dev' to start development"
  exit 0
fi
