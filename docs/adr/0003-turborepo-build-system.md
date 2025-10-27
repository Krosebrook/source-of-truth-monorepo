# ADR-0003: Turborepo as Build System

**Date**: 2025-10-27
**Status**: Accepted
**Deciders**: @Krosebrook, FlashFusion Team

---

## Context

With 53 projects in a monorepo, we needed a build orchestration system that could:
- Build projects in the correct order (respecting dependencies)
- Cache build outputs (avoid rebuilding unchanged projects)
- Run tasks in parallel when possible
- Work seamlessly with pnpm workspaces
- Provide fast CI/CD builds (critical for developer productivity)

---

## Decision

We will use **Turborepo 2.1** as the build system and task orchestrator for the monorepo.

Configuration in `turbo.json` at repository root.

---

## Rationale

### Considered Alternatives

#### 1. **Lerna**
- **Pros**:
  - Mature (2016+)
  - Large community
  - Well-documented
- **Cons**:
  - ❌ **Slow**: No built-in caching (can add with plugins)
  - ❌ **No parallelization**: Runs tasks sequentially by default
  - ❌ **Maintenance mode**: Less active development post-2020
  - ❌ **Verbose config**: Requires lots of boilerplate

#### 2. **Nx**
- **Pros**:
  - Very powerful (computation caching, distributed execution)
  - Rich plugin ecosystem
  - Great for large enterprises
- **Cons**:
  - ❌ **Opinionated**: Enforces Nx project structure
  - ❌ **Heavy**: Large learning curve and config overhead
  - ❌ **Overkill**: Too complex for our 53-project use case
  - ❌ **Plugin-dependent**: Many features require plugins

#### 3. **Custom Scripts (npm/pnpm)**
- **Pros**:
  - No additional dependencies
  - Full control
- **Cons**:
  - ❌ **No caching**: Would need to implement ourselves
  - ❌ **No parallelization**: Hard to parallelize cross-project
  - ❌ **No dependency graph**: Must manually order tasks
  - ❌ **Maintenance burden**: Reinventing the wheel

#### 4. **Turborepo (Chosen)**
- **Pros**:
  - ✅ **Fast**: Incremental builds with caching (30s → 0.2s on cached builds)
  - ✅ **Simple**: Minimal config (just `turbo.json`)
  - ✅ **Smart caching**: Content-addressable cache (only rebuild if inputs changed)
  - ✅ **Parallel execution**: Automatic task parallelization
  - ✅ **Remote caching**: Optional (Vercel or self-hosted)
  - ✅ **pnpm native**: Designed for pnpm workspaces
  - ✅ **Active development**: Maintained by Vercel
- **Cons**:
  - ⚠️ **Newer**: Less mature than Lerna/Nx (but rapidly improving)
  - ⚠️ **Vercel-centric**: Remote caching easiest with Vercel (though self-hosting works)

### Why Turborepo

For 53 projects:
- **CI performance**: First build ~20 min, cached builds <1 min (20x faster)
- **DX**: Developers see instant feedback when nothing changed
- **Simple config**: Single `turbo.json` vs complex Nx workspace configs
- **Industry momentum**: Turborepo + pnpm is the 2025 standard for monorepos

**Real-world example from testing**:
```
Initial build:   30 seconds
Cached build:    0.2 seconds  (150x faster!)
```

---

## Consequences

### Positive

- ✅ **20x faster CI**: Cached builds skip unchanged projects
- ✅ **Developer productivity**: Local builds nearly instant after first run
- ✅ **Automatic parallelization**: Turbo schedules tasks optimally
- ✅ **Correct build order**: Dependency graph ensures no race conditions
- ✅ **Simple config**: Just define task pipelines in `turbo.json`

### Negative

- ⚠️ **Learning curve**: Team must understand caching behavior
- ⚠️ **Cache misses**: Incorrect cache keys can cause cache thrashing
- ⚠️ **Debugging**: Harder to debug why something *didn't* rebuild

### Neutral

- ℹ️ **Remote cache optional**: Can use local cache only (simpler) or add remote cache later
- ℹ️ **Lockfile dependency**: Turbo uses pnpm-lock.yaml to understand dep graph

---

## Implementation

### turbo.json Configuration

```json
{
  "$schema": "https://turbo.build/schema.json",
  "globalDependencies": ["**/.env.*local"],
  "pipeline": {
    "build": {
      "dependsOn": ["^build"],
      "outputs": ["dist/**", "build/**", ".next/**", "out/**"]
    },
    "dev": {
      "cache": false,
      "persistent": true
    },
    "lint": {
      "cache": true
    },
    "test": {
      "cache": true,
      "dependsOn": ["build"]
    },
    "type-check": {
      "cache": true,
      "dependsOn": ["^build"]
    }
  }
}
```

### Key Concepts

1. **`dependsOn: ["^build"]`**: Run dependency builds first
2. **`outputs`**: Cache these directories
3. **`cache: false`**: Don't cache dev servers (they need to run)
4. **`persistent: true`**: Keep dev servers running

### Usage

```bash
# Build all projects
pnpm build

# Build only changed projects
pnpm build --filter=...[HEAD^]

# Build specific project + dependencies
pnpm build --filter=flashfusion-consolidated...

# Clear cache
rm -rf .turbo
```

### CI Optimization

```yaml
# GitHub Actions
- uses: actions/cache@v4
  with:
    path: |
      ~/.pnpm-store
      .turbo
    key: ${{ runner.os }}-turbo-${{ hashFiles('pnpm-lock.yaml') }}
```

---

## References

- [Turborepo Documentation](https://turborepo.com/)
- [Why Turborepo](https://vercel.com/blog/how-turborepo-works)
- [Turborepo Handbook](https://turborepo.com/docs/handbook)
- [Turborepo vs Nx](https://turborepo.com/docs/comparisons/nx)
- Related ADRs:
  - [ADR-0002: pnpm Package Manager](./0002-pnpm-package-manager.md)
  - [ADR-0001: SoT Canonical Model](./0001-sot-canonical-model.md)

---

## Revision History

| Date | Author | Change |
|------|--------|--------|
| 2025-10-27 | @Krosebrook | Initial version |
