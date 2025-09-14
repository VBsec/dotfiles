return {
  "nvim-neo-tree/neo-tree.nvim",
  keys = {
    -- Disable the default Neo-tree explorer mappings since we're using fzf-lua for .env files
    { "<leader>fe", false },
    { "<leader>fE", false },
    { "<leader>e", false },
    { "<leader>E", false },
  },
}