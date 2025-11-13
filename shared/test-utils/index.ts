/**
 * Shared test utilities for FlashFusion SoT monorepo
 * Provides common test helpers and assertions
 */

/**
 * Simple assertion helper for smoke tests
 */
export function assert(condition: boolean, message: string): void {
  if (!condition) {
    throw new Error(`Assertion failed: ${message}`);
  }
}

/**
 * Assert that a value is defined (not null or undefined)
 */
export function assertDefined<T>(value: T | null | undefined, message?: string): asserts value is T {
  if (value === null || value === undefined) {
    throw new Error(message || `Expected value to be defined, got ${value}`);
  }
}

/**
 * Assert that a value equals an expected value
 */
export function assertEqual<T>(actual: T, expected: T, message?: string): void {
  if (actual !== expected) {
    throw new Error(
      message || `Expected ${JSON.stringify(expected)}, got ${JSON.stringify(actual)}`
    );
  }
}

/**
 * Assert that a function is defined and callable
 */
export function assertFunction(fn: any, name: string): void {
  if (typeof fn !== 'function') {
    throw new Error(`Expected ${name} to be a function, got ${typeof fn}`);
  }
}

/**
 * Assert that an object has a specific property
 */
export function assertHasProperty(obj: any, property: string): void {
  if (!(property in obj)) {
    throw new Error(`Expected object to have property "${property}"`);
  }
}

/**
 * Sleep helper for async tests
 */
export function sleep(ms: number): Promise<void> {
  return new Promise(resolve => setTimeout(resolve, ms));
}

/**
 * Mock logger for testing
 */
export class MockLogger {
  public logs: Array<{ level: string; message: string; meta?: any }> = [];

  debug(message: string, meta?: any): void {
    this.logs.push({ level: 'debug', message, meta });
  }

  info(message: string, meta?: any): void {
    this.logs.push({ level: 'info', message, meta });
  }

  warn(message: string, meta?: any): void {
    this.logs.push({ level: 'warn', message, meta });
  }

  error(message: string, meta?: any): void {
    this.logs.push({ level: 'error', message, meta });
  }

  clear(): void {
    this.logs = [];
  }

  hasLog(level: string, messageSubstring: string): boolean {
    return this.logs.some(
      log => log.level === level && log.message.includes(messageSubstring)
    );
  }
}

export default {
  assert,
  assertDefined,
  assertEqual,
  assertFunction,
  assertHasProperty,
  sleep,
  MockLogger,
};
