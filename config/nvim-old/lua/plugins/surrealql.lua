-- SurrealQL file support using SQL highlighting
return {
	{
		"nvim-treesitter/nvim-treesitter",
		init = function()
			-- Use SQL highlighting for SurrealQL files
			vim.filetype.add({
				extension = {
					surql = "sql",
					surrealql = "sql",
				},
			})
		end,
	},
}