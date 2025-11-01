# Guides

> Comprehensive guides for contributors and maintainers

This directory contains in-depth guides for working with the FlashFusion Source-of-Truth monorepo. Guides are organized by topic and provide detailed, actionable information.

---

## 📖 Available Guides

### Contributor Onboarding

New to the repository? Start here!

- **[Quick Start Guide](./contributor-onboarding/quick-start.md)** - Get set up in 15 minutes
  - Prerequisites and setup
  - Your first contribution
  - Essential commands
  - Common workflows

### Monorepo Best Practices

Essential practices for monorepo development:

- **[Monorepo Best Practices](./monorepo-best-practices/)** - Complete guide to monorepo development
  - Core principles (SoT model, workspace-first thinking)
  - Development workflow
  - Dependencies management
  - Building and testing
  - Commits and changesets
  - Common pitfalls and solutions

- **[Mirror Repository Best Practices](./monorepo-best-practices/mirror-repository-best-practices.md)** - Working with mirror repos
  - Understanding mirrors
  - SoT canonical model
  - Mirror synchronization
  - Common scenarios
  - Troubleshooting

---

## 🎯 Guide Categories

### For New Contributors

1. Start with [Quick Start Guide](./contributor-onboarding/quick-start.md)
2. Read [Monorepo Best Practices](./monorepo-best-practices/)
3. Review [Getting Started](/GETTING_STARTED.md) (root)
4. Complete [Onboarding Checklist](/docs/ONBOARDING_CHECKLIST.md)

### For Active Contributors

- [Monorepo Best Practices](./monorepo-best-practices/) - Reference daily
- [Mirror Repository Guide](./monorepo-best-practices/mirror-repository-best-practices.md) - When working with mirrors
- [How-To Guides](/docs/how-to/) - For specific tasks

### For Maintainers

- [Mirror Repository Best Practices](./monorepo-best-practices/mirror-repository-best-practices.md) - Managing mirrors
- [Deploy Keys Guide](/docs/how-to/configure-deploy-keys.md) - Setting up sync
- [ADRs](/docs/adr/) - Architecture decisions

---

## 🚀 Quick Links

### Essential Scripts

- `./scripts/onboard-contributor.sh` - Automated onboarding
- `./scripts/verify-setup.sh` - Verify your environment
- `./scripts/import-github-repos.sh` - Import repositories
- `./scripts/generate-deploy-keys.sh` - Generate deploy keys

### Key Documentation

- [README](/README.md) - Repository overview
- [GETTING_STARTED](/GETTING_STARTED.md) - Comprehensive getting started
- [Documentation Index](/docs/index.md) - All documentation
- [How-To Guides](/docs/how-to/) - Task-specific guides

---

## 📚 Documentation Structure

FlashFusion SoT uses the **Diátaxis** framework to organize documentation:

```
docs/
├── tutorials/          # Learning-oriented (step-by-step)
├── how-to/            # Task-oriented (problem-solving)
├── guides/            # Understanding-oriented (in-depth) ← You are here
├── reference/         # Information-oriented (lookup)
└── explanation/       # Understanding-oriented (concepts)
```

**Guides** are:
- **In-depth**: Comprehensive coverage of topics
- **Understanding-focused**: Help you understand "why" and "how"
- **Best practices**: Recommended approaches
- **Real-world**: Based on actual usage patterns

---

## 🤝 Contributing to Guides

Found an issue or want to add a guide?

1. **File an issue**: Describe what's missing or incorrect
2. **Submit a PR**: Add or update guides
3. **Follow the style**: Match existing guide format

**Guide template**:
```markdown
# Guide Title

> Brief description

## Table of Contents
- [Section 1](#section-1)
- [Section 2](#section-2)

---

## Section 1
Content...

## Section 2
Content...

---

**Last updated**: YYYY-MM-DD
```

---

## 📞 Getting Help

- **Documentation**: [/docs/index.md](/docs/index.md)
- **Issues**: https://github.com/Krosebrook/source-of-truth-monorepo/issues
- **Discussions**: https://github.com/Krosebrook/source-of-truth-monorepo/discussions
- **Slack/Discord**: #flashfusion-sot channel

---

**Last updated**: 2025-11-01  
**Maintained by**: FlashFusion SoT Team
