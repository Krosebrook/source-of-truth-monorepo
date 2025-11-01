# How to Run Performance Benchmarks

> Step-by-step guide for benchmarking Turbo build performance

**Time to Complete**: 10-15 minutes  
**Prerequisites**: Local development environment setup  
**Related**: [Performance Benchmarks](../performance-benchmarks.md)

---

## Overview

This guide walks you through running performance benchmarks to measure Turbo build cache effectiveness and identify optimization opportunities.

---

## Prerequisites

Before running benchmarks:

1. **Install dependencies**
   ```bash
   pnpm install
   ```

2. **Verify Turbo is working**
   ```bash
   pnpm build --dry-run
   ```

3. **Ensure you have disk space**
   ```bash
   df -h .
   # Need at least 2GB free for cache
   ```

---

## Running the Automated Benchmark

### Quick Start

The easiest way to benchmark is using the automated script:

```bash
# Run full benchmark suite
./scripts/benchmark-build.sh
```

This will:
1. Measure clean build time (no cache)
2. Measure cached build time (full cache)
3. Measure force rebuild time
4. Measure incremental build time
5. Collect cache statistics
6. Update documentation with results

### Expected Output

```
=== Turbo Build Performance Benchmark ===
Repository: source-of-truth-monorepo
Date: 2025-11-01 13:00:00 UTC

[1/5] Clean Build (No Cache)
Time: 0m5.2s

[2/5] Full Cached Build (No Changes)
Time: 0m4.4s (15% faster)

[3/5] Force Rebuild (Ignore Cache)
Time: 0m5.3s

[4/5] Incremental Build (Single Package Change)
Time: 0m4.8s

[5/5] Collecting Build Statistics

=== Cache Statistics ===
Cache Size: 20KB
Cache Files: 4
Total Packages: 9

Benchmark Complete!
Results logged to: docs/performance-benchmarks.md
```

---

## Manual Benchmarking

For more control, run benchmarks manually:

### 1. Clean Build (No Cache)

```bash
# Clear all caches
rm -rf .turbo node_modules/.cache

# Measure clean build
time pnpm build
```

**What to look for**:
- Total build time
- Number of packages built
- Any build failures

### 2. Cached Build (Full Cache)

```bash
# Run build again without changes
time pnpm build
```

**What to look for**:
- Cache hit ratio (should be 100%)
- Build time reduction (should be 50-90% faster)
- Number of cached packages

### 3. Force Rebuild

```bash
# Force rebuild all packages
time pnpm build --force
```

**What to look for**:
- Similar time to clean build
- Zero cache hits
- All packages rebuilt

### 4. Incremental Build

```bash
# Make a small change
touch projects/local/flashfusion-consolidated/apps/web/package.json

# Rebuild
time pnpm build
```

**What to look for**:
- Only affected packages rebuild
- Most packages come from cache
- Fast build time (<30% of clean build)

### 5. Check Cache Statistics

```bash
# Cache size
du -sh .turbo/cache

# Cache files
find .turbo/cache -type f | wc -l

# List cached packages
ls -lh .turbo/cache
```

---

## Interpreting Results

### Good Performance Indicators

✅ **Cache Hit Rate >80%**: Most packages using cache  
✅ **Cached Build <1 min**: Fast subsequent builds  
✅ **Incremental Build <2 min**: Quick feedback on changes  
✅ **Cache Size <5GB**: Manageable disk usage

### Performance Issues

❌ **Cache Hit Rate <50%**: Cache not effective  
❌ **Cached Build >5 min**: Not much faster than clean build  
❌ **Cache Size >10GB**: Excessive disk usage  
❌ **Incremental Build >5 min**: Too many packages rebuilding

### Common Issues and Solutions

#### Issue: No Cache Hits

**Symptoms**: Every build shows "cache miss"

**Possible Causes**:
1. Cache directory deleted
2. Source files changing between builds
3. Environment variables not declared in `turbo.json`

**Solutions**:
```bash
# Check if cache exists
ls -la .turbo/cache

# Verify no files are changing
git status

# Check turbo.json env configuration
cat turbo.json | grep -A 5 "env"
```

#### Issue: Slow Cached Builds

**Symptoms**: Cached build not much faster than clean build

**Possible Causes**:
1. Too many packages have no build outputs
2. Build scripts doing extra work beyond compilation
3. Dependencies not properly declared

