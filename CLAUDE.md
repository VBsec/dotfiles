# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a personal dotfiles repository containing configuration files for various development tools on macOS. The configurations are organized by application and designed to be symlinked to their appropriate locations using GNU stow.

## Architecture

### Directory Structure
Two stow layouts are used:

1. **`config/`** — a single stow package for everything that lives under `~/.config`.
   Each app is a flat subdir (no `.config/<app>` nesting): `config/<app>/...`. Stowed
   with `stow -t ~/.config config`, so `config/ghostty/config` → `~/.config/ghostty/config`
   and `config/starship.toml` → `~/.config/starship.toml`. Apps inside `config/`:
   aerospace, alacritty, ghostty, helix, linearmouse, mise, nvim, sketchybar,
   skhd, yabai, yazi, zed, zellij, plus the loose starship.toml.

2. **Home-dir packages** — one stow package each, targeting `~` directly:
   - **claude/**: Claude Code config → `~/.claude/`
   - **pi/**: Pi agent config → `~/.pi/`
   - **tmux/**: `tmux/.tmux.conf` → `~/.tmux.conf`
   - **zsh/**: `zsh/.zshrc`, `zsh/.zsh/` → `~/`

Non-stow dirs: **cursor/** (macOS Application Support + install scripts).

Per-app notes:
- **aerospace/**: Window manager configuration (aerospace.toml)
- **alacritty/**: Terminal emulator configuration
- **claude/**: Claude AI assistant configuration
- **cursor/**: Cursor editor settings, keybindings, and extensions
- **ghostty/**: Ghostty terminal configuration
- **linearmouse/**: Mouse configuration utility
- **nvim/**: Neovim configuration with LazyVim framework (has its own CLAUDE.md at config/nvim/CLAUDE.md)
- **starship/**: Cross-shell prompt configuration
- **tmux/**: Terminal multiplexer configuration
- **yazi/**: Terminal file manager configuration
- **zed/**: Zed editor configuration
- **zellij/**: Terminal workspace manager
- **zsh/**: Z shell configuration with Oh My Zsh

### Configuration Management
Stow symlinks structurally and strips exactly one path level (the package name), so the
in-repo path must mirror the target path. That's why `~/.config` apps share one `config`
package (giving `config/<app>/...` → `~/.config/<app>/...`) while home-dir packages keep
their own `.`-prefixed files (`zsh/.zshrc` → `~/.zshrc`).

## Common Commands

### Managing Dotfiles with GNU Stow
```bash
# ~/.config apps (single package, explicit target):
stow -t ~/.config config        # install/symlink
stow -t ~/.config -D config     # remove
stow -t ~/.config -R config     # restow (after adding new files)
stow -t ~/.config -n config     # dry run

# Home-dir packages (default target ~):
stow zsh                         # e.g. zsh, tmux, claude, pi
stow -D zsh                      # remove
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
4. For Neovim specifically, refer to config/nvim/CLAUDE.md for detailed guidance

## Environment Details
- Shell: Zsh with Oh My Zsh
- Editor: Neovim (primary), with Cursor and Zed configurations
- Package manager references: Homebrew (macOS)
- Terminal tools: eza, bat, fzf, ripgrep