return {
  -- Mason main configuration
  {
    "williamboman/mason.nvim",
    lazy = false,
    priority = 100,
    cmd = "Mason",
    build = ":MasonUpdate",
    keys = {
      { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" },
    },
    opts = {
      ensure_installed = {
        -- LSP Servers
        "bash-language-server",
        "clangd",
        "cmake-language-server",
        "css-lsp",
        "docker-compose-language-service",
        "dockerfile-language-server",
        "eslint-lsp",
        "gopls",
        "json-lsp",
        "lua-language-server",
        "marksman",
        "basedpyright",
        "ruff",
        "rust-analyzer",
        "tailwindcss-language-server",
        "vtsls",
        "yaml-language-server",
        
        -- Formatters
        "biome",
        "black",
        "clang-format",
        "gofumpt",
        "goimports",
        "prettierd",
        "shfmt",
        "stylua",
        
        -- Linters
        "cmakelint",
        "eslint_d",
        "markdownlint",
        "ruff",
        "shellcheck",
        "sqlfluff",
        
        -- DAP Adapters
        "bash-debug-adapter",
        "codelldb",
        "cpptools",
        "delve",
        "debugpy",
        "js-debug-adapter",
      },
      ui = {
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
    },
    config = function(_, opts)
      require("mason").setup(opts)
      local mr = require("mason-registry")
      mr:on("package:install:success", function()
        vim.defer_fn(function()
          -- trigger FileType event to possibly load this newly installed LSP server
          require("lazy.core.handler.event").trigger({
            event = "FileType",
            buf = vim.api.nvim_get_current_buf(),
          })
        end, 100)
      end)

      mr.refresh(function()
        for _, tool in ipairs(opts.ensure_installed) do
          local p = mr.get_package(tool)
          if not p:is_installed() then
            p:install()
          end
        end
      end)
    end,
  },

  -- Mason-lspconfig bridge
  {
    "williamboman/mason-lspconfig.nvim",
    lazy = false,
    priority = 50,
    dependencies = {
      "williamboman/mason.nvim",
    },
    opts = {
      ensure_installed = {
        "bashls",
        "clangd",
        "cmake",
        "cssls",
        "docker_compose_language_service",
        "dockerls",
        "eslint",
        "gopls",
        "jsonls",
        "lua_ls",
        "marksman",
        "basedpyright",
        "ruff",
        "rust_analyzer",
        "tailwindcss",
        "vtsls",
        "yamlls",
      },
      automatic_installation = true,
      handlers = nil,  -- Disable automatic handlers
    },
  },

  -- Mason-nvim-dap bridge
  {
    "jay-babu/mason-nvim-dap.nvim",
    dependencies = {
      "mason.nvim",
      "mfussenegger/nvim-dap",
    },
    opts = {
      ensure_installed = {
        "bash",
        "cppdbg",
        "delve",
        "js",
        "python",
      },
      automatic_installation = true,
    },
  },
}