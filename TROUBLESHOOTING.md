# Troubleshooting Guide

Common issues and solutions for the FlashFusion Source-of-Truth monorepo.

## Table of Contents

- [Installation Issues](#installation-issues)
- [Build Issues](#build-issues)
- [Dependency Issues](#dependency-issues)
- [Git Issues](#git-issues)
- [Workspace Issues](#workspace-issues)
- [CI/CD Issues](#cicd-issues)
- [Development Environment](#development-environment)

---

## Installation Issues

### pnpm: command not found

**Problem**: pnpm is not installed or not in PATH.

**Solution**:

```bash
# Install pnpm globally
npm install -g pnpm@9

# Or use Corepack (built into Node.js 20+)
corepack enable
corepack prepare pnpm@9 --activate
```

### pnpm install fails with permission errors

**Problem**: Permission denied when installing packages.

**Solution**:

```bash
# Don't use sudo with pnpm
# Instead, fix npm permissions:
mkdir ~/.npm-global
npm config set prefix '~/.npm-global'
echo 'export PATH=~/.npm-global/bin:$PATH' >> ~/.bashrc
source ~/.bashrc

# Then install pnpm
npm install -g pnpm@9
```

### Lockfile out of sync

**Problem**: `pnpm install` shows lockfile errors.

**Solution**:

```bash
# Remove lockfile and reinstall
rm pnpm-lock.yaml
pnpm install

# Or update lockfile only
pnpm install --no-frozen-lockfile
```

---

## Build Issues

### Build fails with "Cannot find module"

**Problem**: Missing dependencies or incorrect workspace references.

**Solution**:

```bash
# Clean and reinstall
rm -rf node_modules
pnpm install

# If using workspace dependencies
pnpm install --force
```

### Turbo cache issues

**Problem**: Stale cache causing build errors.

**Solution**:

```bash
# Clear Turbo cache
rm -rf .turbo

# Force rebuild without cache
pnpm build --force

# Or disable cache temporarily
TURBO_FORCE=true pnpm build
```

### TypeScript errors after updating dependencies

**Problem**: Type errors after dependency updates.

**Solution**:

```bash
# Clean TypeScript build info
find . -name "*.tsbuildinfo" -delete

# Reinstall dependencies
pnpm install

# Run type check
pnpm type-check
```

### "No output files found" warning from Turbo

**Problem**: Turbo warns about missing output files.

**Explanation**: This is normal for packages that don't produce build artifacts (e.g., packages with only echo commands).

**Solution**:

- If the package shouldn't produce outputs, this warning can be ignored
- If it should produce outputs, check the `outputs` configuration in `turbo.json`

---

## Dependency Issues

### Peer dependency warnings

**Problem**: pnpm shows peer dependency warnings.

**Solution**:

```bash
# Most peer dependency warnings are safe to ignore
# To fix them, update the dependency:
pnpm update <package-name>

# Or install the required peer dependency
pnpm add <peer-dependency>
```

### Duplicate dependencies

**Problem**: Multiple versions of the same package installed.

**Solution**:

```bash
# Deduplicate dependencies
pnpm dedupe

# Or use overrides in package.json
{
  "pnpm": {
    "overrides": {
      "package-name": "^1.0.0"
    }
  }
}
```

### Security vulnerabilities

**Problem**: `pnpm audit` reports vulnerabilities.

**Solution**:

```bash
# View vulnerabilities
pnpm audit

# Update vulnerable packages
pnpm update --latest

# For more details
pnpm audit --json

# If updates don't fix it, check if the vulnerability
# is in a dev dependency or has low impact
```

---

## Git Issues

### Husky hooks not running

**Problem**: Pre-commit or commit-msg hooks aren't executing.

**Solution**:

```bash
# Reinstall husky
rm -rf .husky
pnpm run prepare

# Or manually
npx husky install
```

### Commitlint fails

**Problem**: Commit message doesn't follow conventional commits.

**Solution**:

```bash
# Follow this format:
# type(scope): subject
#
# Examples:
git commit -m "feat(agents): add Claude agent"
git commit -m "fix(ci): resolve build failure"
git commit -m "docs: update README"

# Valid types: feat, fix, docs, style, refactor, perf, test, chore, ci, build
```

### Lint-staged fails

**Problem**: Pre-commit hook fails on staged files.

**Solution**:

```bash
# Run manually to see errors
npx lint-staged

# Fix linting errors
pnpm lint:fix

# Format code
pnpm format

# Then retry commit
git commit
```

### Large files rejected

**Problem**: Git refuses to commit large files.

**Solution**:

```bash
# Check .gitignore is correct
cat .gitignore

# Remove large files from staging
git reset HEAD <large-file>

# Use Git LFS for large files if necessary
git lfs install
git lfs track "*.large-extension"
git add .gitattributes
```

---

## Workspace Issues

### Package not found in workspace

**Problem**: pnpm can't find a workspace package.

**Solution**:

```bash
# Verify workspace configuration
cat pnpm-workspace.yaml

# Check package.json exists in the package
ls projects/path/to/package/package.json

# Reinstall to refresh workspace links
pnpm install
```

### Cross-package imports fail

**Problem**: Importing from another workspace package fails.

**Solution**:

```bash
# Use workspace protocol in package.json
{
  "dependencies": {
    "@flashfusion/other-package": "workspace:*"
  }
}

# Then reinstall
pnpm install
```

### Changes not detected by Turbo

**Problem**: Turbo doesn't rebuild changed packages.

**Solution**:

```bash
# Force rebuild
pnpm build --force

# Or clear cache
rm -rf .turbo
pnpm build
```

---

## CI/CD Issues

### GitHub Actions fails

**Problem**: CI workflow fails but works locally.

**Solution**:

```bash
# Check the workflow logs in GitHub Actions

# Common issues:
# 1. Different Node version
# 2. Missing environment variables
# 3. Different pnpm version

# Test with frozen lockfile (same as CI)
pnpm install --frozen-lockfile
pnpm build
pnpm test
```

### Deploy keys not working

**Problem**: Subtree push fails with permission errors.

**Solution**:

1. Verify deploy keys are configured in GitHub Secrets
2. Check key format (no extra newlines or spaces)
3. Ensure key has write permissions
4. See [Configure Deploy Keys](./docs/how-to/configure-deploy-keys.md)

### CodeQL scan fails

**Problem**: CodeQL analysis workflow fails.

**Solution**:

1. Check that code compiles successfully
2. Verify no syntax errors
3. Review CodeQL logs in Actions
4. Some warnings are expected and can be ignored

---

## Development Environment

### VS Code extensions not working

**Problem**: Recommended extensions don't work as expected.

**Solution**:

```bash
# Install recommended extensions
# Open Command Palette (Cmd/Ctrl + Shift + P)
# Type: "Extensions: Show Recommended Extensions"
# Click "Install All"

# Reload VS Code
# Command Palette -> "Developer: Reload Window"
```

### ESLint not running

**Problem**: ESLint doesn't show errors in editor.

**Solution**:

```bash
# Check ESLint configuration
cat eslint.config.js

# Verify ESLint is installed
pnpm list eslint

# Restart ESLint server
# VS Code Command Palette -> "ESLint: Restart ESLint Server"
```

### Prettier not formatting on save

**Problem**: Code doesn't format automatically.

**Solution**:

1. Check VS Code settings:
   - "Editor: Format On Save" should be enabled
   - "Editor: Default Formatter" should be "esbenp.prettier-vscode"
2. Check `.prettierrc.json` exists
3. Reload VS Code window

### TypeScript IntelliSense not working

**Problem**: No autocomplete or type checking in editor.

**Solution**:

```bash
# Select TypeScript version
# VS Code Command Palette -> "TypeScript: Select TypeScript Version"
# Choose "Use Workspace Version"

# Restart TS Server
# Command Palette -> "TypeScript: Restart TS Server"

# Check tsconfig.json exists
ls tsconfig.base.json
```

---

## Performance Issues

### Slow pnpm install

**Problem**: Installation takes too long.

**Solution**:

```bash
# Use frozen lockfile (skip resolution)
pnpm install --frozen-lockfile

# Enable parallel installs (default)
# Or adjust concurrency
pnpm install --network-concurrency=4

# Check disk space
df -h
```

### Slow builds

**Problem**: Builds take too long even with cache.

**Solution**:

```bash
# Build only changed packages
pnpm build --filter="...[HEAD^]"

# Enable remote caching (if available)
# See turbo.json configuration

# Increase Node.js memory
export NODE_OPTIONS="--max-old-space-size=4096"
pnpm build
```

---

## Getting More Help

If you can't find a solution here:

1. **Search Issues**: Check [GitHub Issues](https://github.com/Krosebrook/source-of-truth-monorepo/issues)
2. **Ask in Discussions**: Post in [GitHub Discussions](https://github.com/Krosebrook/source-of-truth-monorepo/discussions)
3. **Read Documentation**: Check [docs/index.md](./docs/index.md)
4. **Contact Maintainer**: Email krosebrook@flashfusion.co

---

## Contributing Fixes

Found a solution not listed here? Please:

1. Open a PR to update this guide
2. Or create an issue with the "documentation" label

Thank you! 🙏
