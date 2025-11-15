# Docker Current Setup Documentation

**Environment:** Ubuntu 24.04.3 LTS on WSL2 (Windows 11)
**Docker Installation:** Docker Desktop 4.50.0 (209931)
**Last Updated:** 2025-11-13
**Status:** ✅ Fully Operational

---

## Installation Overview

### Architecture
- **Installation Type:** Docker Desktop for Windows with WSL2 Backend
- **Management:** GUI + CLI (hybrid approach)
- **Integration:** Native Windows/WSL2 file system integration
- **Updates:** Automatic via Docker Desktop updater

### Version Information

**Client:**
- Version: 28.5.1
- API version: 1.51
- Go version: go1.24.8
- Git commit: e180ab8
- Built: Wed Oct 8 12:16:30 2025
- OS/Arch: linux/amd64
- Context: default

**Server (Docker Desktop 4.50.0):**
- Engine Version: 28.5.1
- API version: 1.51 (minimum version 1.24)
- Go version: go1.24.8
- Git commit: f8215cc
- Built: Wed Oct 8 12:17:24 2025
- OS/Arch: linux/amd64
- Experimental: false

**Container Runtime:**
- containerd: 1.7.27 (GitCommit: 05044ec0a9a75232cad458027ca83437aae3f4da)
- runc: 1.2.5 (GitCommit: v1.2.5-0-g59923ef)
- docker-init: 0.19.0 (GitCommit: de40ad0)

---

## System Configuration

### Docker Daemon Settings

- **Storage Driver:** overlayfs
- **Cgroup Driver:** cgroupfs
- **Cgroup Version:** 2
- **Kernel Version:** 6.6.87.2-microsoft-standard-WSL2
- **Operating System:** Docker Desktop
- **OS Type:** linux
- **Architecture:** x86_64
- **CPUs Allocated:** 32
- **Total Memory:** 16 GB (16,261,447,680 bytes)
- **Docker Root Directory:** `/var/lib/docker`

### Performance Characteristics

**Resource Allocation:**
- ✅ 32 CPU cores available (full host allocation)
- ✅ 16GB RAM allocated
- ✅ Dynamic disk allocation (Docker Desktop manages)

**Overhead:**
- Docker Desktop service: ~200-500MB RAM overhead
- GUI and management services: ~200MB
- Total overhead: ~400-700MB

---

## CLI Plugins & Extensions

### Installed Plugins

1. **docker-ai** (v1.9.11)
   - Purpose: Docker AI Agent for intelligent assistance
   - Status: ✅ Active

2. **docker-buildx** (v0.29.1-desktop.1)
   - Purpose: Docker build with BuildKit extensions
   - Features: Multi-platform builds, caching, advanced build strategies
   - Status: ✅ Active

3. **docker-compose** (v2.40.3-desktop.1)
   - Purpose: Multi-container application orchestration
   - Status: ✅ Active (used by HarvestFlow, mcp-cloud-demo, FlashFusion)

4. **docker-debug** (0.0.45)
   - Purpose: Container debugging utilities
   - Status: ✅ Active

5. **docker-desktop** (v0.2.0)
   - Purpose: Docker Desktop-specific commands
   - Status: ✅ Active

### Available Extensions

- **Portainer Docker Extension** (2.33.3)
  - Visual container management
  - Image: `portainer/portainer-docker-extension:2.33.3` (248MB)

---

## Active Workloads

### Running Containers (3 active)

| Name | Image | Status | Ports | Purpose |
|------|-------|--------|-------|---------|
| `k8s_mcp-server_..._l5shx` | `2229d7c38096` | Up 2 hours | - | MCP Cloud Server (k8s pod 1) |
| `k8s_mcp-server_..._5h8nj` | `2229d7c38096` | Up 2 hours | - | MCP Cloud Server (k8s pod 2) |
| `harvestflow-harvestflow-1` | `harvestflow/local` | Up 2 hours | `5173->5173/tcp` | HarvestFlow local development |

**Notes:**
- MCP (Model Context Protocol) servers running in Kubernetes
- HarvestFlow accessible at http://localhost:5173

### Cached Images (14+ images)

