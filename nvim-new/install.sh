#!/bin/bash

# Install/symlink the new nvim configuration for testing
# This creates ~/.config/nvim-new symlink pointing to this directory

CONFIG_DIR="$HOME/.config/nvim-new"
SOURCE_DIR="$(cd "$(dirname "$0")/.config/nvim-new" && pwd)"

echo "Installing new Neovim configuration for testing..."
echo "Source: $SOURCE_DIR"
echo "Target: $CONFIG_DIR"

# Remove existing symlink/directory if it exists
if [ -L "$CONFIG_DIR" ] || [ -e "$CONFIG_DIR" ]; then
    echo "Removing existing config at $CONFIG_DIR"
    rm -rf "$CONFIG_DIR"
fi

# Create symlink
ln -s "$SOURCE_DIR" "$CONFIG_DIR"

echo ""
echo "✓ Configuration installed!"
echo ""
echo "To test the new config, run:"
echo "  NVIM_APPNAME=nvim-new nvim"
echo ""
echo "Or use the provided script:"
echo "  ./test-new-config.sh"
echo ""
echo "Your original config at ~/.config/nvim remains untouched."