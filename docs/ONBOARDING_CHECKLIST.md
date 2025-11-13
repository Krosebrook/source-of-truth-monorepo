# Onboarding Checklist

> Complete guide for new team members joining FlashFusion SoT

**Current Migration Status** (as of 2025-11-01):

- ✅ 3 local repositories imported
- ⏳ 50 GitHub repositories ready to import (see [Importing Repositories](/docs/tutorials/02-importing-repos.md))
- ✅ Full documentation infrastructure in place
- ✅ CI/CD workflows configured

**Print this page** and check off items as you complete them!

---

## Day 1: Setup & Basics (2-3 hours)

### Environment Setup

- [ ] **Install Node.js 20+**

  ```bash
  node --version  # Should be 20.x or higher
  ```

- [ ] **Install Git**

  ```bash
  git --version
  ```

- [ ] **Install pnpm globally**

  ```bash
  npm install -g pnpm@9
  pnpm --version  # Should show 9.x
  ```

- [ ] **Clone the repository**

  ```bash
  git clone git@github.com:Krosebrook/source-of-truth-monorepo.git
  cd source-of-truth-monorepo
  ```

- [ ] **Install dependencies** (takes 5-10 min)

  ```bash
  pnpm install
  ```

- [ ] **Build everything** (first build: 10-20 min)

  ```bash
  pnpm build
  ```

- [ ] **Verify setup**
  ```bash
  pnpm docs:validate  # Should show: ✓ All validation passed
  ```

### Understanding the Basics

- [ ] **Read [README.md](/README.md)** (5 min)
- [ ] **Complete [15-Min Quickstart](/docs/tutorials/01-quickstart.md)** (15 min)
- [ ] **Browse [Workspace Structure](/docs/reference/workspace-structure.md)** (10 min)
- [ ] **Understand [SoT Canonical Model](/docs/explanation/sot-canonical-model.md)** (15 min)

### Access & Communication

- [ ] **Join team Slack/Discord** (ask manager for invite)
- [ ] **Add yourself to CODEOWNERS** (if applicable)
  ```bash
  # Edit .github/CODEOWNERS
  /projects/your-project/ @your-github-username
  ```
- [ ] **Set up GitHub notifications** (watch the repo for PR/issues)

---

## Day 2: Deep Dive (3-4 hours)

### Architecture Understanding

- [ ] **Read all 6 Architecture Decision Records**
  - [ ] [ADR-0001: SoT Canonical Model](/docs/adr/0001-sot-canonical-model.md)
  - [ ] [ADR-0002: pnpm Package Manager](/docs/adr/0002-pnpm-package-manager.md)
  - [ ] [ADR-0003: Turborepo Build System](/docs/adr/0003-turborepo-build-system.md)
  - [ ] [ADR-0004: Changesets Versioning](/docs/adr/0004-changesets-versioning.md)
  - [ ] [ADR-0005: Flattened Repos](/docs/adr/0005-flattened-repos.md)
  - [ ] [ADR-0006: Diátaxis Documentation](/docs/adr/0006-diataxis-documentation.md)

### Hands-On Practice

- [ ] **Run a specific project**

  ```bash
  pnpm --filter harvestflow build
  ```

- [ ] **Explore the CLI**

  ```bash
  pnpm -r list  # List all workspace projects
  ```

- [ ] **Review [CLI Reference](/docs/reference/cli-reference.md)** (15 min)

- [ ] **Try Turbo caching**
  ```bash
  pnpm build           # First time (slow)
  pnpm build           # Second time (instant!)
  ```

### Contributing Workflow

- [ ] **Read [CONTRIBUTING.md](/CONTRIBUTING.md)**
- [ ] **Understand git workflow**

  ```bash
  git checkout -b feature/my-first-change
  # ... make changes ...
  pnpm changeset  # Add changeset
  git add . && git commit
  git push -u origin feature/my-first-change
  gh pr create
  ```

- [ ] **Make a test PR** (optional: fix a typo in docs)

---

## Week 1: Becoming Productive (1-2 hours/day)

### Project Familiarity

**Note**: Currently only 3 local repositories are imported. To import the remaining 50 GitHub repositories, see the [Importing Repositories Tutorial](/docs/tutorials/02-importing-repos.md).

