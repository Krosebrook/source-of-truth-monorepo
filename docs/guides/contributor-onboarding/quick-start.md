# Contributor Quick Start Guide

> Get up and running as a FlashFusion SoT contributor in minutes

**Estimated time**: 15-30 minutes (depending on download speeds)

---

## Prerequisites

Before starting, ensure you have:
- [ ] GitHub account with access to the repository
- [ ] Node.js 20+ installed
- [ ] Git installed and configured
- [ ] SSH keys set up for GitHub

---

## Quick Setup (5 Steps)

### Step 1: Clone the Repository

```bash
git clone git@github.com:Krosebrook/source-of-truth-monorepo.git
cd source-of-truth-monorepo
```

### Step 2: Run Automated Setup

```bash
./scripts/onboard-contributor.sh
```

This script will:
- ✓ Check prerequisites (Node.js, Git, pnpm)
- ✓ Install pnpm if needed
- ✓ Install dependencies
- ✓ Run initial build
- ✓ Verify setup

**Time**: 15-25 minutes (mostly waiting for installs)

### Step 3: Verify Your Setup

```bash
./scripts/verify-setup.sh
```

Should show all green checkmarks ✓

### Step 4: Explore the Codebase

```bash
# List all projects
pnpm -r list

# View workspace structure
ls -la projects/

# Read getting started guide
cat GETTING_STARTED.md
```

### Step 5: Make Your First Build

```bash
# Build everything (uses cache after first time)
pnpm build

# Or build a specific project
pnpm --filter flashfusion-consolidated build
```

---

## Your First Contribution (10 Steps)

### 1. Pick an Issue

Find a "good first issue":
```bash
gh issue list --label "good first issue"
```

Or browse: https://github.com/Krosebrook/source-of-truth-monorepo/issues

### 2. Create a Branch

```bash
git checkout -b feature/my-feature
```

**Branch naming**:
- `feature/` - New features
- `fix/` - Bug fixes
- `docs/` - Documentation
- `refactor/` - Code refactoring

### 3. Make Your Changes

Edit files in the appropriate project:
```bash
# Example: editing flashfusion project
vim projects/local/flashfusion-consolidated/src/feature.ts
```

### 4. Build and Test Incrementally

```bash
# Build your project
pnpm --filter flashfusion-consolidated build

# Run tests
pnpm --filter flashfusion-consolidated test

# Run linting
pnpm lint
```

### 5. Create a Changeset (if needed)

For user-facing changes:
```bash
pnpm changeset
```

Follow prompts:
1. Select affected packages
2. Choose version bump (major/minor/patch)
3. Write description

**Skip changesets for**:
- Documentation only
- Internal refactoring
- Test changes

### 6. Commit Your Changes

```bash
git add .
git commit -m "feat(project): description of change"
```

**Commit message format**:
```
type(scope): description

[optional body]

[optional footer]
```

**Types**: `feat`, `fix`, `docs`, `refactor`, `test`, `chore`

### 7. Push Your Branch

```bash
git push -u origin feature/my-feature
```

### 8. Create a Pull Request

```bash
gh pr create --fill
```

Or visit: https://github.com/Krosebrook/source-of-truth-monorepo/pulls

**PR checklist**:
- [ ] Clear title and description
- [ ] Link to related issue (`Fixes #123`)
- [ ] Changeset created (if needed)
- [ ] Tests pass
- [ ] Linting passes

### 9. Respond to Review Feedback

Make requested changes:
```bash
# Make changes
vim file.ts

# Commit
git add .
git commit -m "fix: address review feedback"

# Push
git push
```

### 10. Celebrate! 🎉

After merge, your changes will:
- Be included in the next release
- Sync to mirror repositories automatically
- Show up in the changelog

---

## Common Workflows

### Working on Multiple Projects

If your change affects multiple projects:

```bash
# Build all affected projects
pnpm --filter "...{./projects/your-project}" build

# Test all affected projects
pnpm --filter "...{./projects/your-project}" test
```

### Keeping Branch Updated

```bash
# Update main
git checkout main
git pull origin main

# Rebase your branch
git checkout feature/my-feature
git rebase main

# Resolve conflicts (if any)
# Then continue
git rebase --continue

# Force push (after rebase)
git push --force-with-lease
```

### Running Specific Commands

