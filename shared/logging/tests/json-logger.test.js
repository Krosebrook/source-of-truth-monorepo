/**
 * Smoke tests for @flashfusion/logging
 * Basic tests to ensure the package is properly configured
 */

import { describe, it } from 'node:test';
import assert from 'node:assert';
import { readFileSync } from 'fs';
import { join } from 'path';

describe('JSON Logger Package', () => {
  it('should have a valid package.json', () => {
    const pkg = JSON.parse(readFileSync(join(process.cwd(), 'package.json'), 'utf-8'));
    assert.strictEqual(pkg.name, '@flashfusion/logging');
    assert.ok(pkg.version);
  });

  it('should have json-logger.ts file', () => {
    const content = readFileSync(join(process.cwd(), 'json-logger.ts'), 'utf-8');
    assert.ok(content.includes('export class JsonLogger'));
    assert.ok(content.includes('export const createLogger'));
  });

  it('should export LogLevel type', () => {
    const content = readFileSync(join(process.cwd(), 'json-logger.ts'), 'utf-8');
    assert.ok(content.includes('export type LogLevel'));
  });

  it('should export LogEntry interface', () => {
    const content = readFileSync(join(process.cwd(), 'json-logger.ts'), 'utf-8');
    assert.ok(content.includes('export interface LogEntry'));
  });

  it('should have all log level methods', () => {
    const content = readFileSync(join(process.cwd(), 'json-logger.ts'), 'utf-8');
    assert.ok(content.includes('debug('));
    assert.ok(content.includes('info('));
    assert.ok(content.includes('warn('));
    assert.ok(content.includes('error('));
    assert.ok(content.includes('fatal('));
  });

  it('should be marked as private', () => {
    const pkg = JSON.parse(readFileSync(join(process.cwd(), 'package.json'), 'utf-8'));
    assert.strictEqual(pkg.private, true);
  });
});

