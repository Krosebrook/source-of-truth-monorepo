# FlashFusion SoT Development Container
FROM mcr.microsoft.com/devcontainers/typescript-node:20-bullseye

# Install additional tools
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get install -y --no-install-recommends \
        postgresql-client \
        redis-tools \
        vim \
        less \
        curl \
        wget \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*

# Install pnpm globally
RUN corepack enable && corepack prepare pnpm@9.0.0 --activate

# Set up workspace
WORKDIR /workspace

# Copy package files for caching
COPY package.json pnpm-workspace.yaml pnpm-lock.yaml* ./

# Keep container alive
CMD ["sleep", "infinity"]
