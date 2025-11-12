#!/bin/bash

# Claude Code Configuration Setup
# Installs Claude Code CLI globally and sets up configurations
# Can optionally set up repo-specific CLAUDE.md based on language

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SETTINGS_DIR="$SCRIPT_DIR"

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

# Parse command line arguments
SETUP_MODE="both"  # both, global, or repo
TARGET_DIR=""
PROJECT_TYPE=""

# If no arguments, run in interactive mode
if [[ $# -eq 0 ]]; then
    SETUP_MODE="interactive"
elif [[ $# -eq 2 ]]; then
    TARGET_DIR="$1"
    PROJECT_TYPE="$2"
    SETUP_MODE="repo"
else
    echo "❌ Usage: $0 [project-directory] [language]"
    echo ""
    echo "Run without arguments for interactive setup"
    echo ""
    echo "Languages: javascript, python, csharp"
    echo ""
    echo "Examples:"
    echo "  ./setup-claude-code.sh                                    # Interactive mode"
    echo "  ./setup-claude-code.sh /path/to/my-python-project python  # Repo-only setup"
    echo "  ./setup-claude-code.sh ~/code/my-js-app javascript        # Repo-only setup"
    echo "  ./setup-claude-code.sh ./my-dotnet-api csharp             # Repo-only setup"
    echo ""
    exit 1
fi

echo "🤖 Claude Code Configuration Setup"
echo ""

# Interactive mode setup
if [[ "$SETUP_MODE" == "interactive" ]]; then
    INSTALL_CLAUDE_CLI=false
    SETUP_GLOBAL_CLAUDE=false
    SETUP_REPO_CLAUDE=false

    # Check if Claude Code CLI is installed
    if ! command -v claude &>/dev/null; then
        if prompt_yes_no "🤖 Install Claude Code CLI?"; then
            INSTALL_CLAUDE_CLI=true
        fi
    else
        echo "✅ Claude Code CLI already installed: $(claude --version)"
    fi

    # Check global CLAUDE.md
    if [[ ! -f "$HOME/.claude/CLAUDE.md" ]]; then
        if prompt_yes_no "🌍 Setup global CLAUDE.md configuration?"; then
            SETUP_GLOBAL_CLAUDE=true
        fi
    else
        echo "✅ Global CLAUDE.md already configured"
        if prompt_yes_no "🌍 Update global CLAUDE.md configuration?"; then
            SETUP_GLOBAL_CLAUDE=true
        fi
    fi

    # Ask about repo-specific setup
    if prompt_yes_no "📁 Setup repo-specific CLAUDE.md?"; then
        SETUP_REPO_CLAUDE=true
        read -p "📂 Enter project directory: " TARGET_DIR
        TARGET_DIR="${TARGET_DIR/#\~/$HOME}"  # Expand tilde

        # Validate directory
        if [[ ! -d "$TARGET_DIR" ]]; then
            echo "❌ Directory does not exist: $TARGET_DIR"
            exit 1
        fi

        TARGET_DIR=$(cd "$TARGET_DIR" && pwd)

        echo ""
        echo "Select language:"
        echo "  1) JavaScript/TypeScript"
        echo "  2) Python"
        echo "  3) C#"
        read -p "Enter choice (1-3): " lang_choice

        case $lang_choice in
            1) PROJECT_TYPE="javascript";;
            2) PROJECT_TYPE="python";;
            3) PROJECT_TYPE="csharp";;
            *) echo "❌ Invalid choice"; exit 1;;
        esac
    fi
fi

# Repo-only mode setup
if [[ "$SETUP_MODE" == "repo" ]]; then
    # Validate language
    if [[ "$PROJECT_TYPE" != "javascript" && "$PROJECT_TYPE" != "python" && "$PROJECT_TYPE" != "csharp" ]]; then
        echo "❌ Invalid language: $PROJECT_TYPE"
        echo "Valid languages: javascript, python, csharp"
        exit 1
    fi

    # Resolve absolute path
    TARGET_DIR="${TARGET_DIR/#\~/$HOME}"  # Expand tilde
    TARGET_DIR=$(cd "$TARGET_DIR" 2>/dev/null && pwd || echo "$TARGET_DIR")

    # Validate target directory exists
    if [[ ! -d "$TARGET_DIR" ]]; then
        echo "❌ Directory does not exist: $TARGET_DIR"
        exit 1
    fi

    SETUP_REPO_CLAUDE=true
fi

