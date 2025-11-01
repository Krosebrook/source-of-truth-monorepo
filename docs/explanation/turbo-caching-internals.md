# Turbo Caching Internals

> Deep dive into how Turborepo's caching system works and why it's so effective

**Audience**: Developers, DevOps Engineers  
**Reading Time**: 15 minutes  
**Related**: [Performance Benchmarks](../performance-benchmarks.md), [ADR-0003](../adr/0003-turborepo-build-system.md)

---

## Introduction

Turborepo's caching is the secret sauce that makes monorepo builds fast. This document explains the internals of how Turbo caches build outputs and why it can speed up builds by 10-100x.

### Why Caching Matters

In a monorepo with 53 repositories:
- **Without caching**: Every CI run rebuilds everything (~30 minutes)
- **With caching**: Only changed packages rebuild (~2 minutes)

**Result**: 15x faster builds, happier developers, lower CI costs.

---

## How Turbo Caching Works

### The Big Picture

```
Input Files → Hash → Cache Lookup → Cache Hit? → Restore Outputs
                                   ↓ No
                                   Run Build → Store Outputs
```

### Step-by-Step Process

#### 1. Input Hashing

When you run `pnpm build`, Turbo:

1. **Collects inputs** for each task:
   - Source files (e.g., `src/**/*.ts`)
   - Dependencies (`package.json`, `pnpm-lock.yaml`)
   - Build configuration (`tsconfig.json`, `turbo.json`)
   - Environment variables (declared in `env`)
   - Task dependencies (`dependsOn: ["^build"]`)

2. **Computes a hash**:
   ```typescript
   const hash = sha256({
     sourceFiles: hashFiles('src/**/*'),
     packageJson: hashFile('package.json'),
     lockfile: hashFile('pnpm-lock.yaml'),
     envVars: hashEnv(['NODE_ENV']),
     dependencies: hashDependencies()
   });
   ```

3. **Generates cache key**: `70594ba45f32f67b`

#### 2. Cache Lookup

Turbo checks if outputs exist for this hash:

```bash
.turbo/cache/70594ba45f32f67b.tar.zst
```

**Cache hit**: Outputs restored in milliseconds  
**Cache miss**: Task executes normally

#### 3. Task Execution (Cache Miss)

If no cache entry exists:

1. **Run the build**:
   ```bash
   tsc --project .
   ```

2. **Capture outputs**:
   - Files matching `outputs` glob (e.g., `dist/**`)
   - Task logs (stdout/stderr)

3. **Create cache entry**:
   ```bash
   tar -czf .turbo/cache/70594ba45f32f67b.tar.zst dist/
   ```

4. **Store metadata**:
   ```json
   {
     "hash": "70594ba45f32f67b",
     "duration": 12453,
     "outputs": ["dist/index.js", "dist/types.d.ts"]
   }
   ```

#### 4. Cache Restore (Cache Hit)

If cache entry exists:

1. **Extract outputs**:
   ```bash
   tar -xzf .turbo/cache/70594ba45f32f67b.tar.zst
   ```

2. **Replay logs** (optional):
   ```
   cache hit, replaying logs 70594ba45f32f67b
   ```

3. **Skip build**: Task marked as complete

**Time saved**: 12 seconds → 0.2 seconds (60x faster!)

---

## Cache Key Calculation

### What Affects the Cache Key?

The cache key changes when **any input** changes:

#### Source Files

```javascript
// Changing any source file invalidates cache
src/index.ts  // ← Change this
src/utils.ts  // ← Or this
```

**Impact**: Cache miss, rebuild required

#### Dependencies

```json
{
  "dependencies": {
    "react": "^18.0.0"  // ← Version change
  }
}
```

**Impact**: Cache miss (dependencies might affect build output)

#### Build Configuration

```json
// tsconfig.json
{
  "compilerOptions": {
    "target": "ES2020"  // ← Change target
  }
}
```

**Impact**: Cache miss (output format changes)

#### Environment Variables

```javascript
// turbo.json
{
  "tasks": {
    "build": {
      "env": ["NODE_ENV"]  // ← Declared env vars
    }
  }
}
```

```bash
NODE_ENV=production pnpm build  # Different cache key
NODE_ENV=development pnpm build # Different cache key
```

**Impact**: Separate cache entries per env combination

