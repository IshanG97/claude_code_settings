#!/bin/bash

# Export VS Code configuration to dotfiles repo
# This script exports settings, keybindings, snippets, and extensions

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
VSCODE_DIR="$SCRIPT_DIR/.config/vscode"

# Determine VS Code config location based on OS
if [[ "$OSTYPE" == "darwin"* ]]; then
    VSCODE_CONFIG="$HOME/Library/Application Support/Code/User"
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    VSCODE_CONFIG="$HOME/.config/Code/User"
else
    echo "Unsupported OS: $OSTYPE"
    exit 1
fi

# Create vscode directory if it doesn't exist
mkdir -p "$VSCODE_DIR"

echo "Exporting VS Code configuration..."

# Export settings
if [ -f "$VSCODE_CONFIG/settings.json" ]; then
    cp "$VSCODE_CONFIG/settings.json" "$VSCODE_DIR/settings.json"
    echo "✓ Exported settings.json"
else
    echo "⚠ settings.json not found"
fi

# Export keybindings
if [ -f "$VSCODE_CONFIG/keybindings.json" ]; then
    cp "$VSCODE_CONFIG/keybindings.json" "$VSCODE_DIR/keybindings.json"
    echo "✓ Exported keybindings.json"
else
    echo "⚠ keybindings.json not found"
fi

# Export snippets
if [ -d "$VSCODE_CONFIG/snippets" ]; then
    rm -rf "$VSCODE_DIR/snippets"
    cp -r "$VSCODE_CONFIG/snippets" "$VSCODE_DIR/snippets"
    echo "✓ Exported snippets"
else
    echo "⚠ snippets directory not found"
fi

# Export extensions list
code --list-extensions > "$VSCODE_DIR/extensions.txt"
echo "✓ Exported extensions list"

# Export extension versions for reproducibility
code --list-extensions --show-versions > "$VSCODE_DIR/extensions-with-versions.txt"
echo "✓ Exported extensions with versions"

echo ""
echo "VS Code configuration exported to: $VSCODE_DIR"
echo ""
echo "To restore on another machine:"
echo "  1. Run: ./restore-vscode-config.sh"
echo "  2. Or manually copy files and install extensions"