echo ""
echo "🚀 Starting installation..."
echo ""

# Install Claude Code CLI
if [[ "$INSTALL_CLAUDE_CLI" == true ]]; then
    echo "🤖 Installing Claude Code CLI..."

    # Ensure NVM is loaded if available
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

    if ! command -v npm &>/dev/null; then
        echo "❌ npm not found. Please install Node.js first."
        echo "   Visit: https://nodejs.org/ or use NVM"
        exit 1
    fi

    npm install -g @anthropic-ai/claude-code
    echo "✅ Claude Code CLI installed"
fi

# Setup global CLAUDE.md configuration
if [[ "$SETUP_GLOBAL_CLAUDE" == true ]]; then
    echo "🌍 Setting up global CLAUDE.md configuration..."

    GLOBAL_CLAUDE_DIR="$HOME/.claude"
    SOURCE_FILE="$SCRIPT_DIR/claude_templates/CLAUDE.md"

    # Create global .claude directory if it doesn't exist
    if [[ ! -d "$GLOBAL_CLAUDE_DIR" ]]; then
        mkdir -p "$GLOBAL_CLAUDE_DIR"
    fi

    # Backup existing CLAUDE.md if it exists
    if [[ -f "$GLOBAL_CLAUDE_DIR/CLAUDE.md" ]]; then
        echo "💾 Backing up existing global CLAUDE.md..."
        cp "$GLOBAL_CLAUDE_DIR/CLAUDE.md" "$GLOBAL_CLAUDE_DIR/CLAUDE.md.backup.$(date +%Y%m%d_%H%M%S)"
    fi

    # Copy global CLAUDE.md
    cp "$SOURCE_FILE" "$GLOBAL_CLAUDE_DIR/CLAUDE.md"

    # Copy settings.json if it doesn't exist
    if [[ ! -f "$GLOBAL_CLAUDE_DIR/settings.json" ]]; then
        SETTINGS_FILE="$SCRIPT_DIR/claude_templates/settings.json"
        if [[ -f "$SETTINGS_FILE" ]]; then
            cp "$SETTINGS_FILE" "$GLOBAL_CLAUDE_DIR/settings.json"
        fi
    fi

    echo "✅ Global CLAUDE.md configuration installed"
    echo "   Location: $GLOBAL_CLAUDE_DIR/CLAUDE.md"
fi

# Setup repo-specific configuration
if [[ "$SETUP_REPO_CLAUDE" == true ]]; then
    echo ""
    echo "📁 Setting up repo-specific configuration..."
    echo "   Target: $TARGET_DIR"
    echo "   Language: $PROJECT_TYPE"

    # Create .claude directory in target repo
    REPO_CLAUDE_DIR="$TARGET_DIR/.claude"
    if [[ ! -d "$REPO_CLAUDE_DIR" ]]; then
        echo "📁 Creating .claude directory..."
        mkdir -p "$REPO_CLAUDE_DIR"
    fi

    # Backup existing repo CLAUDE.md if it exists
    if [[ -f "$TARGET_DIR/CLAUDE.md" ]]; then
        echo "💾 Backing up existing CLAUDE.md..."
        cp "$TARGET_DIR/CLAUDE.md" "$TARGET_DIR/CLAUDE.md.backup.$(date +%Y%m%d_%H%M%S)"
    fi

    # Copy language-specific CLAUDE.md template
    echo "📝 Installing $PROJECT_TYPE-specific CLAUDE.md..."
    cp "$SETTINGS_DIR/claude_templates/$PROJECT_TYPE/CLAUDE.md" "$TARGET_DIR/CLAUDE.md"

    # Backup existing repo settings if they exist
    if [[ -f "$REPO_CLAUDE_DIR/settings.json" ]]; then
        echo "💾 Backing up existing repo settings..."
        cp "$REPO_CLAUDE_DIR/settings.json" "$REPO_CLAUDE_DIR/settings.json.backup.$(date +%Y%m%d_%H%M%S)"
    fi

    # Copy generic repo settings
    echo "⚙️  Installing generic repo settings..."
    cp "$SETTINGS_DIR/claude_templates/settings.json" "$REPO_CLAUDE_DIR/settings.json"

    echo "✅ Repo-specific configuration installed"
    echo "   - Language-specific CLAUDE.md: $TARGET_DIR/CLAUDE.md"
    echo "   - Local settings: $REPO_CLAUDE_DIR/settings.json"
fi

echo ""
echo "🎉 Setup complete!"
echo ""