| Repository | Tag | Size | Purpose |
|------------|-----|------|---------|
| `mcp-cloud-server` | latest | 373MB | MCP cloud infrastructure |
| `mcp/aks` | - | 1.66GB | Azure Kubernetes Service integration |
| `mcp/playwright` | - | 1.67GB | Browser automation for MCP |
| `portainer/portainer-docker-extension` | 2.33.3 | 248MB | Container management UI |
| `mcp/mongodb` | - | 430MB | MongoDB MCP server |
| `mcp/api-mcp-server` | - | 281MB | API MCP server |
| `mcp/elevenlabs` | - | 695MB | ElevenLabs AI integration |
| `mcp/firecrawl` | - | 442MB | Web scraping MCP server |
| `mcp/desktop-commander` | - | 679MB | Desktop automation |
| `mcp/brave-search` | - | 288MB | Brave search integration |
| `nginx` | latest | 225MB | Web server |
| `mcr.microsoft.com/azure-sdk/azure-mcp` | - | 559MB | Azure SDK MCP server |
| `public.ecr.aws/supabase/realtime` | v2.57.3 | 628MB | Supabase realtime |
| `harvestflow/local` | latest | 534MB | HarvestFlow development |

**Total Image Storage:** ~9.5GB

---

## Kubernetes Integration

### Local Kubernetes Cluster

Docker Desktop includes a single-node Kubernetes cluster:

**Cluster Info:**
- Context: `docker-desktop`
- Node: `docker-desktop` (Ready)
- Version: v1.32.2
- Status: ✅ Running

**Active Namespaces:**
- `mcp-servers` - MCP cloud server deployments
- `default` - Default workloads

**kubectl Configuration:**
```bash
kubectl version --client
kubectl config current-context  # docker-desktop
kubectl get nodes                # 1 node ready
kubectl get pods -A              # Active pods across namespaces
```

---

## Project Integration

### Projects Using Docker

1. **HarvestFlow** (`/home/kyler/HarvestFlow/`)
   - Files: `Dockerfile`, `docker-compose.yml`, `.dockerignore`
   - Status: ✅ Running on port 5173
   - Container: `harvestflow-harvestflow-1`

2. **mcp-cloud-demo** (`/home/kyler/mcp-cloud-demo/`)
   - Files: `Dockerfile`, `.dockerignore`
   - Status: Multiple MCP servers deployed to Kubernetes
   - Images: Various MCP service images

3. **FlashFusion Consolidated** (multiple locations)
   - Packages: `ai-core`, `shared`
   - Files: `Dockerfile`, `docker-compose.yml`, `docker-compose.dev.yml`
   - Status: Ready to deploy (not currently running)
   - Locations:
     - `/home/kyler/projects/flashfusion/flashfusion-consolidated/`
     - `/home/kyler/source-of-truth-monorepo/projects/local/flashfusion-consolidated/`

---

## Configuration Files

### Docker Desktop Managed Configuration

**Location:** Managed internally by Docker Desktop (not in standard `/etc/docker/`)

**Equivalent Production Settings:**
```json
{
  "storage-driver": "overlayfs",
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "10m",
    "max-file": "3"
  },
  "default-ulimits": {
    "nofile": {
      "Name": "nofile",
      "Hard": 64000,
      "Soft": 64000
    }
  },
  "features": {
    "buildkit": true
  }
}
```

**Note:** Docker Desktop manages these settings via GUI. For manual WSL2 Docker setup with custom daemon.json, see:
- `/home/kyler/docs/gists/docker-wsl2-setup/DOCKER_COMPLETE_SETUP_GUIDE.md`
- `/home/kyler/docs/DOCKER_DESKTOP_VS_MANUAL.md`

### User Configuration

**Docker CLI Config:** `/home/kyler/.docker/config.json`
- Credential helpers
- Experimental features
- CLI plugins

**BuildKit Cache:** `/home/kyler/.docker/buildx/`

---

## Network Configuration

### Docker Networks

```bash
docker network ls
```

**Default Networks:**
- `bridge` - Default network for containers
- `host` - Host network mode
- `none` - No networking

**Custom Networks:**
- Project-specific networks created by docker-compose

