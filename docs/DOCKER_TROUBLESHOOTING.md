# Docker Troubleshooting Guide

**Applies To:** Both Docker Desktop and Manual WSL2 Docker installations
**Last Updated:** 2025-11-13
**Source:** Compiled from production experience and WSL2 setup gist

---

## Table of Contents

1. [Common Issues](#common-issues)
2. [Docker Desktop Specific](#docker-desktop-specific)
3. [Manual WSL2 Docker Specific](#manual-wsl2-docker-specific)
4. [Container Issues](#container-issues)
5. [Network Issues](#network-issues)
6. [Storage & Performance](#storage--performance)
7. [BuildKit & Build Issues](#buildkit--build-issues)
8. [Kubernetes Issues](#kubernetes-issues)
9. [Diagnostic Commands](#diagnostic-commands)
10. [Emergency Recovery](#emergency-recovery)

---

## Common Issues

### Issue: Cannot Connect to Docker Daemon

**Symptoms:**
```
Cannot connect to the Docker daemon at unix:///var/run/docker.sock.
Is the docker daemon running?
```

**Diagnosis:**
```bash
# Check if daemon is running
ps aux | grep dockerd

# Check socket exists and permissions
ls -la /var/run/docker.sock

# Try to get daemon info
docker info
```

**Solutions:**

**For Docker Desktop:**
1. Check Docker Desktop is running:
   - Look for Docker icon in Windows system tray
   - Right-click icon → "Docker Desktop is running"

2. Restart Docker Desktop:
   - Right-click Docker icon → Quit Docker Desktop
   - Relaunch Docker Desktop from Start menu

3. Check WSL integration:
   - Docker Desktop → Settings → Resources → WSL Integration
   - Ensure your Ubuntu distribution is enabled
   - Click "Apply & Restart"

**For Manual WSL2 Docker:**
1. Start the daemon:
   ```bash
   start-docker.sh
   ```

2. Check for stale socket:
   ```bash
   sudo rm -f /var/run/docker.sock
   start-docker.sh
   ```

3. Start daemon manually to see errors:
   ```bash
   sudo dockerd
   ```

---

### Issue: Permission Denied

**Symptoms:**
```
Got permission denied while trying to connect to the Docker daemon socket
```

**Diagnosis:**
```bash
# Check current user groups
groups

# Check docker group exists
getent group docker

# Check socket ownership
ls -la /var/run/docker.sock
```

**Solutions:**

**Add user to docker group:**
```bash
sudo usermod -aG docker $USER
```

**IMPORTANT:** You MUST completely close your terminal and open a new one for group changes to take effect.

**Verify group membership:**
```bash
groups | grep docker
```

**Alternative (temporary, not recommended for production):**
```bash
# Use sudo (temporary solution only)
sudo docker ps

# Fix socket permissions (not recommended)
sudo chmod 666 /var/run/docker.sock
```

---

### Issue: Docker Commands Hang or Timeout

**Symptoms:**
- `docker ps` hangs indefinitely
- Commands timeout after 30 seconds
- No error message, just frozen

**Diagnosis:**
```bash
# Check daemon process
ps aux | grep dockerd

# Check for zombie processes
ps aux | grep defunct | grep docker

# Check system resources
free -h
df -h
```

**Solutions:**

1. **Kill and restart Docker:**
   ```bash
   # Kill all Docker processes
   sudo pkill -9 dockerd
   sudo pkill -9 containerd

   # Clean up
   sudo rm -f /var/run/docker.sock
   sudo rm -f /var/run/docker.pid

   # Restart (method depends on installation)
   start-docker.sh         # Manual WSL2
   # OR restart Docker Desktop via GUI
   ```

2. **Check WSL2 resources:**
   ```bash
   # View WSL2 memory usage
   wsl --status

   # Restart WSL2 (from Windows PowerShell)
   wsl --shutdown
   # Then reopen Ubuntu
   ```

3. **Check for disk space issues:**
   ```bash
   df -h /var/lib/docker

   # Clean up if needed
   docker system prune -a --volumes
   ```

---

### Issue: "Waiting for Docker to be ready..." Hangs

**Applies To:** Manual WSL2 Docker installation

**Possible Causes:**
1. Docker daemon binary not found
2. Permission issues
3. Port/socket conflicts
4. WSL2 resource limits
5. Configuration errors in daemon.json

**Solutions:**

#### 1. Check Docker Binary Exists
```bash
ls -lh /home/kyler/.local/bin/dockerd
which dockerd

# If not found, check installation
docker --version
which docker
```

#### 2. Check for Socket Conflicts
```bash
# Remove stale socket
sudo rm -f /var/run/docker.sock

# Check if something is using the socket
sudo lsof /var/run/docker.sock

# Check for process conflicts
ps aux | grep dockerd
```

#### 3. Check Docker Daemon Logs
```bash
# View recent logs
sudo tail -50 /tmp/docker.log

# Or run daemon directly to see errors
sudo /home/kyler/.local/bin/dockerd
# Press Ctrl+C to stop

# With verbose logging
sudo dockerd --debug
```

#### 4. Check WSL2 Integration
```bash
# Verify WSL2 is running
wsl --status

# Check WSL2 kernel version
uname -r
# Should show: x.x.x-microsoft-standard-WSL2

# Check WSL2 version
wsl --list --verbose
```

#### 5. Validate daemon.json
```bash
# Check config syntax
cat /etc/docker/daemon.json

# Validate configuration
sudo dockerd --validate

# Common syntax errors:
# - Missing commas
# - Trailing commas
# - Incorrect quotes
# - Invalid JSON structure
```

---

## Docker Desktop Specific

### Issue: Docker Desktop Won't Start

**Symptoms:**
- Docker Desktop icon shows error
- "Docker Desktop starting..." never completes
- "An unexpected error occurred" message

**Solutions:**

1. **Check Windows services:**
   ```powershell
   # From PowerShell (Admin)
   Get-Service -Name "com.docker.service"
   Restart-Service -Name "com.docker.service"
   ```

2. **Reset Docker Desktop:**
   - Docker Desktop → Troubleshoot → Reset to factory defaults
   - ⚠️ This will delete all containers, images, and volumes

3. **Check WSL2 backend:**
   ```bash
   wsl --list --verbose
   # Ensure WSL2 is version 2, not 1

   # Update WSL2 if needed (from PowerShell Admin)
   wsl --update
   wsl --set-default-version 2
   ```

4. **Reinstall Docker Desktop:**
   - Uninstall via Windows Settings → Apps
   - Download latest from docker.com
   - Reinstall with "Use WSL2 instead of Hyper-V" option

---

### Issue: WSL Integration Not Working

**Symptoms:**
- `docker` command not found in WSL2
- Docker works in Windows, not in Ubuntu
- "Cannot connect to Docker daemon" in WSL2

**Solutions:**

1. **Enable WSL integration:**
   - Docker Desktop → Settings → Resources → WSL Integration
   - Enable integration with Ubuntu/your distribution
   - Click "Apply & Restart"

2. **Check docker command path:**
   ```bash
   which docker
   # Should show: /usr/bin/docker or /mnt/c/Program\ Files/Docker/Docker/resources/bin/docker

   echo $PATH | grep -i docker
   ```

3. **Manually add Docker to PATH (if needed):**
   ```bash
   echo 'export PATH="$PATH:/mnt/c/Program Files/Docker/Docker/resources/bin"' >> ~/.bashrc
   source ~/.bashrc
   ```

4. **Restart WSL2:**
   ```powershell
   # From Windows PowerShell
   wsl --shutdown
   # Then reopen Ubuntu terminal
   ```

---

### Issue: High Resource Usage (Docker Desktop)

**Symptoms:**
- High CPU usage when idle
- Excessive memory consumption
- Slow system performance

**Diagnosis:**
```bash
# Check Docker resource usage
docker stats

# Check Docker Desktop allocation
# Docker Desktop → Settings → Resources
```

**Solutions:**

1. **Adjust resource limits:**
   - Docker Desktop → Settings → Resources
   - Reduce CPUs (try 4-8 instead of all cores)
   - Reduce Memory (try 4-8GB instead of maximum)
   - Reduce Swap (1-2GB usually sufficient)

2. **Limit specific containers:**
   ```bash
   docker run -m 512m --cpus=".5" myimage

   # In docker-compose.yml:
   services:
     web:
       deploy:
         resources:
           limits:
             cpus: '0.5'
             memory: 512M
   ```

3. **Clean up unused resources:**
   ```bash
   docker system prune -a --volumes
   docker builder prune
   ```

4. **Disable unused features:**
   - Docker Desktop → Settings → Kubernetes → Disable (if not needed)
   - Docker Desktop → Settings → Extensions → Disable unused extensions

---

## Manual WSL2 Docker Specific

### Issue: Daemon Fails to Start

**Symptoms:**
```
failed to start daemon: Error initializing network controller
```

**Solutions:**

1. **Check iptables:**
   ```bash
   # WSL2 may have iptables issues
   sudo update-alternatives --set iptables /usr/sbin/iptables-legacy
   sudo update-alternatives --set ip6tables /usr/sbin/ip6tables-legacy
   ```

2. **Start daemon with --iptables=false:**
   ```bash
   # Edit start-docker.sh script
   sudo dockerd --iptables=false > /tmp/docker.log 2>&1 &
   ```

3. **Check for conflicting Docker installations:**
   ```bash
   # Check for Docker Desktop conflict
   ps aux | grep -i "docker desktop"

   # Ensure only one Docker daemon running
   ps aux | grep dockerd
   ```

---

### Issue: Cannot Use docker-compose

**Symptoms:**
```
docker-compose: command not found
```

**Solution:**

Install Docker Compose separately:
```bash
# Download latest docker-compose
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

# Make executable
sudo chmod +x /usr/local/bin/docker-compose

# Verify
docker-compose --version
```

Or use docker compose V2 (plugin):
```bash
# Install compose plugin
mkdir -p ~/.docker/cli-plugins/
curl -SL https://github.com/docker/compose/releases/latest/download/docker-compose-linux-x86_64 -o ~/.docker/cli-plugins/docker-compose
chmod +x ~/.docker/cli-plugins/docker-compose

# Use as: docker compose (note: no hyphen)
docker compose version
```

---

### Issue: Daemon Config Not Applied

**Symptoms:**
- Changes to /etc/docker/daemon.json not working
- Features like BuildKit not enabled

**Solutions:**

1. **Validate daemon.json syntax:**
   ```bash
   # Check for JSON errors
   cat /etc/docker/daemon.json | jq .

   # Validate with dockerd
   sudo dockerd --validate
   ```

2. **Restart daemon after config changes:**
   ```bash
   sudo pkill dockerd
   sudo rm -f /var/run/docker.sock
   start-docker.sh
   ```

3. **Check daemon is reading config:**
   ```bash
   # View active configuration
   docker info | grep -A 10 "Server Version"

   # Check specific settings
   docker info | grep "Storage Driver"
   docker info | grep "BuildKit"
   ```

---

## Container Issues

### Issue: Container Immediately Exits

**Diagnosis:**
```bash
# Check container logs
docker logs <container_name>

# Check exit code
docker ps -a --filter name=<container_name>
# Look at STATUS column for exit code
```

**Common Exit Codes:**
- Exit 0: Normal exit
- Exit 1: Application error
- Exit 137: Out of memory (killed by OOM)
- Exit 139: Segmentation fault
- Exit 143: Graceful termination (SIGTERM)

**Solutions:**

1. **Check logs for errors:**
   ```bash
   docker logs --tail 100 <container_name>
   ```

2. **Run container interactively to debug:**
   ```bash
   docker run -it <image> sh
   # Or
   docker run -it <image> bash
   ```

3. **Override entrypoint:**
   ```bash
   docker run -it --entrypoint /bin/sh <image>
   ```

4. **Check for missing files/dependencies:**
   ```bash
   docker exec -it <container_name> ls -la /app
   docker exec -it <container_name> cat /proc/1/status
   ```

---

### Issue: Container Cannot Connect to Network

**Symptoms:**
- `ping: unknown host` inside container
- Cannot reach external services
- DNS resolution failures

**Diagnosis:**
```bash
# Check container network
docker inspect <container_name> | grep -A 10 Networks

# Check DNS settings
docker exec <container_name> cat /etc/resolv.conf

# Test network from inside container
docker exec <container_name> ping -c 3 google.com
docker exec <container_name> nslookup google.com
```

**Solutions:**

1. **Set custom DNS:**
   ```bash
   docker run --dns 8.8.8.8 --dns 8.8.4.4 <image>

   # Or in daemon.json:
   {
     "dns": ["8.8.8.8", "8.8.4.4"]
   }
   ```

2. **Use host network (testing only):**
   ```bash
   docker run --network host <image>
   ```

3. **Check Docker network configuration:**
   ```bash
   docker network ls
   docker network inspect bridge
   ```

4. **Recreate default networks:**
   ```bash
   docker network prune
   # Restart Docker daemon
   ```

---

### Issue: Port Mapping Not Working

**Symptoms:**
- `localhost:8080` doesn't reach container
- Port already in use
- Connection refused

**Diagnosis:**
```bash
# Check port mappings
docker port <container_name>

# Check what's listening on port
sudo netstat -tlnp | grep 8080
# Or
sudo lsof -i :8080

# From Windows (if accessing from Windows):
netstat -ano | findstr :8080
```

**Solutions:**

1. **Use different port:**
   ```bash
   docker run -p 8081:80 nginx
   ```

2. **Kill process using port:**
   ```bash
   # Linux
   sudo kill $(sudo lsof -t -i:8080)

   # Windows (PowerShell Admin)
   $proc = Get-NetTCPConnection -LocalPort 8080
   Stop-Process -Id $proc.OwningProcess -Force
   ```

3. **Access from Windows (WSL2 specific):**
   ```bash
   # Find WSL2 IP
   ip addr show eth0 | grep inet

   # Access via: http://<WSL2_IP>:8080
   # Or enable port forwarding (Windows PowerShell Admin):
   netsh interface portproxy add v4tov4 listenport=8080 listenaddress=0.0.0.0 connectport=8080 connectaddress=<WSL2_IP>
   ```

4. **Bind to 0.0.0.0 instead of localhost:**
   ```bash
   docker run -p 0.0.0.0:8080:80 nginx
   ```

---

## Network Issues

### Issue: Containers Cannot Communicate

**Symptoms:**
- Container A cannot reach Container B
- `ping: network unreachable`
- HTTP requests timeout between containers

**Diagnosis:**
```bash
# Check networks
docker network ls

# Inspect container networks
docker inspect <container_a> | grep NetworkMode
docker inspect <container_b> | grep NetworkMode

# Check if on same network
docker network inspect bridge
```

**Solutions:**

1. **Put containers on same network:**
   ```bash
   docker network create mynet
   docker run --network mynet --name container_a alpine
   docker run --network mynet --name container_b alpine

   # Test connectivity
   docker exec container_a ping container_b
   ```

2. **Use docker-compose (automatic networking):**
   ```yaml
   version: '3.8'
   services:
     web:
       image: nginx
     api:
       image: myapi
       # Can reach web via http://web:80
   ```

3. **Link containers (legacy):**
   ```bash
   docker run --name db postgres
   docker run --link db:database myapp
   ```

---

## Storage & Performance

### Issue: Disk Space Full

**Symptoms:**
```
Error: No space left on device
```

**Diagnosis:**
```bash
# Check Docker disk usage
docker system df

# Detailed breakdown
docker system df -v

# Check system disk space
df -h /var/lib/docker
```

**Solutions:**

1. **Clean up unused resources:**
   ```bash
   # Remove stopped containers
   docker container prune

   # Remove unused images
   docker image prune -a

   # Remove unused volumes
   docker volume prune

   # Remove build cache
   docker builder prune

   # Nuclear option (removes EVERYTHING unused)
   docker system prune -a --volumes
   ```

2. **Identify large items:**
   ```bash
   # Largest images
   docker images --format "table {{.Repository}}\t{{.Tag}}\t{{.Size}}" | sort -k3 -h

   # Volumes by size
   docker system df -v | grep volume
   ```

3. **Increase Docker disk space (Docker Desktop):**
   - Docker Desktop → Settings → Resources → Disk image size
   - Increase slider value
   - Apply & Restart

---

### Issue: Slow Build Performance

**Symptoms:**
- Builds take very long
- Each layer takes minutes
- No cache being used

**Solutions:**

1. **Enable BuildKit:**
   ```bash
   # Use BuildKit for faster builds
   DOCKER_BUILDKIT=1 docker build .

   # Or enable in daemon.json:
   {
     "features": {
       "buildkit": true
     }
   }
   ```

2. **Optimize Dockerfile layer caching:**
   ```dockerfile
   # Bad: Invalidates cache on any file change
   COPY . /app
   RUN npm install

   # Good: Cache dependencies separately
   COPY package*.json /app/
   RUN npm install
   COPY . /app
   ```

3. **Use .dockerignore:**
   ```
   node_modules
   .git
   .env
   *.log
   ```

4. **Use multi-stage builds:**
   ```dockerfile
   FROM node:18 AS builder
   WORKDIR /app
   COPY package*.json ./
   RUN npm ci
   COPY . .
   RUN npm run build

   FROM nginx:alpine
   COPY --from=builder /app/dist /usr/share/nginx/html
   ```

5. **Check DNS resolution:**
   ```bash
   # Slow package downloads may be DNS issues
   docker build --network=host .
   ```

---

## BuildKit & Build Issues

### Issue: BuildKit Build Failures

**Symptoms:**
```
failed to solve with frontend dockerfile.v0
```

**Solutions:**

1. **Disable BuildKit temporarily:**
   ```bash
   DOCKER_BUILDKIT=0 docker build .
   ```

2. **Clear BuildKit cache:**
   ```bash
   docker builder prune

   # Or
   docker buildx prune
   ```

3. **Check BuildKit version:**
   ```bash
   docker buildx version
   ```

---

## Kubernetes Issues

**(Docker Desktop Kubernetes Only)**

### Issue: Kubernetes Cluster Won't Start

**Symptoms:**
- "Kubernetes is starting..." never completes
- `kubectl` commands fail

**Solutions:**

1. **Reset Kubernetes:**
   - Docker Desktop → Settings → Kubernetes → Reset Kubernetes Cluster
   - ⚠️ This deletes all k8s resources

2. **Check kubectl context:**
   ```bash
   kubectl config get-contexts
   kubectl config use-context docker-desktop
   ```

3. **Disable and re-enable Kubernetes:**
   - Docker Desktop → Settings → Kubernetes
   - Uncheck "Enable Kubernetes"
   - Apply & Restart
   - Re-enable and Apply & Restart

---

### Issue: Pods Stuck in Pending

**Diagnosis:**
```bash
kubectl get pods
kubectl describe pod <pod_name>
kubectl get events --sort-by='.lastTimestamp'
```

**Solutions:**

1. **Check resource requests:**
   ```bash
   kubectl describe node docker-desktop
   # Check Allocated resources vs Capacity
   ```

2. **Reduce resource requests in deployment:**
   ```yaml
   resources:
     requests:
       memory: "64Mi"
       cpu: "100m"
   ```

3. **Check for image pull issues:**
   ```bash
   kubectl describe pod <pod_name> | grep -A 5 Events
   ```

---

## Diagnostic Commands

### General Diagnostics

```bash
# Docker version and info
docker version
docker info

# Check daemon logs (Docker Desktop)
# Windows: %APPDATA%\Docker\log\vm\dockerd.log

# Check daemon logs (Manual WSL2)
sudo tail -f /tmp/docker.log

# System diagnostics
docker system df
docker system events
docker system info

# Network diagnostics
docker network ls
docker network inspect bridge

# Process tree
ps auxf | grep docker
```

### Container Diagnostics

```bash
# Detailed container info
docker inspect <container_name>

# Container logs
docker logs --tail 100 --timestamps <container_name>
docker logs --follow <container_name>

# Container process list
docker top <container_name>

# Container resource usage
docker stats <container_name>

# Execute commands in container
docker exec -it <container_name> sh
docker exec <container_name> cat /etc/os-release
```

### Image Diagnostics

```bash
# Image history
docker history <image_name>

# Image inspection
docker inspect <image_name>

# Scan for vulnerabilities
docker scan <image_name>

# Check image layers
docker image inspect <image_name> --format='{{.RootFS.Layers}}'
```

---

## Emergency Recovery

### Complete Docker Reset (Docker Desktop)

**⚠️ WARNING: This deletes ALL containers, images, volumes, and networks**

```bash
# Option 1: GUI
# Docker Desktop → Troubleshoot → Clean / Purge data

# Option 2: Factory Reset
# Docker Desktop → Troubleshoot → Reset to factory defaults
```

### Complete Docker Reset (Manual WSL2)

**⚠️ WARNING: This removes all Docker data**

```bash
# Stop Docker
sudo pkill dockerd
sudo pkill containerd

# Remove all Docker data
sudo rm -rf /var/lib/docker
sudo rm -rf /etc/docker

# Remove startup script
sudo rm -f /usr/local/bin/start-docker.sh

# Remove user from group
sudo gpasswd -d $USER docker

# Clean up sockets
sudo rm -f /var/run/docker.sock
sudo rm -f /var/run/docker.pid

# Reinstall using setup guide
# See: /home/kyler/docs/gists/docker-wsl2-setup/DOCKER_COMPLETE_SETUP_GUIDE.md
```

### Backup Before Reset

```bash
# Save important images
docker save -o myimage.tar myimage:tag

# Backup volumes
docker run --rm -v myvolume:/data -v $(pwd):/backup ubuntu tar czf /backup/volume-backup.tar.gz /data

# Export containers
docker export <container_name> > container-backup.tar

# Restore after reset:
docker load -i myimage.tar
docker import container-backup.tar myimage:tag
```

---

## Quick Reference

### Start/Stop Docker

```bash
# Docker Desktop
# Use GUI or:
# Windows: Start/Stop from system tray

# Manual WSL2
start-docker.sh              # Start
sudo pkill dockerd           # Stop
ps aux | grep dockerd        # Check status
```

### Clean Up Commands

```bash
# Remove stopped containers
docker container prune

# Remove unused images
docker image prune -a

# Remove unused volumes
docker volume prune

# Remove unused networks
docker network prune

# Remove build cache
docker builder prune

# Everything unused (nuclear option)
docker system prune -a --volumes
```

### Get Help

```bash
# Docker Desktop
# GUI → Troubleshoot → Get support → Run diagnostics

# Check documentation
# Docker Desktop: https://docs.docker.com/desktop/
# Manual WSL2: /home/kyler/docs/gists/docker-wsl2-setup/

# Community support
# Docker Forums: https://forums.docker.com/
# Stack Overflow: https://stackoverflow.com/questions/tagged/docker
```

---

## Related Documentation

- `/home/kyler/docs/DOCKER_CURRENT_SETUP.md` - Current Docker Desktop configuration
- `/home/kyler/docs/DOCKER_DESKTOP_VS_MANUAL.md` - Installation comparison
- `/home/kyler/docs/gists/docker-wsl2-setup/DOCKER_COMPLETE_SETUP_GUIDE.md` - Manual WSL2 setup guide
- `/home/kyler/docs/gists/GIST_INDEX.md` - GitHub gists inventory
- `/home/kyler/CLAUDE.md` - Claude Operations Charter
- `/home/kyler/SBOM_SLSA_SECURITY.md` - Security procedures

---

**Last Updated:** 2025-11-13
**Tested On:** Docker Desktop 4.50.0, Docker Engine 28.5.1, WSL2 Ubuntu 24.04
