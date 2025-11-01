import { describe, it } from 'node:test';
import assert from 'node:assert';
import { JsonLogger, createLogger, log } from '../json-logger';

describe('JSON Logger', () => {
  it('should create a logger instance', () => {
    const logger = new JsonLogger('test-service');
    assert.ok(logger, 'Logger should be created');
  });

  it('should create logger with createLogger factory', () => {
    const logger = createLogger('test-service');
    assert.ok(logger instanceof JsonLogger, 'Should create JsonLogger instance');
  });

  it('should export default log instance', () => {
    assert.ok(log instanceof JsonLogger, 'Should export default log instance');
  });

  it('should have all log level methods', () => {
    const logger = new JsonLogger('test');
    assert.strictEqual(typeof logger.debug, 'function', 'Should have debug method');
    assert.strictEqual(typeof logger.info, 'function', 'Should have info method');
    assert.strictEqual(typeof logger.warn, 'function', 'Should have warn method');
    assert.strictEqual(typeof logger.error, 'function', 'Should have error method');
    assert.strictEqual(typeof logger.fatal, 'function', 'Should have fatal method');
  });

  it('should log structured JSON output', () => {
    const logger = new JsonLogger('test-service');
    const originalLog = console.log;
    let logOutput = '';

    // Capture console.log output
    console.log = (msg) => {
      logOutput = msg;
    };

    logger.info('Test message', { key: 'value' });

    // Restore console.log
    console.log = originalLog;

    const parsed = JSON.parse(logOutput);
    assert.strictEqual(parsed.level, 'info');
    assert.strictEqual(parsed.msg, 'Test message');
    assert.strictEqual(parsed.service, 'test-service');
    assert.strictEqual(parsed.key, 'value');
    assert.ok(parsed.ts, 'Should have timestamp');
  });

  it('should handle metadata', () => {
    const logger = new JsonLogger('test');
    const originalLog = console.log;
    let logOutput = '';

    console.log = (msg) => {
      logOutput = msg;
    };

    logger.warn('Warning', { userId: 123, action: 'login' });

    console.log = originalLog;

    const parsed = JSON.parse(logOutput);
    assert.strictEqual(parsed.userId, 123);
    assert.strictEqual(parsed.action, 'login');
  });
});
