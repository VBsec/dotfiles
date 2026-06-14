return {
  -- Mason
  {
    "williamboman/mason.nvim",
    version = "^1.0.0",  -- Pin to v1 like LazyVim
    cmd = "Mason",
    keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" } },
    build = ":MasonUpdate",
    opts = {
      ensure_installed = {
        "stylua",
        "shfmt",
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

  -- Mason-lspconfig
  {
    "williamboman/mason-lspconfig.nvim",
    version = "^1.0.0",  -- Pin to v1 like LazyVim
    dependencies = { "williamboman/mason.nvim" },
    config = function() end,
  },

  -- LSP Config
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPost", "BufNewFile", "BufWritePre" },
    dependencies = {
      "mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "saghen/blink.cmp",
    },
    opts = {
      servers = {
        -- Lua
        lua_ls = {
          settings = {
            Lua = {
              runtime = { version = "LuaJIT" },
              workspace = {
                checkThirdParty = false,
                library = vim.api.nvim_get_runtime_file("", true),
              },
              completion = {
                callSnippet = "Replace",
              },
              diagnostics = {
                globals = { "vim" },
              },
            },
          },
        },
        -- Bash
        bashls = {
          filetypes = { "sh", "bash", "zsh" },
        },
        -- Go
        gopls = {},
        -- Python
        basedpyright = {},
        ruff = {},
        -- TypeScript/JavaScript
        vtsls = {},
        -- C/C++
        clangd = {},
        -- Other servers
        cmake = {},
        cssls = {},
        docker_compose_language_service = {},
        dockerls = {},
        eslint = {},
        jsonls = {},
        marksman = {},
        tailwindcss = {},
        yamlls = {},
      },
    },
    config = function(_, opts)
      -- Setup keymaps
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("lsp_attach", { clear = true }),
        callback = function(event)
          local map = function(keys, func, desc)
            vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
          end

          map("gd", vim.lsp.buf.definition, "Goto Definition")
          map("gD", vim.lsp.buf.declaration, "Goto Declaration")
          map("gr", vim.lsp.buf.references, "Goto References")
          map("gI", vim.lsp.buf.implementation, "Goto Implementation")
          map("gy", vim.lsp.buf.type_definition, "Goto Type Definition")
          map("K", vim.lsp.buf.hover, "Hover Documentation")
          map("gK", vim.lsp.buf.signature_help, "Signature Documentation")
          map("<leader>ca", vim.lsp.buf.code_action, "Code Action")
          map("<leader>cr", vim.lsp.buf.rename, "Rename")
          map("<leader>ws", vim.lsp.buf.workspace_symbol, "Workspace Symbols")
        end,
      })

      -- Diagnostics signs
      local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
      for type, icon in pairs(signs) do
        local hl = "DiagnosticSign" .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
      end

      -- Diagnostics config
      vim.diagnostic.config({
        underline = true,
        update_in_insert = false,
        virtual_text = {
          spacing = 4,
          source = "if_many",
          prefix = "●",
        },
        severity_sort = true,
      })

      -- Get capabilities
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      local has_blink, blink = pcall(require, "blink.cmp")
      if has_blink then
        capabilities = blink.get_lsp_capabilities(capabilities)
      end

      -- Setup function for each server
      local function setup(server)
        local server_opts = vim.tbl_deep_extend("force", {
          capabilities = vim.deepcopy(capabilities),
        }, opts.servers[server] or {})
        
        if server_opts.enabled == false then
          return
        end
        
        require("lspconfig")[server].setup(server_opts)
      end

      -- Setup with mason-lspconfig
      local have_mason, mlsp = pcall(require, "mason-lspconfig")
      
      if have_mason then
        local ensure_installed = {}
        for server, server_opts in pairs(opts.servers) do
          if server_opts and server_opts.enabled ~= false then
            ensure_installed[#ensure_installed + 1] = server
          end
        end
        
        mlsp.setup({
          ensure_installed = ensure_installed,
          automatic_installation = false,
          handlers = {
            -- Default handler for all servers
            function(server_name)
              setup(server_name)
            end,
          },
        })
      else
        -- Fallback if mason-lspconfig is not available
        for server, _ in pairs(opts.servers) do
          setup(server)
        end
      end
    end,
  },
}