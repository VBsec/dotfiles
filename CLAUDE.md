# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a personal dotfiles repository containing configuration files for various development tools on macOS. The configurations are organized by application and designed to be symlinked to their appropriate locations using GNU stow.

## Architecture

### Directory Structure
Each directory represents a separate application configuration that can be managed independently:

- **aerospace/**: Window manager configuration (aerospace.toml)
- **alacritty/**: Terminal emulator configuration
- **claude/**: Claude AI assistant configuration
- **cursor/**: Cursor editor settings, keybindings, and extensions
- **ghostty/**: Ghostty terminal configuration
- **linearmouse/**: Mouse configuration utility
- **nvim/**: Neovim configuration with LazyVim framework (has its own CLAUDE.md at nvim/.config/nvim/CLAUDE.md)
- **starship/**: Cross-shell prompt configuration
- **tmux/**: Terminal multiplexer configuration
- **yazi/**: Terminal file manager configuration
- **zed/**: Zed editor configuration
- **zellij/**: Terminal workspace manager
- **zsh/**: Z shell configuration with Oh My Zsh

### Configuration Management
Most directories follow the GNU stow convention where the directory structure mirrors the home directory structure. For example:
- `nvim/.config/nvim/` → symlinks to `~/.config/nvim/`
- `tmux/.tmux.conf` → symlinks to `~/.tmux.conf`

## Common Commands

### Managing Dotfiles with GNU Stow
```bash
# Install/symlink a configuration (from dotfiles directory)
stow <directory>  # e.g., stow nvim

# Remove/unlink a configuration
stow -D <directory>  # e.g., stow -D nvim

# Restow (useful after adding new files)
stow -R <directory>  # e.g., stow -R nvim

# Check what would be done without making changes
stow -n <directory>  # e.g., stow -n nvim
```

### Cursor Extensions
```bash
# Install Cursor extensions from list
cd cursor && ./install-ext.sh
```

### Key Shell Aliases (from zsh/.zshrc)
- `v` → nvim
- `l` → eza with icons and git status
- `lg` → lazygit
- `wip` → Quick git commit and push
- `py` → python
- `p` → pnpm

## Working with Configurations

When modifying configurations:
1. Edit files directly in this repository
2. Changes take effect immediately if using symlinks
3. Test changes before committing
4. For Neovim specifically, refer to nvim/.config/nvim/CLAUDE.md for detailed guidance

## Environment Details
- Shell: Zsh with Oh My Zsh
- Editor: Neovim (primary), with Cursor and Zed configurations
- Package manager references: Homebrew (macOS)
- Terminal tools: eza, bat, fzf, ripgrep