```bash
# Build specific project
pnpm --filter project-name build

# Run dev server
pnpm --filter project-name dev

# Run custom script
pnpm --filter project-name custom-script

# Run in all projects
pnpm -r build
```

### Cleaning Build Artifacts

```bash
# Clean Turbo cache
rm -rf .turbo

# Clean node_modules
rm -rf node_modules
pnpm install

# Clean all
pnpm clean
```

---

## Essential Commands

### Setup & Verification
```bash
./scripts/onboard-contributor.sh    # Initial setup
./scripts/verify-setup.sh           # Verify environment
pnpm install                        # Install dependencies
```

### Building
```bash
pnpm build                          # Build all
pnpm --filter <project> build       # Build one project
pnpm build --filter=...[HEAD^]      # Build changed projects
```

### Testing
```bash
pnpm test                           # Test all
pnpm --filter <project> test        # Test one project
pnpm lint                           # Lint all
```

### Development
```bash
pnpm --filter <project> dev         # Start dev server
pnpm format                         # Format code
pnpm type-check                     # Type checking
```

### Changesets
```bash
pnpm changeset                      # Create changeset
pnpm changeset version              # Bump versions (maintainers)
```

### Git
```bash
git checkout -b feature/name        # Create branch
git add .                           # Stage changes
git commit -m "type: message"       # Commit
git push -u origin feature/name     # Push branch
gh pr create                        # Create PR
```

---

## Getting Help

### Documentation

- **Getting Started**: `GETTING_STARTED.md`
- **Onboarding Checklist**: `docs/ONBOARDING_CHECKLIST.md`
- **Monorepo Best Practices**: `docs/guides/monorepo-best-practices/`
- **Full Docs**: `docs/index.md`

### Commands
```bash
# Show documentation status
pnpm docs:status

# Show recent session log
pnpm docs:resume
```

### Resources

- **GitHub Issues**: https://github.com/Krosebrook/source-of-truth-monorepo/issues
- **Discussions**: https://github.com/Krosebrook/source-of-truth-monorepo/discussions
- **Slack/Discord**: Ask your manager for invite

### Troubleshooting

**Problem**: `pnpm: command not found`
```bash
npm install -g pnpm@9
```

**Problem**: Build fails
```bash
rm -rf .turbo node_modules
pnpm install
pnpm build
```

**Problem**: Tests fail
```bash
# Build dependencies first
pnpm --filter your-project... build
pnpm --filter your-project test
```

**Problem**: Out of sync with main
```bash
git checkout main
git pull origin main
git checkout your-branch
git rebase main
```

---

## Tips for Success

### 💡 Pro Tips

1. **Build incrementally**: Don't wait to build everything at the end
2. **Use Turbo filters**: Build only what you need
3. **Keep branches small**: Easier to review and merge
4. **Write good commit messages**: Helps reviewers understand changes
5. **Ask questions early**: Don't struggle alone

### ⚠️ Common Mistakes

1. ❌ Forgetting to create changeset
2. ❌ Building without dependencies
3. ❌ Working on stale branch
4. ❌ Committing directly to main
5. ❌ Skipping tests

### ✅ Good Practices

1. ✅ Run `./scripts/verify-setup.sh` regularly
2. ✅ Keep branch updated with main
3. ✅ Test changes locally before pushing
4. ✅ Follow code style of existing code
5. ✅ Read related documentation

---

## Next Steps

After completing this guide:

1. **Read the full documentation**:
   - [Monorepo Best Practices](../monorepo-best-practices/)
   - [Mirror Repository Guide](../monorepo-best-practices/mirror-repository-best-practices.md)
   
2. **Complete onboarding checklist**:
   - `docs/ONBOARDING_CHECKLIST.md`

3. **Join the community**:
   - Slack/Discord (ask for invite)
   - GitHub Discussions

4. **Start contributing**:
   - Pick a "good first issue"
   - Make your first PR!

---

## Checklist

Track your progress with the interactive checklist:

```bash
./scripts/onboarding-checklist.sh
```

This script will:
- Show your onboarding progress
- Track completed items
- Provide next steps

Or track manually:

- [ ] Repository cloned
- [ ] `./scripts/onboard-contributor.sh` completed
- [ ] `./scripts/verify-setup.sh` passes
- [ ] First build successful
- [ ] Documentation read
- [ ] First contribution made
- [ ] Team communication joined

---

**Welcome to the team! Happy coding! 🚀**

**Last updated**: 2025-11-01
