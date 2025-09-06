#!/bin/bash

# Claude Code Global Configuration Setup
# Installs the local CLAUDE.md to the global Claude directory

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
GLOBAL_CLAUDE_DIR="$HOME/.claude"
SOURCE_FILE="$SCRIPT_DIR/CLAUDE.md"

echo "🌍 Setting up Global Claude Code configuration..."

# Validate source file exists
if [[ ! -f "$SOURCE_FILE" ]]; then
    echo "❌ Source file not found: $SOURCE_FILE"
    echo "   Please run this script from the claude_code_settings directory"
    exit 1
fi

# Create global .claude directory if it doesn't exist
if [[ ! -d "$GLOBAL_CLAUDE_DIR" ]]; then
    echo "📁 Creating global .claude directory..."
    mkdir -p "$GLOBAL_CLAUDE_DIR"
fi

# Backup existing global CLAUDE.md if it exists
if [[ -f "$GLOBAL_CLAUDE_DIR/CLAUDE.md" ]]; then
    echo "💾 Backing up existing global CLAUDE.md..."
    cp "$GLOBAL_CLAUDE_DIR/CLAUDE.md" "$GLOBAL_CLAUDE_DIR/CLAUDE.md.backup.$(date +%Y%m%d_%H%M%S)"
fi

# Copy local CLAUDE.md to global location
echo "📝 Installing global CLAUDE.md..."
cp "$SOURCE_FILE" "$GLOBAL_CLAUDE_DIR/CLAUDE.md"

echo ""
echo "🎉 Global setup complete!"
echo ""
echo "📋 What was installed:"
echo "  - Global CLAUDE.md: $GLOBAL_CLAUDE_DIR/CLAUDE.md"
echo ""
echo "💡 This configuration will now apply to all Claude Code sessions"
echo "   unless overridden by project-specific CLAUDE.md files."