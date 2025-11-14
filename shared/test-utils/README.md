# Test Utilities

Shared test utilities for the FlashFusion Source-of-Truth monorepo.

## Overview

This package provides common test helpers, assertions, and utilities used across all projects in the monorepo.

## Features

- **Assertion Helpers**: Simple assertion functions for smoke tests
- **Mock Logger**: Test double for logging functionality
- **Test Utilities**: Common helpers like `sleep` for async testing

## Usage

```typescript
import { assert, assertEqual, MockLogger } from "@flashfusion/test-utils";

// Basic assertions
assert(true, "Should be true");
assertEqual(1 + 1, 2, "Math should work");

// Mock logger for testing
const logger = new MockLogger();
logger.info("Test message");
assert(logger.hasLog("info", "Test message"), "Should have logged message");
```

## API

### Assertions

- `assert(condition, message)` - Basic assertion
- `assertDefined(value, message)` - Assert value is not null/undefined
- `assertEqual(actual, expected, message)` - Assert equality
- `assertFunction(fn, name)` - Assert value is a function
- `assertHasProperty(obj, property)` - Assert object has property

### Utilities

- `sleep(ms)` - Async sleep helper
- `MockLogger` - Mock logger for testing

## License

MIT
