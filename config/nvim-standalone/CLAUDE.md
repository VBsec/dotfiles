# CLAUDE.md

Guidance for Claude Code when working in this Neovim configuration.

## Overview

Standalone Neovim config built on **Neovim 0.12 natives** — no LazyVim, no lazy.nvim.
It is the in-progress replacement for the LazyVim config at `../nvim/`. Until it is declared
stable and cut over, it runs side-by-side via `NVIM_APPNAME`:

```bash
NVIM_APPNAME=nvim-standalone nvim      # or the `nvs` alias (zsh/.zshrc)
```

This isolates config (`~/.config/nvim-standalone`), data, state, and plugins from the default
`nvim`. The old config remains the unconditional default and must not be modified.

## Architecture

- **Plugin manager**: native `vim.pack` (`lua/config/plugins.lua`). Plugins are added with
  `vim.pack.add{ {src=...} }`. Build steps run from a `PackChanged` autocmd. Update with
  `:lua vim.pack.update()`.
- **LSP**: native `vim.lsp.config` — one file per server in `lsp/<name>.lua`, enabled in
  `init.lua` via `vim.lsp.enable{...}`. No nvim-lspconfig.
- **Completion**: blink.cmp (primary), native `vim.lsp.completion` as fallback.
- **Formatting**: conform.nvim — biome (ts/js/json), dprint (md/yaml/toml/dockerfile/html/css),
  clang_format (c/cpp), ruff_format (python), stylua (lua). Format-on-save on.
- **Project-local config**: native `exrc` (`vim.o.exrc`). Trusted `.nvim.lua`/`.nvimrc`/`.exrc`
  in cwd; nvim prompts to trust via `vim.secure`.
- **VSCode**: `init.lua`, `config/keymaps.lua`, `config/plugins.lua`, `config/autocmds.lua` all
  branch on `vim.g.vscode`. In VSCode only editing plugins + VSCode keymaps load; LSP/UI/cmp are
  skipped (VSCode owns them).

## File layout

- `init.lua` — leader, PATH, requires, `vim.lsp.enable`, diagnostics, highlights.
- `lua/config/options.lua` — editor options + filetype maps + root_spec + exrc.
- `lua/config/defaults.lua` — sensible default keymaps ported from LazyVim
  (window/buffer nav, save, search centering, splits, quickfix, etc.).
- `lua/config/keymaps.lua` — custom textEditing / neovim / vscode keymap groups.
- `lua/config/autocmds.lua` — spell-off, LSP shutdown, dir picker, yank highlight.
- `lua/config/plugins.lua` — all `vim.pack.add` + plugin setup + plugin keymaps + LspAttach.
- `lsp/*.lua` — per-server native LSP configs.
- `after/ftplugin/json.lua` — JSON `// ` commentstring.

## Tooling

All language servers/formatters come from **mise** (`../mise/config.toml`), except clangd /
clang-format which come from Homebrew LLVM (`/opt/homebrew/opt/llvm/bin`). PATH is prefixed with
mise shims in `init.lua`. Binary names: `basedpyright-langserver`, `tailwindcss-language-server`,
`vscode-{css,html,json}-language-server`, `lua-language-server`, `vtsls`,
`biome`, `dprint`.

## Languages supported

TypeScript/JS/JSON (biome + vtsls + tailwind, vitest via neotest), Python (basedpyright + ruff),
C (clangd, per-repo `.clangd` does target tuning), HTML/CSS, Markdown (render-markdown +
treesitter folding + markdown-preview browser server; **no linting/diagnostics**), and
dprint-formatted yaml/toml/dockerfile.

Intentionally NOT included (removed from the LazyVim config): Go, Java, Kotlin, Rust, Terraform,
SQL/dadbod, leetcode, harpoon, yanky, dial, smear-cursor, flash, trouble. Re-add by appending to
`vim.pack.add` and configuring in `plugins.lua` if needed.

## Common tasks

```vim
:lua vim.pack.update()     " update plugins (review buffer, :w to confirm)
:lua =vim.pack.get()       " list installed plugins
:checkhealth               " general health
:checkhealth vim.pack      " plugin manager health
:lua =vim.lsp.get_clients() " attached LSP clients
:TSUpdate                  " update treesitter parsers
```