---

## Volume Management

### Docker Volumes

```bash
docker volume ls
```

**Managed by:**
- Docker Desktop (automatic pruning available via GUI)
- docker-compose (project-specific volumes)

**Storage Location:** `/var/lib/docker/volumes/`

---

## Operational Workflows

### Starting Docker

**Automatic:**
- Docker Desktop starts with Windows
- WSL2 backend initializes automatically
- No manual daemon management required

**Manual Control:**
- Open Docker Desktop GUI
- Right-click system tray icon > Settings

### Common Commands

```bash
# Check status
docker ps
docker stats

# Build images
docker build -t myapp:latest .
docker buildx build --platform linux/amd64,linux/arm64 -t myapp:latest .

# Run containers
docker run -d -p 8080:80 myapp:latest
docker-compose up -d

# Cleanup
docker system prune -a --volumes
docker image prune
docker container prune
```

### Docker Compose Workflows

```bash
# Start services
cd /home/kyler/HarvestFlow
docker-compose up -d

# View logs
docker-compose logs -f

# Stop services
docker-compose down

# Rebuild and restart
docker-compose up -d --build
```

---

## Monitoring & Troubleshooting

### Health Checks

```bash
# Overall system status
docker system df

# Container logs
docker logs <container_name>
docker-compose logs -f

# Resource usage
docker stats

# Events monitoring
docker events
```

### Docker Desktop Diagnostics

**GUI Tools:**
- Docker Desktop > Troubleshoot > Get support
- Docker Desktop > Troubleshoot > Run diagnostics
- Docker Desktop > Settings > Resources (monitor CPU/memory)

**CLI Diagnostics:**
```bash
docker version
docker info
docker system info
```

### Common Issues & Solutions

1. **WSL2 Integration Issues**
   - Solution: Docker Desktop > Settings > Resources > WSL Integration
   - Ensure Ubuntu distribution is enabled

2. **Performance Degradation**
   - Solution: Docker Desktop > Settings > Resources
   - Adjust CPU/memory allocation
   - Enable "Use virtualization framework" (if available)

3. **Image Pull Failures**
   - Solution: Check network connectivity
   - Restart Docker Desktop
   - Clear image cache if needed

4. **Port Conflicts**
   - Solution: `docker ps` to identify conflicting containers
   - Change port mapping in docker-compose.yml

**Detailed Troubleshooting:**
See `/home/kyler/docs/DOCKER_TROUBLESHOOTING.md` for comprehensive troubleshooting procedures.

---

## Security Considerations

### Current Security Posture

✅ **Strengths:**
- Latest Docker Engine version (28.5.1)
- Regular automatic updates via Docker Desktop
- cgroups v2 for improved isolation
- BuildKit enabled (secure build features)

⚠️ **Considerations:**
- Docker Desktop runs with elevated privileges
- Containers share kernel with host (WSL2)
- No additional security scanning configured

### Recommended Security Tools

```bash
# Image vulnerability scanning
docker scan <image_name>

# Use Snyk for deeper analysis (already installed)
snyk container test <image_name>

# SBOM generation (Syft installed)
syft <image_name> -o json > sbom.json

# Container signing (Cosign installed)
cosign sign --key cosign.key <image_name>
```

**Security Documentation:**
- See `/home/kyler/SBOM_SLSA_SECURITY.md` for supply chain security
- See `/home/kyler/CLAUDE.md` for security scanning requirements

---

## Maintenance Procedures

### Regular Maintenance

**Weekly:**
```bash
# Remove unused images
docker image prune -a

# Remove stopped containers
docker container prune

# Remove unused volumes
docker volume prune

# Remove unused networks
docker network prune
```

**Monthly:**
```bash
# Full system cleanup (caution: removes all unused resources)
docker system prune -a --volumes

# Update Docker Desktop via GUI
# Docker Desktop > Check for updates
```

**Quarterly:**
- Review and update Dockerfiles
- Audit running containers
- Review resource allocation
- Update base images

---

## Comparison with Manual WSL2 Docker

