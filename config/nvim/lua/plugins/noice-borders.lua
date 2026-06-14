-- Configure noice.nvim to show borders on LSP hover
return {
	{
		"folke/noice.nvim",
		opts = {
			presets = {
				lsp_doc_border = true, -- add borders to hover docs and signature help
			},
			views = {
				hover = {
					win_options = {
						winhighlight = {
							Normal = "NormalFloat",
							FloatBorder = "FloatBorder",
						},
					},
				},
			},
		},
	},
}