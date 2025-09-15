#!/bin/bash

set -e

echo "🚀 Starting macOS setup..."

# Check if running on macOS
if [[ "$OSTYPE" != "darwin"* ]]; then
    echo "❌ This script is only for macOS"
    exit 1
fi

# Install Xcode Command Line Tools (required for git and other tools)
echo "📦 Checking Xcode Command Line Tools..."
if ! xcode-select -p &>/dev/null; then
    echo "Installing Xcode Command Line Tools..."
    xcode-select --install
    echo "⏳ Please complete the Xcode Command Line Tools installation and run this script again"
    exit 0
else
    echo "✅ Xcode Command Line Tools already installed"
fi

# Install Homebrew
echo "🍺 Checking Homebrew..."
if ! command -v brew &>/dev/null; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # Add Homebrew to .zshrc for zsh shell
    if [[ $(uname -m) == "arm64" ]]; then
        echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zshrc
        eval "$(/opt/homebrew/bin/brew shellenv)"
    else
        echo 'eval "$(/usr/local/bin/brew shellenv)"' >> ~/.zshrc
        eval "$(/usr/local/bin/brew shellenv)"
    fi

    echo "✅ Homebrew installed and added to .zshrc"
else
    echo "✅ Homebrew already installed"

    # Ensure Homebrew is in .zshrc
    if ! grep -q "brew shellenv" ~/.zshrc 2>/dev/null; then
        echo "Adding Homebrew to .zshrc..."
        if [[ $(uname -m) == "arm64" ]]; then
            echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zshrc
        else
            echo 'eval "$(/usr/local/bin/brew shellenv)"' >> ~/.zshrc
        fi
        echo "✅ Homebrew added to .zshrc"
    fi
fi

# Update Homebrew
echo "🔄 Updating Homebrew..."
brew update

# Install git
echo "📚 Checking git..."
if ! command -v git &>/dev/null; then
    echo "Installing git..."
    brew install git
    echo "✅ Git installed"
else
    echo "✅ Git already installed"
fi

# Install uv
echo "🐍 Checking uv..."
if ! command -v uv &>/dev/null; then
    echo "Installing uv..."
    curl -LsSf https://astral.sh/uv/install.sh | sh
    # Add uv to PATH in .zshrc
    export PATH="$HOME/.cargo/bin:$PATH"
    echo 'export PATH="$HOME/.cargo/bin:$PATH"' >> ~/.zshrc
    echo "✅ uv installed"
else
    echo "✅ uv already installed"
fi

# Install git-filter-repo
echo "🧹 Checking git-filter-repo..."
if ! command -v git-filter-repo &>/dev/null; then
    echo "Installing git-filter-repo..."
    brew install git-filter-repo
    echo "✅ git-filter-repo installed"
else
    echo "✅ git-filter-repo already installed"
fi


# Install applications via Homebrew Cask
echo "📱 Checking applications..."

# Brave Browser
if ! ls /Applications/ 2>/dev/null | grep -qi "brave"; then
    echo "🦁 Installing Brave Browser..."
    brew install --cask brave-browser
    echo "✅ Brave Browser installed"
else
    echo "✅ Brave Browser already installed"
fi

# Visual Studio Code
if ! ls /Applications/ 2>/dev/null | grep -qi "visual studio code"; then
    echo "💻 Installing Visual Studio Code..."
    brew install --cask visual-studio-code
    echo "✅ Visual Studio Code installed"
else
    echo "✅ Visual Studio Code already installed"
fi

# Install VS Code command line tools
echo "⚙️ Checking VS Code CLI..."
if ! command -v code &>/dev/null; then
    echo "Installing VS Code CLI..."
    # The 'code' command should be available after installing VS Code via Homebrew
    # If not, we can add it manually
    sudo ln -sf "/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code" /usr/local/bin/code 2>/dev/null || {
        echo "Please add VS Code CLI manually by opening VS Code and running 'Shell Command: Install code command in PATH'"
    }
else
    echo "✅ VS Code CLI already available"
fi

# Verify installations
echo ""
echo "🔍 Current installation status:"

command -v brew >/dev/null && echo "✅ Homebrew: $(brew --version | head -n1)"
command -v git >/dev/null && echo "✅ Git: $(git --version)"
command -v uv >/dev/null && echo "✅ uv: $(uv --version)"
command -v git-filter-repo >/dev/null && echo "✅ git-filter-repo: $(git-filter-repo --version 2>&1 | head -n1)"

# Check Node/npm (may be installed separately)
command -v node >/dev/null && echo "✅ Node.js: $(node --version)"
command -v npm >/dev/null && echo "✅ npm: $(npm --version)"

ls /Applications/ 2>/dev/null | grep -qi "brave" && echo "✅ Brave Browser: Installed"
ls /Applications/ 2>/dev/null | grep -qi "visual studio code" && echo "✅ VS Code: Installed"
command -v code >/dev/null && echo "✅ VS Code CLI: Available"

echo ""
echo "🎉 macOS setup complete!"
echo ""
echo "📝 Next steps:"
echo "1. Restart your terminal or run 'source ~/.zshrc' to reload your shell"
echo "2. Configure git if not already done:"
echo "   git config --global user.name 'Your Name'"
echo "   git config --global user.email 'your.email@example.com'"
echo "3. Open VS Code and install your preferred extensions"