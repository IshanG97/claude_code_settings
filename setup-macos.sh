#!/bin/bash

set -e

echo "🚀 Starting macOS setup..."

# Check if running on macOS
if [[ "$OSTYPE" != "darwin"* ]]; then
    echo "❌ This script is only for macOS"
    exit 1
fi

# Function to prompt for yes/no
prompt_yes_no() {
    local prompt="$1"
    local response
    while true; do
        read -p "$prompt (y/n): " response
        case "$response" in
            [Yy]* ) return 0;;
            [Nn]* ) return 1;;
            * ) echo "Please answer y or n.";;
        esac
    done
}

echo ""
echo "📋 Let's configure what to install..."
echo ""

# Ask about each component upfront
INSTALL_XCODE=false
INSTALL_HOMEBREW=false
INSTALL_GIT=false
INSTALL_UV=false
INSTALL_GIT_FILTER_REPO=false
INSTALL_BRAVE=false
INSTALL_VSCODE=false
INSTALL_VSCODE_CLI=false
INSTALL_NVM=false
INSTALL_NODE=false
INSTALL_NPM_PACKAGES=false
INSTALL_PYENV=false
INSTALL_PYTHON=false
INSTALL_LUNAR=false
INSTALL_MACCY=false

# Check Xcode
if ! xcode-select -p &>/dev/null; then
    if prompt_yes_no "📦 Install Xcode Command Line Tools?"; then
        INSTALL_XCODE=true
    fi
else
    echo "✅ Xcode Command Line Tools already installed"
fi

# Check Homebrew
if ! command -v brew &>/dev/null; then
    if prompt_yes_no "🍺 Install Homebrew?"; then
        INSTALL_HOMEBREW=true
    fi
else
    echo "✅ Homebrew already installed"
    INSTALL_HOMEBREW=true  # Mark as true so we can install brew packages
fi

# Only ask about Homebrew-dependent tools if Homebrew will be available
if [[ "$INSTALL_HOMEBREW" == true ]] || command -v brew &>/dev/null; then
    # Check Git
    if ! command -v git &>/dev/null; then
        if prompt_yes_no "📚 Install Git?"; then
            INSTALL_GIT=true
        fi
    else
        echo "✅ Git already installed"
    fi

    # Check git-filter-repo
    if ! command -v git-filter-repo &>/dev/null; then
        if prompt_yes_no "🧹 Install git-filter-repo?"; then
            INSTALL_GIT_FILTER_REPO=true
        fi
    else
        echo "✅ git-filter-repo already installed"
    fi

    # Check pyenv
    if ! command -v pyenv &>/dev/null; then
        if prompt_yes_no "🐍 Install pyenv (Python version manager)?"; then
            INSTALL_PYENV=true
            # Ask about Python if installing pyenv
            if prompt_yes_no "   Install Python via pyenv?"; then
                INSTALL_PYTHON=true
                read -p "   Enter Python version (e.g., 3.13): " PYTHON_VERSION
            fi
        fi
    else
        echo "✅ pyenv already installed"
        # Ask about Python if pyenv exists but no global Python set
        if ! pyenv global &>/dev/null || [[ "$(pyenv global)" == "system" ]]; then
            if prompt_yes_no "🐍 Install Python via pyenv?"; then
                INSTALL_PYTHON=true
                read -p "   Enter Python version (e.g., 3.13): " PYTHON_VERSION
            fi
        else
            echo "✅ Python already configured via pyenv: $(pyenv global)"
        fi
    fi

    # Check Brave Browser
    if ! ls /Applications/ 2>/dev/null | grep -qi "brave"; then
        if prompt_yes_no "🦁 Install Brave Browser?"; then
            INSTALL_BRAVE=true
        fi
    else
        echo "✅ Brave Browser already installed"
    fi

    # Check Lunar
    if ! ls /Applications/ 2>/dev/null | grep -qi "lunar"; then
        if prompt_yes_no "🌙 Install Lunar (display brightness control)?"; then
            INSTALL_LUNAR=true
        fi
    else
        echo "✅ Lunar already installed"
    fi

    # Check Maccy
    if ! command -v maccy &>/dev/null && ! ls /Applications/ 2>/dev/null | grep -qi "maccy"; then
        if prompt_yes_no "📋 Install Maccy (clipboard manager)?"; then
            INSTALL_MACCY=true
        fi
    else
        echo "✅ Maccy already installed"
    fi

    # Check Visual Studio Code
    if ! ls /Applications/ 2>/dev/null | grep -qi "visual studio code"; then
        if prompt_yes_no "💻 Install Visual Studio Code?"; then
            INSTALL_VSCODE=true
            # Ask about CLI if installing VS Code
            if prompt_yes_no "⚙️  Install VS Code CLI (code command)?"; then
                INSTALL_VSCODE_CLI=true
            fi
        fi
    else
        echo "✅ Visual Studio Code already installed"
        # Ask about CLI if VS Code exists but CLI doesn't
        if ! command -v code &>/dev/null; then
            if prompt_yes_no "⚙️  Install VS Code CLI (code command)?"; then
                INSTALL_VSCODE_CLI=true
            fi
        else
            echo "✅ VS Code CLI already available"
        fi
    fi
