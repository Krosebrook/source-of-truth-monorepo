import { describe, it } from 'node:test';
import assert from 'node:assert';

describe('API Application', () => {
  it('should have a valid package.json', async () => {
    const pkg = await import('../package.json', { assert: { type: 'json' } });
    assert.strictEqual(pkg.default.name, '@flashfusion/api');
    assert.ok(pkg.default.version);
  });

  it('should have required scripts', async () => {
    const pkg = await import('../package.json', { assert: { type: 'json' } });
    const scripts = pkg.default.scripts;
    assert.ok(scripts.build, 'Should have build script');
    assert.ok(scripts.dev, 'Should have dev script');
    assert.ok(scripts.lint, 'Should have lint script');
    assert.ok(scripts['type-check'], 'Should have type-check script');
  });

  it('should have TypeScript configuration', async () => {
    const pkg = await import('../package.json', { assert: { type: 'json' } });
    assert.ok(pkg.default.devDependencies.typescript, 'Should have TypeScript as dev dependency');
  });

  it('should have Express as dependency', async () => {
    const pkg = await import('../package.json', { assert: { type: 'json' } });
    assert.ok(pkg.default.dependencies.express, 'Should have Express as dependency');
  });
});
