#!/usr/bin/env bash
# enhanced-bootstrap.sh - Comprehensive Project-specific development environment setup
# Includes 65+ modern development tools, AI-assisted development, and full-stack capabilities
# Usage: ./enhanced-bootstrap.sh [config-file]

set -euo pipefail

# Color output for better readability
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

echo_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

echo_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

echo_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

# Load project config if it exists
if [ -f ".project-config" ]; then
    echo_info "Loading project config from .project-config"
    source .project-config
elif [ -f "$1" ] 2>/dev/null; then
    echo_info "Loading project config from $1"
    source "$1"
else
    echo_warning "No project config found, using defaults"
fi

# Set defaults for all variables
PROJECT_NAME="${PROJECT_NAME:-default-project}"
NODE_VERSION="${NODE_VERSION:-lts}"
PYTHON_VERSION="${PYTHON_VERSION:-3.12.2}"
RUST_VERSION="${RUST_VERSION:-stable}"
GO_VERSION="${GO_VERSION:-latest}"
PROJECT_DIR="${PROJECT_DIR:-$HOME/projects/$PROJECT_NAME}"
EXTRA_NPM_PACKAGES="${EXTRA_NPM_PACKAGES:-}"
EXTRA_PIP_PACKAGES="${EXTRA_PIP_PACKAGES:-}"
EXTRA_PIPX_PACKAGES="${EXTRA_PIPX_PACKAGES:-}"
EXTRA_APT_PACKAGES="${EXTRA_APT_PACKAGES:-}"
EXTRA_CARGO_PACKAGES="${EXTRA_CARGO_PACKAGES:-}"
EXTRA_GO_PACKAGES="${EXTRA_GO_PACKAGES:-}"
AI_TOOLS="${AI_TOOLS:-true}"
DEVOPS_TOOLS="${DEVOPS_TOOLS:-true}"
DATABASE_TOOLS="${DATABASE_TOOLS:-true}"
CREATIVE_TOOLS="${CREATIVE_TOOLS:-false}"
SKIP_BASE_SETUP="${SKIP_BASE_SETUP:-false}"
SKIP_DOCKER="${SKIP_DOCKER:-false}"
SKIP_RUST="${SKIP_RUST:-true}"
SKIP_GO="${SKIP_GO:-true}"

# Display configuration
echo ""
echo_info "==================== Configuration ===================="
echo_info "Project Name: $PROJECT_NAME"
echo_info "Project Directory: $PROJECT_DIR"
echo_info "Node.js Version: $NODE_VERSION"
echo_info "Python Version: $PYTHON_VERSION"
[ -n "$EXTRA_NPM_PACKAGES" ] && echo_info "Extra NPM Packages: $EXTRA_NPM_PACKAGES"
[ -n "$EXTRA_PIP_PACKAGES" ] && echo_info "Extra PIP Packages: $EXTRA_PIP_PACKAGES"
[ -n "$EXTRA_PIPX_PACKAGES" ] && echo_info "Extra PIPX Packages: $EXTRA_PIPX_PACKAGES"
[ -n "$EXTRA_APT_PACKAGES" ] && echo_info "Extra APT Packages: $EXTRA_APT_PACKAGES"
echo_info "========================================================"
echo ""

# Create project directory
mkdir -p "$PROJECT_DIR"
cd "$PROJECT_DIR"

# Base system setup
if [ "$SKIP_BASE_SETUP" != "true" ]; then
    echo_info "Installing base system packages..."
    sudo apt update
    sudo apt upgrade -y
    sudo apt install -y \
        build-essential \
        curl \
        git \
        unzip \
        ca-certificates \
        wget \
        software-properties-common \
        pkg-config \
        libssl-dev \
        zlib1g-dev \
        libbz2-dev \
        libreadline-dev \
        libsqlite3-dev \
        libffi-dev \
        libncursesw5-dev \
        make \
        jq \
        tree \
        htop \
        vim \
        neovim \
        tmux \
        ripgrep \
        fd-find \
        bat \
        exa \
        zsh \
        fish \
        direnv \
        sqlite3 \
        postgresql-client \
        mysql-client \
        redis-tools \
        nginx \
        apache2-utils \
        graphviz \
        imagemagick \
        ffmpeg \
        pandoc \
        $EXTRA_APT_PACKAGES
    echo_success "Base packages installed"
else
    echo_warning "Skipping base system setup"
fi

# Node.js setup
echo_info "Setting up Node.js environment..."
if [ ! -d "$HOME/.nvm" ]; then
    echo_info "Installing NVM..."
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
else
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
fi

# Install and use specified Node version
if [ "$NODE_VERSION" = "lts" ]; then
    nvm install --lts
    nvm use --lts
else
    nvm install "$NODE_VERSION"
    nvm use "$NODE_VERSION"
fi

# Create .nvmrc for this project
echo "$NODE_VERSION" > .nvmrc
echo_success "Node.js $NODE_VERSION configured for project"

# Install global NPM packages
echo_info "Installing NPM packages..."
npm install -g pnpm yarn

