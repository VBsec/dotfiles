-- Autocmds (ported from the old config).

-- Disable spell checking for prose filetypes. In VSCode, cover the broader set;
-- in native Neovim only markdown (LazyVim used to enable spell elsewhere).
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

if vim.g.vscode then
  return
end

-- Native Neovim only below ----------------------------------------------------

-- Force-stop LSP clients before exit to avoid async-shutdown races on quit.
vim.api.nvim_create_autocmd("VimLeavePre", {
  callback = function()
    for _, client in ipairs(vim.lsp.get_clients()) do
      client:stop(true)
    end
  end,
})

-- Open the smart picker when nvim is started on a directory.
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    local arg = vim.fn.argv(0)
    if type(arg) == "string" and arg ~= "" and vim.fn.isdirectory(arg) == 1 then
      vim.cmd("cd " .. vim.fn.fnameescape(arg))
      if Snacks and Snacks.picker then
        Snacks.picker.smart()
      end
    end
  end,
})

-- Highlight on yank (small native nicety).
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.hl.on_yank()
  end,
})