#### Dependency Builds

```json
// turbo.json
{
  "tasks": {
    "build": {
      "dependsOn": ["^build"]  // ← Depends on dependency builds
    }
  }
}
```

If `package-a` depends on `package-b`:
- `package-b` hash changes → `package-a` hash changes
- Both packages rebuild

**Impact**: Transitive cache invalidation

### What Doesn't Affect the Cache Key?

These **do not** invalidate cache:

❌ **Comments in source files** (usually)  
❌ **Whitespace changes** (usually)  
❌ **Undeclared environment variables**  
❌ **System time/date**  
❌ **Git commit message**  
❌ **User running the build**

**Note**: Some tools (like Vite) might include metadata that makes these matter.

---

## Cache Storage

### Local Cache

```
.turbo/
├── cache/
│   ├── 70594ba45f32f67b.tar.zst  # Compressed outputs
│   ├── a1b2c3d4e5f6g7h8.tar.zst
│   └── ...
└── runs/
    ├── abc123.json  # Metadata
    └── ...
```

**Storage Format**: Zstandard compression (`.tar.zst`)
**Typical Size**: 1-5GB for monorepo
**Location**: Gitignored (never committed)

### Remote Cache

Turbo supports remote caching for sharing across:
- Team members
- CI/CD runners
- Different machines

**Providers**:
1. **Vercel** (official, easiest)
2. **Self-hosted** (S3, GCS, custom)

**Setup**:
```bash
# Vercel
turbo login
turbo link

# Custom
export TURBO_API="https://cache.example.com"
export TURBO_TOKEN="secret-token"
```

**Benefits**:
- Share cache across team
- Faster CI (no cold starts)
- Consistent builds

---

## Cache Invalidation Strategies

### When Cache is Invalidated

Turbo invalidates cache when inputs change, but you can force invalidation:

#### 1. Manual Invalidation

```bash
# Clear all cache
rm -rf .turbo

# Force rebuild (ignore cache)
pnpm build --force
```

#### 2. Automatic Invalidation

Cache automatically invalidates when:

```javascript
// Any file in these patterns changes
"**/*.ts"       // Source files
"package.json"  // Dependencies
"turbo.json"    // Task config
".env*local"    // Global dependencies
```

#### 3. Time-Based Invalidation (CI)

GitHub Actions cache:
- **TTL**: 7 days
- **Size limit**: 10GB total

Old entries automatically cleaned up.

### Cache Invalidation Gotchas

#### Problem: Too Much Invalidation

**Symptom**: Cache hit rate <50%

**Causes**:
1. Files changing unnecessarily (e.g., timestamps)
2. Non-deterministic builds (random IDs in output)
3. Undeclared dependencies

**Solutions**:
```json
// Exclude generated files from inputs
{
  "tasks": {
    "build": {
      "inputs": ["src/**", "!src/**/*.generated.ts"]
    }
  }
}
```

#### Problem: Too Little Invalidation

**Symptom**: Stale builds, wrong outputs

**Causes**:
1. Missing files in inputs
2. Undeclared environment variables
3. External dependencies not tracked

**Solutions**:
```json
// Declare all inputs explicitly
{
  "tasks": {
    "build": {
      "inputs": ["src/**", "config/**", "schemas/**"],
      "env": ["API_URL", "FEATURE_FLAGS"]
    }
  }
}
```

---

## Performance Characteristics

### Cache Hit Performance

| Operation | Time | Notes |
|-----------|------|-------|
| Hash calculation | ~50ms | Per package |
| Cache lookup | ~10ms | Local cache |
| Extract outputs | ~100ms | Depends on size |
| **Total (hit)** | **~200ms** | 50-100x faster |

### Cache Miss Performance

| Operation | Time | Notes |
|-----------|------|-------|
| Hash calculation | ~50ms | Per package |
| Run build | 5-60s | Depends on package |
| Compress outputs | ~500ms | Zstd compression |
| **Total (miss)** | **5-60s** | Normal build time |

### Cache Size vs Speed Tradeoff

**Small cache (<1GB)**:
- ✅ Fast lookups
- ✅ Low disk usage
- ❌ Frequent cache misses

**Large cache (>10GB)**:
- ✅ High hit rate
- ❌ Slower lookups
- ❌ High disk usage