else
    echo "⚠️  Skipping Homebrew-dependent tools (Homebrew not selected)"
fi

# Check uv (not dependent on Homebrew)
if ! command -v uv &>/dev/null; then
    if prompt_yes_no "🐍 Install uv (Python package manager)?"; then
        INSTALL_UV=true
    fi
else
    echo "✅ uv already installed"
fi

# Check NVM (not dependent on Homebrew)
if ! command -v nvm &>/dev/null; then
    if prompt_yes_no "📦 Install NVM (Node Version Manager)?"; then
        INSTALL_NVM=true
        # Ask about Node.js if installing NVM
        if prompt_yes_no "   Install Node.js LTS via NVM?"; then
            INSTALL_NODE=true
            # Ask about global npm packages if installing Node.js
            if prompt_yes_no "   Install global npm packages (@openai/codex)?"; then
                INSTALL_NPM_PACKAGES=true
            fi
        fi
    fi
else
    echo "✅ NVM already installed"
    # Ask about Node.js if NVM exists but Node doesn't
    if ! command -v node &>/dev/null; then
        if prompt_yes_no "📦 Install Node.js LTS via NVM?"; then
            INSTALL_NODE=true
            # Ask about global npm packages if installing Node.js
            if prompt_yes_no "   Install global npm packages (@openai/codex)?"; then
                INSTALL_NPM_PACKAGES=true
            fi
        fi
    else
        echo "✅ Node.js already installed"
        # Ask about global npm packages if Node exists
        if prompt_yes_no "📦 Install global npm packages (@openai/codex)?"; then
            INSTALL_NPM_PACKAGES=true
        fi
    fi
fi

echo ""
echo "🚦 Starting installation based on your choices..."
echo ""

# Install Xcode Command Line Tools (required for git and other tools)
if [[ "$INSTALL_XCODE" == true ]]; then
    echo "📦 Installing Xcode Command Line Tools..."
    xcode-select --install
    echo "⏳ Please complete the Xcode Command Line Tools installation and run this script again"
    exit 0
fi

# Install Homebrew
if [[ "$INSTALL_HOMEBREW" == true ]] && ! command -v brew &>/dev/null; then
    echo "🍺 Installing Homebrew..."
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
fi

# Ensure Homebrew is in .zshrc if already installed
if command -v brew &>/dev/null; then
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
if command -v brew &>/dev/null; then
    echo "🔄 Updating Homebrew..."
    brew update
fi

# Install git
if [[ "$INSTALL_GIT" == true ]]; then
    echo "📚 Installing Git..."
    brew install git
    echo "✅ Git installed"
fi

# Install uv
if [[ "$INSTALL_UV" == true ]]; then
    echo "🐍 Installing uv..."
    curl -LsSf https://astral.sh/uv/install.sh | sh
    # Add uv to PATH in .zshrc
    export PATH="$HOME/.cargo/bin:$PATH"
    echo 'export PATH="$HOME/.cargo/bin:$PATH"' >> ~/.zshrc
    echo "✅ uv installed"
fi

# Install git-filter-repo
if [[ "$INSTALL_GIT_FILTER_REPO" == true ]]; then
    echo "🧹 Installing git-filter-repo..."
    brew install git-filter-repo
    echo "✅ git-filter-repo installed"
fi

# Install pyenv
if [[ "$INSTALL_PYENV" == true ]]; then
    echo "🐍 Installing pyenv..."
    brew install pyenv

    # Add pyenv to .zshrc
    if ! grep -q 'eval "$(pyenv init -)"' ~/.zshrc 2>/dev/null; then
        echo '' >> ~/.zshrc
        echo '# pyenv configuration' >> ~/.zshrc
        echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.zshrc
        echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.zshrc
        echo 'eval "$(pyenv init --path)"' >> ~/.zshrc
        echo 'eval "$(pyenv init -)"' >> ~/.zshrc
    fi

    # Load pyenv for this session
    export PYENV_ROOT="$HOME/.pyenv"
    export PATH="$PYENV_ROOT/bin:$PATH"
    eval "$(pyenv init --path)"
    eval "$(pyenv init -)"

    echo "✅ pyenv installed"
