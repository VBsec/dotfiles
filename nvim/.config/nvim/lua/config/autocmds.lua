-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

-- Associate CDDL files with YAML syntax highlighting
vim.filetype.add({
  extension = {
    cddl = "yaml",
  },
})
if vim.g.vscode then
	vim.api.nvim_create_autocmd("FileType", {
		pattern = { "text", "plaintex", "typst", "gitcommit", "markdown" },
		callback = function()
			vim.opt_local.spell = false
		end,
	})
end
