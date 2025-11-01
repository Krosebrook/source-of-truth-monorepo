import { describe, it } from 'node:test';
import assert from 'node:assert';
import { readFileSync } from 'fs';
import { join } from 'path';

describe('Chat History Harvester', () => {
  it('should have a valid package.json', () => {
    const pkg = JSON.parse(readFileSync(join(process.cwd(), 'package.json'), 'utf-8'));
    assert.strictEqual(pkg.name, 'chat-history-harvester');
    assert.ok(pkg.private, 'Should be a private package');
  });

  it('should have a start script', () => {
    const pkg = JSON.parse(readFileSync(join(process.cwd(), 'package.json'), 'utf-8'));
    assert.ok(pkg.scripts.start, 'Should have start script');
  });

  it('should be configured as ES module', () => {
    const pkg = JSON.parse(readFileSync(join(process.cwd(), 'package.json'), 'utf-8'));
    assert.strictEqual(pkg.type, 'module', 'Should be configured as ES module');
  });

  it('should have required dependencies', () => {
    const pkg = JSON.parse(readFileSync(join(process.cwd(), 'package.json'), 'utf-8'));
    assert.ok(pkg.dependencies['ts-node'], 'Should have ts-node dependency');
    assert.ok(pkg.dependencies.typescript, 'Should have TypeScript dependency');
    assert.ok(pkg.dependencies.zod, 'Should have zod dependency');
    assert.ok(pkg.dependencies['js-yaml'], 'Should have js-yaml dependency');
  });

  it('should have a TypeScript configuration file', () => {
    // Just verify we can read tsconfig.json without errors
    const tsconfig = JSON.parse(readFileSync(join(process.cwd(), 'tsconfig.json'), 'utf-8'));
    assert.ok(tsconfig, 'Should have tsconfig.json');
  });
});
