# Best Practice Context

## GitHub Secrets

- Use for CI/CD-only secrets (`API keys`, deploy tokens, third-party credentials).
- Store encrypted values in the repository's GitHub Secrets manager.
- Inject into GitHub Actions workflows as needed for build, test, or deploy steps.

## Vercel Environment Variables

- Use for production runtime secrets, not for local development.
- Configure in the Vercel dashboard under the Production environment.
- Allow Vercel-hosted apps to access secrets such as API URLs, tokens, and service credentials.

## Docker Compose and `.env`

- Use for local development secrets to avoid polluting production settings.
- Keep `.env` files out of version control by listing them in `.gitignore`.
- Load values into Docker Compose services via `${VARIABLE}` substitution.

## Why This Matters

GitHub Secrets are scoped to CI/CD workflows and cannot be read directly by containers started via local Docker Compose. Bridge secrets securely by flowing GitHub Secrets → GitHub Actions → Docker build arguments or mounted files → container runtime environment.
