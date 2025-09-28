-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
--
-- prefer Biome
vim.g.lazyvim_prettier_needs_config = true

vim.filetype.add({
  extension = {
    h = "c",
  },
})

vim.diagnostic.config({ virtual_text = true })

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Associate CDDL files with YAML syntax highlighting
vim.filetype.add({
  extension = {
    cddl = "yaml",
  },
})

-- Configure LazyVim root patterns
-- Root detection priority for :LazyRoot and pickers
vim.g.root_spec = {
  -- Monorepo markers have highest priority
  { "pnpm-workspace.yaml" },
  { "turbo.json" },
  { "lerna.json" },
  { "nx.json" },
  { "rush.json" },
  { "yarn.workspaces" },
  { "go.work" },
  -- Git root (second priority)
  { ".git" },
  -- LSP roots come after monorepo markers
  "lsp",
  -- Current directory as fallback
  "cwd",
}