**Solutions**:
```bash
# Check which packages are rebuilding
pnpm build --summarize

# Verify outputs in turbo.json
cat turbo.json | grep -A 3 "outputs"

# Check dependency graph
pnpm ls --depth=1
```

#### Issue: Large Cache Size

**Symptoms**: `.turbo/cache` using >10GB disk space

**Possible Causes**:
1. Too many build variations cached
2. Large build artifacts (e.g., bundled apps)
3. Old cache not being cleaned

**Solutions**:
```bash
# Clear old cache entries
find .turbo/cache -type f -mtime +30 -delete

# Clear all cache and rebuild
rm -rf .turbo && pnpm build

# Check largest cache entries
du -sh .turbo/cache/* | sort -h
```

---

## Continuous Monitoring

### Weekly Benchmarks

Add to your weekly routine:

```bash
# Run benchmark
./scripts/benchmark-build.sh

# Review results
cat docs/performance-benchmarks.md

# Check for regressions
git diff docs/performance-benchmarks.md
```

### CI Monitoring

Track build times in GitHub Actions:

1. Go to repository **Actions** tab
2. Open recent CI run
3. Check **Build** step duration
4. Compare with previous runs

**Alert if**:
- Build time increased >50% without new packages
- Build time consistently >20 minutes
- Cache hit rate dropped below 70%

### Automated Alerts

Set up alerts (future enhancement):

```yaml
# .github/workflows/performance-alert.yml
- name: Check build time
  run: |
    if [ "$BUILD_TIME" -gt 1200 ]; then
      echo "::error::Build exceeded 20 minutes!"
      exit 1
    fi
```

---

## Benchmarking Best Practices

### Do's

✅ **Run benchmarks on clean state**: Clear cache before clean build test  
✅ **Run multiple times**: Take average of 3 runs for accuracy  
✅ **Benchmark on same machine**: Consistent hardware for comparison  
✅ **Document changes**: Note package additions before/after benchmark  
✅ **Track trends**: Compare weekly to spot performance regressions

### Don'ts

❌ **Don't benchmark with background tasks**: Close heavy apps  
❌ **Don't change code during benchmark**: Introduces variables  
❌ **Don't compare different machines**: Hardware affects results  
❌ **Don't benchmark with network issues**: Can slow dependency resolution  
❌ **Don't ignore outliers**: Investigate unusual results

---

## Advanced Benchmarking

### Profiling Individual Packages

```bash
# Profile a specific package
pnpm build --filter=@flashfusion/web --profile

# View profile
cat .turbo/runs/*.json
```

### Comparing Before/After

```bash
# Benchmark baseline
./scripts/benchmark-build.sh > /tmp/before.txt

# Make changes (e.g., add package)
# ...

# Benchmark after changes
./scripts/benchmark-build.sh > /tmp/after.txt

# Compare
diff /tmp/before.txt /tmp/after.txt
```

### Remote Cache Testing

```bash
# Enable remote cache (Vercel)
turbo login
turbo link

# Benchmark with remote cache
pnpm build

# Check remote cache stats
turbo info
```

---

## Next Steps

After benchmarking:

1. **Review Results**: Check `docs/performance-benchmarks.md`
2. **Identify Issues**: Look for slow packages or low cache hits
3. **Optimize**: Fix configuration issues
4. **Re-benchmark**: Verify improvements
5. **Document**: Update performance findings

---

## Related Documentation

- [Performance Benchmarks](../performance-benchmarks.md) - Current metrics and trends
- [Turbo Caching Internals](../explanation/turbo-caching-internals.md) - How caching works
- [CI Configuration](./configure-ci-cd.md) - Setting up CI optimizations
- [ADR-0003: Turborepo Build System](../adr/0003-turborepo-build-system.md) - Architecture decision

---

## Troubleshooting

### Benchmark Script Fails

```bash
# Make script executable
chmod +x scripts/benchmark-build.sh

# Check dependencies
which pnpm
which time

# Run with bash explicitly
bash scripts/benchmark-build.sh
```

### Inconsistent Results

```bash
# Clear all state
rm -rf .turbo node_modules/.cache

# Reinstall
pnpm install --frozen-lockfile

# Try again
./scripts/benchmark-build.sh
```

### Need Help?

- Check [Performance Benchmarks FAQ](../performance-benchmarks.md#troubleshooting)
- Open an issue with benchmark results
- Contact the team in #performance Slack channel

---

**Last Updated**: 2025-11-01  
**Maintainer**: FlashFusion Team
