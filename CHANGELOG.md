# Changelog

All notable changes to the FlashFusion Source-of-Truth monorepo will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

- Comprehensive monorepo organization and best practices implementation
- CONTRIBUTING.md with detailed contribution guidelines
- CODE_OF_CONDUCT.md for community standards
- Enhanced .gitignore with comprehensive patterns
- Improved documentation structure

### Changed

- Updated ESLint configuration in packages to use modern flat config
- Fixed build scripts in packages with missing directories

### Fixed

- ESLint `--ext` flag usage in flashfusion-consolidated/packages/shared
- Build failures due to missing directories

### Security

- Enhanced .gitignore to prevent accidental secret commits

## [1.0.0] - 2025-11-01

### Added

- Initial monorepo setup
- pnpm workspace configuration
- Turborepo build system
- CI/CD workflows (ci.yml, security.yml, docs.yml)
- Security workflows (Gitleaks, pnpm audit)
- Renovate configuration for automated dependency updates
- Subtree push infrastructure for mirror sync
- Comprehensive documentation (Diátaxis framework)
- Architecture Decision Records (ADRs)
- 3 local repositories imported
- Agent implementations structure (Claude, Codex, Gemini, GitHub)
- Shared utilities (contracts, logging, otel, workflows)
- Getting Started guide
- Repository Map
- Security Policy

### Infrastructure

- ✅ Package management (pnpm workspaces)
- ✅ Build system (Turborepo)
- ✅ Documentation structure
- ✅ CI/CD workflows
- ✅ Deploy keys infrastructure
- ✅ Security scanning (Gitleaks)
- ✅ Dependency auditing (pnpm audit)
- ✅ Automated updates (Renovate)

### Documentation

- README.md - Project overview
- REPO_MAP.md - Complete repository index
- SECURITY.md - Security policy and procedures
- GETTING_STARTED.md - Onboarding guide
- docs/ - Comprehensive documentation structure
  - tutorials/ - Step-by-step guides
  - how-to/ - Task-oriented guides
  - reference/ - Technical reference
  - explanation/ - Conceptual explanations
  - adr/ - Architecture Decision Records

### Configuration

- pnpm-workspace.yaml - Workspace configuration
- turbo.json - Build system configuration
- renovate.json - Dependency update automation
- eslint.config.js - Linting rules
- tsconfig.base.json - TypeScript base configuration
- .prettierrc.json - Code formatting rules

### Pending

- [ ] Import 50 GitHub repositories
- [ ] Configure deploy keys for mirror sync
- [ ] Full monorepo build validation
- [ ] Package publishing

---

## Version Guidelines

### Version Number Format: MAJOR.MINOR.PATCH

- **MAJOR**: Incompatible API changes
- **MINOR**: Backwards-compatible functionality additions
- **PATCH**: Backwards-compatible bug fixes

### Change Categories

- **Added**: New features
- **Changed**: Changes to existing functionality
- **Deprecated**: Soon-to-be removed features
- **Removed**: Removed features
- **Fixed**: Bug fixes
- **Security**: Security vulnerability fixes

### Example Entry

```markdown
## [1.2.0] - 2025-11-15

### Added

- New authentication system (#123)
- Support for OAuth providers (#124)

### Changed

- Improved error handling in API (#125)
- Updated dependencies

### Fixed

- Fixed memory leak in websocket handler (#126)

### Security

- Patched XSS vulnerability in user input (#127)
```

---

[Unreleased]: https://github.com/Krosebrook/source-of-truth-monorepo/compare/v1.0.0...HEAD
[1.0.0]: https://github.com/Krosebrook/source-of-truth-monorepo/releases/tag/v1.0.0
