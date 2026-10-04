# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a personal dotfiles repository containing configuration files for various development tools on macOS (primary workstation) and Arch Linux (Hyprland + ML4W dotfiles). The configurations are organized by application and designed to be symlinked to their appropriate locations using GNU stow.

One `main` branch serves both OSes: shared configs (nvim, mise) are used as-is on both, and OS-specific pieces live in their own packages/dirs (see "Arch Linux" below).

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

### Arch Linux
The Arch machine runs ML4W dotfiles, which own most of the desktop and the zsh loader.
This repo only adds to them, and grows as things are needed (not a full port of macOS):

- **`arch/stow.sh`** — stows everything used on Arch: `config` (with macOS-only and not-yet-used
  apps skipped via `--ignore`; currently just nvim + mise get linked), `zsh-linux`, and the
  `ml4w/` packages. Pass stow flags through: `arch/stow.sh -n -v` (dry run), `arch/stow.sh -D`.
- **`arch/packages.txt`** — pacman packages (Arch counterpart to `brew/Brewfile`).
  `sudo pacman -S --needed - < <(grep -v '^#' arch/packages.txt)`
- **`arch/system/`** — root-owned system files, installed with `sudo install` (not stowed).
  `getty-autologin.conf`: passwordless autologin on tty1.
- **`zsh-linux/`** — `.zshrc_custom` → `~/.zshrc_custom`, sourced last by ML4W's `~/.zshrc`
  loader; `.zprofile` starts Hyprland on tty1. The macOS `zsh/` package is not stowed on Arch.
- **`ml4w/`** — a stow dir (`-d ml4w`) whose packages fill the slots ML4W leaves for the user,
  so ML4W's own files stay stock and updates never conflict:
  - `hypr/custom.lua` → `~/.config/hypr/custom.lua`: keyboard layout, NVIDIA env, monitor
    rules, mouse settings, 1Password autostart + keybinds.
  - `zshrc/custom/20-customization` → replaces ML4W's Oh My Zsh module (Arch-packaged
    plugins instead; ML4W's oh-my-posh prompt kept).
  - `ml4w-settings/hide-fastfetch` → disables fastfetch on terminal start.
  ML4W's dirs are symlinks into `~/.mydotfiles/`, so stow.sh targets their `realpath`
  with `--no-folding`; stowing through the symlink would create broken relative links.

#### Fresh install / restore order
1. Arch base install (GPU: `nvidia-580xx-dkms` + `nvidia-580xx-utils` from AUR, Pascal),
   `yay`, then `nvidia_drm.modeset=1` on the kernel cmdline.
2. ML4W: `bash <(curl -s https://ml4w.com/os/stable)`
3. `sudo pacman -S github-cli && gh auth login --git-protocol https --web`, then
   `gh repo clone vbsec/dotfiles ~/Projects/dotfiles`
4. `sudo pacman -S --needed - < <(grep -v '^#' arch/packages.txt)`, then `arch/stow.sh`
5. System setup:
   - `chsh -s /usr/bin/zsh`
   - locale: uncomment `en_US.UTF-8 UTF-8` in `/etc/locale.gen`, `sudo locale-gen`
   - `sudo systemctl enable --now bluetooth`
   - `sudo install -Dm644 arch/system/getty-autologin.conf /etc/systemd/system/getty@tty1.service.d/autologin.conf`
   - git: `gh auth setup-git`, `user.name`/`user.email` (GitHub noreply), `init.defaultBranch main`
6. `mise install` (tools from `config/mise/config.toml`), then open `nvim` once for plugins.

Not in the repo: 1Password (`yay -S 1password 1password-cli`), Logitech devices (paired to
the Unifying receiver itself, so pairing survives reinstalls).

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