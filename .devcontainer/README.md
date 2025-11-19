# VS Code Development Container

This directory contains the configuration for developing FlashFusion SoT in a containerized environment using VS Code Dev Containers.

## Quick Start

### Prerequisites

- [VS Code](https://code.visualstudio.com/)
- [Docker Desktop](https://www.docker.com/products/docker-desktop)
- [Dev Containers extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers)

### Usage

1. **Open in Container**
   - Open this repository in VS Code
   - Press `F1` and select "Dev Containers: Reopen in Container"
   - Wait for container to build (first time takes 5-10 minutes)

2. **Automatic Setup**
   - Dependencies are installed automatically
   - Projects are built
   - Git hooks are configured
   - PostgreSQL and Redis are started

3. **Start Developing**
   ```bash
   make dev     # Start development servers
   make test    # Run tests
   make help    # Show all commands
   ```

## What's Included

### Services

- **PostgreSQL 16**: Database (port 5432)
- **Redis 7**: Caching (port 6379)
- **Node.js 20**: Runtime environment

### Tools

- pnpm 9.0.0
- GitHub CLI (gh)
- Docker-in-Docker
- PostgreSQL client
- Redis tools

### VS Code Extensions

Pre-installed extensions:
- ESLint & Prettier
- TypeScript
- TailwindCSS
- GitLens
- Docker
- SQL Tools
- GitHub Copilot (if available)

## Configuration Files

- **`devcontainer.json`**: Main configuration
- **`docker-compose.yml`**: Services definition
- **`Dockerfile`**: Container image
- **`post-create.sh`**: Setup script

## Customization

### Add Extensions

Edit `devcontainer.json`:

```json
"customizations": {
  "vscode": {
    "extensions": [
      "your.extension-id"
    ]
  }
}
```

### Change Settings

Edit VS Code settings in `devcontainer.json`:

```json
"settings": {
  "your.setting": "value"
}
```

### Add Services

Edit `docker-compose.yml`:

```yaml
services:
  myservice:
    image: myimage:latest
    ports:
      - "8080:8080"
```

## Troubleshooting

### Container Won't Start

1. Ensure Docker Desktop is running
2. Check Docker has enough resources (4GB+ RAM)
3. Try: "Dev Containers: Rebuild Container"

### Slow Performance

1. Increase Docker resources
2. Use named volumes for node_modules (already configured)
3. On Mac/Windows: Enable VirtioFS

### Port Already in Use

1. Stop services on host: `make services-stop`
2. Change ports in `devcontainer.json`

## Manual Commands

### Rebuild Container

```bash
# VS Code Command Palette (F1)
Dev Containers: Rebuild Container
```

### Shell Access

```bash
# VS Code Terminal (automatically in container)
# Or attach to running container:
docker exec -it <container-name> bash
```

### Database Access

```bash
# PostgreSQL
psql -h localhost -U dev -d flashfusion_dev

# Redis
redis-cli
```

## Benefits

- ✅ Consistent environment across team
- ✅ No local Node/pnpm installation needed
- ✅ Isolated dependencies
- ✅ Pre-configured tools and extensions
- ✅ Easy onboarding for new developers

## Learn More

- [VS Code Dev Containers](https://code.visualstudio.com/docs/devcontainers/containers)
- [Dev Containers specification](https://containers.dev/)