# Install core development tools
if [ "$SKIP_BASE_SETUP" != "true" ]; then
    echo_info "Installing core development CLIs..."
    npm install -g \
        @anthropic-ai/claude-code \
        openai \
        vercel \
        netlify-cli \
        firebase-tools \
        @railway/cli \
        heroku \
        gh \
        glab \
        @shopify/cli \
        wrangler \
        serverless \
        aws-cdk \
        azure-cli \
        @google-cloud/cli
fi

# Install AI-assisted development tools
if [ "$AI_TOOLS" = "true" ]; then
    echo_info "Installing AI development tools..."
    npm install -g \
        cursor-ide \
        windsurf-editor \
        @replit/cli || echo_warning "Some AI tools may not be available via npm"
    
    # Install GitHub Copilot CLI if available
    gh extension install github/gh-copilot || echo_warning "GitHub Copilot CLI not available"
fi

# Install modern development utilities
echo_info "Installing modern development utilities..."
npm install -g \
    typescript \
    tsx \
    nodemon \
    concurrently \
    cross-env \
    rimraf \
    dotenv-cli \
    serve \
    http-server \
    live-server \
    json-server \
    pm2 \
    forever \
    npm-check-updates \
    depcheck

# Install extra NPM packages if specified
if [ -n "$EXTRA_NPM_PACKAGES" ]; then
    echo_info "Installing project-specific NPM packages..."
    npm install -g $EXTRA_NPM_PACKAGES
fi
echo_success "NPM packages installed"

# Python setup
echo_info "Setting up Python environment..."
if [ ! -d "$HOME/.pyenv" ]; then
    echo_info "Installing pyenv..."
    curl https://pyenv.run | bash
fi

export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --path)"
eval "$(pyenv init -)"

# Install specified Python version
pyenv install -s "$PYTHON_VERSION"
pyenv local "$PYTHON_VERSION"
echo_success "Python $PYTHON_VERSION configured for project"

# Create .python-version file for this project
echo "$PYTHON_VERSION" > .python-version

# Upgrade pip and install pipx
echo_info "Setting up Python package managers..."
python -m pip install --upgrade pip
python -m pip install pipx
pipx ensurepath

# Install base Python tools
if [ "$SKIP_BASE_SETUP" != "true" ]; then
    echo_info "Installing Python CLI tools..."
    pipx install openai || echo_warning "openai already installed"
    pipx install anthropic || echo_warning "anthropic already installed"
    pipx install httpie || echo_warning "httpie already installed"
    pipx install poetry || echo_warning "poetry already installed"
    pipx install pipenv || echo_warning "pipenv already installed"
    pipx install black || echo_warning "black already installed"
    pipx install isort || echo_warning "isort already installed"
    pipx install flake8 || echo_warning "flake8 already installed"
    pipx install mypy || echo_warning "mypy already installed"
    pipx install ruff || echo_warning "ruff already installed"
    pipx install pytest || echo_warning "pytest already installed"
    pipx install jupyter || echo_warning "jupyter already installed"
    pipx install cookiecutter || echo_warning "cookiecutter already installed"
    pipx install pre-commit || echo_warning "pre-commit already installed"
    pipx install commitizen || echo_warning "commitizen already installed"
fi

# Install DevOps and deployment tools via pipx
if [ "$DEVOPS_TOOLS" = "true" ]; then
    echo_info "Installing DevOps Python tools..."
    pipx install docker-compose || echo_warning "docker-compose already installed"
    pipx install ansible || echo_warning "ansible already installed"
    pipx install awscli || echo_warning "awscli already installed"
    pipx install azure-cli || echo_warning "azure-cli already installed"
    pipx install google-cloud-cli || echo_warning "google-cloud-cli already installed"
    pipx install terraform || echo_warning "terraform not available via pipx"
    pipx install pulumi || echo_warning "pulumi already installed"
fi

# Install database tools
if [ "$DATABASE_TOOLS" = "true" ]; then
    echo_info "Installing database management tools..."
    pipx install pgcli || echo_warning "pgcli already installed"
    pipx install mycli || echo_warning "mycli already installed"
    pipx install redis-cli || echo_warning "redis-cli not available via pipx"
    pipx install mongodb-tools || echo_warning "mongodb-tools not available via pipx"
fi

# Install extra pipx packages if specified
if [ -n "$EXTRA_PIPX_PACKAGES" ]; then
    echo_info "Installing project-specific pipx packages..."
    for package in $EXTRA_PIPX_PACKAGES; do
        pipx install "$package" || echo_warning "$package already installed"
    done
fi

# Install extra pip packages if specified
if [ -n "$EXTRA_PIP_PACKAGES" ]; then
    echo_info "Installing project-specific Python packages..."
    python -m pip install $EXTRA_PIP_PACKAGES
fi
echo_success "Python packages installed"

