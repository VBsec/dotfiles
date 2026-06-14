return {
  "folke/snacks.nvim",
  ---@type snacks.Config
  opts = {
    image = {},
    scroll = {
      enabled = false,
    },
    explorer = {
      replace_netrw = false,
    },
    picker = {
      layout = "vertical",
    },
  },
  keys = {
    {
      "<leader>fe",
      function()
        Snacks.picker.files({
          title = "Env Files",
          hidden = true,
          ignored = true,
          exclude = { "node_modules", ".git", "*cache*", "dist", "build" },
          pattern = "^.env",
        })
      end,
      desc = "Find env files",
    },
    {
      "<leader>se",
      function()
        Snacks.picker.grep({
          title = "Grep Code Files",
          glob = { "*.ts", "*.tsx", "*.js", "*.go", "*.rs", "*.py", "*.c", "*.h" },
        })
      end,
      desc = "Grep code files",
    },
  },
}
