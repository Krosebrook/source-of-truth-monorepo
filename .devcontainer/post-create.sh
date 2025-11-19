#!/bin/bash
# Post-create script for devcontainer
# Runs after container is created

set -e

echo "🚀 Setting up FlashFusion SoT Development Container..."

# Install dependencies
echo "📥 Installing dependencies..."
pnpm install

# Build projects
echo "🔨 Building projects..."
pnpm build || echo "⚠️  Some builds may have failed (this is OK for stubs)"

# Setup git hooks
echo "🪝 Setting up git hooks..."
pnpm prepare || true

echo "✅ Development container setup complete!"
echo ""
echo "Quick start:"
echo "  make help    - Show available commands"
echo "  make dev     - Start development servers"
echo "  make test    - Run tests"
echo ""
