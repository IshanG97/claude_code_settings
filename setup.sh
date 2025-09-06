#!/bin/bash

# Claude Code Configuration Setup
# Sets up repo-specific CLAUDE.md and settings.json based on language

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SETTINGS_DIR="$SCRIPT_DIR"

# Check if required arguments were provided
if [[ $# -ne 2 ]]; then
    echo "❌ Usage: $0 <project-directory> <language>"
    echo ""
    echo "Languages: javascript, python, csharp"
    echo ""
    echo "Examples:"
    echo "  $0 /path/to/my-python-project python"
    echo "  $0 ~/code/my-js-app javascript"
    echo "  $0 ./my-dotnet-api csharp"
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