#!/usr/bin/env node
/**
 * Generate REPO_MAP.md
 * Scans the import script and projects directory to create a comprehensive repository map
 */

const fs = require('fs');
const path = require('path');

// Paths
const REPO_ROOT = path.join(__dirname, '..');
const IMPORT_SCRIPT = path.join(REPO_ROOT, 'scripts', 'import-github-repos.sh');
const PROJECTS_DIR = path.join(REPO_ROOT, 'projects');
const OUTPUT_FILE = path.join(REPO_ROOT, 'REPO_MAP.md');
const PROGRESS_FILE = path.join(REPO_ROOT, 'docs', '.progress.yaml');

/**
 * Parse the import script to extract repository definitions
 */
function parseImportScript() {
  const content = fs.readFileSync(IMPORT_SCRIPT, 'utf-8');
  const repos = [];
  
  // Extract the repos from the import list in the script
  const lines = content.split('\n');
  let inList = false;
  
  for (const line of lines) {
    // Start of the import list
    if (line.includes("cat > /tmp/sot-import-list.txt")) {
      inList = true;
      continue;
    }
    
    // End of the import list
    if (inList && line.includes('EOF')) {
      break;
    }
    
    // Skip comments and empty lines
    if (!inList || line.trim().startsWith('#') || !line.trim() || line.trim() === 'EOF') {
      continue;
    }
    
    // Parse repo line: org|name|url|target_dir
    const parts = line.split('|');
    if (parts.length === 4) {
      repos.push({
        org: parts[0].trim(),
        name: parts[1].trim(),
        url: parts[2].trim(),
        targetDir: parts[3].trim(),
      });
    }
  }
  
  return repos;
}

/**
 * Check if a repository is imported (directory exists)
 */
function isRepoImported(targetDir) {
  const fullPath = path.join(REPO_ROOT, targetDir);
  return fs.existsSync(fullPath);
}

/**
 * Get repository metadata
 */
function getRepoMetadata(targetDir) {
  const fullPath = path.join(REPO_ROOT, targetDir);
  const metadata = {
    imported: false,
    lastSync: null,
    maintainer: '@Krosebrook', // Default maintainer based on CODEOWNERS
  };
  
  if (fs.existsSync(fullPath)) {
    metadata.imported = true;
    
    // Try to get last modification time
    try {
      const stats = fs.statSync(fullPath);
      metadata.lastSync = stats.mtime.toISOString().split('T')[0];
    } catch (e) {
      // Ignore
    }
  }
  
  return metadata;
}

/**
 * Group repositories by organization
 */
function groupReposByOrg(repos) {
  const grouped = {};
  
  for (const repo of repos) {
    if (!grouped[repo.org]) {
      grouped[repo.org] = [];
    }
    grouped[repo.org].push(repo);
  }
  
  return grouped;
}

/**
 * Further categorize Krosebrook repos by subdirectory
 */
function categorizeKrosebrookRepos(repos) {
  const categories = {
    core: [],
    apps: [],
    tools: [],
  };
  
  for (const repo of repos) {
    if (repo.targetDir.includes('/core/')) {
      categories.core.push(repo);
    } else if (repo.targetDir.includes('/apps/')) {
      categories.apps.push(repo);
    } else if (repo.targetDir.includes('/tools/')) {
      categories.tools.push(repo);
    }
  }
  
  return categories;
}

/**
 * Get local repositories (not from import script)
 */
function getLocalRepos() {
  const localDir = path.join(PROJECTS_DIR, 'local');
  const repos = [];
  
  if (fs.existsSync(localDir)) {
    const entries = fs.readdirSync(localDir);
    for (const entry of entries) {
      const fullPath = path.join(localDir, entry);
      if (fs.statSync(fullPath).isDirectory()) {
        repos.push({
          name: entry,
          path: `projects/local/${entry}`,
          imported: true,
        });
      }
    }
  }
  
  return repos;
}

/**
 * Generate the REPO_MAP.md content
 */
