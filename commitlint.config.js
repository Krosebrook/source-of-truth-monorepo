// Commitlint configuration for Conventional Commits
// https://commitlint.js.org/

export default {
  extends: ['@commitlint/config-conventional'],
  rules: {
    // Type
    'type-enum': [
      2,
      'always',
      [
        'feat',     // New feature
        'fix',      // Bug fix
        'docs',     // Documentation changes
        'style',    // Code style changes (formatting, etc.)
        'refactor', // Code refactoring
        'perf',     // Performance improvements
        'test',     // Adding or updating tests
        'chore',    // Maintenance tasks
        'ci',       // CI/CD changes
        'build',    // Build system changes
        'revert',   // Revert previous commit
      ],
    ],
    // Scope
    'scope-enum': [
      2,
      'always',
      [
        // General
        'deps',
        'config',
        'scripts',
        'docs',
        'ci',
        
        // Areas
        'agents',
        'shared',
        'projects',
        
        // Specific packages
        'claude-agent',
        'codex-agent',
        'gemini-agent',
        'github-agent',
        'logging',
        'test-utils',
        'contracts',
        'otel',
        'workflows',
        
        // Projects
        'web',
        'api',
        'ai-core',
        'harvestflow',
        'int-smart-triage',
        
        // Infrastructure
        'workspace',
        'turbo',
        'security',
      ],
    ],
    'scope-case': [2, 'always', 'kebab-case'],
    
    // Subject
    'subject-empty': [2, 'never'],
    'subject-case': [2, 'always', 'lower-case'],
    'subject-full-stop': [2, 'never', '.'],
    'subject-max-length': [2, 'always', 100],
    
    // Body
    'body-leading-blank': [2, 'always'],
    'body-max-line-length': [2, 'always', 100],
    
    // Footer
    'footer-leading-blank': [2, 'always'],
    'footer-max-line-length': [2, 'always', 100],
    
    // Header
    'header-max-length': [2, 'always', 100],
  },
};
