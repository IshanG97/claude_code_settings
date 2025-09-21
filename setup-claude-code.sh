#!/bin/bash

# Claude Code Configuration Setup
# Sets up repo-specific CLAUDE.md and settings.json based on language

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SETTINGS_DIR="$SCRIPT_DIR"

# Check if global setup was requested
if [[ $# -eq 1 && "$1" == "--global" ]]; then
    echo "🌍 Setting up Global Claude Code configuration..."

    GLOBAL_CLAUDE_DIR="$HOME/.claude"
    SOURCE_FILE="$SCRIPT_DIR/CLAUDE.md"

    # Validate source file exists
    if [[ ! -f "$SOURCE_FILE" ]]; then
        echo "❌ Source file not found: $SOURCE_FILE"
        exit 1
    fi

    # Create global .claude directory if it doesn't exist
    if [[ ! -d "$GLOBAL_CLAUDE_DIR" ]]; then
        echo "📁 Creating global .claude directory..."
        mkdir -p "$GLOBAL_CLAUDE_DIR"
    fi

    # Copy local CLAUDE.md to global location
    echo "📝 Installing global CLAUDE.md..."
    cp "$SOURCE_FILE" "$GLOBAL_CLAUDE_DIR/CLAUDE.md"

    # Copy settings.json to global location
    SETTINGS_FILE="$SCRIPT_DIR/templates/settings.json"
    if [[ -f "$SETTINGS_FILE" ]]; then
        echo "⚙️  Installing global settings.json..."
        cp "$SETTINGS_FILE" "$GLOBAL_CLAUDE_DIR/settings.json"
    fi

    echo ""
    echo "🎉 Global setup complete!"
    echo "📋 Installed: $GLOBAL_CLAUDE_DIR/CLAUDE.md"
    echo "📋 Installed: $GLOBAL_CLAUDE_DIR/settings.json"
    echo "💡 This configuration will apply to all Claude Code sessions"
    exit 0
fi

# Check if required arguments were provided for project setup
if [[ $# -ne 2 ]]; then
    echo "❌ Usage: $0 <project-directory> <language>"
    echo "   OR: $0 --global"
    echo ""
    echo "Languages: javascript, python, csharp"
    echo ""
    echo "Examples:"
    echo "  $0 /path/to/my-python-project python"
    echo "  $0 ~/code/my-js-app javascript"
    echo "  $0 ./my-dotnet-api csharp"
    echo "  $0 --global"
    exit 1
fi

TARGET_DIR="$1"
PROJECT_TYPE="$2"

# Validate language
if [[ "$PROJECT_TYPE" != "javascript" && "$PROJECT_TYPE" != "python" && "$PROJECT_TYPE" != "csharp" ]]; then
    echo "❌ Invalid language: $PROJECT_TYPE"
    echo "Valid languages: javascript, python, csharp"
    exit 1
fi

# Resolve absolute path
TARGET_DIR=$(cd "$TARGET_DIR" 2>/dev/null && pwd || echo "$TARGET_DIR")

# Validate target directory exists
if [[ ! -d "$TARGET_DIR" ]]; then
    echo "❌ Directory does not exist: $TARGET_DIR"
    exit 1
fi

echo "🎯 Setting up Claude Code configuration..."
echo "📁 Target: $TARGET_DIR"
echo "🔤 Language: $PROJECT_TYPE"


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
cp "$SETTINGS_DIR/templates/$PROJECT_TYPE/CLAUDE.md" "$TARGET_DIR/CLAUDE.md"

# Backup existing repo settings if they exist
if [[ -f "$REPO_CLAUDE_DIR/settings.json" ]]; then
    echo "💾 Backing up existing repo settings..."
    cp "$REPO_CLAUDE_DIR/settings.json" "$REPO_CLAUDE_DIR/settings.json.backup.$(date +%Y%m%d_%H%M%S)"
fi

# Copy generic repo settings
echo "⚙️  Installing generic repo settings..."
cp "$SETTINGS_DIR/templates/settings.json" "$REPO_CLAUDE_DIR/settings.json"

echo ""
echo "🎉 Setup complete!"
echo ""
echo "📋 What was installed:"
echo "  - Language-specific CLAUDE.md: $TARGET_DIR/CLAUDE.md"
echo "  - Local settings: $TARGET_DIR/.claude/settings.json"
echo ""