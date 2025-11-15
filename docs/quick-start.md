# 🚀 Quick Start Guide

Get up and running with the comprehensive development environment in 5 minutes.

## Prerequisites

- Ubuntu/Debian-based Linux system (WSL2 works great)
- Internet connection for downloading tools
- Sudo access for system package installation

## Step 1: Initial Bootstrap (2 minutes)

Run your foundational bootstrap script first:

```bash
# Run the basic system setup
bash ~/bootstrap-fullstack-ai.sh
```

This installs:
- System packages and dependencies
- Node.js via NVM
- Python via pyenv  
- Docker and essential tools
- Basic AI CLIs (Claude Code, OpenAI)

## Step 2: Enhanced AI Setup (1 minute)

Add comprehensive AI development tools:

```bash
# Install AI development environment
~/bin/setup-ai-dev-tools.sh
```

This adds:
- Cursor AI editor
- GitHub Copilot CLI
- Warp terminal
- AI development aliases and functions

## Step 3: Environment Auto-Switching (1 minute)

Set up automatic environment switching:

```bash
# Configure direnv for auto environment switching
~/bin/setup-direnv.sh

# Restart terminal or source bashrc
source ~/.bashrc
```

## Step 4: Create Your First Project (1 minute)

Choose your project type and create it:

### For E-commerce (SoleMuchBetter.com)
```bash
~/bin/create-ecommerce-site.sh my-store --nextjs --ai --stripe
```

### For AI Development
```bash
~/bin/create-ai-project.sh my-chatbot chatbot --all
```

### For React App
```bash
~/bin/create-react-project.sh my-app --typescript --tailwind
```

### For API Backend
```bash
~/bin/create-fastapi-project.sh my-api --postgres --redis
```

## Step 5: Start Development

Navigate to your project and start coding:

```bash
# Go to your project
cd ~/projects/my-store  # or whatever you named it

# Environment auto-loads thanks to direnv
# Start development (varies by project type)

# For e-commerce:
docker-compose up -d  # Start PostgreSQL & Redis
cd backend && poetry run uvicorn app.main:app --reload &
cd frontend && npm run dev

# For React:
npm run dev

# For FastAPI:
poetry run uvicorn app.main:app --reload

# For AI projects:
python src/main.py
# or
streamlit run streamlit_app/main.py
```

## ✅ Verification

Check that everything is working:

```bash
# Check installed tools
node --version     # Should show Node.js 20+
python --version   # Should show Python 3.12+
docker --version   # Should show Docker
cursor --version   # Should show Cursor AI
gh --version       # Should show GitHub CLI

# Check AI tools
ai-dev list

# Check environment switching
cd ~/projects/your-project
# Should auto-load project environment
```

## 🎯 What You Can Do Now

1. **Develop with AI assistance**: Use `claude`, `copilot suggest`, or `ai-explain <code>`
2. **Auto environment switching**: CD into any project for automatic environment setup
3. **Create more projects**: Use any of the project creation scripts
4. **Deploy easily**: Projects come with Docker configurations and deployment guides

## 🔧 Quick Commands Reference

```bash
# AI assistance
claude                                    # Start Claude Code
ai-dev explain <file>                    # Explain code with AI
ai-dev commit                            # AI-generated commit messages
copilot suggest "implement user auth"    # Get implementation suggestions

# Project management
ai-dev project react my-new-app         # Quick project creation
direnv-template react                   # Add React environment to existing project

# Environment management
ls ~/project-configs/                   # See available configurations
~/enhanced-bootstrap.sh ~/project-configs/ai-fullstack.config  # Use specific config
```

## 🚨 Troubleshooting

### Common Issues:

**"Command not found"**
```bash
# Restart terminal or source bashrc
source ~/.bashrc
```

**Docker permission denied**
```bash
# Log out and back in, or:
sudo usermod -aG docker $USER
newgrp docker
```

**AI tools not working**
```bash
# Check API keys in your project's .env file
cat .env
# Add missing keys:
OPENAI_API_KEY=sk-...
ANTHROPIC_API_KEY=sk-ant-...
```

**Environment not switching**
```bash
# Ensure direnv is installed and hooked
direnv --version
grep direnv ~/.bashrc
# If missing, re-run:
~/bin/setup-direnv.sh
```

## 🎉 You're Ready!

You now have a complete development environment with:
- ✅ AI-assisted coding (Cursor, Claude, Copilot)
- ✅ Automatic environment switching
- ✅ Modern development tools (React, FastAPI, Docker, etc.)
- ✅ Project templates for any type of application
- ✅ Deployment-ready configurations

Start building your next project with AI assistance and modern tooling!