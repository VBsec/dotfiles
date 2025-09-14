return {
  -- Disable neo-tree completely
  {
    "nvim-neo-tree/neo-tree.nvim",
    enabled = false,
  },
  -- Also disable the LazyVim neo-tree extra if it's loaded
  {
    "LazyVim/LazyVim",
    opts = {
      defaults = {
        autocmds = false, -- disable LazyVim autocmds that might open neo-tree
      },
    },
  },
}