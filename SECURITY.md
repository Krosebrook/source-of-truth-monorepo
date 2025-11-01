# Security Policy

## Overview

This document outlines the security practices, audit procedures, and update policies for the FlashFusion Source-of-Truth Monorepo.

## Automated Security Measures

### 1. Secret Scanning (Gitleaks)

**Purpose:** Prevent accidental commit of sensitive credentials and API keys.

**Frequency:**
- On every push to `main` branch
- On every pull request
- Weekly scheduled scan (Mondays at 6 AM UTC)

**How it works:**
- Uses [Gitleaks](https://github.com/gitleaks/gitleaks) to scan entire repository history
- Automatically detects patterns matching secrets, tokens, and credentials
- Fails the workflow if secrets are detected

**Action on Detection:**
- Immediately revoke any exposed credentials
- Remove from git history if needed
- Update `.gitleaksignore` only for verified false positives

### 2. Dependency Audits

**Purpose:** Identify and track known vulnerabilities in npm dependencies.

**Frequency:**
- On every push to `main` branch
- On every pull request
- Weekly scheduled scan (Mondays at 6 AM UTC)

**How it works:**
- Runs `pnpm audit --audit-level=moderate` to check for vulnerabilities
- Generates audit reports stored as workflow artifacts
- Comments summary on pull requests

**Audit Levels:**
- `moderate` and above trigger notifications
- Reports saved for 30 days in GitHub Actions artifacts

**Action on Detection:**
1. Review audit report in workflow artifacts
2. Assess severity and impact
3. Update dependencies where possible
4. Document exceptions if updates break functionality

### 3. Automated Dependency Updates (Renovate)

**Purpose:** Keep dependencies up-to-date automatically with minimal manual intervention.

**Configuration:** See `renovate.json`

**Schedule:** Mondays before 6 AM UTC

**Rules:**
- **Patch updates:** Auto-merged after CI passes
- **Minor updates:** Auto-merged after CI passes (with `automerge` label)
- **Major updates:** Manual review required, assigned to @Krosebrook
- **PR Limits:** Max 5 concurrent PRs, 2 per hour

**Labels Applied:**
- `dependencies` - All dependency updates
- `automerge` - Patch/minor updates eligible for auto-merge
- `major-update` - Major version updates requiring review

## Manual Security Checks

### Running Security Audits Locally

```bash
# Install dependencies
pnpm install

# Run dependency audit
pnpm audit

# Run with different severity threshold
pnpm audit --audit-level=high

# Scan for secrets locally (requires gitleaks CLI)
gitleaks detect --source . --verbose
```

### Fixing Vulnerabilities

1. **Identify the vulnerability:**
   ```bash
   pnpm audit
   ```

2. **Update the vulnerable package:**
   ```bash
   # Update specific package
   pnpm update <package-name> --latest
   
   # Or update all dependencies
   pnpm update -r --latest
   ```

3. **Verify the fix:**
   ```bash
   pnpm audit
   pnpm build
   pnpm test
   ```

4. **Create a changeset:**
   ```bash
   pnpm changeset
   ```

## Security Workflow Integration

Security checks run as part of the CI/CD pipeline:

```
┌─────────────────┐
│  Code Changes   │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│   CI Workflow   │ ◄── Lint, Build, Test
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│Security Workflow│ ◄── Gitleaks + Audit (runs on push/PR)
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  Audit Results  │ ◄── Artifacts saved for 30 days
└─────────────────┘
```

## Reporting Security Vulnerabilities

If you discover a security vulnerability in this repository:

1. **DO NOT** open a public GitHub issue
2. Contact via GitHub: Open a [GitHub Security Advisory](https://github.com/Krosebrook/source-of-truth-monorepo/security/advisories/new)
3. Include:
   - Description of the vulnerability
   - Steps to reproduce
   - Potential impact
   - Suggested fix (if any)

We aim to respond within 48 hours and provide a fix within 7 days for critical issues.

## Security Best Practices

### For Contributors

1. **Never commit secrets:**
   - Use environment variables for credentials
   - Keep `.env` files in `.gitignore`
   - Use GitHub Secrets for CI/CD credentials

2. **Review dependencies:**
   - Check npm package reputation before adding
   - Prefer packages with active maintenance
   - Review Renovate PRs promptly

3. **Keep dependencies updated:**
   - Review and merge Renovate PRs weekly
   - Don't ignore security updates
   - Test thoroughly after major updates

4. **Use security tools:**
   - Enable GitHub Dependabot alerts
   - Review security workflow results
   - Act on vulnerability notifications

### For Maintainers

1. **Monitor security alerts:**
   - Check GitHub Security tab regularly
   - Review weekly audit reports
   - Respond to Renovate PRs

2. **Configure secrets properly:**
   - Use GitHub Secrets for sensitive data
   - Rotate credentials periodically
   - Use deploy keys with minimal permissions

3. **Review PRs for security:**
   - Check for hardcoded credentials
   - Verify dependency changes
   - Ensure tests cover security scenarios

## Audit Results Archive

Security audit results are automatically stored as GitHub Actions artifacts:

- **Location:** Actions → Security workflow → Artifacts
- **Retention:** 30 days
- **Format:** Markdown report + raw audit output

### Accessing Audit Results

1. Go to repository Actions tab
2. Click on "Security" workflow
3. Select a workflow run
4. Download "security-audit-results" artifact
5. Review `audit-report.md` for summary

## Update Policies

### Dependency Update Policy

- **Critical vulnerabilities:** Immediate update required
- **High severity:** Update within 7 days
- **Moderate severity:** Update within 30 days
- **Low severity:** Update with next regular maintenance

### Exceptions Process

If a vulnerability cannot be fixed immediately:

1. Document the reason in a GitHub issue
2. Implement workarounds/mitigations
3. Set a timeline for resolution
4. Track in security backlog

## Compliance and Standards

This repository follows:

- OWASP Top 10 security best practices
- npm security guidelines
- GitHub security best practices
- Regular dependency maintenance (weekly via Renovate)

## Security Contacts

- **Primary:** @Krosebrook
- **Security Reporting:** [GitHub Security Advisories](https://github.com/Krosebrook/source-of-truth-monorepo/security/advisories/new)
- **GitHub Security Advisories:** Enabled

## Changelog

- **2025-11-01:** Initial security policy created
  - Gitleaks integration configured
  - Dependency audit automation implemented
  - Renovate bot configured for automatic updates
  - Audit result archival implemented
