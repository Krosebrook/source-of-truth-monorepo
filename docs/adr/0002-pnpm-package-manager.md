# ADR-0002: pnpm as Package Manager

**Date**: 2025-10-27
**Status**: Accepted
**Deciders**: @Krosebrook, FlashFusion Team

---

## Context

For a monorepo consolidating 53 repositories, we needed to choose a package manager that could efficiently handle:

- Workspace management across 53 projects
- Dependency deduplication (avoiding massive node_modules)
- Fast installs in CI/CD
- Deterministic builds (lockfile consistency)

---

## Decision

We will use **pnpm 9.x** as the package manager for the entire monorepo.

All projects will use `"packageManager": "pnpm@9.0.0"` in root `package.json`.

---

## Rationale

### Considered Alternatives

#### 1. **npm (Default)**

- **Pros**:
  - Built into Node.js (no installation needed)
  - Most familiar to developers
  - npm workspaces supported (v7+)
- **Cons**:
  - ❌ **Slow installs**: npm workspaces are 2-3x slower than pnpm
  - ❌ **Disk space**: Duplicates dependencies across workspaces
  - ❌ **Large node_modules**: 53 projects = ~5-10GB node_modules
  - ❌ **No symlink optimization**: Each workspace gets full copy

#### 2. **Yarn Classic (v1)**

- **Pros**:
  - Faster than npm
  - Workspaces support
  - Offline mode
- **Cons**:
  - ❌ **Deprecated**: Yarn team recommends migrating to Yarn Berry
  - ❌ **Hoisting issues**: Phantom dependencies (can import undeclared deps)
  - ❌ **Large node_modules**: Still duplicates across workspaces

#### 3. **Yarn Berry (v3+)**

- **Pros**:
  - Plug'n'Play (PnP) - no node_modules
  - Very fast installs
  - Zero-installs (commit .yarn/cache)
- **Cons**:
  - ❌ **PnP compatibility**: Many tools don't work with PnP (VSCode, some ESLint plugins)
  - ❌ **Breaking change**: Requires rewriting imports for some packages
  - ❌ **Limited adoption**: Less community support than pnpm

#### 4. **pnpm (Chosen)**

- **Pros**:
  - ✅ **Symlink-based**: Stores deps in global content-addressable store (~/.pnpm-store)
  - ✅ **Disk space savings**: 50-70% less than npm/yarn (deduplicates across all projects)
  - ✅ **Fast**: 2-3x faster than npm, comparable to Yarn Berry
  - ✅ **Strict**: Prevents phantom dependencies (must declare all deps)
  - ✅ **Workspace support**: First-class monorepo support
  - ✅ **Deterministic**: pnpm-lock.yaml ensures reproducible builds
  - ✅ **CI optimized**: Works great with GitHub Actions caching
- **Cons**:
  - ⚠️ **Learning curve**: Symlink structure different from npm
  - ⚠️ **Requires installation**: Not built into Node.js

### Why pnpm

For a 53-project monorepo:

- **Disk space**: npm would require ~8-10GB node_modules, pnpm uses ~3-4GB (60% savings)
- **CI speed**: pnpm installs in 30-60 seconds with cache, npm takes 2-3 minutes
- **Correctness**: Strict dependency resolution prevents "works on my machine" issues
- **Turbo compatibility**: pnpm + Turborepo is the recommended stack for 2025

---

## Consequences

### Positive

- ✅ **60% disk space savings**: 53 projects share dependencies via symlinks
- ✅ **2-3x faster installs**: Critical for CI/CD performance
- ✅ **Strict dependency resolution**: Prevents phantom dependencies
- ✅ **Better caching in CI**: GitHub Actions pnpm cache dramatically speeds up CI
- ✅ **Future-proof**: pnpm is the recommended package manager for monorepos in 2025

### Negative

- ⚠️ **Team learning curve**: Developers must learn pnpm commands
- ⚠️ **IDE setup**: Some IDEs need configuration for pnpm symlinks (usually auto-detected)
- ⚠️ **Global install required**: `npm install -g pnpm` on new machines

### Neutral

- ℹ️ **Migration effort**: Converting 53 package-lock.json files to pnpm-lock.yaml
- ℹ️ **Documentation needed**: Team must understand pnpm workspace protocol (`workspace:*`)

---

## Implementation

### Migration Steps

1. **Install pnpm globally**:

   ```bash
   npm install -g pnpm@9
   ```

2. **Remove old lockfiles**:

   ```bash
   find . -name "package-lock.json" -delete
   find . -name "yarn.lock" -delete
   ```

3. **Create pnpm workspace**:

   ```yaml
   # pnpm-workspace.yaml
   packages:
     - "agents/*"
     - "projects/**/*"
     - "shared/*"
   ```

4. **Install dependencies**:

   ```bash
   pnpm install
   ```

5. **Update package.json**:
   ```json
   {
     "packageManager": "pnpm@9.0.0"
   }
   ```

### Workspace Dependencies

Use `workspace:*` protocol for internal dependencies:

```json
{
  "dependencies": {
    "@flashfusion/logging": "workspace:*"
  }
}
```

### CI Configuration

```yaml
# .github/workflows/ci.yml
- uses: pnpm/action-setup@v4
  with:
    version: 9
- uses: actions/setup-node@v4
  with:
    node-version: 20
    cache: "pnpm"
- run: pnpm install --frozen-lockfile
```

---

## References

- [pnpm Documentation](https://pnpm.io/)
- [pnpm Benchmarks](https://pnpm.io/benchmarks)
- [pnpm Workspaces](https://pnpm.io/workspaces)
- [Why pnpm?](https://pnpm.io/motivation)
- Related ADRs:
  - [ADR-0003: Turborepo Build System](./0003-turborepo-build-system.md)
  - [ADR-0001: SoT Canonical Model](./0001-sot-canonical-model.md)

---

## Revision History

| Date       | Author      | Change          |
| ---------- | ----------- | --------------- |
| 2025-10-27 | @Krosebrook | Initial version |
