#!/bin/bash

set -e

echo "📦 Installing NVM and Node.js..."

# Check if NVM is already installed
if command -v nvm &>/dev/null; then
    echo "✅ NVM already installed: $(nvm --version)"
else
    echo "Installing NVM..."
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.4/install.sh | bash
    echo "✅ NVM installed"
fi

# Load nvm for this session
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# Check if Node.js is installed
if ! command -v node &>/dev/null; then
    echo "Installing latest LTS Node.js..."
    nvm install --lts
    nvm use --lts
    nvm alias default node
    echo "✅ Node.js installed: $(node --version)"
    echo "✅ npm installed: $(npm --version)"
else
    echo "✅ Node.js already installed: $(node --version)"
    echo "✅ npm already installed: $(npm --version)"
fi

echo ""
echo "🎉 NVM setup complete!"
echo ""
echo "📝 To use NVM in new terminal sessions, restart your terminal or run:"
echo "   source ~/.zshrc   # or ~/.bash_profile for bash"