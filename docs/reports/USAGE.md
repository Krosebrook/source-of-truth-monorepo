# 🎯 How to Use Your Comprehensive Bootstrap System

This is your complete guide to using the development environment bootstrap system effectively.

## 🚀 Quick Actions You Can Take Right Now

### 1. **Validate Your System**
```bash
# Check if everything is working properly
~/bin/validate-system.sh --verbose

# Run a quick demo to see capabilities
~/bin/demo-system.sh --quick
```

### 2. **Create Your First Real Project**

#### For SoleMuchBetter.com E-commerce:
```bash
~/bin/create-ecommerce-site.sh solemuchbetter --nextjs --ai --stripe

# This creates a complete e-commerce platform with:
# - Next.js frontend with TypeScript & Tailwind
# - FastAPI backend with PostgreSQL & Redis
# - Stripe payment integration
# - AI-powered features
# - Docker development environment
```

#### For AI Development:
```bash
~/bin/create-ai-project.sh my-chatbot chatbot --all

# This creates an AI project with:
# - OpenAI & Anthropic integration
# - LangChain framework
# - Streamlit web interface
# - Vector database support
```

#### For Standard Web App:
```bash
~/bin/create-react-project.sh my-app --typescript --tailwind
~/bin/create-fastapi-project.sh my-api --postgres --redis --celery
```

### 3. **Set Up AI Development Environment**
```bash
# Install all AI coding assistants
~/bin/setup-ai-dev-tools.sh

# After restart, you'll have:
# - Claude Code: `claude` or `cc`
# - GitHub Copilot: `copilot suggest "task"`
# - AI code review: `ai-dev review`
# - AI commit messages: `ai-dev commit`
```

## 📁 System Organization

### **File Structure**
```
~/
├── README.md                          # Main documentation
├── USAGE.md                          # This file
├── enhanced-bootstrap.sh             # Main bootstrap script
├── bin/                              # Executable scripts
│   ├── create-ecommerce-site.sh     # E-commerce creator
│   ├── create-ai-project.sh         # AI project creator
│   ├── create-react-project.sh      # React app creator
│   ├── create-fastapi-project.sh    # FastAPI creator
│   ├── setup-ai-dev-tools.sh        # AI tools installer
│   ├── setup-direnv.sh              # Environment switcher
│   ├── validate-system.sh           # System checker
│   ├── demo-system.sh               # System demo
│   └── update-system.sh             # System updater
├── project-configs/                  # Pre-built configurations
│   ├── ai-fullstack.config          # Complete AI stack
│   ├── ecommerce-platform.config    # E-commerce optimized
│   ├── enterprise-saas.config       # Enterprise applications
│   └── ...                          # More configurations
├── docs/                             # Detailed documentation
│   ├── quick-start.md               # 5-minute setup guide
│   └── configuration.md             # Configuration reference
└── projects/                         # Your projects go here
    ├── solemuchbetter/               # E-commerce site
    ├── my-chatbot/                   # AI project
    └── ...                           # More projects
```

## 🔄 Daily Workflow

### **Starting a New Project**
1. **Choose project type** from available templates
2. **Run creation script** with desired options
3. **Environment auto-loads** when you `cd` into project
4. **Start development** with pre-configured tools

### **Working on Existing Projects**
```bash
cd ~/projects/my-project
# Environment automatically loads (Node.js version, Python env, etc.)

# Use AI assistance
ai-dev explain app.py
copilot suggest "add user authentication"
claude  # Start interactive Claude session

# Normal development workflow
npm run dev  # or poetry run uvicorn app.main:app --reload
```

## 🛠 Configuration Management

### **Using Pre-built Configurations**
```bash
# See available configurations
ls ~/project-configs/

# Use specific configuration
~/enhanced-bootstrap.sh ~/project-configs/ai-fullstack.config
```

### **Creating Custom Configurations**
```bash
# Create custom config
cat > ~/project-configs/my-custom.config <<EOF
PROJECT_NAME="my-custom-project"
NODE_VERSION="18"
PYTHON_VERSION="3.11.8"
AI_TOOLS="true"
EXTRA_NPM_PACKAGES="custom-package"
EXTRA_PIP_PACKAGES="special-library"
EOF

# Use custom config
~/enhanced-bootstrap.sh ~/project-configs/my-custom.config
```

## 🤖 AI Development Features

### **Available AI Commands** (after `source ~/.bashrc`)
```bash
# Claude Code
claude                              # Interactive Claude session
cc "explain this code"              # Quick Claude query

# GitHub Copilot
copilot suggest "implement user auth"
copilot explain main.py

# AI Development Helper
ai-dev project react my-app         # Quick project creation
ai-dev review                       # AI code review
ai-dev commit                       # AI commit messages
ai-dev explain app.py               # Explain code
ai-dev debug "error message"        # Debug with AI

# OpenAI
openai chat "help with this code"
gpt "optimize this function"
```

