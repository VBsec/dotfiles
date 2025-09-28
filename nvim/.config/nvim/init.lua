-- bootstrap lazy.nvim, LazyVim and your plugins

if vim.g.vscode then
  -- VSCode extension
  require("config.lazy")
else
  require("config.lazy")
  require("nvim-ts-autotag").setup({})
  vim.api.nvim_command("highlight LineNr guifg=#bae67e ctermfg=149")
  vim.api.nvim_command("highlight CursorLineNr guifg=#ef6b73 ctermfg=203")
  vim.api.nvim_command("highlight CursorLine guibg=#1C1C3E")
end
