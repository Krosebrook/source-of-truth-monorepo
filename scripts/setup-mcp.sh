#!/bin/bash
# MCP Servers Setup Script
# Run this to verify and setup MCP servers for Claude Code

set -e

echo "🔧 MCP Servers Setup Script"
echo "================================"
echo ""

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Check if npm is installed
if ! command -v npm &> /dev/null; then
    echo -e "${RED}❌ npm not found. Please install Node.js first.${NC}"
    exit 1
fi

echo -e "${GREEN}✓ npm found${NC}"

# Check installed MCP packages
echo ""
echo "📦 Installed MCP Packages:"
echo "--------------------------------"
npm list -g --depth=0 2>/dev/null | grep -E "@modelcontextprotocol|mcp|notion|puppeteer|chrome-devtools|apify|heroku|mongodb-mcp|upstash" || echo "None found"

# Check for MCP config files
echo ""
echo "📄 MCP Configuration Files:"
echo "--------------------------------"
if [ -f ~/.mcp.json ]; then
    echo -e "${GREEN}✓ Global config: ~/.mcp.json${NC}"
else
    echo -e "${YELLOW}⚠ Global config not found: ~/.mcp.json${NC}"
fi

if [ -f ~/.mcp.env.example ]; then
    echo -e "${GREEN}✓ Env template: ~/.mcp.env.example${NC}"
else
    echo -e "${YELLOW}⚠ Env template not found${NC}"
fi

if [ -f ~/source-of-truth-monorepo/.mcp.json ]; then
    echo -e "${GREEN}✓ Project config: ~/source-of-truth-monorepo/.mcp.json${NC}"
else
    echo -e "${YELLOW}⚠ Project config not found${NC}"
fi

# Check environment variables
echo ""
echo "🔑 Environment Variables:"
echo "--------------------------------"
[ -n "$GITHUB_TOKEN" ] && echo -e "${GREEN}✓ GITHUB_TOKEN${NC}" || echo -e "${YELLOW}⚠ GITHUB_TOKEN not set${NC}"
[ -n "$POSTGRES_CONNECTION_STRING" ] && echo -e "${GREEN}✓ POSTGRES_CONNECTION_STRING${NC}" || echo -e "${YELLOW}⚠ POSTGRES_CONNECTION_STRING not set${NC}"
[ -n "$MONGODB_CONNECTION_STRING" ] && echo -e "${GREEN}✓ MONGODB_CONNECTION_STRING${NC}" || echo -e "${YELLOW}⚠ MONGODB_CONNECTION_STRING not set${NC}"
[ -n "$NOTION_API_KEY" ] && echo -e "${GREEN}✓ NOTION_API_KEY${NC}" || echo -e "${YELLOW}⚠ NOTION_API_KEY not set${NC}"
[ -n "$APIFY_API_TOKEN" ] && echo -e "${GREEN}✓ APIFY_API_TOKEN${NC}" || echo -e "${YELLOW}⚠ APIFY_API_TOKEN not set${NC}"
[ -n "$HEROKU_API_KEY" ] && echo -e "${GREEN}✓ HEROKU_API_KEY${NC}" || echo -e "${YELLOW}⚠ HEROKU_API_KEY not set${NC}"

# Offer to install missing packages
echo ""
echo "🚀 Quick Actions:"
echo "--------------------------------"
echo "1. Install all MCP servers: npm install -g @modelcontextprotocol/server-filesystem @modelcontextprotocol/server-memory @modelcontextprotocol/server-sequential-thinking mongodb-mcp-server @notionhq/notion-mcp-server puppeteer-mcp-server chrome-devtools-mcp @upstash/context7-mcp @apify/actors-mcp-server @heroku/mcp-server"
echo "2. Setup environment: cp ~/.mcp.env.example ~/.mcp.env && nano ~/.mcp.env"
echo "3. Test configuration: claude --mcp-config ~/.mcp.json"
echo "4. View documentation: cat ~/MCP_SERVERS_README.md"
echo ""

# Check if user wants to install
read -p "Would you like to install/update all MCP packages now? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo ""
    echo "📥 Installing MCP packages..."
    npm install -g \
        @modelcontextprotocol/server-filesystem \
        @modelcontextprotocol/server-memory \
        @modelcontextprotocol/server-sequential-thinking \
        @modelcontextprotocol/server-everything \
        @modelcontextprotocol/server-postgres \
        mongodb-mcp-server \
        @notionhq/notion-mcp-server \
        puppeteer-mcp-server \
        chrome-devtools-mcp \
        @upstash/context7-mcp \
        @apify/actors-mcp-server \
        @heroku/mcp-server
    
    echo ""
    echo -e "${GREEN}✅ Installation complete!${NC}"
fi

# Check if env file exists
if [ ! -f ~/.mcp.env ]; then
    read -p "Would you like to create an environment file now? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        cp ~/.mcp.env.example ~/.mcp.env
        echo -e "${GREEN}✓ Created ~/.mcp.env${NC}"
        echo "Please edit this file and add your credentials:"
        echo "  nano ~/.mcp.env"
    fi
fi

echo ""
echo -e "${GREEN}✅ Setup complete!${NC}"
echo ""
echo "Next steps:"
echo "1. Configure credentials in ~/.mcp.env"
echo "2. Source the file: source ~/.mcp.env"
echo "3. Start Claude Code: claude"
echo "4. Read full docs: cat ~/MCP_SERVERS_README.md"
echo ""
