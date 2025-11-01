/**
 * Smoke tests for @flashfusion/ai-core
 * Basic tests to ensure the package builds and exports correctly
 */

describe('AI Core Package', () => {
  it('should have a valid package.json', () => {
    const pkg = require('../package.json');
    expect(pkg.name).toBe('@flashfusion/ai-core');
    expect(pkg.version).toBeDefined();
  });

  it('should export main entry point', () => {
    // This test verifies the package can be required/imported
    expect(() => {
      require('../index.ts');
    }).not.toThrow();
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
});
