return {
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      -- Ensure servers table exists
      opts.servers = opts.servers or {}
      
      -- Configure clangd for STM32CubeIDE/Eclipse CDT projects
      opts.servers.clangd = opts.servers.clangd or {}
      
      -- Default clangd configuration for C/C++ projects
      opts.servers.clangd = vim.tbl_deep_extend("force", opts.servers.clangd, {
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
        root_dir = function(fname)
          local util = require("lspconfig.util")
          
          -- First check for STM32CubeIDE/Eclipse CDT project markers
          local stm32_root = util.root_pattern(
            "compile_commands.json",
            ".cproject",              -- Eclipse CDT/STM32CubeIDE project
            ".project",               -- Eclipse project
            "STM32.*\\.ld",          -- STM32 linker script pattern
            ".mxproject"              -- STM32CubeMX project
          )(fname)
          
          if stm32_root then
            return stm32_root
          end
          
          -- Check for Zephyr application directory markers (app-specific)
          local zephyr_app_root = util.root_pattern(
            "prj.conf",               -- Zephyr application config
            "sample.yaml",            -- Zephyr sample metadata
            "Kconfig"                 -- Application-specific Kconfig
          )(fname)
          
          if zephyr_app_root then
            -- Verify this is actually a Zephyr app by checking for CMakeLists.txt
            local cmakelists = zephyr_app_root .. "/CMakeLists.txt"
            if vim.fn.filereadable(cmakelists) == 1 then
              return zephyr_app_root
            end
          end
          
          -- Then check for Zephyr workspace markers (less preferred)
          local zephyr_workspace_root = util.root_pattern(
            "west.yml",
            ".west"
          )(fname)
          
          if zephyr_workspace_root then
            return zephyr_workspace_root
          end
          
          -- Fall back to common markers
          return util.root_pattern(
            "CMakeLists.txt",
            "Makefile",
            ".git"
          )(fname)
        end,
        filetypes = { "c", "cpp", "h", "objc", "objcpp", "cuda", "proto" },
      })

      return opts
    end,
  },
}