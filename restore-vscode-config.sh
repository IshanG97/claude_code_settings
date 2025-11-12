#!/bin/bash

# Restore VS Code configuration from dotfiles repo
# This script restores settings, keybindings, snippets, and installs extensions

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

# Check if VS Code config exists
if [ ! -d "$VSCODE_DIR" ]; then
    echo "Error: VS Code configuration not found at $VSCODE_DIR"
    echo "Run ./export-vscode-config.sh first"
    exit 1
fi

# Create VS Code config directory if it doesn't exist
mkdir -p "$VSCODE_CONFIG"

echo "Restoring VS Code configuration..."

# Restore settings
if [ -f "$VSCODE_DIR/settings.json" ]; then
    cp "$VSCODE_DIR/settings.json" "$VSCODE_CONFIG/settings.json"
    echo "✓ Restored settings.json"
fi

# Restore keybindings
if [ -f "$VSCODE_DIR/keybindings.json" ]; then
    cp "$VSCODE_DIR/keybindings.json" "$VSCODE_CONFIG/keybindings.json"
    echo "✓ Restored keybindings.json"
fi

# Restore snippets
if [ -d "$VSCODE_DIR/snippets" ]; then
    rm -rf "$VSCODE_CONFIG/snippets"
    cp -r "$VSCODE_DIR/snippets" "$VSCODE_CONFIG/snippets"
    echo "✓ Restored snippets"
fi

# Install extensions
if [ -f "$VSCODE_DIR/extensions.txt" ]; then
    echo ""
    echo "Installing extensions..."
    while IFS= read -r extension; do
        if [ -n "$extension" ]; then
            echo "Installing: $extension"
            code --install-extension "$extension" --force
        fi
    done < "$VSCODE_DIR/extensions.txt"
    echo "✓ Extensions installed"
fi

echo ""
echo "VS Code configuration restored successfully!"
echo "Restart VS Code to apply all changes."
