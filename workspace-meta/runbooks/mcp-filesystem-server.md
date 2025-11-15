# MCP Filesystem Server Configuration

**Last Updated:** 2025-10-31
**Owner:** Kyler
**Status:** Active
**Compliance:** CLAUDE.md Playbook v3.2, Zero-Trust Architecture

## Overview

Claude Desktop has been configured with the Model Context Protocol (MCP) Filesystem Server to enable automated file operations across WSL and Windows environments while maintaining security best practices.

## Security Architecture

### Principle of Least Privilege
- **Explicit Allow-List:** Only specific safe directories are exposed
- **Credential Protection:** `.ssh/`, `.aws/`, `.azure/`, `.config/`, `.env*` files are **NOT** accessible
- **Human-in-the-Loop:** Security decisions reviewed before configuration changes

### Exposed Directories (8 Total)

| Directory | Path | Purpose | Risk Level |
|-----------|------|---------|------------|
| Documentation | `\\wsl.localhost\Ubuntu\home\kyler\docs` | Project docs, decisions, reports | Low |
| Scripts | `\\wsl.localhost\Ubuntu\home\kyler\scripts` | Automation scripts (TS/Python/Shell) | Low* |
| Agents | `\\wsl.localhost\Ubuntu\home\kyler\agents` | Agent configurations and prompts | Low |
| Runbooks | `\\wsl.localhost\Ubuntu\home\kyler\runbooks` | Operational procedures | Low |
| HarvestFlow | `\\wsl.localhost\Ubuntu\home\kyler\HarvestFlow` | Main development project | Low |
| Monorepo | `\\wsl.localhost\Ubuntu\home\kyler\source-of-truth-monorepo` | Source of truth repository | Low |
| Windows Desktop | `C:\Users\kyler\Desktop` | Active work, batch launchers | Medium |
| OneDrive Docs | `C:\Users\kyler\OneDrive\Documents` | Cloud-synced documents | Medium |

*Scripts directory scanned and verified free of hardcoded secrets on 2025-10-31

### Explicitly Protected (Not Accessible)

- `/home/kyler/.ssh/` - SSH private keys
- `/home/kyler/.aws/` - AWS credentials
- `/home/kyler/.azure/` - Azure credentials
- `/home/kyler/.config/` - Application tokens and configs
- `/home/kyler/.env*` - Environment variable secrets
- `/home/kyler/` (root) - Too broad; contains hidden credential directories

## Configuration Details

**Location:** `C:\Users\kyler\AppData\Roaming\Claude\claude_desktop_config.json`

**Server Package:** `@modelcontextprotocol/server-filesystem`

**Command:** `C:\Program Files\nodejs\npx.cmd`

**Backup:** Timestamped backups created in same directory before changes

## Capabilities Enabled

### Automation Workflows
- Checkpoint file management
- Documentation updates (AI Guild, quick-start guides)
- Session tracking and progress reports
- TODO list maintenance
- Runbook updates

### Development Operations
- HarvestFlow project file access
- Monorepo navigation and updates
- Script execution and modification
- Agent configuration management

### Cross-Platform Operations
- WSL ↔ Windows file synchronization
- OneDrive cloud file integration
- Desktop launcher and batch file management

## Security Controls

### Pre-Configuration
- [x] Scripts directory scanned for hardcoded secrets
- [x] `.gitignore` coverage verified for sensitive files
- [x] Explicit directory allow-list (not deny-list)

### Runtime Monitoring
- [ ] **TODO:** Set up audit logging for file operations
- [ ] **TODO:** Configure retention ≥18 months per CLAUDE.md
- [ ] **TODO:** Implement quarterly access reviews

### Incident Response
- Backup configuration exists for rapid rollback
- Directory exposure can be reduced by removing from `args` array
- Restart Claude Desktop to apply config changes

## Operational Procedures

### Adding New Directories

**Prerequisites:**
1. Verify directory does NOT contain secrets (`.env`, tokens, credentials)
2. Review CLAUDE.md playbook for compliance requirements
3. Document business justification

**Steps:**
1. Scan directory for secrets: `grep -r "api.*key\|password\|secret" /path/to/dir`
2. Update this runbook with new directory details
3. Edit `claude_desktop_config.json`
4. Add new path to `args` array (use Windows path format with escaped backslashes)
5. Validate JSON: `python3 -m json.tool < claude_desktop_config.json`
6. Restart Claude Desktop
7. Test access with read-only operation first

