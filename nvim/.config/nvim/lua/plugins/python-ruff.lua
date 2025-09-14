-- Python configuration with Ruff as formatter and linter
return {
  -- Configure conform for Python formatting with Ruff
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        python = { "ruff_format", "ruff_organize_imports" },
      },
      formatters = {
        ruff_format = {
          command = "ruff",
          args = {
            "format",
            "--force-exclude",
            "--stdin-filename",
            "$FILENAME",
            "-",
          },
          stdin = true,
          cwd = require("conform.util").root_file({
            "pyproject.toml",
            "ruff.toml",
            ".ruff.toml",
          }),
        },
        ruff_organize_imports = {
          command = "ruff",
          args = {
            "check",
            "--select",
            "I",
            "--fix",
            "--force-exclude",
            "--stdin-filename",
            "$FILENAME",
            "-",
          },
          stdin = true,
          cwd = require("conform.util").root_file({
            "pyproject.toml",
            "ruff.toml",
            ".ruff.toml",
          }),
        },
      },
    },
  },

  -- Configure nvim-lint for Python linting with Ruff
  {
    "mfussenegger/nvim-lint",
    opts = function(_, opts)
      opts.linters_by_ft = opts.linters_by_ft or {}
      opts.linters_by_ft.python = { "ruff" }
      return opts
    end,
  },

  -- Update LSP settings for better Ruff integration
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        ruff = {
          -- Ensure ruff uses the project's virtual environment
          on_attach = function(client, bufnr)
            -- Disable hover in favor of Pyright
            client.server_capabilities.hoverProvider = false
          end,
        },
        pyright = {
          settings = {
            python = {
              analysis = {
                -- Let Ruff handle most diagnostics
                ignore = { "*" },
                typeCheckingMode = "basic",
              },
            },
          },
        },
      },
    },
  },

  -- Mason tool installer - ensure tools are installed
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        "ruff",
        "pyright",
        "debugpy",
      })
      return opts
    end,
  },
}