#!/bin/bash

###############################################################################
# Automated Contributor Onboarding Script
# 
# This script automates the setup process for new contributors to the
# FlashFusion Source-of-Truth monorepo.
#
# Usage: ./scripts/onboard-contributor.sh [--skip-deps]
#
# Options:
#   --skip-deps    Skip dependency installation (for re-runs)
###############################################################################

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Flags
SKIP_DEPS=false

# Parse arguments
while [[ $# -gt 0 ]]; do
  case $1 in
    --skip-deps)
      SKIP_DEPS=true
      shift
      ;;
    *)
      echo -e "${RED}Unknown option: $1${NC}"
      echo "Usage: $0 [--skip-deps]"
      exit 1
      ;;
  esac
done

# Helper functions
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

check_command() {
  if command -v "$1" &> /dev/null; then
    print_success "$1 is installed"
    return 0
  else
    print_error "$1 is not installed"
    return 1
  fi
}

print_header "FlashFusion SoT Contributor Onboarding"
echo "Welcome to the FlashFusion Source-of-Truth monorepo!"
echo "This script will guide you through the setup process."
echo ""

# Step 1: Check prerequisites
print_header "Step 1: Checking Prerequisites"

PREREQS_MET=true

# Check Node.js
if check_command node; then
  NODE_VERSION=$(node --version | sed 's/v//')
  MAJOR_VERSION=$(echo "$NODE_VERSION" | cut -d. -f1)
  if [ "$MAJOR_VERSION" -ge 20 ]; then
    print_success "Node.js version: $NODE_VERSION (✓ >= 20.0.0)"
  else
    print_error "Node.js version $NODE_VERSION is too old. Need >= 20.0.0"
    PREREQS_MET=false
  fi
else
  print_error "Please install Node.js 20+ from https://nodejs.org"
  PREREQS_MET=false
fi

# Check Git
if check_command git; then
  GIT_VERSION=$(git --version | awk '{print $3}')
  print_success "Git version: $GIT_VERSION"
else
  print_error "Please install Git from https://git-scm.com"
  PREREQS_MET=false
fi

# Check pnpm
if check_command pnpm; then
  PNPM_VERSION=$(pnpm --version)
  print_success "pnpm version: $PNPM_VERSION"
else
  print_warning "pnpm is not installed. Installing now..."
  if npm install -g pnpm@9; then
    print_success "pnpm installed successfully"
  else
    print_error "Failed to install pnpm"
    PREREQS_MET=false
  fi
fi

if [ "$PREREQS_MET" = false ]; then
  print_error "Please install missing prerequisites and run this script again."
  exit 1
fi

# Step 2: Verify repository
print_header "Step 2: Verifying Repository"

if [ ! -f "package.json" ]; then
  print_error "package.json not found. Are you in the repository root?"
  exit 1
fi

if [ ! -f "pnpm-workspace.yaml" ]; then
  print_error "pnpm-workspace.yaml not found. This doesn't appear to be the SoT monorepo."
  exit 1
fi

print_success "Repository structure verified"

# Step 3: Install dependencies
if [ "$SKIP_DEPS" = false ]; then
  print_header "Step 3: Installing Dependencies"
  print_info "This may take 5-10 minutes on first run..."
  
  if pnpm install; then
    print_success "Dependencies installed successfully"
  else
    print_error "Failed to install dependencies"
    exit 1
  fi
else
  print_info "Skipping dependency installation (--skip-deps flag provided)"
fi

# Step 4: Validate setup
print_header "Step 4: Validating Setup"

# Check if .llms.txt exists
if [ -f ".llms.txt" ]; then
  print_success "AI context file (.llms.txt) present"
else
  print_warning ".llms.txt not found (optional)"
fi

# Check if docs/mcp.json exists
if [ -f "docs/mcp.json" ]; then
  print_success "MCP configuration (docs/mcp.json) present"
else
  print_warning "docs/mcp.json not found (optional)"
fi

# Step 5: Run initial build
print_header "Step 5: Running Initial Build"
print_info "This will take 10-20 minutes on first run..."
print_info "Subsequent builds will be much faster thanks to Turbo caching!"

if pnpm build; then
  print_success "Build completed successfully"
else
  print_error "Build failed. Please check the error messages above."
  exit 1
fi

# Step 6: Run linting
print_header "Step 6: Running Linting"

if pnpm lint; then
  print_success "Linting passed"
else
  print_warning "Linting reported issues (non-fatal)"
fi

# Step 7: Summary and next steps
print_header "Setup Complete! 🎉"

echo "Your development environment is ready!"
echo ""
echo "Next steps:"
echo ""
echo "1. Read the documentation:"
echo "   - Getting Started: ${GREEN}cat GETTING_STARTED.md${NC}"
echo "   - Onboarding Checklist: ${GREEN}cat docs/ONBOARDING_CHECKLIST.md${NC}"
echo "   - Documentation Index: ${GREEN}cat docs/index.md${NC}"
echo ""
echo "2. Explore the monorepo:"
echo "   - List all projects: ${GREEN}pnpm -r list${NC}"
echo "   - View workspace structure: ${GREEN}ls projects/${NC}"
echo ""
echo "3. Try building a specific project:"
echo "   - ${GREEN}pnpm --filter <project-name> build${NC}"
echo ""
echo "4. Start developing:"
echo "   - Create a branch: ${GREEN}git checkout -b feature/my-feature${NC}"
echo "   - Make changes and test: ${GREEN}pnpm build && pnpm test${NC}"
echo "   - Create a changeset: ${GREEN}pnpm changeset${NC}"
echo ""
echo "5. Join the community:"
echo "   - Ask your manager for Slack/Discord invite"
echo "   - Review CODEOWNERS: ${GREEN}cat .github/CODEOWNERS${NC}"
echo ""
echo "For help, see:"
echo "   - GitHub Issues: https://github.com/Krosebrook/source-of-truth-monorepo/issues"
echo "   - Documentation: docs/index.md"
echo ""
print_success "Happy coding! 🚀"