fi

# Install Python via pyenv
if [[ "$INSTALL_PYTHON" == true ]]; then
    # Ensure pyenv is loaded
    export PYENV_ROOT="$HOME/.pyenv"
    export PATH="$PYENV_ROOT/bin:$PATH"
    eval "$(pyenv init --path)"
    eval "$(pyenv init -)"

    echo "🐍 Installing Python $PYTHON_VERSION via pyenv..."
    pyenv install "$PYTHON_VERSION"
    pyenv global "$PYTHON_VERSION"

    echo "✅ Python installed: $(python --version)"
    echo "✅ pip installed: $(pip --version)"
fi

# Install NVM
if [[ "$INSTALL_NVM" == true ]]; then
    echo "📦 Installing NVM..."
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.4/install.sh | bash
    echo "✅ NVM installed"

    # Load NVM for this session
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
fi

# Install Node.js via NVM
if [[ "$INSTALL_NODE" == true ]]; then
    # Ensure NVM is loaded
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

    echo "📦 Installing Node.js LTS via NVM..."
    nvm install --lts
    nvm use --lts
    nvm alias default node
    echo "✅ Node.js installed: $(node --version)"
    echo "✅ npm installed: $(npm --version)"
fi

# Install global npm packages
if [[ "$INSTALL_NPM_PACKAGES" == true ]]; then
    # Ensure NVM is loaded
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

    echo "📦 Installing global npm packages..."
    npm install -g @openai/codex
    echo "✅ Global npm packages installed"
fi

# Install applications via Homebrew Cask
# Brave Browser
if [[ "$INSTALL_BRAVE" == true ]]; then
    echo "🦁 Installing Brave Browser..."
    brew install --cask brave-browser
    echo "✅ Brave Browser installed"
fi

# Lunar
if [[ "$INSTALL_LUNAR" == true ]]; then
    echo "🌙 Installing Lunar..."
    brew install --cask lunar
    echo "✅ Lunar installed"
fi

# Maccy
if [[ "$INSTALL_MACCY" == true ]]; then
    echo "📋 Installing Maccy..."
    brew install maccy
    echo "✅ Maccy installed"
fi

# Visual Studio Code
if [[ "$INSTALL_VSCODE" == true ]]; then
    echo "💻 Installing Visual Studio Code..."
    brew install --cask visual-studio-code
    echo "✅ Visual Studio Code installed"
fi

# Install VS Code command line tools
if [[ "$INSTALL_VSCODE_CLI" == true ]]; then
    echo "⚙️ Installing VS Code CLI..."
    # The 'code' command should be available after installing VS Code via Homebrew
    # If not, we can add it manually
    sudo ln -sf "/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code" /usr/local/bin/code 2>/dev/null || {
        echo "Please add VS Code CLI manually by opening VS Code and running 'Shell Command: Install code command in PATH'"
    }
    echo "✅ VS Code CLI installed"
fi

# Verify installations
echo ""
echo "🔍 Current installation status:"

command -v brew >/dev/null && echo "✅ Homebrew: $(brew --version | head -n1)"
command -v git >/dev/null && echo "✅ Git: $(git --version)"
command -v uv >/dev/null && echo "✅ uv: $(uv --version)"
command -v git-filter-repo >/dev/null && echo "✅ git-filter-repo: $(git-filter-repo --version 2>&1 | head -n1)"

# Check pyenv/Python
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --path)" 2>/dev/null
eval "$(pyenv init -)" 2>/dev/null
command -v pyenv >/dev/null && echo "✅ pyenv: $(pyenv --version)"
command -v python >/dev/null && echo "✅ Python: $(python --version)"
command -v pip >/dev/null && echo "✅ pip: $(pip --version)"

# Check NVM/Node/npm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
command -v nvm >/dev/null && echo "✅ NVM: $(nvm --version)"
command -v node >/dev/null && echo "✅ Node.js: $(node --version)"
command -v npm >/dev/null && echo "✅ npm: $(npm --version)"

ls /Applications/ 2>/dev/null | grep -qi "brave" && echo "✅ Brave Browser: Installed"
ls /Applications/ 2>/dev/null | grep -qi "lunar" && echo "✅ Lunar: Installed"
command -v maccy >/dev/null && echo "✅ Maccy: Installed"
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