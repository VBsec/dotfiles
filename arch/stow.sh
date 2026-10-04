#!/usr/bin/env bash
# Stow the packages used on Arch. Run from anywhere; pass extra stow flags
# through, e.g. `arch/stow.sh -n -v` (dry run) or `arch/stow.sh -D` (remove).
# Run after the ML4W installer, since ml4w/ links into ML4W's directories.
set -euo pipefail
cd "$(dirname "$0")/.."

# config/ apps that are macOS-only or not set up on Arch yet. Remove an entry
# here to start stowing that app into ~/.config.
skip='aerospace|sketchybar|skhd|yabai|karabiner|linearmouse|ghostty|alacritty|zed|helix|zellij|yazi|starship\.toml|nvim-old'

stow "$@" -t ~/.config --ignore="^($skip)\$" config
stow "$@" -t ~ zsh-linux

# ml4w/: files ML4W leaves to the user (custom.lua, zshrc custom/, settings).
# ~/.config/hypr etc. are symlinks into ~/.mydotfiles, and stow builds relative
# links, so target the resolved directories. --no-folding keeps ML4W's own
# directories real instead of replacing them with links into this repo.
ml4w_stow() {
  local pkg=$1 target=$2; shift 2
  stow "$@" --no-folding -d ml4w -t "$(realpath "$target")" "$pkg"
}
ml4w_stow hypr          ~/.config/hypr          "$@"
ml4w_stow zshrc         ~/.config/zshrc         "$@"
ml4w_stow ml4w-settings ~/.config/ml4w/settings "$@"
