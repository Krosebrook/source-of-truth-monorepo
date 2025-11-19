#!/bin/bash
# FlashFusion SoT Monorepo - Bootstrap Script
# Complete setup for new developers in one command
# Usage: ./scripts/bootstrap.sh [--skip-build]

set -euo pipefail

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
SKIP_BUILD=false

# Parse arguments
while [[ $# -gt 0 ]]; do
  case $1 in
    --skip-build)
      SKIP_BUILD=true
      shift
      ;;
    --help|-h)
      echo "Usage: $0 [--skip-build]"
      echo ""
      echo "Options:"
      echo "  --skip-build    Skip the build step (faster for testing)"
      echo "  --help, -h      Show this help message"
      exit 0
      ;;
    *)
      echo -e "${RED}Unknown option: $1${NC}"
      exit 1
      ;;
  esac
done

# Script start
echo -e "${BLUE}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║                                                            ║${NC}"
echo -e "${BLUE}║      🚀 FlashFusion SoT Monorepo Bootstrap                ║${NC}"
echo -e "${BLUE}║                                                            ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════════════╝${NC}"
echo ""

# Track progress
STEP=0
TOTAL_STEPS=7
if [ "$SKIP_BUILD" = true ]; then
  TOTAL_STEPS=6
fi

step() {
  STEP=$((STEP + 1))
  echo ""
  echo -e "${BLUE}[$STEP/$TOTAL_STEPS]${NC} $1"
}

success() {
  echo -e "${GREEN}✓${NC} $1"
}

warning() {
  echo -e "${YELLOW}⚠${NC} $1"
}

error() {
  echo -e "${RED}✗${NC} $1"
}

# =============================================================================
# Step 1: Check Prerequisites
# =============================================================================
step "Checking prerequisites..."

# Check Node.js
if ! command -v node &> /dev/null; then
  error "Node.js is not installed"
  echo ""
  echo "Please install Node.js 20+ from:"
  echo "  - https://nodejs.org/"
  echo "  - Or use nvm: https://github.com/nvm-sh/nvm"
  exit 1
fi

NODE_VERSION=$(node --version | sed 's/v//')
NODE_MAJOR=$(echo "$NODE_VERSION" | cut -d. -f1)

if [ "$NODE_MAJOR" -lt 20 ]; then
  error "Node.js version $NODE_VERSION is too old (need 20+)"
  echo ""
  echo "Please upgrade Node.js to version 20 or higher"
  exit 1
fi

success "Node.js $NODE_VERSION detected"

# Check Git
if ! command -v git &> /dev/null; then
  error "Git is not installed"
  echo ""
  echo "Please install Git from: https://git-scm.com/"
  exit 1
fi

success "Git $(git --version | cut -d' ' -f3) detected"

# =============================================================================
# Step 2: Check/Install pnpm
# =============================================================================
step "Checking pnpm installation..."

if ! command -v pnpm &> /dev/null; then
  warning "pnpm not found, installing..."

  # Try to use corepack first (comes with Node 16+)
  if command -v corepack &> /dev/null; then
    echo "  Using corepack to enable pnpm..."
    corepack enable
    corepack prepare pnpm@9.0.0 --activate
  else
    echo "  Installing pnpm via npm..."
    npm install -g pnpm@9
  fi

  success "pnpm installed successfully"
else
  PNPM_VERSION=$(pnpm --version)
  success "pnpm $PNPM_VERSION detected"
fi

# =============================================================================
# Step 3: Create .env file if it doesn't exist
# =============================================================================
step "Setting up environment configuration..."

if [ ! -f .env ]; then
  if [ -f .env.example ]; then
    warning ".env not found, creating from .env.example"
    cp .env.example .env
    echo ""
    echo "  ${YELLOW}Important:${NC} Edit .env and add your configuration values"
    echo "  Especially: GITHUB_TOKEN for importing repositories"
    success ".env created from template"
  else
    warning ".env.example not found, skipping .env creation"
  fi
else
  success ".env already exists"
fi

# =============================================================================
# Step 4: Install Dependencies
# =============================================================================
step "Installing dependencies..."

