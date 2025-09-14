return {
  -- Dotenv file support with syntax highlighting
  {
    "ellisonleao/dotenv.nvim",
    config = function()
      require("dotenv").setup({
        enable_on_load = false, -- Don't auto-load .env files for security
        verbose = false,
      })
    end,
  },
  -- Alternative: Use bash syntax highlighting for .env files
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "bash",
      },
    },
    config = function()
      -- Use bash highlighting for .env files
      vim.filetype.add({
        filename = {
          [".env"] = "sh",
          [".env.example"] = "sh",
          [".env.local"] = "sh",
          [".env.production"] = "sh",
          [".env.development"] = "sh",
          [".env.test"] = "sh",
        },
        pattern = {
          ["%.env%..*"] = "sh",
        },
      })
    end,
  },
}