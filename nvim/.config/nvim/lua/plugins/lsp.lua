local util = require("lspconfig.util")

local root_files = {
	"setup.py",
	"setup.cfg",
	"Pipfile",
	"pyrightconfig.json",
	".git",
}
return {
	"neovim/nvim-lspconfig",
	opts = {
		inlay_hints = {
			enabled = false,
		},
		diagnostics = {
			float = {
				border = "rounded",
			},
		},
		servers = {
			bashls = {
				filetypes = { "sh", "bash" },
				on_init = function(client)
					local file_path = vim.api.nvim_buf_get_name(0) -- Get the current buffer name
					if file_path:match("%.env") then
						client.stop() -- Stop `bashls` from attaching to .env files
					end
				end,
			},
			pyright = {
				root_dir = function(fname)
					return util.root_pattern(unpack(root_files))(fname)
				end,
				single_file_support = false,
			},
			ruff = {
				root_dir = function(fname)
					return util.root_pattern(".git", "ruff.toml", ".ruff.toml")(fname)
				end,
			},
		},
	},
}
