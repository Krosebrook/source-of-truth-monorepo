# Renovate Configuration Guide

This document explains the Renovate Bot configuration for automated dependency updates.

## Overview

Renovate automatically creates pull requests to update dependencies, keeping the codebase secure and up-to-date with minimal manual effort.

## Configuration File

See: [`renovate.json`](../../renovate.json)

## Schedule

- **When:** Mondays before 6 AM UTC
- **Why:** Allows time for review during the work week
- **Frequency:** Weekly

## Update Strategy

### Patch Updates (e.g., 1.0.0 → 1.0.1)

- **Auto-merge:** ✅ Yes
- **Labels:** `dependencies`, `automerge`
- **Review:** Optional (auto-merged after CI passes)

**Rationale:** Patch updates are typically bug fixes and safe to auto-merge.

### Minor Updates (e.g., 1.0.0 → 1.1.0)

- **Auto-merge:** ✅ Yes
- **Labels:** `dependencies`, `automerge`  
- **Review:** Optional (auto-merged after CI passes)

**Rationale:** Minor updates add features but maintain backward compatibility.

### Major Updates (e.g., 1.0.0 → 2.0.0)

- **Auto-merge:** ❌ No
- **Labels:** `dependencies`, `major-update`
- **Assignee:** @Krosebrook
- **Review:** ✅ Required

**Rationale:** Major updates may include breaking changes requiring manual review and testing.

## Rate Limits

- **Concurrent PRs:** Maximum 5 at a time
- **Hourly Limit:** Maximum 2 PRs per hour

**Why:** Prevents overwhelming the team with too many updates at once.

## Package Rules

### All npm Packages

```json
{
  "matchManagers": ["npm"],
  "automerge": false,
  "labels": ["dependencies"]
}
```

### Patch/Pin/Digest Updates

```json
{
  "matchUpdateTypes": ["patch", "pin", "digest"],
  "automerge": true,
  "automergeType": "pr",
  "labels": ["dependencies", "automerge"]
}
```

### Major Updates

```json
{
  "matchUpdateTypes": ["major"],
  "labels": ["dependencies", "major-update"],
  "assignees": ["Krosebrook"]
}
```

## How Renovate Works

```
┌──────────────────────┐
│  Renovate Checks     │
│  Dependencies Weekly │
└──────────┬───────────┘
           │
           ▼
┌──────────────────────┐
│  New Version Found?  │
└──────────┬───────────┘
           │
           ▼
┌──────────────────────┐
│  Create PR with      │
│  Updated package.json│
└──────────┬───────────┘
           │
           ▼
┌──────────────────────┐
│   CI Runs Tests      │
└──────────┬───────────┘
           │
           ▼
    ┌─────┴─────┐
    │           │
    ▼           ▼
┌────────┐  ┌────────┐
│ Patch/ │  │ Major  │
│ Minor  │  │ Update │
└───┬────┘  └───┬────┘
    │           │
    ▼           ▼
┌────────┐  ┌────────┐
│Auto-   │  │Manual  │
│merge   │  │Review  │
└────────┘  └────────┘
```

## Reviewing Renovate PRs

### For Auto-merge PRs (Patch/Minor)

1. **Check CI:** Ensure all tests pass
2. **Quick Review:** Glance at changelog if curious
3. **Let it merge:** Auto-merges if CI is green

### For Major Updates

1. **Read Changelog:** Review breaking changes
2. **Check Impact:** Identify affected code
3. **Test Locally:**
   ```bash
   git fetch origin
   git checkout renovate/major-update-branch
   pnpm install
   pnpm build
   pnpm test
   ```
4. **Update Code:** Fix any breaking changes
5. **Approve & Merge:** Once tests pass

## Common Scenarios

### Scenario 1: Security Vulnerability Detected

**What happens:**
1. Renovate detects vulnerable package
2. Creates PR with fix
3. Labels with `dependencies`
4. Triggers security audit in CI

**Your action:**
- Review and merge ASAP (even if major update)
- Security takes priority over breaking changes

### Scenario 2: Multiple Updates Available

**What happens:**
- Renovate respects concurrent PR limit (5 max)
- Creates PRs by priority (security first)
- Queues remaining updates for next run

**Your action:**
- Review/merge PRs to free up slots
- Critical updates created first

### Scenario 3: Update Breaks Tests

**What happens:**
- CI fails on Renovate PR
- Auto-merge disabled
- Assigned to maintainer

**Your action:**
1. Check CI logs for failure
2. Determine if code needs updating
3. Either:
   - Update code to work with new version
   - Close PR and document why (add to package.json)

## Customizing Renovate

To modify Renovate behavior, edit `renovate.json`:

### Change Schedule

```json
{
  "schedule": ["after 9am on monday"]
}
```

### Add Package-Specific Rules

```json
{
  "packageRules": [
    {
      "matchPackageNames": ["react", "react-dom"],
      "groupName": "React",
      "automerge": false
    }
  ]
}
```

### Disable for Specific Packages

```json
{
  "packageRules": [
    {
      "matchPackageNames": ["legacy-package"],
      "enabled": false
    }
  ]
}
```

## Monitoring Renovate

### Check Renovate Status

1. Go to repository Settings → Integrations
2. Find Renovate App
3. View dashboard and logs

### View Renovate PRs

Filter PRs by label:
- Label: `dependencies` - All Renovate PRs
- Label: `automerge` - Auto-mergeable updates
- Label: `major-update` - Requires review

### Renovate Dashboard

Renovate creates a dependency dashboard issue:
- Lists all pending updates
- Shows why updates might be blocked
- Provides configuration errors

## Troubleshooting

### Renovate Not Creating PRs

**Check:**
1. Is it Monday before 6 AM UTC?
2. Are there < 5 concurrent Renovate PRs?
3. Check Renovate logs in app dashboard
4. Validate `renovate.json` syntax

### Auto-merge Not Working

**Check:**
1. Are CI checks passing?
2. Is PR labeled with `automerge`?
3. Branch protection rules may prevent auto-merge
4. Check repository settings → Branches

### Too Many PRs

**Solution:**
- Lower `prConcurrentLimit` in `renovate.json`
- Lower `prHourlyLimit`
- Group related packages

## Best Practices

1. **Review Weekly:** Check Renovate PRs every Monday
2. **Don't Ignore:** Outdated deps = security risks
3. **Keep Tests Updated:** Good tests catch breaking changes
4. **Document Exceptions:** If you must skip an update, document why
5. **Use Grouping:** Group related packages (e.g., all React packages)

## Resources

- [Renovate Documentation](https://docs.renovatebot.com/)
- [Configuration Options](https://docs.renovatebot.com/configuration-options/)
- [renovate.json Schema](https://docs.renovatebot.com/renovate-schema/)
- [SECURITY.md](../../SECURITY.md) - Security policy

## Getting Help

- **Renovate Issues:** Check [Renovate GitHub](https://github.com/renovatebot/renovate)
- **Configuration Help:** See [docs.renovatebot.com](https://docs.renovatebot.com)
- **Repository Help:** Contact @Krosebrook
