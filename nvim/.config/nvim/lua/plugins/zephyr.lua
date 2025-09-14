return {
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      -- Ensure servers table exists
      opts.servers = opts.servers or {}

      -- Add support for devicetree files
      if vim.fn.executable("zephyr-ide") == 1 then
        opts.servers.zephyr_ide = {
          cmd = { "zephyr-ide", "lsp" },
          filetypes = { "dts", "overlay" },
        }
      end

      return opts
    end,
  },
  
  -- Syntax highlighting for Kconfig files
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        "c",
        "cmake",
        "devicetree",
        "kconfig",
        "python",
        "yaml",
      })
      return opts
    end,
  },


  -- Quick compile error navigation
  {
    "folke/trouble.nvim",
    opts = {
      modes = {
        west_build = {
          mode = "quickfix",
          preview = {
            type = "split",
            relative = "win",
            position = "right",
            size = 0.3,
          },
        },
      },
    },
    keys = {
      { "<leader>xw", "<cmd>Trouble west_build toggle<cr>", desc = "West Build Errors (Trouble)" },
    },
  },
}