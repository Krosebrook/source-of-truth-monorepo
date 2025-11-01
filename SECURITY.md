# Security Policy

## Overview

The FlashFusion Source-of-Truth monorepo takes security seriously. This document outlines our security practices, audit procedures, and vulnerability reporting process.

## Security Measures

### 1. Automated Secret Scanning

We use **Gitleaks** to scan for accidentally committed secrets:

- Runs on every push to main
- Runs on every pull request
- Weekly scheduled scans (Mondays at 6 AM UTC)
- Full repository history is scanned

### 2. Dependency Auditing

Automated dependency vulnerability scanning using `pnpm audit`:

- Runs on every push to main
- Runs on every pull request
- Weekly scheduled audits
- Fails CI/CD on critical or high severity vulnerabilities

**Run locally:**

```bash
# Full audit report
pnpm security:audit

# JSON output for parsing
pnpm security:audit:json

# Check for moderate+ vulnerabilities
pnpm security:audit:check
```

### 3. Automated Dependency Updates

We use **Renovate** for automated dependency updates:

- Scheduled updates: Weekly on Mondays before 6 AM
- Patch and pin updates: Auto-merged after passing CI
- Major updates: Require manual review and are assigned to @Krosebrook
- PR concurrency limit: 5 simultaneous PRs
- PR hourly limit: 2 PRs per hour

**Configuration:** See `renovate.json` for complete settings.

## Security Audit Schedule

### Weekly (Automated)
- **Mondays at 6 AM UTC**: Gitleaks secret scan
- **Mondays at 6 AM UTC**: Dependency vulnerability audit
- **Mondays before 6 AM**: Renovate dependency updates

### Per-Commit (Automated)
- All pushes to `main` trigger security scans
- All pull requests trigger security scans

### Manual Audits
Developers should run local security audits before committing:

```bash
# Run dependency audit
pnpm security:audit:check

# Format check
pnpm format:check

# Full lint
pnpm lint
```

## Vulnerability Severity Levels

We categorize vulnerabilities using standard CVSS severity ratings:

| Severity | Action | Timeline |
|----------|--------|----------|
| **Critical** | CI fails, immediate fix required | Within 24 hours |
| **High** | CI fails, fix required | Within 1 week |
| **Moderate** | Warning logged, fix in next sprint | Within 1 month |
| **Low** | Informational, fix when convenient | Best effort |

## Dependency Update Policy

### Automatic Updates (Auto-merge)
- Patch updates (e.g., 1.0.0 → 1.0.1)
- Pin updates (e.g., ^1.0.0 → 1.0.1)
- Digest updates (e.g., Docker image digest updates)

These are automatically merged after:
- CI passes (lint, build, test)
- Security scans pass
- No breaking changes detected

### Manual Review Required
- Minor updates (e.g., 1.0.0 → 1.1.0)
- Major updates (e.g., 1.0.0 → 2.0.0)
- Updates with known breaking changes

## Secrets Management

### GitHub Secrets
All sensitive credentials are stored in GitHub Secrets:
- Deploy keys (50 mirror repositories)
- API tokens
- Service credentials

### Environment Variables
- Never commit `.env` files (enforced by `.gitignore`)
- Use `.env.example` files to document required variables
- Load secrets at runtime from secure sources

### Deploy Keys
- Unique deploy key per mirror repository
- Write-only access (can push but not read)
- Rotated annually or on compromise

## Reporting Security Vulnerabilities

If you discover a security vulnerability, please report it by:

1. **Do NOT** open a public issue
2. Email security concerns to: [security@flashfusion.co]
3. Include:
   - Description of the vulnerability
   - Steps to reproduce
   - Potential impact
   - Suggested fix (if any)

We will respond within 48 hours and provide updates every 72 hours until resolved.

## Security Audit Results

Latest audit results are available in:
- **Workflow Artifacts**: Check the Security workflow run artifacts for detailed audit reports
- **PR Comments**: Renovate PRs include security impact analysis
- **CI Logs**: Review security workflow logs for the latest scan results

### Viewing Audit Results

1. Go to [Actions](https://github.com/Krosebrook/source-of-truth-monorepo/actions)
2. Select "Security" workflow
3. Download `dependency-audit-results` artifact from the latest run

## Compliance

### Current Status
- ✅ Automated secret scanning (Gitleaks)
- ✅ Automated dependency auditing (pnpm audit)
- ✅ Automated dependency updates (Renovate)
- ✅ CI/CD security gates
- ✅ Security documentation

### Standards Followed
- OWASP Top 10 awareness
- Principle of Least Privilege
- Defense in Depth
- Secure by Default

## Additional Security Resources

- [GitHub Security Advisories](https://github.com/advisories)
- [npm Security Best Practices](https://docs.npmjs.com/security-best-practices)
- [pnpm Security](https://pnpm.io/cli/audit)
- [Renovate Documentation](https://docs.renovatebot.com/)

## Version History

| Version | Date | Changes |
|---------|------|---------|
| 1.0.0 | 2025-11-01 | Initial security policy and audit procedures |

---

**Last Updated**: November 1, 2025  
**Policy Owner**: @Krosebrook
