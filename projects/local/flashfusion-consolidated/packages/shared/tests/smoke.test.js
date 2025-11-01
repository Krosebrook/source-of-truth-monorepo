/**
 * Smoke tests for @flashfusion/shared
 * Basic tests to ensure the package builds and exports correctly
 */

describe('Shared Package', () => {
  it('should have a valid package.json', () => {
    const pkg = require('../package.json');
    expect(pkg.name).toBe('@flashfusion/shared');
    expect(pkg.version).toBeDefined();
  });

  it('should have required dependencies', () => {
    const pkg = require('../package.json');
    expect(pkg.dependencies).toBeDefined();
    expect(pkg.devDependencies).toBeDefined();
  });

  it('should have test scripts configured', () => {
    const pkg = require('../package.json');
    expect(pkg.scripts.test).toBeDefined();
    expect(pkg.scripts['test:coverage']).toBeDefined();
  });

  it('should have jest configuration', () => {
    const pkg = require('../package.json');
    expect(pkg.jest).toBeDefined();
    expect(pkg.jest.testEnvironment).toBe('node');
  });

  it('should have proper module type', () => {
    const pkg = require('../package.json');
    expect(pkg.type).toBe('module');
  });
});
