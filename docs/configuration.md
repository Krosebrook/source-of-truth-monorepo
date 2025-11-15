# ⚙️ Configuration Reference

Complete reference for configuring your development environment.

## Configuration Files

Configuration files are located in `~/project-configs/` and follow this naming pattern:
- `[project-type].config` - Specific project type configurations
- `[custom-name].config` - Your custom configurations

## Configuration Variables

### Core Project Settings

```bash
# Project identification
PROJECT_NAME="my-project"           # Project name (used for directories, etc.)
PROJECT_DIR="$HOME/projects/..."    # Custom project directory (optional)

# Language versions
NODE_VERSION="20"                   # Node.js version (lts, 18, 20, etc.)
PYTHON_VERSION="3.12.2"            # Python version
RUST_VERSION="stable"              # Rust version (stable, beta, nightly)
GO_VERSION="latest"                 # Go version

# Tool categories (true/false)
AI_TOOLS="true"                     # Enable AI development tools
DEVOPS_TOOLS="true"                 # Enable DevOps and deployment tools
DATABASE_TOOLS="true"               # Enable database management tools
CREATIVE_TOOLS="false"              # Enable design and creative tools

# Skip options
SKIP_BASE_SETUP="false"            # Skip system package installation
SKIP_DOCKER="false"                # Skip Docker installation
SKIP_RUST="true"                   # Skip Rust installation
SKIP_GO="true"                     # Skip Go installation
```

### Package Management

```bash
# NPM packages (space-separated)
EXTRA_NPM_PACKAGES="vite @vitejs/plugin-react typescript"

# Python packages via pip (space-separated)
EXTRA_PIP_PACKAGES="fastapi uvicorn sqlalchemy"

# Python packages via pipx (space-separated)
EXTRA_PIPX_PACKAGES="black mypy ruff pytest"

# Rust packages via cargo (space-separated)
EXTRA_CARGO_PACKAGES="serde tokio axum"

# Go packages (space-separated, full import paths)
EXTRA_GO_PACKAGES="github.com/gin-gonic/gin"

# System packages via apt (space-separated)
EXTRA_APT_PACKAGES="postgresql-client redis-tools"
```

## Pre-built Configurations

### AI Full-Stack (`ai-fullstack.config`)
**Purpose**: Comprehensive AI-powered development setup  
**Includes**: All AI tools, Rust, Go, advanced packages  
**Use case**: AI/ML applications, intelligent web apps

```bash
AI_TOOLS="true"
DEVOPS_TOOLS="true" 
DATABASE_TOOLS="true"
SKIP_RUST="false"
SKIP_GO="false"
```

### E-commerce Platform (`ecommerce-platform.config`)
**Purpose**: E-commerce websites like SoleMuchBetter.com  
**Includes**: Payment processing, inventory management, customer tools  
**Use case**: Online stores, marketplace applications

```bash
# Optimized for e-commerce
EXTRA_NPM_PACKAGES="stripe @stripe/stripe-js shopify-buy"
EXTRA_PIP_PACKAGES="stripe shopify-python-api"
```

### Enterprise SaaS (`enterprise-saas.config`)
**Purpose**: B2B SaaS applications  
**Includes**: Enterprise auth, monitoring, multi-tenancy  
**Use case**: Business applications, SaaS platforms

```bash
# Enterprise-grade tools
EXTRA_NPM_PACKAGES="@auth0/nextjs-auth0 @sentry/nextjs"
EXTRA_PIP_PACKAGES="auth0-python sentry-sdk[fastapi]"
```

### DevOps Platform (`devops-platform.config`)
**Purpose**: Infrastructure and deployment automation  
**Includes**: Cloud CLIs, monitoring, orchestration  
**Use case**: Infrastructure projects, CI/CD systems

```bash
# DevOps focused
AI_TOOLS="false"
DEVOPS_TOOLS="true"
EXTRA_PIPX_PACKAGES="ansible awscli azure-cli"
```

### Creative Studio (`creative-studio.config`)
**Purpose**: Content creation and design projects  
**Includes**: Media processing, design tools, creative APIs  
**Use case**: Design agencies, content creation

```bash
# Creative tools
CREATIVE_TOOLS="true"
EXTRA_APT_PACKAGES="ffmpeg imagemagick gimp"
SKIP_DOCKER="true"
```

### ML/AI Project (`ml-ai-project.config`)
**Purpose**: Machine learning and data science  
**Includes**: ML frameworks, Jupyter, data processing  
**Use case**: Data science, ML research, AI experiments

```bash
# ML optimized
PYTHON_VERSION="3.10.13"  # Better ML library compatibility
EXTRA_PIP_PACKAGES="torch transformers jupyter"
```

## Custom Configuration Examples

### Minimal Development Setup
```bash
# minimal-dev.config
PROJECT_NAME="minimal-project"
NODE_VERSION="lts"
PYTHON_VERSION="3.12.2"

# Minimal tools only
AI_TOOLS="false"
DEVOPS_TOOLS="false"
DATABASE_TOOLS="false"
CREATIVE_TOOLS="false"

# Skip optional components
SKIP_RUST="true"
SKIP_GO="true"
SKIP_DOCKER="true"
SKIP_BASE_SETUP="true"

# Basic packages only
EXTRA_NPM_PACKAGES=""
EXTRA_PIP_PACKAGES="requests"
EXTRA_PIPX_PACKAGES="black"
```

