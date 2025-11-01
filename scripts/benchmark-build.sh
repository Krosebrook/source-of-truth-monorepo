#!/bin/bash
# Performance Benchmarking Script for Turbo Build System
# Measures build cache effectiveness and CI performance

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
RESULTS_FILE="$REPO_ROOT/docs/performance-benchmarks.md"
TEMP_RESULTS="/tmp/benchmark-results-$(date +%s).json"

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${BLUE}=== Turbo Build Performance Benchmark ===${NC}"
echo "Repository: source-of-truth-monorepo"
echo "Date: $(date -u +"%Y-%m-%d %H:%M:%S UTC")"
echo ""

cd "$REPO_ROOT"

# Function to measure build time
measure_build() {
    local label="$1"
    local extra_args="${2:-}"
    
    echo -e "${YELLOW}Running: $label${NC}"
    
    # Use GNU time if available, otherwise fallback to bash time
    if command -v /usr/bin/time &> /dev/null; then
        /usr/bin/time -f "Time: %E (real) %U (user) %S (sys)" \
            pnpm build $extra_args 2>&1 | tee /tmp/build-output.log
    else
        time pnpm build $extra_args 2>&1 | tee /tmp/build-output.log
    fi
    
    # Extract time from output
    local time_info=$(grep -i "time:" /tmp/build-output.log | tail -1 || echo "Time: N/A")
    echo "$label: $time_info"
    echo ""
}

# Benchmark 1: Clean build (no cache)
echo -e "${GREEN}[1/5] Clean Build (No Cache)${NC}"
rm -rf .turbo node_modules/.cache
measure_build "Clean Build" ""

# Benchmark 2: Full cached build (no changes)
echo -e "${GREEN}[2/5] Full Cached Build (No Changes)${NC}"
measure_build "Cached Build - All Hits" ""

# Benchmark 3: Force rebuild
echo -e "${GREEN}[3/5] Force Rebuild (Ignore Cache)${NC}"
measure_build "Force Rebuild" "--force"

# Benchmark 4: Single package change simulation
echo -e "${GREEN}[4/5] Incremental Build (Single Package Change)${NC}"
# Touch a file to simulate a change
SAMPLE_FILE=$(find projects -name "package.json" -type f | head -1)
if [ -n "$SAMPLE_FILE" ]; then
    touch "$SAMPLE_FILE"
    measure_build "Incremental Build" ""
fi

# Benchmark 5: Parallel execution info
echo -e "${GREEN}[5/5] Collecting Build Statistics${NC}"
pnpm build --summarize 2>&1 | tee /tmp/build-summary.log || echo "Summarize not available"

# Generate cache statistics
echo -e "${BLUE}=== Cache Statistics ===${NC}"
if [ -d ".turbo/cache" ]; then
    CACHE_SIZE=$(du -sh .turbo/cache | cut -f1)
    CACHE_FILES=$(find .turbo/cache -type f | wc -l)
    echo "Cache Size: $CACHE_SIZE"
    echo "Cache Files: $CACHE_FILES"
else
    echo "No cache directory found"
fi

# Count packages
PACKAGE_COUNT=$(find projects -name "package.json" -type f | wc -l)
echo "Total Packages: $PACKAGE_COUNT"

echo ""
echo -e "${GREEN}Benchmark Complete!${NC}"
echo "Results logged to: $RESULTS_FILE"
