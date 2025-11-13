# Contributing to FlashFusion Source-of-Truth Monorepo

Thank you for your interest in contributing to the FlashFusion Source-of-Truth (SoT) monorepo! This document provides guidelines and best practices for contributing.

## Table of Contents

- [Code of Conduct](#code-of-conduct)
- [Getting Started](#getting-started)
- [Development Workflow](#development-workflow)
- [Commit Guidelines](#commit-guidelines)
- [Pull Request Process](#pull-request-process)
- [Code Style](#code-style)
- [Testing Guidelines](#testing-guidelines)
- [Documentation](#documentation)
- [Security](#security)

## Code of Conduct

This project adheres to a code of conduct. By participating, you are expected to uphold this code. Please be respectful, inclusive, and professional in all interactions.

## Getting Started

### Prerequisites

- Node.js 20+
- pnpm 9+
- Git
- GitHub account

### Initial Setup

1. **Fork the repository** on GitHub

2. **Clone your fork**:
   ```bash
   git clone git@github.com:YOUR_USERNAME/source-of-truth-monorepo.git
   cd source-of-truth-monorepo
   ```

3. **Add upstream remote**:
   ```bash
   git remote add upstream git@github.com:Krosebrook/source-of-truth-monorepo.git
   ```

4. **Install pnpm** (if not already installed):
   ```bash
   npm install -g pnpm@9
   ```

5. **Install dependencies**:
   ```bash
   pnpm install
   ```

6. **Verify setup**:
   ```bash
   pnpm lint
   pnpm build
   pnpm test
   ```

## Development Workflow

### 1. Create a Feature Branch

Always create a new branch for your work:

```bash
# Update your main branch
git checkout main
git pull upstream main

# Create a feature branch
git checkout -b feature/your-feature-name
# or
git checkout -b fix/issue-description
```

**Branch naming conventions**:
- `feature/` - New features
- `fix/` - Bug fixes
- `docs/` - Documentation updates
- `refactor/` - Code refactoring
- `test/` - Test additions or updates
- `chore/` - Maintenance tasks

### 2. Make Your Changes

- Write clear, self-documenting code
- Follow existing code style and patterns
- Add tests for new functionality
- Update documentation as needed
- Keep commits focused and atomic

### 3. Test Your Changes

Run the full test suite:

```bash
# Lint code
pnpm lint

# Run type checking
pnpm type-check

# Build all projects
pnpm build

# Run tests
pnpm test

# Run security audit
pnpm security:audit:check
```

### 4. Commit Your Changes

Follow our [commit guidelines](#commit-guidelines) (see below).

### 5. Push to Your Fork

```bash
git push origin feature/your-feature-name
```

### 6. Create a Pull Request

- Go to the original repository on GitHub
- Click "New Pull Request"
- Select your fork and branch
- Fill out the PR template completely
- Link related issues

## Commit Guidelines

We follow the [Conventional Commits](https://www.conventionalcommits.org/) specification.

### Commit Message Format

```
<type>(<scope>): <subject>

<body>

<footer>
```

### Types

- `feat`: A new feature
- `fix`: A bug fix
- `docs`: Documentation changes
- `style`: Code style changes (formatting, missing semicolons, etc.)
- `refactor`: Code refactoring without changing functionality
- `perf`: Performance improvements
- `test`: Adding or updating tests
- `chore`: Maintenance tasks, dependency updates
- `ci`: CI/CD changes
- `build`: Build system changes

### Scope

The scope should indicate which package or area is affected:
- `agents` - AI agent implementations
- `shared` - Shared utilities
- `docs` - Documentation
- `ci` - CI/CD workflows
- `scripts` - Automation scripts
- Package names (e.g., `@flashfusion/web`)

### Examples

```bash
# Good commit messages
feat(agents): add Claude agent implementation
fix(shared/logging): correct JSON output format
docs: update getting started guide
chore(deps): update dependencies

# Bad commit messages
update stuff
fix bug
changes
WIP
```

### Commit Body and Footer

- **Body**: Explain what and why, not how
- **Footer**: Reference issues and breaking changes

```
feat(api): add user authentication endpoint

Implement JWT-based authentication with refresh tokens.
Includes rate limiting and security headers.

Closes #123
```

## Pull Request Process

### PR Checklist

Before submitting, ensure:

- [ ] Code follows project style guidelines
- [ ] All tests pass locally
- [ ] New tests added for new functionality
- [ ] Documentation updated
- [ ] Commit messages follow conventions
- [ ] PR description is clear and complete
- [ ] No merge conflicts
- [ ] Security audit passes
- [ ] Build succeeds

### PR Title Format

Use the same format as commit messages:

```
feat(scope): add new feature
fix(scope): resolve issue with X
docs: update contribution guidelines
```

### PR Description Template

```markdown
## Description
Brief description of changes

## Type of Change
- [ ] Bug fix
- [ ] New feature
- [ ] Breaking change
- [ ] Documentation update

## Related Issues
Closes #123

## Changes Made
- Change 1
- Change 2
- Change 3

## Testing
Describe testing performed

## Screenshots (if applicable)
Add screenshots for UI changes

## Checklist
- [ ] Tests pass
- [ ] Documentation updated
- [ ] Code follows style guidelines
```

### Review Process

1. **Automated Checks**: CI/CD runs automatically
2. **Code Review**: Maintainers review your code
3. **Feedback**: Address review comments
4. **Approval**: Maintainers approve PR
5. **Merge**: Maintainer merges (squash merge preferred)

### After Merge

- Delete your feature branch
- Update your local main branch:
  ```bash
  git checkout main
  git pull upstream main
  ```

## Code Style

### JavaScript/TypeScript

We use ESLint and Prettier for code formatting:

```bash
# Run linter
pnpm lint

# Fix auto-fixable issues
pnpm lint --fix

# Format code
pnpm format
```

### Style Guidelines

- Use **ES6+ features** (const/let, arrow functions, destructuring)
- Prefer **functional programming** patterns
- Use **async/await** over callbacks
- Add **JSDoc comments** for public APIs
- Keep functions **small and focused**
- Use **meaningful variable names**

### Example

```javascript
// Good
const getUserById = async (userId) => {
  if (!userId) {
    throw new Error('User ID is required');
  }
  
  const user = await database.users.findById(userId);
  return user;
};

// Bad
async function getUser(id) {
  return await db.users.find({ _id: id });
}
```

## Testing Guidelines

### Test Structure

- Place tests next to source files or in `__tests__` directory
- Use descriptive test names
- Follow AAA pattern: Arrange, Act, Assert

### Test Example

```javascript
import { getUserById } from './user-service.js';

describe('getUserById', () => {
  it('should return user when valid ID is provided', async () => {
    // Arrange
    const userId = '123';
    
    // Act
    const user = await getUserById(userId);
    
    // Assert
    expect(user).toBeDefined();
    expect(user.id).toBe(userId);
  });
  
  it('should throw error when ID is missing', async () => {
    // Arrange & Act & Assert
    await expect(getUserById(null)).rejects.toThrow('User ID is required');
  });
});
```

### Test Coverage

- Aim for **80%+ coverage** for new code
- Test edge cases and error conditions
- Test both success and failure paths

Run coverage report:

```bash
pnpm test --coverage
```

## Documentation

### Documentation Standards

- Update docs when changing functionality
- Use clear, concise language
- Include code examples
- Follow [Diátaxis framework](https://diataxis.fr/):
  - **Tutorials**: Learning-oriented
  - **How-to guides**: Task-oriented
  - **Reference**: Information-oriented
  - **Explanation**: Understanding-oriented

### Documentation Locations

- **Root README.md**: Project overview
- **docs/tutorials/**: Step-by-step guides
- **docs/how-to/**: Problem-solving guides
- **docs/reference/**: API and configuration docs
- **docs/explanation/**: Conceptual explanations
- **docs/adr/**: Architecture decisions

### Markdown Style

- Use **ATX-style headers** (`#`, `##`, `###`)
- Add **table of contents** for long documents
- Use **code blocks** with language hints
- Include **links** to related docs
- Add **examples** where helpful

## Security

### Security Best Practices

- **Never commit secrets** (API keys, passwords, tokens)
- Use `.env.example` for required environment variables
- Follow [SECURITY.md](./SECURITY.md) guidelines
- Report vulnerabilities privately

### Security Checklist

Before committing:

- [ ] No hardcoded credentials
- [ ] No API keys in code
- [ ] Dependencies up to date
- [ ] Security audit passes

```bash
# Run security audit
pnpm security:audit:check
```

### Reporting Security Issues

**DO NOT** open public issues for security vulnerabilities.

Instead:
1. Email: security@flashfusion.co
2. Include:
   - Description of vulnerability
   - Steps to reproduce
   - Potential impact
   - Suggested fix (if any)

## Workspace Commands

### Common Tasks

```bash
# Install dependencies
pnpm install

# Build all projects
pnpm build

# Build specific project
pnpm --filter <package-name> build

# Run dev server
pnpm --filter <package-name> dev

# Lint all code
pnpm lint

# Run all tests
pnpm test

# Type checking
pnpm type-check

# Format code
pnpm format

# Security audit
pnpm security:audit

# Clean build artifacts
pnpm clean
```

### Turbo Commands

```bash
# Build only changed projects
pnpm build --filter=...[HEAD^]

# Clear Turbo cache
rm -rf .turbo

# Run with cache disabled
pnpm build --force
```

## Getting Help

### Resources

- **Documentation**: [/docs/index.md](./docs/index.md)
- **Getting Started**: [GETTING_STARTED.md](./GETTING_STARTED.md)
- **Repository Map**: [REPO_MAP.md](./REPO_MAP.md)
- **Security Policy**: [SECURITY.md](./SECURITY.md)

### Communication

- **GitHub Issues**: Bug reports and feature requests
- **GitHub Discussions**: Questions and general discussion
- **Pull Requests**: Code contributions
- **Email**: krosebrook@flashfusion.co

## License

By contributing to this project, you agree that your contributions will be licensed under the MIT License.

## Recognition

Contributors will be recognized in:
- GitHub contributors page
- Release notes
- Project documentation

Thank you for contributing! 🎉
