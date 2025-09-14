return {
	-- Enhance gopls settings beyond LazyVim defaults
	{
		"neovim/nvim-lspconfig",
		opts = {
			servers = {
				gopls = {
					settings = {
						gopls = {
							staticcheck = true,
							analyses = {
								fieldalignment = true,
								nilness = true,
								unusedparams = true,
								unusedwrite = true,
								useany = true,
								ST1003 = true,
								ST1016 = true,
								ST1020 = true,
								ST1021 = true,
								ST1022 = true,
								ST1023 = true,
								QF1001 = true,
								QF1002 = true,
								QF1003 = true,
								QF1004 = true,
								QF1005 = true,
								QF1006 = true,
								QF1007 = true,
								QF1010 = true,
								QF1011 = true,
								QF1012 = true,
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
							codelenses = {
								gc_details = true,
								regenerate_cgo = true,
								run_govulncheck = true,
								vendor = true,
							},
						},
					},
				},
			},
		},
	},
	-- Add golangci-lint for additional checks
	{
		"mfussenegger/nvim-lint",
		opts = {
			linters_by_ft = {
				go = { "golangcilint" },
			},
		},
		keys = {
			{
				"<leader>cgl",
				function()
					-- Toggle diagnostic display for golangci-lint
					vim.g.hide_golangci = not vim.g.hide_golangci
					
					if vim.g.hide_golangci then
						-- Hide golangci-lint diagnostics using vim.diagnostic.hide
						local bufnr = vim.api.nvim_get_current_buf()
						local all_diagnostics = vim.diagnostic.get(bufnr)
						
						-- Find namespace with golangci-lint diagnostics
						local namespaces = vim.diagnostic.get_namespaces()
						for ns_id, _ in pairs(namespaces) do
							local ns_diagnostics = vim.diagnostic.get(bufnr, { namespace = ns_id })
							for _, d in ipairs(ns_diagnostics) do
								if d.source == "golangci-lint" then
									-- Hide diagnostics from this namespace
									vim.diagnostic.hide(ns_id, bufnr)
									break
								end
							end
						end
						
						-- Also disable future linting
						local lint = require("lint")
						vim.g.lint_go_backup = lint.linters_by_ft.go
						lint.linters_by_ft.go = {}
						
						vim.notify("Go linter diagnostics hidden", vim.log.levels.INFO)
					else
						-- Show all diagnostics again
						local bufnr = vim.api.nvim_get_current_buf()
						local namespaces = vim.diagnostic.get_namespaces()
						for ns_id, _ in pairs(namespaces) do
							vim.diagnostic.show(ns_id, bufnr)
						end
						
						-- Re-enable linting
						local lint = require("lint")
						lint.linters_by_ft.go = vim.g.lint_go_backup or { "golangcilint" }
						lint.try_lint()
						
						vim.notify("Go linter diagnostics shown", vim.log.levels.INFO)
					end
				end,
				desc = "Toggle Go linter diagnostics",
			},
		},
	},
	-- Add golines formatter with line length from golangci.yml
	{
		"stevearc/conform.nvim",
		optional = true,
		opts = {
			formatters_by_ft = {
				go = { "goimports", "golines" },
			},
			formatters = {
				golines = {
					prepend_args = { "-m", "120" },
				},
			},
		},
	},
	-- Enhanced neotest config with coverage path
	{
		"nvim-neotest/neotest",
		optional = true,
		dependencies = {
			"fredrikaverpil/neotest-golang",
		},
		opts = {
			adapters = {
				["neotest-golang"] = {
					go_test_args = {
						"-v",
						"-race",
						"-count=1",
						"-timeout=60s",
						"-coverprofile=" .. vim.fn.getcwd() .. "/coverage.out",
					},
					dap_go_enabled = true,
				},
			},
		},
	},
	{
		"olexsmir/gopher.nvim",
		ft = "go",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
		},
		build = function()
			-- Only install deps if go binary exists
			if vim.fn.executable("go") == 1 then
				vim.cmd([[silent! GoInstallDeps]])
			end
		end,
		config = function()
			require("gopher").setup({
				commands = {
					go = "go",
					gomodifytags = "gomodifytags",
					gotests = "gotests",
					impl = "impl",
					iferr = "iferr",
				},
				-- Disable auto installation
				install_on_start = false,
			})
		end,
		keys = {
			{ "<leader>cge", "<cmd>GoIfErr<cr>", desc = "Generate if err" },
			{ "<leader>cgt", "<cmd>GoTagAdd<cr>", desc = "Add struct tags" },
			{ "<leader>cgT", "<cmd>GoTagRm<cr>", desc = "Remove struct tags" },
			{ "<leader>cgc", "<cmd>GoCmt<cr>", desc = "Generate comment" },
			{ "<leader>cgi", "<cmd>GoImpl<cr>", desc = "Generate interface implementation" },
			{ "<leader>cgg", "<cmd>GoGenerate<cr>", desc = "Run go generate" },
			{ "<leader>cgr", "<cmd>GoGenReturn<cr>", desc = "Generate return values" },
			{ "<leader>cgf", "<cmd>GoFillStruct<cr>", desc = "Fill struct" },
			{ "<leader>cgF", "<cmd>GoFillSwitch<cr>", desc = "Fill switch" },
			{ "<leader>cgx", "<cmd>GoFixPlurals<cr>", desc = "Fix plurals" },
		},
	},
	{
		"ray-x/go.nvim",
		ft = { "go", "gomod" },
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
		},
		build = function()
			-- Only try to update tools if go binary exists
			local go_exists = vim.fn.executable("go") == 1
			if go_exists then
				vim.cmd([[silent! GoInstallDeps]])
			end
		end,
		config = function()
			-- Check if go binary exists before setup
			local go_exists = vim.fn.executable("go") == 1
			if not go_exists then
				vim.notify("Go binary not found. Some go.nvim features will be disabled.", vim.log.levels.WARN)
			end

			require("go").setup({
				go = "go", -- go command path
				disable_defaults = true,
				diagnostic = false,
				lsp_cfg = false,
				lsp_gofumpt = false,
				lsp_keymaps = false,
				lsp_codelens = false,
				-- null_ls is deprecated, don't use it
				dap_debug = false,
				dap_debug_keymap = false,
				textobjects = false,
				test_runner = "go",
				run_in_floaterm = false,
				trouble = true,
				luasnip = true,
				iferr_vertical_shift = 4,
			})

			-- Only register keymaps if go binary exists
			if go_exists then
				local wk = require("which-key")
				wk.add({
					{ "<leader>cgm", "<cmd>GoModTidy<cr>", desc = "Go mod tidy" },
					{ "<leader>cgM", "<cmd>GoModVendor<cr>", desc = "Go mod vendor" },
					{ "<leader>cgs", "<cmd>!task gen:models<cr>", desc = "Generate SurrealDB models" },
					{ "<leader>cgd", "<cmd>!task gen:digita<cr>", desc = "Generate Digita API client" },
					{ "<leader>cgD", "<cmd>!task gen:golioth<cr>", desc = "Generate Golioth API client" },
					{ "<leader>cgG", "<cmd>!task gen:all<cr>", desc = "Generate all code" },
					{ "<leader>cga", "<cmd>GoAddTag<cr>", desc = "Add tags to struct" },
					{ "<leader>cgA", "<cmd>GoRmTag<cr>", desc = "Remove tags from struct" },
					{ "<leader>cgC", "<cmd>GoClearTag<cr>", desc = "Clear all tags" },
					{ "<leader>cgo", "<cmd>GoModifyTag<cr>", desc = "Modify tags" },
					{ "<leader>cgj", "<cmd>GoAddTag json<cr>", desc = "Add json tags" },
					{ "<leader>cgy", "<cmd>GoAddTag yaml<cr>", desc = "Add yaml tags" },
				})
			end
		end,
	},
}