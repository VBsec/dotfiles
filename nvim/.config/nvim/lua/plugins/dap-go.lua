return {
	{
		"leoluz/nvim-dap-go",
		ft = "go",
		dependencies = {
			"mfussenegger/nvim-dap",
			"theHamsta/nvim-dap-virtual-text",
		},
		config = function()
			-- Setup dap-go with delve
			require("dap-go").setup({
				-- Additional dap configurations can be added here
				dap_configurations = {
					{
						type = "go",
						name = "Debug",
						request = "launch",
						program = "${file}",
					},
					{
						type = "go",
						name = "Debug Package",
						request = "launch",
						program = "${fileDirname}",
					},
					{
						type = "go",
						name = "Debug test",
						request = "launch",
						mode = "test",
						program = "${file}",
					},
					{
						type = "go",
						name = "Debug test (go.mod)",
						request = "launch",
						mode = "test",
						program = "./${relativeFileDirname}",
					},
				},
				-- delve configurations
				delve = {
					path = "dlv",
					initialize_timeout_sec = 20,
					port = "${port}",
				},
			})

			-- Add custom configuration for server with env
			local dap = require("dap")
			
			-- Ensure dap.configurations.go exists
			if not dap.configurations.go then
				dap.configurations.go = {}
			end
			
			table.insert(dap.configurations.go, {
				type = "go",
				name = "Debug server with env",
				request = "launch",
				program = "${workspaceFolder}/cmd/server",
				env = function()
					local env = {}
					
					-- Try to run infisical if available
					local infisical_exists = vim.fn.executable("infisical") == 1
					if infisical_exists then
						vim.fn.system({
							"infisical",
							"export",
							"--format=dotenv",
							"--env=dev",
							"--output-file=" .. vim.fn.getcwd() .. "/.env",
						})
					end

					-- Load .env files
					for _, file in ipairs({ "/.env", "/.env.local" }) do
						local env_file = vim.fn.getcwd() .. file
						if vim.fn.filereadable(env_file) == 1 then
							for line in io.lines(env_file) do
								-- Skip comments and empty lines
								if not line:match("^#") and line:match("%S") then
									local key, value = line:match("^([^=]+)=(.*)$")
									if key and value then
										-- Remove quotes if present
										value = value:gsub('^"', ''):gsub('"$', '')
										value = value:gsub("^'", ''):gsub("'$", '')
										env[key] = value
									end
								end
							end
						end
					end
					env.LOG_LEVEL = "debug"
					return env
				end,
			})
		end,
	},
}