### **AI Project Types**
```bash
# Available AI project types
~/bin/create-ai-project.sh my-project <type> [options]

# Types:
chatbot       # AI chatbot with multiple LLM providers
ml-pipeline   # Machine learning pipeline with MLflow
ai-api        # FastAPI with AI endpoints
rag-system    # Retrieval Augmented Generation
ai-agent      # Autonomous AI agent framework
computer-vision # Computer vision processing
nlp-processor # Natural language processing
ai-saas       # Full-stack AI SaaS application
```

## 🌐 Environment Switching

### **Automatic Environment Loading** (via direnv)
```bash
cd ~/projects/react-app
# Automatically loads: Node.js 20, npm packages, React env vars

cd ~/projects/python-api
# Automatically loads: Python 3.12, activates venv, API env vars

cd ~/projects/ai-project
# Automatically loads: Python 3.11, AI libraries, API keys
```

### **Manual Environment Templates**
```bash
# Copy environment template to existing project
cd my-existing-project
direnv-template react              # For React projects
direnv-template fastapi            # For FastAPI projects
direnv-template ml                 # For ML projects
direnv-template fullstack          # For full-stack projects
direnv allow                       # Enable auto-loading
```

## 📦 Package Management

### **Language Versions**
- **Node.js**: Managed by NVM, auto-switches per project
- **Python**: Managed by pyenv, auto-switches per project  
- **Rust**: Optional, managed by rustup
- **Go**: Optional, manual installation

### **Global Tools**
```bash
# Update all global packages
npm update -g                      # Node.js packages
pipx upgrade-all                   # Python CLI tools
rustup update                      # Rust toolchain (if installed)

# Or use the update script
~/bin/update-system.sh
```

## 🚀 Deployment Ready

### **Built-in Deployment Support**
All projects come with:
- **Docker** configurations
- **Environment variable** templates
- **CI/CD** ready structures
- **Cloud platform** configurations (Vercel, Railway, etc.)

### **Quick Deployment**
```bash
# For Next.js projects
cd frontend && vercel --prod

# For FastAPI projects
cd backend && railway deploy

# For Docker deployment
docker-compose up --build
```

## 🔧 Maintenance

### **System Updates**
```bash
# Check for updates (safe, no changes)
~/bin/update-system.sh --check-only

# Perform updates
~/bin/update-system.sh

# Force update everything
~/bin/update-system.sh --force
```

### **System Health Checks**
```bash
# Validate installation
~/bin/validate-system.sh

# Demo system capabilities
~/bin/demo-system.sh

# Check specific components
which claude-code openai gh docker
```

## 📚 Documentation

### **Getting Help**
- **Quick Start**: `~/docs/quick-start.md` - 5-minute setup
- **Configuration**: `~/docs/configuration.md` - All config options
- **Main README**: `~/README.md` - Complete system overview
- **This File**: `~/USAGE.md` - Daily usage guide

### **Examples and Tutorials**
```bash
# See example project structures
tree ~/projects/demo/react-demo -L 2
tree ~/projects/demo/api-demo -L 2

# Run interactive demo
~/bin/demo-system.sh --interactive
```

## 🎯 Common Workflows

### **E-commerce Development (SoleMuchBetter.com)**
```bash
# 1. Create e-commerce platform
~/bin/create-ecommerce-site.sh solemuchbetter --nextjs --ai --stripe

# 2. Configure environment
cd ~/projects/solemuchbetter
cp .env.example .env
# Edit .env with Stripe keys, database URLs

# 3. Start development
docker-compose up -d                    # Start PostgreSQL & Redis
cd backend && poetry run uvicorn app.main:app --reload &
cd frontend && npm run dev

# 4. Development with AI assistance
ai-dev review src/components/ProductCard.tsx
copilot suggest "add product reviews feature"
```

### **AI Application Development**
```bash
# 1. Create AI project
~/bin/create-ai-project.sh my-assistant rag-system --all

# 2. Configure API keys
cd ~/projects/my-assistant
cp .env.example .env
# Add OpenAI, Anthropic, Pinecone keys

# 3. Start development
python -m venv venv && source venv/bin/activate
pip install -r requirements.txt
streamlit run streamlit_app/main.py

# 4. Use AI development tools
claude "help optimize this embedding function"
ai-dev explain src/vector_store.py
```

### **Full-stack Web Application**
```bash
# 1. Create backend
~/bin/create-fastapi-project.sh myapp-api --postgres --redis --celery

# 2. Create frontend
~/bin/create-react-project.sh myapp-frontend --typescript --tailwind

# 3. Configure both
# Set up databases, environment variables, etc.

# 4. Develop with auto environment switching
cd ~/projects/myapp-api     # Auto-loads Python env
cd ~/projects/myapp-frontend # Auto-loads Node.js env
```

## 🎉 What You Can Build

With this system, you can create:
- **E-commerce sites** (like SoleMuchBetter.com)
- **AI chatbots and assistants**
- **SaaS applications**
- **Mobile app backends**
- **Machine learning platforms**
- **Content management systems**
- **Real-time applications**
- **Microservices architectures**
- **DevOps automation tools**
- **Creative and design applications**

Start with any project type and scale up with the comprehensive tooling provided!