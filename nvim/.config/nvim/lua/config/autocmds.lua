-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")
-- Disable spell for markdown (and other prose files in VSCode)
if vim.g.vscode then
  vim.api.nvim_create_autocmd("FileType", {
    pattern = { "text", "plaintex", "typst", "gitcommit", "markdown" },
    callback = function()
      vim.opt_local.spell = false
    end,
  })
else
  vim.api.nvim_create_autocmd("FileType", {
    pattern = { "markdown" },
    callback = function()
      vim.opt_local.spell = false
    end,
  })
end

-- Open snacks picker when starting nvim with a directory
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    local arg = vim.fn.argv(0)
    if vim.fn.isdirectory(arg) == 1 then
      vim.cmd("cd " .. arg)
      Snacks.picker.files()
    end
  end,
})
