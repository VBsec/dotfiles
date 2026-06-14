return {
  -- Clangd extensions
  {
    "p00f/clangd_extensions.nvim",
    ft = { "c", "cpp", "objc", "objcpp", "cuda", "proto" },
    opts = {
      inlay_hints = {
        inline = false,
      },
      ast = {
        role_icons = {
          type = "",
          declaration = "",
          expression = "",
          specifier = "",
          statement = "",
          ["template argument"] = "",
        },
        kind_icons = {
          Compound = "",
          Recovery = "",
          TranslationUnit = "",
          PackExpansion = "",
          TemplateTypeParm = "",
          TemplateTemplateParm = "",
          TemplateParamObject = "",
        },
      },
    },
    config = function(_, opts)
      require("clangd_extensions").setup(opts)
      
      -- Add header/source switch keymap when clangd attaches
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if client and client.name == "clangd" then
            vim.keymap.set("n", "<leader>ch", "<cmd>ClangdSwitchSourceHeader<cr>", 
              { buffer = args.buf, desc = "Switch Source/Header" })
          end
        end,
      })
    end,
  },

  -- Configure clangd
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        clangd = {
          cmd = {
            "clangd",
            "--background-index",
            "--clang-tidy",
            "--header-insertion=iwyu",
            "--completion-style=detailed",
            "--function-arg-placeholders",
            "--fallback-style=llvm",
          },
          init_options = {
            usePlaceholders = true,
            completeUnimported = true,
            clangdFileStatus = true,
          },
          capabilities = {
            offsetEncoding = { "utf-16" },
          },
          filetypes = { "c", "cpp", "objc", "objcpp", "cuda", "proto" },
        },
      },
    },
  },

  -- CMake integration
  {
    "Civitasv/cmake-tools.nvim",
    ft = { "cmake", "c", "cpp" },
    opts = {
      cmake_generate_options = { "-DCMAKE_EXPORT_COMPILE_COMMANDS=1" },
      cmake_build_directory = "build",
      cmake_soft_link_compile_commands = true,
    },
    keys = {
      { "<leader>cm", "<cmd>CMakeGenerate<cr>", desc = "Generate CMake" },
      { "<leader>cb", "<cmd>CMakeBuild<cr>", desc = "Build CMake" },
      { "<leader>ct", "<cmd>CMakeSelectBuildTarget<cr>", desc = "Select Build Target" },
      { "<leader>cl", "<cmd>CMakeSelectLaunchTarget<cr>", desc = "Select Launch Target" },
      { "<leader>cR", "<cmd>CMakeRun<cr>", desc = "Run CMake Target" },
      { "<leader>cd", "<cmd>CMakeDebug<cr>", desc = "Debug CMake Target" },
    },
  },
}