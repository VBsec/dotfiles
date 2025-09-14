return {
  {
    "nvim-tree/nvim-tree.lua",
    enabled = false,
  },
  {
    "LazyVim/LazyVim",
    opts = {
      -- Disable netrw
      defaults = {
        autocmds = true,
        keymaps = true,
      },
    },
    init = function()
      -- Disable netrw completely
      vim.g.loaded_netrw = 1
      vim.g.loaded_netrwPlugin = 1
    end,
  },
}