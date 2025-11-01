# Testing Reference

This document describes the testing structure and practices for the FlashFusion Source-of-Truth monorepo.

## Overview

The monorepo uses a combination of testing frameworks and approaches suited to each project:

- **Node.js native test runner** (`node:test`) for smoke tests and simple unit tests
- **Jest** for packages requiring more advanced testing features (flashfusion packages)
- **Shared test utilities** for common testing helpers

## Test Structure

### Repository Organization

```
source-of-truth-monorepo/
├── shared/
│   └── test-utils/          # Shared test utilities
│       ├── index.ts         # Common test helpers
│       └── README.md
├── projects/local/
│   ├── flashfusion-consolidated/
│   │   ├── packages/
│   │   │   ├── ai-core/
│   │   │   │   └── tests/   # Jest-based tests
│   │   │   └── shared/
│   │   │       └── tests/   # Jest-based tests
│   │   └── apps/
│   │       ├── api/
│   │       │   └── tests/   # Node test runner
│   │       └── web/
│   │           └── tests/   # Node test runner
│   ├── harvestflow/
│   │   ├── tests/           # Node test runner
│   │   └── chat-history/
│   │       └── tests/       # Node test runner
│   └── int-smart-triage-ai-2.0/
│       └── test/            # Node test runner (existing)
└── shared/
    └── logging/
        └── tests/           # Node test runner
```

## Test Types

### 1. Smoke Tests

Minimal tests that verify basic functionality:
- Package configuration is valid
- Required dependencies are present
- Main entry points can be imported
- Build scripts are configured

**Example:**
```javascript
import { describe, it } from 'node:test';
import assert from 'node:assert';

describe('Package Smoke Tests', () => {
  it('should have valid package.json', () => {
    const pkg = require('../package.json');
    assert.ok(pkg.name);
    assert.ok(pkg.version);
  });
});
```

### 2. Unit Tests

Test individual functions and modules in isolation.

**Example using shared test utils:**
```typescript
import { assert, assertEqual } from '@flashfusion/test-utils';

function add(a: number, b: number): number {
  return a + b;
}

// Test
assertEqual(add(1, 2), 3, 'Addition should work');
```

### 3. Integration Tests

Test interactions between components (to be added as needed).

## Running Tests

### Run All Tests

```bash
pnpm test
```

This runs tests across all packages using Turbo.

### Run Tests for Specific Package

```bash
cd projects/local/harvestflow
pnpm test
```

### Run Tests with Coverage (Jest packages)

```bash
cd projects/local/flashfusion-consolidated/packages/ai-core
pnpm test:coverage
```

## CI/CD Integration

Tests are automatically run in CI on every push and pull request. See `.github/workflows/ci.yml`:

```yaml
- name: Test
  run: pnpm test
```

The CI pipeline runs:
1. Lint
2. Type check
3. Build
4. Test

## Shared Test Utilities

The `@flashfusion/test-utils` package provides common utilities:

### Assertions
- `assert(condition, message)` - Basic assertion
- `assertEqual(actual, expected, message)` - Equality check
- `assertDefined(value, message)` - Not null/undefined check
- `assertFunction(fn, name)` - Function type check
- `assertHasProperty(obj, property)` - Property existence check

### Utilities
- `sleep(ms)` - Async sleep helper
- `MockLogger` - Mock logger for testing

**Usage:**
```typescript
import { assert, MockLogger } from '@flashfusion/test-utils';

const logger = new MockLogger();
logger.info('Test');
assert(logger.hasLog('info', 'Test'), 'Should log message');
```

## Test Configuration

### Node Test Runner

Packages using Node's native test runner (Node 18+):

```json
{
  "scripts": {
    "test": "node --test tests/*.test.js"
  }
}
```

### Jest

Packages using Jest have configuration in their `package.json`:

```json
{
  "jest": {
    "testEnvironment": "node",
    "testMatch": ["**/tests/**/*.test.js"],
    "coverageDirectory": "coverage"
  }
}
```

## Best Practices

1. **Write Tests First**: Consider test cases when implementing features
2. **Keep Tests Simple**: Each test should verify one behavior
3. **Use Descriptive Names**: Test names should clearly describe what they verify
4. **Maintain Test Coverage**: Every new feature should include tests
5. **Run Tests Locally**: Always run tests before pushing
6. **Use Shared Utilities**: Leverage `@flashfusion/test-utils` for common patterns

## Adding Tests to New Packages

1. Create a `tests/` directory in your package
2. Add test files following the naming convention: `*.test.js` or `*.test.ts`
3. Add a test script to `package.json`:
   ```json
   {
     "scripts": {
       "test": "node --test tests/*.test.js"
     }
   }
   ```
4. Write smoke tests at minimum:
   - Package configuration
   - Required dependencies
   - Basic functionality

## Troubleshooting

### Tests Not Running

- Verify the test script is defined in `package.json`
- Check that test files match the pattern in your test configuration
- Ensure dependencies are installed (`pnpm install`)

### Import Errors

- For ES modules, ensure `"type": "module"` is set in `package.json`
- Use proper import syntax for JSON files:
  ```javascript
  import pkg from '../package.json' assert { type: 'json' };
  ```

### Jest Configuration Issues

- Verify Jest is installed as a dev dependency
- Check that `jest` configuration block exists in `package.json`
- Ensure test files are in the correct location

## Resources

- [Node.js Test Runner](https://nodejs.org/api/test.html)
- [Jest Documentation](https://jestjs.io/)
- [Turbo Test Documentation](https://turbo.build/repo/docs/core-concepts/monorepos/running-tasks)

## Future Enhancements

- Add integration test suite
- Set up E2E testing for web applications
- Add performance benchmarking tests
- Configure automated test reporting