**Why Docker Desktop was chosen:**
- ✅ Zero-configuration setup
- ✅ Automatic updates
- ✅ Kubernetes included
- ✅ GUI for troubleshooting
- ✅ Windows integration seamless
- ✅ Docker AI assistant included

**Trade-offs:**
- ⚠️ Higher resource overhead (~400-700MB)
- ⚠️ Less control over daemon.json
- ⚠️ Proprietary components

**Alternative:**
For production-parity WSL2 setup or lightweight alternative, see:
- `/home/kyler/docs/gists/docker-wsl2-setup/DOCKER_COMPLETE_SETUP_GUIDE.md`
- `/home/kyler/docs/DOCKER_DESKTOP_VS_MANUAL.md`

---

## Backup & Disaster Recovery

### What to Backup

1. **Container Images** (if custom-built)
   ```bash
   docker save -o backup.tar myapp:latest
   ```

2. **Volumes with persistent data**
   ```bash
   docker run --rm -v myvolume:/data -v $(pwd):/backup ubuntu tar czf /backup/volume-backup.tar.gz /data
   ```

3. **Docker Compose configurations**
   - Already in git repositories (HarvestFlow, FlashFusion, etc.)

4. **Build contexts and Dockerfiles**
   - Version controlled in project repositories

### Recovery Procedure

1. **Reinstall Docker Desktop** from https://www.docker.com/products/docker-desktop
2. **Enable WSL2 Integration** in Docker Desktop settings
3. **Restore images:**
   ```bash
   docker load -i backup.tar
   ```
4. **Restore volumes:**
   ```bash
   docker run --rm -v myvolume:/data -v $(pwd):/backup ubuntu tar xzf /backup/volume-backup.tar.gz -C /
   ```
5. **Rebuild containers:**
   ```bash
   cd /home/kyler/HarvestFlow
   docker-compose up -d
   ```

---

## Integration with Development Tools

### Claude Code Integration
- Docker commands available via Bash tool
- Container inspection and debugging
- Dockerfile generation and optimization

### VS Code/Cursor Integration
- Docker extension installed (Windows side)
- Remote - Containers extension
- Dev Container support

### GitHub Actions Integration
- Docker images built in CI/CD
- Container registry push workflows
- Multi-platform builds with buildx

---

## Performance Optimization

### Current Optimizations

✅ BuildKit enabled (faster builds, better caching)
✅ Layer caching configured
✅ Multi-stage builds used in projects
✅ .dockerignore files present

### Recommended Optimizations

```dockerfile
# Use specific base image versions (not latest)
FROM node:22.19.0-alpine

# Leverage build cache by ordering commands efficiently
COPY package*.json ./
RUN npm ci --only=production

# Multi-stage builds to reduce image size
FROM node:22.19.0-alpine AS builder
WORKDIR /app
COPY . .
RUN npm run build

FROM nginx:alpine
COPY --from=builder /app/dist /usr/share/nginx/html
```

---

## Related Documentation

- `/home/kyler/docs/gists/GIST_INDEX.md` - GitHub gists inventory
- `/home/kyler/docs/gists/docker-wsl2-setup/DOCKER_COMPLETE_SETUP_GUIDE.md` - Manual WSL2 Docker setup
- `/home/kyler/docs/DOCKER_DESKTOP_VS_MANUAL.md` - Docker installation comparison
- `/home/kyler/docs/DOCKER_TROUBLESHOOTING.md` - Troubleshooting procedures
- `/home/kyler/CLAUDE.md` - Claude Operations Charter
- `/home/kyler/SBOM_SLSA_SECURITY.md` - Security and supply chain

---

## Summary

**Status:** ✅ Fully Operational and Production-Ready

**Key Strengths:**
- Latest Docker Engine (28.5.1)
- Kubernetes integrated and running
- Active projects successfully containerized
- MCP infrastructure deployed
- Automatic updates and management
- Rich ecosystem of plugins and extensions

**Recommended Actions:**
- ✅ Current setup is stable - no immediate changes needed
- 📋 Monitor resource usage periodically
- 🔄 Keep Docker Desktop updated
- 📊 Consider security scanning for production images
- 📝 Document project-specific Docker workflows

**Last Verified:** 2025-11-13
**Next Review:** 2025-12-13