echo "  This may take a few minutes on first run..."
if pnpm install --frozen-lockfile 2>&1; then
  success "Dependencies installed successfully"
else
  warning "Frozen lockfile install failed, trying normal install..."
  if pnpm install; then
    success "Dependencies installed successfully"
  else
    error "Failed to install dependencies"
    exit 1
  fi
fi

# =============================================================================
# Step 5: Setup Git Hooks
# =============================================================================
step "Setting up Git hooks..."

if [ -d .husky ]; then
  # Git hooks are set up via the "prepare" script in package.json
  # which runs automatically during pnpm install
  success "Git hooks configured (husky)"
  echo "  - Pre-commit: lint-staged"
  echo "  - Commit-msg: commitlint"
  if [ -f .husky/pre-push ]; then
    echo "  - Pre-push: lint + type-check + test"
  fi
else
  warning "Husky directory not found"
fi

# =============================================================================
# Step 6: Build All Projects
# =============================================================================
if [ "$SKIP_BUILD" = false ]; then
  step "Building all projects..."

  echo "  ${YELLOW}Note:${NC} First build may take 10-20 minutes"
  echo "  Subsequent builds will be <1 minute with Turbo cache"
  echo ""

  if pnpm build 2>&1 | tee /tmp/bootstrap-build.log; then
    success "Build completed successfully"
  else
    warning "Build encountered some issues (see /tmp/bootstrap-build.log)"
    echo ""
    echo "  Common solutions:"
    echo "    - Some packages may not have build scripts (this is OK)"
    echo "    - Check individual project README files"
    echo "    - Try: pnpm build --force"
  fi
else
  echo ""
  echo "  ${YELLOW}Skipping build step${NC} (use --skip-build flag)"
fi

# =============================================================================
# Step 7: Validate Setup
# =============================================================================
step "Validating setup..."

if [ -x scripts/validate-setup.sh ]; then
  echo ""
  ./scripts/validate-setup.sh || true
  echo ""
else
  warning "Validation script not found (scripts/validate-setup.sh)"
fi

# =============================================================================
# Success Summary
# =============================================================================
echo ""
echo -e "${GREEN}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║                                                            ║${NC}"
echo -e "${GREEN}║      ✅ Bootstrap Complete!                                ║${NC}"
echo -e "${GREEN}║                                                            ║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${BLUE}What's Next?${NC}"
echo ""
echo "  ${GREEN}1.${NC} Edit .env and add your configuration"
echo "     ${YELLOW}→${NC} Especially GITHUB_TOKEN if you plan to import repos"
echo ""
echo "  ${GREEN}2.${NC} Start developing:"
echo "     ${YELLOW}→${NC} make dev              # Start all dev servers"
echo "     ${YELLOW}→${NC} pnpm dev              # Same as above"
echo "     ${YELLOW}→${NC} make dev-web          # Start just web app"
echo ""
echo "  ${GREEN}3.${NC} Import remaining repositories (optional):"
echo "     ${YELLOW}→${NC} make import           # Import 50 GitHub repos"
echo "     ${YELLOW}→${NC} ./scripts/import-github-repos.sh"
echo ""
echo "  ${GREEN}4.${NC} Explore the documentation:"
echo "     ${YELLOW}→${NC} cat GETTING_STARTED.md"
echo "     ${YELLOW}→${NC} cat CLAUDE.md         # AI assistant guide"
echo "     ${YELLOW}→${NC} ls docs/              # Full documentation"
echo ""
echo "  ${GREEN}5.${NC} Run common tasks:"
echo "     ${YELLOW}→${NC} make help             # Show all make targets"
echo "     ${YELLOW}→${NC} make test             # Run tests"
echo "     ${YELLOW}→${NC} make lint             # Lint code"
echo "     ${YELLOW}→${NC} make services         # Start Docker services"
echo ""
echo -e "${BLUE}Useful Commands:${NC}"
echo "  make help        - Show all available commands"
echo "  make doctor      - Run diagnostics"
echo "  make info        - Show environment info"
echo "  make clean-all   - Deep clean and start fresh"
echo ""
echo -e "${GREEN}Happy coding! 🚀${NC}"
echo ""
