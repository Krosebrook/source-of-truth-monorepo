#!/bin/bash
# FlashFusion SoT - Health Check Script
# Verifies that all systems are operational
# Usage: ./scripts/health-check.sh

set -euo pipefail

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}🏥 FlashFusion SoT Health Check${NC}"
echo ""

CHECKS_PASSED=0
CHECKS_FAILED=0

check_pass() {
  echo -e "${GREEN}✓${NC} $1"
  CHECKS_PASSED=$((CHECKS_PASSED + 1))
}

check_fail() {
  echo -e "${RED}✗${NC} $1"
  CHECKS_FAILED=$((CHECKS_FAILED + 1))
}

# Type checking
echo "Type Checking..."
if pnpm type-check 2>&1 | grep -q "error"; then
  check_fail "Type checking has errors"
else
  check_pass "Type checking passed"
fi

# Linting
echo ""
echo "Linting..."
if pnpm lint 2>&1 | grep -q "error"; then
  check_fail "Linting has errors"
else
  check_pass "Linting passed"
fi

# Tests
echo ""
echo "Testing..."
if pnpm test 2>&1 | grep -q "fail"; then
  check_fail "Tests have failures"
else
  check_pass "Tests passed"
fi

# Security audit
echo ""
echo "Security Audit..."
if pnpm security:audit:check 2>&1; then
  check_pass "No security vulnerabilities"
else
  check_fail "Security vulnerabilities found"
fi

# Summary
echo ""
echo "═══════════════════════════════════"
if [ $CHECKS_FAILED -eq 0 ]; then
  echo -e "${GREEN}✅ All systems operational!${NC}"
  echo "Passed: $CHECKS_PASSED"
  exit 0
else
  echo -e "${RED}⚠ Some systems need attention${NC}"
  echo "Passed: $CHECKS_PASSED"
  echo "Failed: $CHECKS_FAILED"
  exit 1
fi
