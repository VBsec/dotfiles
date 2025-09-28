return {
  "folke/snacks.nvim",
  ---@type snacks.Config
  opts = {
    image = {},
    animate = {},
    explorer = {
      replace_netrw = false,
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
  },
}
