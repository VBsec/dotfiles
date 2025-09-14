return {
	{ "nxvu699134/vn-night.nvim" },
	{ "ellisonleao/gruvbox.nvim" },
	{
		"Shatur/neovim-ayu",
		config = function()
			require("ayu").setup({
				-- overrides = {
				-- 	Normal = { bg = "None" },
				-- 	ColorColumn = { bg = "None" },
				-- 	SignColumn = { bg = "None" },
				-- 	Folded = { bg = "None" },
				-- 	FoldColumn = { bg = "None" },
				-- 	CursorLine = { bg = "None" },
				-- 	CursorColumn = { bg = "None" },
				-- 	WhichKeyFloat = { bg = "None" },
				-- 	VertSplit = { bg = "None" },
				-- },
			})
		end,
	},
	{ "rose-pine/neovim", name = "rose-pine" },
	{
		"LazyVim/LazyVim",
		opts = {
			colorscheme = "tokyonight",
		},
	},
	{
		"folke/tokyonight.nvim",
		lazy = false,
		priority = 1000,
		opts = {
			transparent = true,
			style = "night",
			styles = {
				sidebars = "transparent",
				floats = "transparent", -- Transparent floating windows
			},
			on_highlights = function(hl, c)
				-- Configure floating window colors with transparent backgrounds
				hl.NormalFloat = { bg = "NONE", fg = c.fg }
				-- Border with transparent background but visible color
				hl.FloatBorder = { fg = c.blue, bg = "NONE" }
				hl.FloatTitle = { fg = c.cyan, bg = "NONE", bold = true }
				hl.FloatFooter = { fg = c.comment, bg = "NONE" }
				
				-- Ensure hover windows have transparent background
				hl.LspInfoBorder = { fg = c.blue, bg = "NONE" }
				hl.LspInfoTitle = { fg = c.cyan, bg = "NONE" }
				hl.LspInfoList = { bg = "NONE", fg = c.fg }
				hl.LspInfoFiletype = { bg = "NONE", fg = c.blue }
				
				-- Noice-specific highlights with transparent background
				hl.NoiceCmdlinePopupBorder = { fg = c.blue, bg = "NONE" }
				hl.NoicePopupBorder = { fg = c.blue, bg = "NONE" }
			end,
		},
	},
}