### Mobile Development Setup
```bash
# mobile-dev.config
PROJECT_NAME="mobile-app"
NODE_VERSION="18"  # React Native compatibility
PYTHON_VERSION="3.11.8"

# Mobile-focused tools
EXTRA_NPM_PACKAGES="react-native @react-native-community/cli expo-cli"
EXTRA_APT_PACKAGES="android-tools-adb"
```

### Game Development Setup
```bash
# game-dev.config
PROJECT_NAME="game-project"
NODE_VERSION="20"
PYTHON_VERSION="3.11.8"

# Game development tools
EXTRA_NPM_PACKAGES="phaser three @types/three"
EXTRA_PIP_PACKAGES="pygame panda3d"
EXTRA_APT_PACKAGES="blender audacity"
SKIP_RUST="false"  # For performance-critical components
```

## Environment Variables

### Project-Specific Variables
Each project gets these environment variables automatically:

```bash
PROJECT_NAME="your-project-name"
PROJECT_DIR="/full/path/to/project"
NODE_ENV="development"
PYTHONPATH="$PWD:$PYTHONPATH"
```

### Language Environment Variables
```bash
# Node.js
NVM_DIR="$HOME/.nvm"
NODE_ENV="development"

# Python  
PYENV_ROOT="$HOME/.pyenv"
PYTHONPATH="$PWD:$PYTHONPATH"

# Rust (if enabled)
CARGO_HOME="$HOME/.cargo"
RUSTUP_HOME="$HOME/.rustup"

# Go (if enabled)
GOPATH="$HOME/go"
GOROOT="/usr/local/go"
```

## Direnv Integration

### Automatic `.envrc` Generation
The bootstrap system automatically creates `.envrc` files with:

```bash
# Auto-generated environment switching
export PROJECT_NAME="project-name"
export PROJECT_DIR="$PROJECT_DIR"

# Language environments
source "$HOME/.nvm/nvm.sh"
[ -f ".nvmrc" ] && nvm use

export PYENV_ROOT="$HOME/.pyenv"
[ -f ".python-version" ] && pyenv local

# Custom environment variables
[ -f ".env.local" ] && source .env.local
```

### Custom Environment Templates
Use direnv templates for specific project types:

```bash
# Copy a template
direnv-template react      # React projects
direnv-template fastapi    # FastAPI projects  
direnv-template fullstack  # Full-stack projects
direnv-template ml         # ML projects

# Allow the environment
direnv allow
```

## Advanced Configuration

### Conditional Package Installation
```bash
# Install packages based on conditions
if [ "$USE_AI" = true ]; then
    EXTRA_PIP_PACKAGES="$EXTRA_PIP_PACKAGES openai anthropic"
fi

if [ "$USE_DATABASE" = true ]; then
    EXTRA_APT_PACKAGES="$EXTRA_APT_PACKAGES postgresql-client"
fi
```

### Version-Specific Configurations
```bash
# React 17 vs 18 compatibility
if [[ "$REACT_VERSION" == "17" ]]; then
    EXTRA_NPM_PACKAGES="react@17 react-dom@17"
else
    EXTRA_NPM_PACKAGES="react@18 react-dom@18"
fi
```

### Platform-Specific Settings
```bash
# Different settings for different platforms
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    EXTRA_APT_PACKAGES="$EXTRA_APT_PACKAGES linux-specific-package"
elif [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS specific settings
    EXTRA_BREW_PACKAGES="macos-specific-package"
fi
```

## Configuration Validation

### Required Variables
```bash
# These variables must be set
PROJECT_NAME="${PROJECT_NAME:?PROJECT_NAME is required}"
NODE_VERSION="${NODE_VERSION:?NODE_VERSION is required}"
PYTHON_VERSION="${PYTHON_VERSION:?PYTHON_VERSION is required}"
```

### Default Values
```bash
# Variables with sensible defaults
AI_TOOLS="${AI_TOOLS:-false}"
DEVOPS_TOOLS="${DEVOPS_TOOLS:-false}"
SKIP_DOCKER="${SKIP_DOCKER:-false}"
```

## Best Practices

### 1. Naming Conventions
- Use kebab-case for project names: `my-awesome-project`
- Use descriptive config names: `ecommerce-with-ai.config`
- Keep environment variable names UPPERCASE

### 2. Package Management
- Group related packages together in comments
- Use specific versions for production: `package@1.2.3`
- Separate development and production dependencies

### 3. Environment Isolation
- Use `.env.local` for sensitive/local-only variables
- Keep `.env.example` up to date with required variables
- Use direnv for automatic environment switching

### 4. Documentation
- Comment your custom configurations
- Include usage examples in config files
- Document any special setup requirements

## Troubleshooting

### Configuration Not Loading
```bash
# Check if file exists and is readable
ls -la ~/project-configs/your-config.config

# Test configuration loading
source ~/project-configs/your-config.config
echo $PROJECT_NAME
```

### Package Installation Failures
```bash
# Check for syntax errors in package lists
echo $EXTRA_NPM_PACKAGES | tr ' ' '\n'

# Test individual package installation
npm install specific-package
```

### Environment Variables Not Set
```bash
# Check if direnv is working
direnv status

# Reload environment
direnv reload

# Check environment variables
env | grep PROJECT
```