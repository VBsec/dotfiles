#!/bin/bash

# Test the new Neovim configuration
# This uses NVIM_APPNAME to load config from ~/.config/nvim-new instead of ~/.config/nvim

echo "Testing new Neovim configuration..."
echo "Config location: ~/.config/nvim-new"
echo ""
echo "To use this config:"
echo "1. Run: ./install.sh to symlink the config"
echo "2. Then: NVIM_APPNAME=nvim-new nvim"
echo ""
echo "Starting Neovim with new config..."

NVIM_APPNAME=nvim-new nvim "$@"