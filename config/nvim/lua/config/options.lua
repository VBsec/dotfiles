-- Editor options. LazyVim used to set a sane baseline; since it's gone we set
-- the equivalents here, then add the project-specific bits ported from the old
-- config (filetype maps, root_spec, netrw disable, exrc).

-- Skip most UI options inside VSCode (it owns the display).
if not vim.g.vscode then
  local opt = vim.opt

  opt.number = true
  opt.relativenumber = true
  opt.cursorline = true
  opt.signcolumn = "yes"
  opt.termguicolors = true
  opt.scrolloff = 4
  opt.sidescrolloff = 8
  opt.wrap = false
  opt.linebreak = true

  -- Indentation: 2-space soft tabs (matches stylua / biome / dprint defaults).
  opt.expandtab = true
  opt.shiftwidth = 2
  opt.tabstop = 2
  opt.softtabstop = 2
  opt.shiftround = true
  opt.smartindent = true

  -- Search.
  opt.ignorecase = true
  opt.smartcase = true
  opt.inccommand = "nosplit"

  -- Splits.
  opt.splitright = true
  opt.splitbelow = true

  -- Files / persistence.
  opt.undofile = true
  opt.undolevels = 10000
  opt.swapfile = false
  opt.confirm = true

  -- UI niceties.
  opt.mouse = "a"
  opt.showmode = false
  opt.pumheight = 12
  opt.completeopt = "menu,menuone,noselect"
  opt.timeoutlen = 400
  opt.updatetime = 200
  opt.winminwidth = 5

  -- Folding via treesitter (used for markdown collapsing). Start unfolded.
  opt.foldlevel = 99
  opt.foldlevelstart = 99
  opt.foldmethod = "expr"
  opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
  opt.foldtext = ""
end

-- Clipboard: share with system (skip in VSCode, it syncs its own).
if not vim.g.vscode then
  vim.opt.clipboard = "unnamedplus"
end

-- Filetype associations (ported).
vim.filetype.add({
  extension = {
    h = "c", -- treat .h as C (not C++)
    cddl = "yaml", -- CDDL syntax ~ YAML
  },
})

-- Disable netrw (oil.nvim is the file explorer).
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Root detection priority, read by snacks pickers via vim.g.root_spec.
-- Monorepo markers first, then git, then LSP, then cwd.
vim.g.root_spec = {
  { "pnpm-workspace.yaml" },
  { "turbo.json" },
  { "lerna.json" },
  { "nx.json" },
  { "rush.json" },
  { "yarn.workspaces" },
  { "go.work" },
  { ".git" },
  "lsp",
  "cwd",
}

-- Project-local config: native exrc (replaces nvim-config-local plugin).
-- Loads trusted .nvim.lua / .nvimrc / .exrc from cwd; nvim prompts to trust
-- new/changed files via vim.secure.
vim.o.exrc = true
