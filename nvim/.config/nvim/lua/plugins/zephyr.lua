return {
	-- Syntax highlighting for Kconfig files
	{
		"nvim-treesitter/nvim-treesitter",
		opts = function(_, opts)
			opts.ensure_installed = opts.ensure_installed or {}
			vim.list_extend(opts.ensure_installed, {
				"c",
				"cmake",
				"devicetree",
				"kconfig",
				"python",
				"yaml",
			})
			return opts
		end,
	},
}

