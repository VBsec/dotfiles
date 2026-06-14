-- Standalone Neovim config (no LazyVim, no lazy.nvim).
-- Built on Neovim 0.12 natives: vim.pack (plugins), vim.lsp.config/enable (LSP),
-- exrc (project-local config). Works both in the terminal and inside the
-- VSCode-Neovim extension (gated on vim.g.vscode).
--
-- Launch with:  NVIM_APPNAME=nvim-standalone nvim   (alias: nvs)

-- Leader must be set before any mappings/plugins load.
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Tool PATH: prefer mise shims so biome/dprint/typescript-language-server/etc.
-- resolve consistently regardless of how nvim was launched.
vim.env.PATH = vim.env.HOME .. "/.local/share/mise/shims:" .. vim.env.PATH

require("config.options")
require("config.defaults")
require("config.keymaps")
require("config.autocmds")
require("config.plugins")

if vim.g.vscode then
  -- Inside VSCode: VSCode owns LSP, UI, completion. Only the editing plugins
  -- and the VSCode-specific keymaps (set in config.keymaps) are active.
  return
end

-- Native Neovim only below this point ----------------------------------------

-- Native LSP: configs live in lsp/<name>.lua (auto-discovered on runtimepath).
vim.lsp.enable({
  "clangd",
  "biome",
  "vtsls",
  "basedpyright",
  "tailwindcss",
  "cssls",
  "html",
  "jsonls",
  "lua_ls",
  "bashls",
})

-- Diagnostics presentation (ported from the LazyVim-era options/lsp config).
vim.diagnostic.config({
  virtual_text = true,
  float = { border = "rounded" },
  severity_sort = true,
})

-- nvim-ts-autotag (terminal only) is set up in config.plugins.

-- Custom line-number / cursorline accents (ported from old init.lua).
vim.api.nvim_create_autocmd("ColorScheme", {
  callback = function()
    vim.cmd("highlight LineNr guifg=#bae67e ctermfg=149")
    vim.cmd("highlight CursorLineNr guifg=#ef6b73 ctermfg=203")
    vim.cmd("highlight CursorLine guibg=#1C1C3E")
  end,
})
