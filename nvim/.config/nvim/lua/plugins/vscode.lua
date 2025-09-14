return {
	"vscode-neovim/vscode-multi-cursor.nvim",
	event = "VeryLazy",
	cond = not not vim.g.vscode,
	opts = {
		setup = function()
			require("vscode-multi-cursor").setup({
				default_mappings = true,
			})
		end,
	},
}
