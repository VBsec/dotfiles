return {
	{
		"neovim/nvim-lspconfig",
		opts = function(_, opts)
			-- Ensure servers table exists
			opts.servers = opts.servers or {}
			opts.setup = opts.setup or {}

			-- Configure clangd for STM32CubeIDE/Eclipse CDT projects
			opts.servers.clangd = opts.servers.clangd or {}

			-- Custom root_dir function for STM32/Zephyr projects
			local custom_root_dir = function(fname)
				local util = require("lspconfig.util")

				-- First check for STM32CubeIDE/Eclipse CDT project markers
				local stm32_root = util.root_pattern(
					"compile_commands.json",
					".cproject", -- Eclipse CDT/STM32CubeIDE project
					".project", -- Eclipse project
					"STM32.*\\.ld", -- STM32 linker script pattern
					".mxproject" -- STM32CubeMX project
				)(fname)

				if stm32_root then
					return stm32_root
				end

				-- Check for Zephyr application directory markers (app-specific)
				local zephyr_app_root = util.root_pattern(
					"prj.conf", -- Zephyr application config
					"sample.yaml", -- Zephyr sample metadata
					"Kconfig" -- Application-specific Kconfig
				)(fname)

				if zephyr_app_root then
					-- Verify this is actually a Zephyr app by checking for CMakeLists.txt
					local cmakelists = zephyr_app_root .. "/CMakeLists.txt"
					if vim.fn.filereadable(cmakelists) == 1 then
						return zephyr_app_root
					end
				end

				-- Then check for Zephyr workspace markers (less preferred)
				local zephyr_workspace_root = util.root_pattern("west.yml", ".west")(fname)

				if zephyr_workspace_root then
					return zephyr_workspace_root
				end

				-- Fall back to common markers
				return util.root_pattern("CMakeLists.txt", "Makefile", ".git")(fname)
			end

			-- Default clangd configuration for C/C++ projects
			opts.servers.clangd = vim.tbl_deep_extend("force", opts.servers.clangd, {
				cmd = {
					vim.fn.exepath("clangd") ~= "" and vim.fn.exepath("clangd") or "clangd",
					"--background-index",
					"--clang-tidy",
					"--header-insertion=iwyu",
					"--completion-style=detailed",
					"--function-arg-placeholders",
					"--fallback-style=llvm",
				},
				capabilities = {
					offsetEncoding = { "utf-8", "utf-16" },
					textDocument = {
						completion = {
							editsNearCursor = true,
						},
					},
				},
				init_options = {
					usePlaceholders = true,
					completeUnimported = true,
					clangdFileStatus = true,
				},
				root_dir = custom_root_dir,
				filetypes = { "c", "cpp", "h", "objc", "objcpp", "cuda", "proto" },
			})

			-- Don't override setup - let LazyVim's default clangd setup work
			-- The custom root_dir is already in opts.servers.clangd above

			return opts
		end,
	},
}

