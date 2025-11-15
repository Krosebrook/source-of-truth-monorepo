# Local Repository Setup Guide (2025 Q4)

## 1. Prepare Your Environment
- Install required runtimes and package managers (git ≥2.44, Node/Bun, Python, Docker) per project stack.
- Authenticate to source control (SSH keys preferred); ensure keys are loaded into `ssh-agent`.
- Configure global git defaults:
  ```bash
  git config --global user.name "Your Name"
  git config --global user.email "you@example.com"
  git config --global pull.rebase true
  git config --global init.defaultBranch main
  ```

## 2. Create Workspace Structure
- Choose a root workspace (e.g., `~/repos`).
- Mirror production layout when possible (e.g., `~/repos/org/product/component`).
- Keep documentation (`docs/`), automation (`scripts/`), and compliance artefacts (`compliance/`) in consistent locations.

## 3. Clone or Initialize Repositories
- **Clone existing repo**:
  ```bash
  git clone git@github.com:org/project.git ~/repos/project
  ```
- **Initialize new repo**:
  ```bash
  mkdir -p ~/repos/project
  cd ~/repos/project
  git init
  echo "# Project" > README.md
  git add README.md
  git commit -m "chore: scaffold repository"
  ```
- Add upstream remotes as needed:
  ```bash
  git remote add upstream git@github.com:org/project-upstream.git
  ```

## 4. Enforce Governance Baselines
- Copy canonical files (`CLAUDE.md`, `AGENTS.md`, `CHECKPOINT.md`, `README.md`) into new repo or symlink to `/home/kyler/…/canonical`.
- Add `.gitignore`, `SECURITY.md`, `CODEOWNERS`, and compliance templates from `templates/`.
- Register the repo in `agents/registry.json` with owner, risk tier, and validation date.

## 5. Install Dependencies & Tooling
- Follow project-specific bootstrap instructions (`scripts/bootstrap.sh`, `npm install`, `pip install -r requirements.txt`).
- Run initial validation:
  ```bash
  npm run lint
  npm test
  make sbom && make sbom-verify   # when Makefile/tooling available
  ```
- Record hashes and evaluator results in `compliance_log.json`.

## 6. Branching & Workflow Discipline
- Create feature branches from `main` or latest release tag:
  ```bash
  git checkout -b feature/brief-description
  ```
- Commit with Conventional Commit messages; push to origin and open PRs for review.
- Use feature flags or environment toggles for risky changes; capture rollback strategy in `CHECKPOINT.md`.

## 7. Continuous Compliance
- After each significant change, regenerate SBOM/SLSA proofs and update `compliance_log.json`.
- Update `docs/sessions/SESSION_CONTINUITY_LOG.md` with session outcomes, residual risks, and next review date.
- Schedule periodic audits to refresh `agents/registry.json` last_validation_date fields.

## 8. Backup & Restore Practices
- Configure scheduled backups (rsync, restic, or cloud snapshots) for critical repos.
- Store checksum manifests alongside archives to ensure integrity on restore.
- Test restoration quarterly to verify recoverability.

## 9. Troubleshooting Tips
- If git operations fail, run `git fsck` and `git status --short --branch` to diagnose.
- For permission issues, verify SSH agent forwarding and repository access rights.
- Use `gh repo clone/search` for GitHub-backed orgs to simplify discovery.