- [ ] **Identify your primary project(s)**

  ```bash
  ls projects/local/           # Currently imported (3 repos)
  ls projects/krosebrook/      # Available after import
  ```

- [ ] **Build and run your project**

  ```bash
  pnpm --filter <your-project> build
  pnpm --filter <your-project> dev
  ```

- [ ] **Review your project's dependencies**
  ```bash
  pnpm --filter <your-project> list
  ```

### Documentation Authoring

- [ ] **Read [Style Guide](/docs/STYLE_GUIDE.md)**
- [ ] **Understand Diátaxis framework** (tutorials, how-to, reference, explanation)
- [ ] **Write your first doc** (add to team wiki or internal docs)

### CI/CD Understanding

- [ ] **Review [CI workflow](/.github/workflows/ci.yml)**
- [ ] **Review [Security workflow](/.github/workflows/security.yml)**
- [ ] **Review [Docs workflow](/.github/workflows/docs.yml)**
- [ ] **Trigger a CI build** (push a branch and watch GitHub Actions)

---

## Month 1: Mastery (Ongoing)

### Advanced Topics

- [ ] **Learn Changesets**
  - [ ] Read [ADR-0004: Changesets](/docs/adr/0004-changesets-versioning.md)
  - [ ] Create a changeset: `pnpm changeset`
  - [ ] Version packages: `pnpm changeset version`

- [ ] **Explore agent integration** (if applicable)
  - [ ] [Claude Agent Guide](/docs/guides/agent-integration/claude-agent.md)
  - [ ] [Agent Output Schema](/shared/contracts/agent-output.schema.json)

- [ ] **Review security practices**
  - [ ] [Security Policy](/SECURITY.md)
  - [ ] [Secret Management](/docs/guides/security/secret-management.md)

### Operational Knowledge

- [ ] **Read runbooks** (if on-call rotation)
  - [ ] [Daily Operations](/docs/runbooks/daily-operations.md)
  - [ ] [Incident Response](/docs/runbooks/incident-response.md)
  - [ ] [Disaster Recovery](/docs/runbooks/disaster-recovery.md)

- [ ] **Shadow an on-call engineer** (if applicable)

### Mentorship

- [ ] **Find a mentor** (senior team member)
- [ ] **Schedule regular 1:1s** (weekly or bi-weekly)
- [ ] **Pair program** on a feature or bug fix

---

## Knowledge Check (Self-Assessment)

After completing the onboarding, you should be able to:

- [ ] Clone, install, and build the monorepo
- [ ] Explain the SoT Canonical Model
- [ ] Use pnpm to run commands in specific projects
- [ ] Understand how Turbo caching works
- [ ] Create a PR with a changeset
- [ ] Navigate the documentation (Diátaxis categories)
- [ ] Know where to find help (docs, Slack, GitHub issues)

---

## Quick Reference

### Most Used Commands

```bash
# Install dependencies
pnpm install

# Build everything
pnpm build

# Build specific project
pnpm --filter <project-name> build

# Run dev server
pnpm --filter <project-name> dev

# Add changeset
pnpm changeset

# Check documentation progress
pnpm docs:status

# Lint
pnpm lint

# Test
pnpm test
```

### Key Documentation

- [Getting Started](/GETTING_STARTED.md)
- [Documentation Index](/docs/index.md)
- [CLI Reference](/docs/reference/cli-reference.md)
- [ADRs](/docs/adr/)
- [Tutorials](/docs/tutorials/)

### Get Help

- **Documentation**: [/docs/index.md](/docs/index.md)
- **Slack/Discord**: #flashfusion-sot channel
- **GitHub Issues**: [Report bugs/ask questions](https://github.com/Krosebrook/source-of-truth-monorepo/issues)
- **Email**: krosebrook@flashfusion.co

---

## Feedback

**New to the team?** Help us improve onboarding!

After completing this checklist, please:

1. [Open a discussion](https://github.com/Krosebrook/source-of-truth-monorepo/discussions) with feedback
2. Suggest improvements to this checklist
3. Share what helped you most

**Your feedback makes onboarding better for the next person!**

---

**Congratulations on completing onboarding!** 🎉

You're now ready to contribute to the FlashFusion SoT monorepo.

**Next**: Pick a "good first issue" and make your first contribution!