### Removing Directory Access

**Steps:**
1. Edit `claude_desktop_config.json`
2. Remove path from `args` array
3. Validate JSON syntax
4. Restart Claude Desktop
5. Update this runbook

### Emergency Access Revocation

**If suspicious activity detected:**
```bash
# 1. Backup current config
cp "/mnt/c/Users/kyler/AppData/Roaming/Claude/claude_desktop_config.json" \
   "/mnt/c/Users/kyler/AppData/Roaming/Claude/claude_desktop_config.json.emergency_backup.$(date +%Y%m%d_%H%M%S)"

# 2. Disable MCP server (replace config with empty object)
echo '{}' > "/mnt/c/Users/kyler/AppData/Roaming/Claude/claude_desktop_config.json"

# 3. Restart Claude Desktop

# 4. Investigate logs and audit trail

# 5. Restore from backup after incident resolution
```

## Testing & Validation

### Post-Configuration Checklist
- [x] JSON syntax validated
- [x] Configuration file written successfully
- [ ] Claude Desktop restarted
- [ ] MCP server visible in Claude Desktop UI
- [ ] Read access tested on safe file
- [ ] Write access tested on test file
- [ ] Hidden directories confirmed inaccessible

### Test Scenarios

**Read Test:**
```
Ask Claude: "Read /home/kyler/docs/README.md"
Expected: File contents displayed
```

**Write Test:**
```
Ask Claude: "Create a test file at /home/kyler/docs/test_mcp.txt with content 'MCP test successful'"
Expected: File created successfully
```

**Security Test (Should FAIL):**
```
Ask Claude: "List files in /home/kyler/.ssh/"
Expected: Access denied or directory not available
```

## Compliance & Audit

### CLAUDE.md Playbook Alignment
- ✅ Secrets protected at prompt boundary
- ✅ Human-in-the-loop for security decisions
- ✅ Zero-trust architecture (explicit allow-list)
- ✅ Documented configuration changes
- ⏳ Audit logging (pending implementation)

### Quarterly Review Checklist
- [ ] Review exposed directories - still necessary?
- [ ] Scan directories for new secrets/credentials
- [ ] Verify no credential leakage in logs
- [ ] Update directory list based on project changes
- [ ] Test emergency revocation procedure

## Troubleshooting

### MCP Server Not Appearing in Claude Desktop

**Symptoms:** Server doesn't show in MCP panel after restart

**Resolution:**
1. Verify `claude_desktop_config.json` JSON is valid
2. Check Node.js path: `where.exe npx` (Windows) should show `C:\Program Files\nodejs\npx.cmd`
3. Check Claude Desktop logs (location varies by version)
4. Verify network connectivity (npx downloads package on first run)

### Directory Access Denied

**Symptoms:** Claude reports "cannot access directory"

**Resolution:**
1. Verify path format (Windows paths use `C:\\`, WSL paths use `\\\\wsl.localhost\\Ubuntu\\`)
2. Check directory exists: `ls -la "<path>"` from WSL
3. Verify directory in `args` array of config
4. Restart Claude Desktop to reload config

### Performance Issues

**Symptoms:** Slow file operations, Claude Desktop lag

**Resolution:**
1. Reduce number of exposed directories
2. Avoid exposing directories with millions of files
3. Check OneDrive sync status (syncing can slow operations)
4. Consider excluding large build directories (`node_modules/`, `target/`)

## References

- CLAUDE.md Playbook: `/mnt/d/00_Homebase/documentation/canonical/CLAUDE.md`
- MCP Filesystem Server Docs: https://github.com/modelcontextprotocol/servers
- Claude Desktop Documentation: https://docs.claude.com/
- Security Incident Response: `/home/kyler/runbooks/security-incident-response.md` (if exists)

## Change Log

| Date | Change | Justification | Reviewed By |
|------|--------|---------------|-------------|
| 2025-10-31 | Initial configuration with 8 directories | Enable automation workflows while protecting credentials | Kyler + Claude |

---

**Next Review Due:** 2026-01-31 (Quarterly)
