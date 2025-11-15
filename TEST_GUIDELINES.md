# Test Guidelines

## Overview

All projects in this monorepo must maintain a minimum test coverage of 60% for production code. This document outlines testing standards and best practices.

## Coverage Requirements

- **Lines**: 60% minimum
- **Functions**: 60% minimum
- **Branches**: 60% minimum
- **Statements**: 60% minimum

### Exceptions

Projects in early development (< 1 month old) may request temporary exemptions via issue tracker.

## Testing Tools

### Node.js Native Test Runner

For simple projects without complex testing needs:

```json
{
  "scripts": {
    "test": "node --test test/*.test.js",
    "test:coverage": "c8 --reporter=text --reporter=html node --test test/*.test.js",
    "test:coverage:check": "c8 --check-coverage --lines 60 --functions 60 --branches 60 node --test test/*.test.js"
  }
}
```

### Jest (for React/TypeScript projects)

For projects requiring more advanced testing features:

```json
{
  "scripts": {
    "test": "jest",
    "test:coverage": "jest --coverage",
    "test:watch": "jest --watch"
  }
}
```

## File Structure

```
project-name/
├── src/
│   ├── index.ts
│   └── utils.ts
└── test/
    ├── index.test.ts
    └── utils.test.ts
```

Or co-located tests:

```
project-name/
└── src/
    ├── index.ts
    ├── index.test.ts
    ├── utils.ts
    └── utils.test.ts
```

## Test Naming Conventions

- Test files: `*.test.{js,ts,tsx}` or `*.spec.{js,ts,tsx}`
- Test suites: Descriptive `describe()` blocks
- Test cases: Use `it()` or `test()` with clear descriptions

### Example

```javascript
import { describe, it } from 'node:test';
import assert from 'node:assert';
import { myFunction } from '../src/utils.js';

describe('myFunction', () => {
  it('should return expected output for valid input', () => {
    const result = myFunction('input');
    assert.strictEqual(result, 'expected');
  });

  it('should throw error for invalid input', () => {
    assert.throws(() => myFunction(null), /Invalid input/);
  });
});
```

## What to Test

### Priority 1: Critical Business Logic
- Core algorithms
- Data transformations
- Security-sensitive code
- API endpoints
- Database queries

### Priority 2: Edge Cases
- Error handling
- Boundary conditions
- Null/undefined handling
- Invalid inputs

### Priority 3: Integration Points
- External API calls (with mocks)
- Database interactions (with test DB)
- File system operations

## What NOT to Test

- Third-party library internals
- Auto-generated code
- Simple getters/setters
- Configuration files

## CI/CD Integration

All tests run automatically on:
- Every push to `main` or `develop`
- Every pull request
- Pre-commit hooks (optional, recommended)

### Failing Tests Block Merges

If tests fail in CI, the PR cannot be merged. Fix failing tests before requesting review.

## Coverage Reports

Coverage reports are generated in:
- **Text**: Console output
- **HTML**: `coverage/index.html` (local viewing)
- **LCOV**: `coverage/lcov.info` (CI integration)

### Viewing Coverage

```bash
# Run tests with coverage
pnpm test:coverage

# Open HTML report
open coverage/index.html  # macOS
xdg-open coverage/index.html  # Linux
start coverage/index.html  # Windows
```

## Mocking & Fixtures

### External APIs

Use mocking libraries to avoid hitting real APIs in tests:

```javascript
// Mock example using Node.js native mocking
import { mock } from 'node:test';

mock.method(global, 'fetch', () => {
  return Promise.resolve({
    json: () => Promise.resolve({ data: 'mocked' })
  });
});
```

### Database

Use in-memory databases or test fixtures:

```javascript
// SQLite in-memory for testing
const db = new Database(':memory:');
```

## Performance Testing

For performance-critical code:

```javascript
import { describe, it } from 'node:test';
import assert from 'node:assert';

describe('Performance', () => {
  it('should complete within 100ms', async () => {
    const start = performance.now();
    await myExpensiveFunction();
    const duration = performance.now() - start;
    assert.ok(duration < 100, `Took ${duration}ms, expected < 100ms`);
  });
});
```

## Snapshot Testing

For UI components or complex object outputs:

```javascript
// Using Jest snapshots
test('renders correctly', () => {
  const component = render(<MyComponent />);
  expect(component).toMatchSnapshot();
});
```

## Troubleshooting

### Tests Pass Locally but Fail in CI

- Check Node.js version matches CI environment
- Ensure all dependencies in `package.json`
- Look for timing-dependent tests (use `--inspect` flag)

### Low Coverage on New Code

- Run `pnpm test:coverage` to see uncovered lines
- Add tests for conditional branches
- Test error handling paths

### Flaky Tests

- Avoid timing-dependent assertions
- Use proper async/await
- Mock external dependencies
- Ensure test isolation (no shared state)

## Pre-commit Hooks

Recommended configuration for `.husky/pre-commit`:

```bash
#!/bin/sh
pnpm test
pnpm lint
```

## Resources

- [Node.js Test Runner Docs](https://nodejs.org/api/test.html)
- [c8 Coverage Tool](https://github.com/bcoe/c8)
- [Jest Documentation](https://jestjs.io/)
- [Testing Best Practices](https://github.com/goldbergyoni/javascript-testing-best-practices)

## Questions?

Open an issue with the `testing` label for questions or suggestions.

---

**Last Updated**: 2025-11-15
**Maintained By**: @Krosebrook
