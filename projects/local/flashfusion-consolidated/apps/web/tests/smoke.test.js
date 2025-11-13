import { describe, it } from 'node:test';
import assert from 'node:assert';

describe('Web Application', () => {
  it('should have a valid package.json', async () => {
    const pkg = await import('../package.json', { assert: { type: 'json' } });
    assert.strictEqual(pkg.default.name, '@flashfusion/web');
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

  it('should have Next.js as dependency', async () => {
    const pkg = await import('../package.json', { assert: { type: 'json' } });
    assert.ok(pkg.default.dependencies.next, 'Should have Next.js as dependency');
  });

  it('should have React as dependency', async () => {
    const pkg = await import('../package.json', { assert: { type: 'json' } });
    assert.ok(pkg.default.dependencies.react, 'Should have React as dependency');
    assert.ok(pkg.default.dependencies['react-dom'], 'Should have React DOM as dependency');
  });
});
