#!/bin/bash
# FlashFusion Repository Analysis - Phase 1

echo "🔍 FlashFusion Duplicate & Structure Analysis"
echo "============================================="
echo ""

# Define locations
LOCATIONS=(
    "/mnt/c/FlashFusion-Unified"
    "/mnt/d/01_Projects/Active/FlashFusion_Ecosystem/FlashFusion_Main"
    "/mnt/d/01_Projects/Active/FlashFusion_Ecosystem/FlashFusion_TurboRepo" 
    "/mnt/d/01_Projects/Active/FlashFusion_Ecosystem/FlashFusion_V1"
    "/mnt/d/02_Backups/Project_Backups/FlashFusion-SuperRepo"
)

# Create report file
REPORT="/home/kyler/FLASHFUSION_DUPLICATE_ANALYSIS.md"

cat > "$REPORT" << 'EOF'
# 🔍 FlashFusion Duplicate & Structure Analysis Report

## Executive Summary
Comprehensive analysis of FlashFusion repositories across C: and D: drives to identify duplicates, conflicts, and consolidation opportunities.

## Repository Locations Analyzed

EOF

echo "📊 Analyzing repository structure and content..."
echo ""

# Check each location
for location in "${LOCATIONS[@]}"; do
    echo "Checking: $location"
    if [[ -d "$location" ]]; then
        echo "✅ Found: $location" 
        echo "- ✅ $location" >> "$REPORT"
        
        # Count key files
        js_count=$(find "$location" -name "*.js" -o -name "*.jsx" 2>/dev/null | wc -l)
        ts_count=$(find "$location" -name "*.ts" -o -name "*.tsx" 2>/dev/null | wc -l)
        json_count=$(find "$location" -name "*.json" 2>/dev/null | wc -l)
        md_count=$(find "$location" -name "*.md" 2>/dev/null | wc -l)
        
        echo "  📊 Files: JS/JSX:$js_count TS/TSX:$ts_count JSON:$json_count MD:$md_count"
    else
        echo "❌ Not found: $location"
        echo "- ❌ $location (Not Found)" >> "$REPORT"
    fi
done

echo "" >> "$REPORT"
echo "## File Statistics by Location" >> "$REPORT"
echo "" >> "$REPORT"
echo "| Location | JS/JSX | TS/TSX | JSON | MD | Total |" >> "$REPORT"
echo "|----------|--------|--------|------|-----|-------|" >> "$REPORT"

total_files=0
for location in "${LOCATIONS[@]}"; do
    if [[ -d "$location" ]]; then
        loc_name=$(basename "$location")
        js_count=$(find "$location" -name "*.js" -o -name "*.jsx" 2>/dev/null | wc -l)
        ts_count=$(find "$location" -name "*.ts" -o -name "*.tsx" 2>/dev/null | wc -l)
        json_count=$(find "$location" -name "*.json" 2>/dev/null | wc -l)
        md_count=$(find "$location" -name "*.md" 2>/dev/null | wc -l)
        subtotal=$((js_count + ts_count + json_count + md_count))
        total_files=$((total_files + subtotal))
        
        echo "| $loc_name | $js_count | $ts_count | $json_count | $md_count | $subtotal |" >> "$REPORT"
    fi
done
echo "| **TOTAL** | - | - | - | - | **$total_files** |" >> "$REPORT"

echo "" >> "$REPORT"
echo "## Package.json Files Found" >> "$REPORT"
echo "" >> "$REPORT"

echo ""
echo "📦 Analyzing package.json files..."

for location in "${LOCATIONS[@]}"; do
    if [[ -d "$location" ]]; then
        echo "### $(basename $location)" >> "$REPORT"
        echo '```' >> "$REPORT"
        find "$location" -name "package.json" -not -path "*/node_modules/*" -not -path "*/.kiro/*" 2>/dev/null | head -10 >> "$REPORT"
        echo '```' >> "$REPORT"
        echo "" >> "$REPORT"
    fi
done

echo "## Critical Files Comparison" >> "$REPORT"
echo "" >> "$REPORT"

# Check for duplicate README files
echo "### README.md Files" >> "$REPORT"
echo '```' >> "$REPORT"
find /mnt/c/FlashFusion-Unified /mnt/d/01_Projects/Active/FlashFusion_Ecosystem -name "README.md" -not -path "*/node_modules/*" 2>/dev/null | head -20 >> "$REPORT"
echo '```' >> "$REPORT"
echo "" >> "$REPORT"

# Check for Docker files
echo "### Docker Configuration Files" >> "$REPORT"
echo '```' >> "$REPORT"
find /mnt/c/FlashFusion-Unified /mnt/d/01_Projects/Active/FlashFusion_Ecosystem -name "docker*" -o -name "Dockerfile*" -not -path "*/node_modules/*" 2>/dev/null | head -20 >> "$REPORT"
echo '```' >> "$REPORT"
echo "" >> "$REPORT"

# Check for configuration files
echo "### Configuration Files (tsconfig, eslint, etc.)" >> "$REPORT"
echo '```' >> "$REPORT"
find /mnt/c/FlashFusion-Unified /mnt/d/01_Projects/Active/FlashFusion_Ecosystem \( -name "tsconfig*.json" -o -name ".eslint*" -o -name "prettier*" \) -not -path "*/node_modules/*" 2>/dev/null | head -20 >> "$REPORT"
echo '```' >> "$REPORT"
echo "" >> "$REPORT"

# Analyze key directories
echo "## Key Directory Structure" >> "$REPORT"
echo "" >> "$REPORT"

for location in "${LOCATIONS[@]}"; do
    if [[ -d "$location" ]]; then
        echo "### $(basename $location)" >> "$REPORT"
        echo '```' >> "$REPORT"
        ls -la "$location" 2>/dev/null | head -15 >> "$REPORT"
        echo '```' >> "$REPORT"
        echo "" >> "$REPORT"
    fi
done

# Generate consolidation recommendations
cat >> "$REPORT" << 'EOF'

## 🚀 Consolidation Recommendations

### Priority 1: Immediate Actions
1. **FlashFusion-Unified** appears to be the most complete repository
2. **FlashFusion_TurboRepo** likely contains the monorepo structure
3. Multiple versions (V1, Main, SuperRepo) indicate version fragmentation

### Priority 2: Duplicate Resolution
- Merge package.json files using workspace configuration
- Standardize configuration files (tsconfig, eslint, prettier)
- Consolidate documentation files

### Priority 3: Structure Optimization  
- Implement TurboRepo monorepo structure
- Create workspace packages for shared code
- Setup unified build pipeline

## Next Steps
1. Run `~/bin/consolidate-repositories.sh` to merge repositories
2. Validate with `~/bin/validate-best-practices.sh`
3. Setup continuous synchronization

---
*Report generated: $(date)*
EOF

echo ""
echo "✅ Analysis complete!"
echo "📄 Report saved to: $REPORT"
echo ""
echo "📊 Summary:"
echo "  Total files analyzed: $total_files"
echo "  Repositories found: $(ls -ld /mnt/c/FlashFusion-Unified /mnt/d/01_Projects/Active/FlashFusion_Ecosystem/* 2>/dev/null | wc -l)"
echo ""
echo "🔧 Next step: Review the report and run consolidation"