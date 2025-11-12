#!/bin/bash

# OpenAI Codex Installation Script
# Installs @openai/codex npm package globally

set -e

echo "📦 OpenAI Codex Setup"
echo ""

# Ensure NVM is loaded if available
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# Check if npm is available
if ! command -v npm &>/dev/null; then
    echo "❌ npm not found. Please install Node.js first."
    echo ""
    echo "Options:"
    echo "  1. Run ./setup-macos.sh to install NVM and Node.js"
    echo "  2. Visit https://nodejs.org/ to download Node.js"
    echo "  3. Install NVM: https://github.com/nvm-sh/nvm"
    exit 1
fi

# Check if @openai/codex is already installed
if npm list -g @openai/codex &>/dev/null; then
    echo "✅ @openai/codex is already installed"

    # Show current version
    CURRENT_VERSION=$(npm list -g @openai/codex --depth=0 2>/dev/null | grep @openai/codex | awk '{print $2}' | tr -d '@')
    echo "   Current version: $CURRENT_VERSION"
    echo ""

    read -p "Do you want to update it? (y/n): " response
    case "$response" in
        [Yy]* )
            echo "📦 Updating @openai/codex..."
            npm update -g @openai/codex
            echo "✅ @openai/codex updated"
            ;;
        * )
            echo "Skipping update"
            exit 0
            ;;
    esac
else
    echo "📦 Installing @openai/codex..."
    npm install -g @openai/codex
    echo "✅ @openai/codex installed"
fi

echo ""
echo "🎉 Setup complete!"
echo ""