function generateRepoMap() {
  const repos = parseImportScript();
  const groupedRepos = groupReposByOrg(repos);
  const localRepos = getLocalRepos();
  
  // Count statistics
  let totalRepos = localRepos.length;
  let importedCount = localRepos.length;
  let pendingCount = 0;
  
  for (const repo of repos) {
    totalRepos++;
    const metadata = getRepoMetadata(repo.targetDir);
    if (metadata.imported) {
      importedCount++;
    } else {
      pendingCount++;
    }
  }
  
  // Build markdown content
  let content = `# Repository Map

Complete index of all repositories in the FlashFusion SoT monorepo.

**Last Updated**: ${new Date().toISOString().split('T')[0]}

## Summary

- **Total Repositories**: ${totalRepos}
- **Imported**: ${importedCount}
- **Pending Import**: ${pendingCount}
- **Progress**: ${Math.round((importedCount / totalRepos) * 100)}%

### By Organization

- **Local**: ${localRepos.length} repos
- **Krosebrook**: ${groupedRepos.krosebrook?.length || 0} repos
- **FlashFusionv1**: ${groupedRepos.flashfusionv1?.length || 0} repos
- **ChaosClubCo**: ${groupedRepos.chaosclubco?.length || 0} repos

## Import Status

| Status | Count | Description |
|--------|-------|-------------|
| ✅ Imported | ${importedCount} | Repository code is present in monorepo |
| ⏳ Pending | ${pendingCount} | Scheduled for import |

## Repositories

### Local Repositories (${localRepos.length})

`;

  // Add local repos
  for (const repo of localRepos) {
    content += `#### ${repo.name}
- **Path**: \`${repo.path}\`
- **Status**: ✅ Imported
- **Type**: Local-only repository
- **Maintainer**: @Krosebrook

`;
  }

  // Add Krosebrook repos
  if (groupedRepos.krosebrook) {
    const krosebrookCategories = categorizeKrosebrookRepos(groupedRepos.krosebrook);
    
    content += `### Krosebrook Organization (${groupedRepos.krosebrook.length})

#### Core Projects (${krosebrookCategories.core.length})

`;
    for (const repo of krosebrookCategories.core) {
      const metadata = getRepoMetadata(repo.targetDir);
      const status = metadata.imported ? '✅ Imported' : '⏳ Pending';
      content += `##### ${repo.name}
- **Path**: \`${repo.targetDir}\`
- **Status**: ${status}
- **GitHub**: [${repo.url}](${repo.url})
- **Maintainer**: ${metadata.maintainer}
${metadata.lastSync ? `- **Last Sync**: ${metadata.lastSync}\n` : ''}
`;
    }

    content += `#### Applications (${krosebrookCategories.apps.length})

`;
    for (const repo of krosebrookCategories.apps) {
      const metadata = getRepoMetadata(repo.targetDir);
      const status = metadata.imported ? '✅ Imported' : '⏳ Pending';
      content += `##### ${repo.name}
- **Path**: \`${repo.targetDir}\`
- **Status**: ${status}
- **GitHub**: [${repo.url}](${repo.url})
- **Maintainer**: ${metadata.maintainer}
${metadata.lastSync ? `- **Last Sync**: ${metadata.lastSync}\n` : ''}
`;
    }

    content += `#### Tools & SDKs (${krosebrookCategories.tools.length})

`;
    for (const repo of krosebrookCategories.tools) {
      const metadata = getRepoMetadata(repo.targetDir);
      const status = metadata.imported ? '✅ Imported' : '⏳ Pending';
      content += `##### ${repo.name}
- **Path**: \`${repo.targetDir}\`
- **Status**: ${status}
- **GitHub**: [${repo.url}](${repo.url})
- **Maintainer**: ${metadata.maintainer}
${metadata.lastSync ? `- **Last Sync**: ${metadata.lastSync}\n` : ''}
`;
    }
  }

  // Add FlashFusionv1 repos
  if (groupedRepos.flashfusionv1) {
    content += `### FlashFusionv1 Organization (${groupedRepos.flashfusionv1.length})

`;
    for (const repo of groupedRepos.flashfusionv1) {
      const metadata = getRepoMetadata(repo.targetDir);
      const status = metadata.imported ? '✅ Imported' : '⏳ Pending';
      content += `#### ${repo.name}
- **Path**: \`${repo.targetDir}\`
- **Status**: ${status}
- **GitHub**: [${repo.url}](${repo.url})
- **Maintainer**: ${metadata.maintainer}
${metadata.lastSync ? `- **Last Sync**: ${metadata.lastSync}\n` : ''}
`;
    }
  }

  // Add ChaosClubCo repos
  if (groupedRepos.chaosclubco) {
    content += `### ChaosClubCo Organization (${groupedRepos.chaosclubco.length})

`;
    for (const repo of groupedRepos.chaosclubco) {
      const metadata = getRepoMetadata(repo.targetDir);
      const status = metadata.imported ? '✅ Imported' : '⏳ Pending';
      content += `#### ${repo.name}
- **Path**: \`${repo.targetDir}\`
- **Status**: ${status}
- **GitHub**: [${repo.url}](${repo.url})
- **Maintainer**: ${metadata.maintainer}
${metadata.lastSync ? `- **Last Sync**: ${metadata.lastSync}\n` : ''}
`;
    }
  }

  // Add footer
  content += `---

## Maintenance

### Updating This Map

This file is auto-generated. To update:

\`\`\`bash
pnpm run generate:repo-map
\`\`\`

### Import Progress Tracking

For detailed import progress and task tracking, see:
- [Documentation Progress Tracker](docs/.progress.yaml)

### Next Steps

1. Run the import script: \`./scripts/import-github-repos.sh\`
2. Review imported repositories
3. Update this map: \`pnpm run generate:repo-map\`
4. Commit changes

---

*Generated on ${new Date().toISOString()}*
`;

  return content;
}

/**
 * Main execution
 */
function main() {
  console.log('🗺️  Generating REPO_MAP.md...\n');
  
  const content = generateRepoMap();
  fs.writeFileSync(OUTPUT_FILE, content, 'utf-8');
  
  console.log(`✅ REPO_MAP.md generated successfully!`);
  console.log(`📍 Location: ${OUTPUT_FILE}`);
  console.log(`\nRun 'cat REPO_MAP.md | head -50' to preview\n`);
}

// Run if called directly
if (require.main === module) {
  main();
}

module.exports = { generateRepoMap, parseImportScript };
