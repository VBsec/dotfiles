return {
  "nvim-mini/mini.pairs",
  event = "VeryLazy",
  opts = {
    modes = { insert = true, command = false, terminal = false },
  },
  keys = {
    {
      "<leader>up",
      function()
        vim.g.minipairs_disable = not vim.g.minipairs_disable
        if vim.g.minipairs_disable then
          LazyVim.warn("Disabled auto pairs", { title = "Option" })
        else
          LazyVim.info("Enabled auto pairs", { title = "Option" })
        end
      end,
      desc = "Toggle Auto Pairs",
    },
  },
}
