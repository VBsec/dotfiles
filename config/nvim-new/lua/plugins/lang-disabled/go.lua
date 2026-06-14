return {
  -- Go development
  {
    "ray-x/go.nvim",
    dependencies = {
      "ray-x/guihua.lua",
      "neovim/nvim-lspconfig",
      "nvim-treesitter/nvim-treesitter",
    },
    ft = { "go", "gomod", "gowork", "gotmpl" },
    build = ':lua require("go.install").update_all_sync()',
    config = function()
      require("go").setup({
        goimports = "gopls",
        gofmt = "gopls",
        max_line_len = 120,
        tag_transform = false,
        test_dir = "",
        comment_placeholder = " ",
        lsp_cfg = false, -- We use our own LSP config
        lsp_gofumpt = false,
        lsp_keymaps = false,
        lsp_codelens = true,
        diagnostic = {
          hdlr = false, -- Use default diagnostic handler
          underline = true,
          virtual_text = true,
          signs = true,
          update_in_insert = false,
        },
        lsp_document_formatting = false,
        dap_debug = true,
        dap_debug_keymap = false,
        dap_debug_gui = true,
        dap_debug_vt = true,
        build_tags = "",
        textobjects = true,
        test_runner = "go",
        run_in_floaterm = false,
        trouble = false,
        luasnip = false,
        iferr_vertical_shift = 4,
      })

      -- Format on save
      vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = "*.go",
        callback = function()
          require("go.format").goimports()
        end,
        group = vim.api.nvim_create_augroup("GoFormat", { clear = true }),
      })
    end,
  },

  -- Configure gopls
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        gopls = {
          settings = {
            gopls = {
              gofumpt = true,
              codelenses = {
                gc_details = false,
                generate = true,
                regenerate_cgo = true,
                run_govulncheck = true,
                test = true,
                tidy = true,
                upgrade_dependency = true,
                vendor = true,
              },
              hints = {
                assignVariableTypes = true,
                compositeLiteralFields = true,
                compositeLiteralTypes = true,
                constantValues = true,
                functionTypeParameters = true,
                parameterNames = true,
                rangeVariableTypes = true,
              },
              analyses = {
                fieldalignment = true,
                nilness = true,
                unusedparams = true,
                unusedwrite = true,
                useany = true,
              },
              usePlaceholders = true,
              completeUnimported = true,
              staticcheck = true,
              directoryFilters = { "-.git", "-.vscode", "-.idea", "-.vscode-test", "-node_modules" },
              semanticTokens = true,
            },
          },
        },
      },
    },
  },

  -- Go tests
  {
    "nvim-neotest/neotest",
    optional = true,
    dependencies = {
      "fredrikaverpil/neotest-golang",
    },
    opts = {
      adapters = {
        ["neotest-golang"] = {
          -- Here we can set options for neotest-golang
        },
      },
    },
  },
}