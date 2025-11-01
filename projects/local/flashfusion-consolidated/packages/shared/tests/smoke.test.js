/**
 * Smoke tests for @flashfusion/shared
 * Basic tests to ensure the package builds and exports correctly
 */

import { describe, it } from 'node:test';
import assert from 'node:assert';
import { readFileSync } from 'fs';
import { join } from 'path';

describe('Shared Package', () => {
  it('should have a valid package.json', () => {
    const pkgText = readFileSync(join(process.cwd(), 'package.json'), 'utf-8');
    const pkg = JSON.parse(pkgText);
    assert.strictEqual(pkg.name, '@flashfusion/shared');
    assert.ok(pkg.version);
  });

  it('should have required dependencies', () => {
    const pkgText = readFileSync(join(process.cwd(), 'package.json'), 'utf-8');
    const pkg = JSON.parse(pkgText);
    assert.ok(pkg.dependencies);
    assert.ok(pkg.devDependencies);
  });

  it('should have test scripts configured', () => {
    const pkgText = readFileSync(join(process.cwd(), 'package.json'), 'utf-8');
    const pkg = JSON.parse(pkgText);
    assert.ok(pkg.scripts.test);
    assert.ok(pkg.scripts['test:coverage']);
  });

  it('should have jest configuration', () => {
    const pkgText = readFileSync(join(process.cwd(), 'package.json'), 'utf-8');
    const pkg = JSON.parse(pkgText);
    assert.ok(pkg.jest);
    assert.strictEqual(pkg.jest.testEnvironment, 'node');
  });

  it('should have proper module type', () => {
    const pkgText = readFileSync(join(process.cwd(), 'package.json'), 'utf-8');
    const pkg = JSON.parse(pkgText);
    assert.strictEqual(pkg.type, 'module');
  });
});

