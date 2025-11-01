#!/bin/bash

###############################################################################
# Interactive Onboarding Checklist
# 
# This script provides an interactive checklist for new contributors
# following the onboarding process.
#
# Usage: ./scripts/onboarding-checklist.sh
###############################################################################

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Progress file
PROGRESS_FILE="$HOME/.flashfusion-sot-onboarding.progress"

# Initialize progress file if it doesn't exist
if [ ! -f "$PROGRESS_FILE" ]; then
  cat > "$PROGRESS_FILE" << 'EOF'
# FlashFusion SoT Onboarding Progress
# Mark items as done by changing [ ] to [x]

## Setup
[ ] Clone repository
[ ] Install Node.js 20+
[ ] Install pnpm
[ ] Run onboard-contributor.sh
[ ] Run verify-setup.sh

## Learning
[ ] Read README.md
[ ] Read GETTING_STARTED.md
[ ] Read contributor quick start guide
[ ] Complete onboarding checklist

## First Steps
[ ] Build all projects (pnpm build)
[ ] Explore workspace (pnpm -r list)
[ ] Join team communication
[ ] Configure git user.name and user.email

## First Contribution
[ ] Create feature branch
[ ] Make a change
[ ] Run tests and linting
[ ] Create changeset
[ ] Create pull request

## Advanced
[ ] Read monorepo best practices
[ ] Read mirror repository guide
[ ] Understand SoT canonical model
[ ] Review architecture decisions (ADRs)
EOF
fi

print_header() {
  echo -e "\n${CYAN}========================================${NC}"
  echo -e "${CYAN}$1${NC}"
  echo -e "${CYAN}========================================${NC}\n"
}

print_section() {
  echo -e "${BLUE}$1${NC}"
}

print_done() {
  echo -e "${GREEN}✓ $1${NC}"
}

print_todo() {
  echo -e "  $1"
}

count_progress() {
  local total=$(grep -c "^\[" "$PROGRESS_FILE")
  local done=$(grep -c "^\[x\]" "$PROGRESS_FILE")
  echo "$done/$total"
}

calculate_percentage() {
  local total=$(grep -c "^\[" "$PROGRESS_FILE")
  local done=$(grep -c "^\[x\]" "$PROGRESS_FILE")
  if [ $total -eq 0 ]; then
    echo "0"
  else
    echo $((done * 100 / total))
  fi
}

show_progress() {
  print_header "FlashFusion SoT Onboarding Checklist"
  
  local progress=$(count_progress)
  local percentage=$(calculate_percentage)
  
  echo -e "Progress: ${GREEN}${progress}${NC} items completed (${percentage}%)"
  echo ""
  
  local current_section=""
  
  while IFS= read -r line; do
    # Skip comments and empty lines
    if [[ $line =~ ^#.*$ ]] && [[ ! $line =~ ^##.*$ ]]; then
      continue
    fi
    
    if [[ -z $line ]]; then
      continue
    fi
    
    # Section headers
    if [[ $line =~ ^##.*$ ]]; then
      section_name="${line### }"
      print_section "\n$section_name"
      continue
    fi
    
    # Checklist items
    if [[ $line =~ ^\[x\].*$ ]]; then
      item_text="${line#[x] }"
      print_done "$item_text"
    elif [[ $line =~ ^\[\ \].*$ ]]; then
      item_text="${line#[ ] }"
      print_todo "☐ $item_text"
    fi
  done < "$PROGRESS_FILE"
  
  echo ""
  echo -e "${CYAN}========================================${NC}"
  echo ""
  
  if [ $percentage -eq 100 ]; then
    echo -e "${GREEN}🎉 Congratulations! You've completed onboarding!${NC}"
    echo ""
    echo "Next steps:"
    echo "  - Pick a 'good first issue' to work on"
    echo "  - Join the team communication channels"
    echo "  - Make your first contribution!"
  else
    echo "Keep going! You're $percentage% complete."
    echo ""
    echo "To update your progress:"
    echo "  ${YELLOW}vim $PROGRESS_FILE${NC}"
    echo ""
    echo "Or mark items complete automatically:"
    echo "  ${YELLOW}./scripts/onboarding-checklist.sh --mark \"item name\"${NC}"
  fi
  
  echo ""
  echo "To view this checklist again:"
  echo "  ${YELLOW}./scripts/onboarding-checklist.sh${NC}"
  echo ""
}

mark_item() {
  local item_name="$1"
  
  # Escape special characters for sed
  local escaped_item=$(echo "$item_name" | sed 's/[.[\*^$/]/\\&/g')
  
  # Replace [ ] with [x] for matching item
  sed -i "s/^\[ \] $escaped_item$/[x] $item_name/" "$PROGRESS_FILE"
  
  echo -e "${GREEN}✓ Marked \"$item_name\" as complete${NC}"
}

reset_progress() {
  rm -f "$PROGRESS_FILE"
  echo "Progress reset. Run this script again to create a new checklist."
}

show_help() {
  cat << EOF
FlashFusion SoT Onboarding Checklist

Usage:
  ./scripts/onboarding-checklist.sh                 Show progress
  ./scripts/onboarding-checklist.sh --mark "item"   Mark item as complete
  ./scripts/onboarding-checklist.sh --reset         Reset progress
  ./scripts/onboarding-checklist.sh --help          Show this help

Examples:
  ./scripts/onboarding-checklist.sh --mark "Clone repository"
  ./scripts/onboarding-checklist.sh --mark "Read README.md"

Progress file location: $PROGRESS_FILE
EOF
}

# Parse arguments
case "${1:-}" in
  --mark)
    if [ -z "${2:-}" ]; then
      echo "Error: --mark requires an item name"
      echo "Usage: $0 --mark \"item name\""
      exit 1
    fi
    mark_item "$2"
    echo ""
    show_progress
    ;;
  --reset)
    reset_progress
    ;;
  --help|-h)
    show_help
    ;;
  "")
    show_progress
    ;;
  *)
    echo "Unknown option: $1"
    echo "Run '$0 --help' for usage information"
    exit 1
    ;;
esac
