# Security Audits and Dependency Management

## Overview

This document provides detailed information about security audits, dependency management, and automated update processes in the FlashFusion Source-of-Truth monorepo.

## Table of Contents

- [Security Audits](#security-audits)
- [Dependency Management](#dependency-management)
- [Renovate Configuration](#renovate-configuration)
- [Local Development](#local-development)
- [Troubleshooting](#troubleshooting)

## Security Audits

### Automated Audits

The repository runs two types of automated security audits:

#### 1. Gitleaks Secret Scanning

**Purpose**: Detect accidentally committed secrets, API keys, tokens, and credentials.

**When it runs**:
- On every push to `main`
- On every pull request to `main`
- Weekly on Mondays at 6 AM UTC

**Configuration**: `.github/workflows/security.yml`

**What it scans**:
- Full git history
- All branches (for PRs)
- Common secret patterns (AWS keys, GitHub tokens, private keys, etc.)

#### 2. Dependency Vulnerability Audit

**Purpose**: Identify known security vulnerabilities in npm dependencies.

**When it runs**:
- On every push to `main`
- On every pull request to `main`
- Weekly on Mondays at 6 AM UTC

**Configuration**: `.github/workflows/security.yml`

**Severity handling**:
- **Critical/High**: CI fails, blocks merge
- **Moderate/Low**: Logged for review, does not block

**Audit output**: Results are saved as workflow artifacts (JSON format) and retained for 30 days.

### Running Audits Locally

#### Quick Security Check

```bash
# Run all security checks
pnpm security:audit:check
```

#### Detailed Audit Report

```bash
# Human-readable audit report
pnpm security:audit

# JSON format for parsing/automation
pnpm security:audit:json
```

#### Individual Package Audit

```bash
# Audit specific workspace package
pnpm --filter @flashfusion/package-name audit

# Audit a specific project
cd projects/local/flashfusion-consolidated
pnpm audit
```

### Interpreting Audit Results

When you run `pnpm audit`, you'll see output like:

```
┌───────────────┬──────────────────────────────────────────────────────────────┐
│ moderate      │ Prototype Pollution in lodash                                │
├───────────────┼──────────────────────────────────────────────────────────────┤
│ Package       │ lodash                                                       │
├───────────────┼──────────────────────────────────────────────────────────────┤
│ Patched in    │ >=4.17.21                                                    │
├───────────────┼──────────────────────────────────────────────────────────────┤
│ Dependency of │ some-package                                                 │
├───────────────┼──────────────────────────────────────────────────────────────┤
│ Path          │ some-package > lodash                                        │
├───────────────┼──────────────────────────────────────────────────────────────┤
│ More info     │ https://github.com/advisories/GHSA-xxxx-xxxx-xxxx           │
└───────────────┴──────────────────────────────────────────────────────────────┘
```

**Action steps**:

1. **Check if update is available**: Look at "Patched in" version
2. **Update dependency**: 
   - If direct dependency: Update in `package.json`
   - If transitive dependency: Update parent package or wait for Renovate
3. **Verify fix**: Run `pnpm audit` again
4. **Test changes**: Run `pnpm build && pnpm test`

## Dependency Management

### Package Manager: pnpm

We use pnpm for several reasons:
- Fast, efficient disk usage
- Strict dependency resolution
- Built-in workspace support
- Better security (content-addressable store)

### Workspace Structure

```
source-of-truth-monorepo/
├── package.json                 # Root workspace
├── pnpm-workspace.yaml          # Workspace configuration
├── projects/                    # Project workspaces
│   ├── local/
│   ├── krosebrook/
│   ├── flashfusionv1/
│   └── chaosclubco/
├── agents/                      # Agent workspaces
└── shared/                      # Shared utility workspaces
```

### Adding Dependencies

#### To Root Workspace

```bash
# Production dependency
pnpm add -w package-name

# Dev dependency
pnpm add -D -w package-name
```

#### To Specific Package

```bash
# Add to specific workspace package
pnpm --filter @flashfusion/package-name add dependency-name

# Add from root (recommended)
cd projects/local/package-name
pnpm add dependency-name
```

#### Workspace Dependencies

To reference another workspace package:

```json
{
  "dependencies": {
    "@flashfusion/other-package": "workspace:*"
  }
}
```

### Updating Dependencies

#### Manual Updates

```bash
# Update all dependencies (interactive)
pnpm update --interactive --recursive

# Update specific package
pnpm update package-name

# Update to latest (ignore semver)
pnpm update --latest package-name
```

#### Automated Updates (Renovate)

Renovate automatically creates PRs for dependency updates. See [Renovate Configuration](#renovate-configuration) below.

## Renovate Configuration

### Overview

Renovate is configured in `renovate.json` and automatically:
- Detects outdated dependencies
- Creates PRs with updates
- Auto-merges safe updates (patches)
- Assigns major updates for review

### Configuration Breakdown

```json
{
  "$schema": "https://docs.renovatebot.com/renovate-schema.json",
  "extends": ["config:recommended"],
  "rangeStrategy": "bump",
  "separateMajorMinor": true,
  "prConcurrentLimit": 5,
  "prHourlyLimit": 2,
  "schedule": ["before 6am on monday"]
}
```

**Key settings**:

- **`extends: ["config:recommended"]`**: Uses Renovate's recommended preset
- **`rangeStrategy: "bump"`**: Updates both version and range (e.g., `^1.0.0` → `^1.1.0`)
- **`separateMajorMinor: true`**: Creates separate PRs for major vs minor updates
- **`prConcurrentLimit: 5`**: Max 5 open PRs at once
- **`prHourlyLimit: 2`**: Max 2 PRs created per hour
- **`schedule`**: Runs before 6 AM on Mondays

### Package Rules

#### 1. NPM Packages (Manual Review)

```json
{
  "matchManagers": ["npm"],
  "automerge": false,
  "labels": ["dependencies"]
}
```

All npm packages labeled with `dependencies` and require manual review.

#### 2. Patch Updates (Auto-merge)

```json
{
  "matchUpdateTypes": ["patch", "pin", "digest"],
  "automerge": true,
  "automergeType": "pr",
  "labels": ["dependencies", "automerge"]
}
```

Patch updates (1.0.0 → 1.0.1) are auto-merged if CI passes.

#### 3. Major Updates (Require Review)

```json
{
  "matchPackagePatterns": ["*"],
  "matchUpdateTypes": ["major"],
  "labels": ["dependencies", "major-update"],
  "assignees": ["Krosebrook"]
}
```

Major updates assigned to @Krosebrook for review.

### Renovate Dashboard

View the Renovate dashboard by creating an issue titled "Renovate Dashboard" or checking existing Renovate PRs.

### Customizing Renovate

To modify Renovate behavior, edit `renovate.json`:

```bash
# Edit configuration
vim renovate.json

# Validate configuration
npx renovate-config-validator
```

## Local Development

### Pre-commit Checks

Before committing, run:

```bash
# Security audit
pnpm security:audit:check

# Lint
pnpm lint

# Format check
pnpm format:check

# Build
pnpm build

# Test
pnpm test
```

### Git Hooks

Consider adding these to `.husky/pre-commit` (if using Husky):

```bash
#!/bin/sh
pnpm security:audit:check
pnpm format:check
pnpm lint
```

### IDE Integration

#### VS Code

Install recommended extensions:
- ESLint
- Prettier
- GitLens
- npm Intellisense

#### Security Extensions

- **GitHub Copilot**: AI-assisted code review
- **Snyk**: Real-time vulnerability scanning

## Troubleshooting

### "pnpm audit" Fails with Errors

**Problem**: `pnpm audit` exits with non-zero code

**Solution**:
1. Check audit output for vulnerabilities
2. Update affected packages: `pnpm update`
3. For transitive dependencies, update parent package
4. If no fix available, document in SECURITY.md

### Renovate PRs Not Appearing

**Problem**: No Renovate PRs are created

**Checklist**:
1. Verify Renovate is enabled on the repository
2. Check Renovate logs in GitHub Actions (if configured)
3. Verify `renovate.json` syntax: `npx renovate-config-validator`
4. Check schedule: Runs before 6 AM Monday UTC

### Dependency Update Conflicts

**Problem**: Multiple Renovate PRs conflict with each other

**Solution**:
1. Close conflicting PRs
2. Wait for Renovate to recreate PRs with resolved conflicts
3. Or manually resolve: Update dependencies locally and push

### False Positive Vulnerabilities

**Problem**: Audit reports vulnerability that doesn't apply

**Solution**:
1. Verify the vulnerability applies to your usage
2. Document in `SECURITY.md` if false positive
3. Consider using `.npmrc` audit-level to adjust sensitivity
4. Report false positive to npm or package maintainer

### High Severity in Development Dependencies

**Problem**: Dev dependencies have vulnerabilities

**Risk**: Generally lower risk (not in production bundle)

**Action**:
1. Update if possible
2. If no fix, document and monitor
3. Ensure dev dependencies not included in production build

## Best Practices

1. **Review Renovate PRs**: Don't blindly merge, even auto-merge candidates
2. **Run tests locally**: Before approving dependency updates
3. **Check changelogs**: Review what changed in major updates
4. **Monitor security advisories**: Subscribe to GitHub security advisories
5. **Keep lockfile committed**: Always commit `pnpm-lock.yaml`
6. **Use exact versions for critical deps**: Consider using exact versions (no `^` or `~`) for security-critical packages

## Additional Resources

- [pnpm Audit Documentation](https://pnpm.io/cli/audit)
- [Renovate Documentation](https://docs.renovatebot.com/)
- [GitHub Security Advisories](https://github.com/advisories)
- [npm Security Best Practices](https://docs.npmjs.com/security-best-practices)
- [OWASP Dependency Check](https://owasp.org/www-project-dependency-check/)

## Related Documents

- [SECURITY.md](/SECURITY.md) - Main security policy
- [README.md](/README.md) - Repository overview
- [docs/reference/cli-reference.md](cli-reference.md) - CLI commands

---

**Last Updated**: November 1, 2025  
**Maintained by**: @Krosebrook
