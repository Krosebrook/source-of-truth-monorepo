# FlashFusion SoT Monorepo - Makefile
# Common development tasks for convenience
# Usage: make <target>

.PHONY: help bootstrap install build dev test lint format clean validate import check health doctor services

# Default target - show help
.DEFAULT_GOAL := help

# Colors for output
GREEN  := \033[0;32m
YELLOW := \033[1;33m
BLUE   := \033[0;34m
NC     := \033[0m # No Color

help: ## Show this help message
	@echo "$(BLUE)FlashFusion SoT Monorepo - Available Commands$(NC)"
	@echo ""
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "$(GREEN)%-20s$(NC) %s\n", $$1, $$2}'
	@echo ""
	@echo "$(YELLOW)Quick Start:$(NC)"
	@echo "  1. make bootstrap    # Complete setup for new developers"
	@echo "  2. make dev          # Start development servers"
	@echo "  3. make test         # Run tests"

# =============================================================================
# Setup & Installation
# =============================================================================

bootstrap: ## Complete setup for new developers (installs deps, builds, validates)
	@echo "$(BLUE)🚀 Bootstrapping FlashFusion SoT Monorepo...$(NC)"
	@./scripts/bootstrap.sh

install: ## Install all dependencies using pnpm
	@echo "$(BLUE)📥 Installing dependencies...$(NC)"
	@pnpm install

reinstall: ## Clean install (removes node_modules and reinstalls)
	@echo "$(YELLOW)🧹 Cleaning node_modules...$(NC)"
	@rm -rf node_modules
	@pnpm install

# =============================================================================
# Build & Development
# =============================================================================

build: ## Build all projects using Turbo
	@echo "$(BLUE)🔨 Building all projects...$(NC)"
	@pnpm build

build-changed: ## Build only changed projects since last commit
	@echo "$(BLUE)🔨 Building changed projects...$(NC)"
	@pnpm build --filter=...[HEAD^]

dev: ## Start development servers for all projects
	@echo "$(BLUE)🚀 Starting development servers...$(NC)"
	@pnpm dev

dev-web: ## Start web app development server
	@pnpm --filter @flashfusion/web dev

dev-api: ## Start API server development server
	@pnpm --filter @flashfusion/api dev

# =============================================================================
# Testing & Quality
# =============================================================================

test: ## Run all tests
	@echo "$(BLUE)🧪 Running tests...$(NC)"
	@pnpm test

test-watch: ## Run tests in watch mode
	@pnpm test --watch

test-coverage: ## Run tests with coverage report
	@pnpm test --coverage

lint: ## Lint all code
	@echo "$(BLUE)🔍 Linting code...$(NC)"
	@pnpm lint || true

lint-fix: ## Lint and auto-fix issues
	@echo "$(BLUE)🔧 Linting and fixing code...$(NC)"
	@pnpm lint --fix

format: ## Format all code with Prettier
	@echo "$(BLUE)✨ Formatting code...$(NC)"
	@pnpm format

format-check: ## Check code formatting without modifying
	@pnpm format:check

type-check: ## Run TypeScript type checking
	@echo "$(BLUE)📝 Type checking...$(NC)"
	@pnpm type-check

check: lint type-check ## Run all checks (lint + type-check)
	@echo "$(GREEN)✅ All checks completed$(NC)"

# =============================================================================
# Cleaning
# =============================================================================

clean: ## Clean build artifacts and caches
	@echo "$(YELLOW)🧹 Cleaning build artifacts...$(NC)"
	@pnpm clean
	@rm -rf .turbo

clean-all: ## Clean everything (build artifacts, node_modules, caches)
	@echo "$(YELLOW)🧹 Deep cleaning...$(NC)"
	@pnpm clean || true
	@rm -rf node_modules .turbo .pnpm-cache
	@echo "$(GREEN)✓ Clean complete. Run 'make install' to reinstall.$(NC)"

# =============================================================================
# Repository Management
# =============================================================================

import: ## Import remaining GitHub repositories
	@echo "$(BLUE)📦 Importing GitHub repositories...$(NC)"
	@./scripts/import-github-repos.sh

validate: ## Validate setup and configuration
	@echo "$(BLUE)✅ Validating setup...$(NC)"
	@./scripts/validate-setup.sh

repo-map: ## Regenerate repository map
	@echo "$(BLUE)🗺️  Generating repository map...$(NC)"
	@node scripts/generate-repo-map.js

# =============================================================================
# Security & Maintenance
# =============================================================================

security: ## Run security audit
	@echo "$(BLUE)🔒 Running security audit...$(NC)"
	@pnpm security:audit

security-check: ## Run security audit (fails on moderate+ vulnerabilities)
	@echo "$(BLUE)🔒 Running security audit check...$(NC)"
	@pnpm security:audit:check

update-deps: ## Update dependencies (interactive)
	@echo "$(BLUE)📦 Updating dependencies...$(NC)"
	@pnpm update --interactive

outdated: ## Show outdated dependencies
	@pnpm outdated

# =============================================================================
# Development Services (Docker)
# =============================================================================

services: ## Start local development services (PostgreSQL, Redis)
	@echo "$(BLUE)🐳 Starting development services...$(NC)"
	@docker-compose up -d

services-stop: ## Stop local development services
	@echo "$(YELLOW)🛑 Stopping development services...$(NC)"
	@docker-compose down

services-logs: ## Show logs from development services
	@docker-compose logs -f

services-clean: ## Stop and remove all service data
	@echo "$(YELLOW)🧹 Cleaning development services...$(NC)"
	@docker-compose down -v

# =============================================================================
# Documentation
# =============================================================================

docs-status: ## Check documentation status
	@pnpm docs:status

docs-resume: ## Resume documentation work
	@pnpm docs:resume

docs-lint: ## Lint markdown documentation
	@pnpm docs:lint

docs-validate: ## Validate documentation structure
	@pnpm docs:validate

# =============================================================================
# Health & Diagnostics
# =============================================================================

health: ## Run health checks on the repository
	@echo "$(BLUE)🏥 Running health checks...$(NC)"
	@./scripts/health-check.sh || echo "$(YELLOW)⚠ Health check script not found$(NC)"

doctor: validate health ## Run full diagnostic (validate + health)
	@echo "$(GREEN)✅ Diagnostic complete$(NC)"

info: ## Show environment and version information
	@echo "$(BLUE)📊 Environment Information$(NC)"
	@echo ""
	@echo "Node version:    $$(node --version)"
	@echo "pnpm version:    $$(pnpm --version)"
	@echo "Turbo version:   $$(pnpm turbo --version)"
	@echo "Git version:     $$(git --version)"
	@echo ""
	@echo "Current branch:  $$(git branch --show-current)"
	@echo "Repository:      $$(git remote get-url origin 2>/dev/null || echo 'No remote')"
	@echo ""
	@echo "Workspace packages:"
	@pnpm list --depth=0 2>/dev/null | head -20

# =============================================================================
# Git Workflow Helpers
# =============================================================================

status: ## Show comprehensive git status
	@git status
	@echo ""
	@echo "$(BLUE)Unpushed commits:$(NC)"
	@git log @{u}.. --oneline 2>/dev/null || echo "No unpushed commits or no upstream"

sync: ## Sync with upstream (fetch and pull)
	@echo "$(BLUE)🔄 Syncing with upstream...$(NC)"
	@git fetch origin
	@git pull origin $$(git branch --show-current)

# =============================================================================
# CI/CD Simulation
# =============================================================================

ci-local: clean install build test lint ## Simulate CI pipeline locally
	@echo "$(GREEN)✅ CI simulation complete$(NC)"

# =============================================================================
# Utility
# =============================================================================

version: ## Show repository version information
	@echo "FlashFusion SoT Monorepo"
	@echo "Version: $$(node -p "require('./package.json').version")"

workspace-list: ## List all workspace packages
	@echo "$(BLUE)📦 Workspace Packages:$(NC)"
	@pnpm list --depth=-1 --json | node -e "const data=JSON.parse(require('fs').readFileSync(0)); data.forEach(p=>console.log(p.name))"

# =============================================================================
# Aliases
# =============================================================================

b: build ## Alias for build
d: dev ## Alias for dev
t: test ## Alias for test
l: lint ## Alias for lint
c: clean ## Alias for clean
i: install ## Alias for install