# Rust setup (optional)
if [ "$SKIP_RUST" != "true" ]; then
    echo_info "Setting up Rust environment..."
    if ! command -v rustc &> /dev/null; then
        echo_info "Installing Rust..."
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
        source "$HOME/.cargo/env"
    fi
    
    rustup update "$RUST_VERSION"
    rustup default "$RUST_VERSION"
    
    # Install popular Rust tools
    echo_info "Installing Rust development tools..."
    cargo install \
        cargo-edit \
        cargo-watch \
        cargo-generate \
        cargo-outdated \
        cargo-audit \
        cargo-expand \
        serde_json \
        tokio \
        reqwest \
        $EXTRA_CARGO_PACKAGES || echo_warning "Some Rust packages may have failed to install"
    
    echo_success "Rust $RUST_VERSION configured"
fi

# Go setup (optional)
if [ "$SKIP_GO" != "true" ]; then
    echo_info "Setting up Go environment..."
    if ! command -v go &> /dev/null; then
        echo_info "Installing Go..."
        GO_LATEST=$(curl -s "https://golang.org/VERSION?m=text")
        wget "https://golang.org/dl/${GO_LATEST}.linux-amd64.tar.gz"
        sudo tar -C /usr/local -xzf "${GO_LATEST}.linux-amd64.tar.gz"
        rm "${GO_LATEST}.linux-amd64.tar.gz"
        export PATH=$PATH:/usr/local/go/bin
        echo 'export PATH=$PATH:/usr/local/go/bin' >> ~/.bashrc
    fi
    
    # Install popular Go tools
    echo_info "Installing Go development tools..."
    go install github.com/air-verse/air@latest
    go install github.com/cosmtrek/air@latest
    go install github.com/golang/mock/mockgen@latest
    go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest
    go install github.com/swaggo/swag/cmd/swag@latest
    
    echo_success "Go environment configured"
fi

# Docker setup
if [ "$SKIP_DOCKER" != "true" ]; then
    echo_info "Setting up Docker..."
    if ! command -v docker &> /dev/null; then
        sudo apt install -y docker.io docker-compose-plugin
        sudo usermod -aG docker "$USER"
        echo_warning "You need to log out and back in for Docker group membership to take effect"
    else
        echo_info "Docker already installed"
    fi
fi

# Create directory structure
echo_info "Creating project directory structure..."
mkdir -p "$HOME/projects" "$HOME/bin" "$HOME/.config"

# Create .envrc file for direnv (if direnv is installed)
if command -v direnv &> /dev/null; then
    echo_info "Creating .envrc for direnv auto-switching..."
    cat > .envrc <<EOF
# Auto-generated by enhanced-bootstrap.sh
export PROJECT_NAME="$PROJECT_NAME"
export PROJECT_DIR="$PROJECT_DIR"

# Node.js environment
export NVM_DIR="\$HOME/.nvm"
[ -s "\$NVM_DIR/nvm.sh" ] && \. "\$NVM_DIR/nvm.sh"
[ -f ".nvmrc" ] && nvm use

# Python environment
export PYENV_ROOT="\$HOME/.pyenv"
export PATH="\$PYENV_ROOT/bin:\$PATH"
if command -v pyenv 1>/dev/null 2>&1; then
    eval "\$(pyenv init --path)"
    eval "\$(pyenv init -)"
fi

# Custom project environment variables
[ -f ".env.local" ] && source .env.local
EOF
    direnv allow .
    echo_success ".envrc created for automatic environment switching"
else
    echo_info "direnv not installed, skipping .envrc creation"
    echo_info "Install direnv with: sudo apt install direnv"
fi

# Create a project info file
cat > .project-info <<EOF
# Project Information
# Generated on $(date)

PROJECT_NAME=$PROJECT_NAME
NODE_VERSION=$NODE_VERSION
PYTHON_VERSION=$PYTHON_VERSION
CREATED_AT=$(date +%Y-%m-%d)
BOOTSTRAP_VERSION=2.0.0
AI_TOOLS_ENABLED=$AI_TOOLS
DEVOPS_TOOLS_ENABLED=$DEVOPS_TOOLS
DATABASE_TOOLS_ENABLED=$DATABASE_TOOLS
RUST_ENABLED=$([ "$SKIP_RUST" != "true" ] && echo "true" || echo "false")
GO_ENABLED=$([ "$SKIP_GO" != "true" ] && echo "true" || echo "false")

# Installed packages
EXTRA_NPM_PACKAGES=$EXTRA_NPM_PACKAGES
EXTRA_PIP_PACKAGES=$EXTRA_PIP_PACKAGES
EXTRA_PIPX_PACKAGES=$EXTRA_PIPX_PACKAGES
EXTRA_APT_PACKAGES=$EXTRA_APT_PACKAGES
EOF

echo ""
echo_success "==================== Setup Complete ===================="
echo_success "Project '$PROJECT_NAME' has been configured!"
echo ""
echo_info "Next steps:"
echo_info "  1. cd $PROJECT_DIR"
echo_info "  2. Start developing your project"
if [ "$SKIP_DOCKER" != "true" ] && ! groups | grep -q docker; then
    echo_warning "  3. Log out and back in for Docker access"
fi
if ! command -v direnv &> /dev/null; then
    echo_info "  Optional: Install direnv for automatic environment switching:"
    echo_info "    sudo apt install direnv"
    echo_info "    echo 'eval \"\$(direnv hook bash)\"' >> ~/.bashrc"
fi
echo_info "========================================================"