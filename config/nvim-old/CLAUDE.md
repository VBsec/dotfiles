# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a Neovim configuration based on LazyVim that supports both standalone Neovim and VS Code integration through the VSCode Neovim extension. The configuration automatically detects the environment (vim.g.vscode) and loads appropriate settings.


## Architecture

### Core Structure
- **init.lua**: Entry point that detects environment (VSCode vs native Neovim) and loads appropriate configurations
- **lua/config/**: Core configuration files
  - `lazy.lua`: Plugin manager setup using lazy.nvim
  - `keymaps.lua`: Keybindings with separate mappings for VSCode and native Neovim
  - `options.lua`: Vim options configuration
  - `autocmds.lua`: Auto commands
- **lua/plugins/**: Individual plugin configurations (one file per plugin/feature)
- **lazyvim.json**: LazyVim extras configuration defining enabled language support and features

### Key Features
- Dual-mode support: Works in both standalone Neovim and as VSCode extension
- LazyVim framework with extensive extras for multiple languages (TypeScript, Python, Rust, Go, etc.)
- Custom plugin configurations for enhanced editing experience
- VSCode-specific keybindings and integrations when running inside VSCode
- Fzf-lua is used instead of Telescope

## Common Development Tasks

### Plugin Management
```bash
# Open Neovim and use:
:Lazy             # Open plugin manager UI
:Lazy update      # Update all plugins
:Lazy sync        # Sync plugin state with lockfile
```

### Health Check
```bash
nvim
:checkhealth      # Check Neovim and plugin health
```

### Configuration Locations
- Add new plugins: Create a new file in `lua/plugins/`. Use existing files where appropriate.
- Modify keybindings: Edit `lua/config/keymaps.lua`
- Add LazyVim extras: Edit `lazyvim.json`
- LazyVim and plugin/extra configs are in ~/.local/share/nvim/

## VS Code Integration

When running inside VS Code:
- Special keybindings activate VS Code commands instead of Neovim features
- Bookmarks integration with VS Code Bookmarks extension
- Multi-cursor support via `vscode-multi-cursor` plugin
- File explorer and symbol navigation use VS Code's native UI

Required VS Code extensions listed in README.md:
- VS Code Neovim
- Neovim UI Modifier
- Bookmarks

## Important Notes

- No Makefile or package.json exists - this is a pure Neovim configuration
- Plugin updates are managed through lazy.nvim's lockfile (`lazy-lock.json`)
- Environment detection happens in init.lua:2-61 to load appropriate configurations
- Before adding or editing keymaps or plugins, always perform a search for existing ones in both this directory as well as ~/.local/share/nvim/