**Sweet spot**: 2-5GB for most monorepos

---

## Advanced Caching Techniques

### 1. Cache Scopes

Different cache keys for different contexts:

```json
{
  "tasks": {
    "build": {
      "env": ["NODE_ENV"]  // Separate cache per environment
    }
  }
}
```

**Result**:
- `NODE_ENV=production` → Cache A
- `NODE_ENV=development` → Cache B

### 2. Partial Cache Hits

Turbo can use cached dependency outputs even if current package changed:

```
package-a (changed) → rebuild
  └─ package-b (unchanged) → cache hit ✅
```

**Benefit**: Incremental builds only rebuild what changed

### 3. Cache Compression

Turbo uses Zstandard compression:

```bash
# Before compression
dist/ → 12 MB

# After compression
cache/70594ba45f32f67b.tar.zst → 3 MB (75% smaller)
```

**Benefits**:
- Faster transfers (remote cache)
- Lower disk usage
- Faster extraction

### 4. Parallel Cache Restores

Turbo restores caches in parallel:

```
┌─────────┐  ┌─────────┐  ┌─────────┐
│ Cache A │  │ Cache B │  │ Cache C │
└────┬────┘  └────┬────┘  └────┬────┘
     │            │            │
     └────────────┴────────────┘
              ↓
         Parallel Restore
         (3x faster)
```

---

## Debugging Cache Issues

### Check Cache Status

```bash
# See cache hits/misses
pnpm build --summarize

# Verbose logging
pnpm build --log-order stream

# Dry run (no execution)
pnpm build --dry-run
```

### Inspect Cache Contents

```bash
# List cache entries
ls -lh .turbo/cache/

# Extract cache entry
tar -xzf .turbo/cache/70594ba45f32f67b.tar.zst -C /tmp/inspect

# View metadata
cat .turbo/runs/abc123.json | jq
```

### Common Issues

#### Cache Not Working

```bash
# Verify cache directory exists
ls -la .turbo/cache

# Check turbo.json outputs
cat turbo.json | jq '.tasks.build.outputs'

# Ensure outputs are being created
ls -la dist/
```

#### Unexpected Cache Misses

```bash
# See what changed
git status
git diff

# Check environment variables
env | grep NODE_ENV

# Compare hashes
turbo run build --dry-run
```

---

## Best Practices

### Do's

✅ **Declare outputs explicitly**: List all generated files  
✅ **Use content hashing**: Let Turbo handle cache keys  
✅ **Enable remote cache**: Share across team/CI  
✅ **Monitor cache size**: Keep under 5GB  
✅ **Version cache carefully**: Invalidate on breaking changes

### Don'ts

❌ **Don't commit `.turbo/`**: Always gitignore  
❌ **Don't use `--force` often**: Defeats purpose of cache  
❌ **Don't generate random IDs**: Makes builds non-deterministic  
❌ **Don't ignore cache misses**: Investigate why  
❌ **Don't share cache across incompatible environments**: Different OS/arch

---

## Comparison with Other Caching

### Turbo vs Nx

| Feature | Turbo | Nx |
|---------|-------|-----|
| Cache Strategy | Content-based | Content-based |
| Local Cache | ✅ | ✅ |
| Remote Cache | ✅ (Vercel) | ✅ (Nx Cloud) |
| Compression | Zstd | Tar.gz |
| Config Complexity | Low | Medium |

### Turbo vs Manual Caching

| Approach | Speed | Complexity | Reliability |
|----------|-------|------------|-------------|
| Manual (`make`, `scripts`) | Slow | High | Error-prone |
| Turbo | Fast | Low | Robust |

---

## Future Enhancements

Potential improvements to caching:

1. **Distributed cache**: Share across data centers
2. **Smart prefetching**: Predict likely cache entries
3. **Incremental caching**: Cache file-by-file, not package-level
4. **AI-optimized keys**: Machine learning to optimize cache invalidation

---

## References

- [Turborepo Caching Docs](https://turbo.build/repo/docs/core-concepts/caching)
- [Content Addressable Storage](https://en.wikipedia.org/wiki/Content-addressable_storage)
- [Zstandard Compression](https://github.com/facebook/zstd)
- [Performance Benchmarks](../performance-benchmarks.md)

---

**Last Updated**: 2025-11-01  
**Author**: FlashFusion Team
