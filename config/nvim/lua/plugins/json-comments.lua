return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      -- Set commentstring for JSON files
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "json", "jsonc" },
        callback = function()
          vim.bo.commentstring = "// %s"
        end,
      })
    end,
  },
}