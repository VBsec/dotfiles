-- UI utilities
local M = {}

function M.statuscolumn()
  local win = vim.g.statusline_winid
  local buf = vim.api.nvim_win_get_buf(win)
  local is_file = vim.bo[buf].buftype == ""
  local show_signs = vim.wo[win].signcolumn ~= "no"

  local components = { "", "", "" } -- left, middle, right

  if show_signs then
    components[1] = "%s"
  end

  if vim.wo[win].number then
    components[2] = "%l" -- line number
  end

  if vim.wo[win].relativenumber then
    components[2] = "%r" -- relative line number
  end

  return table.concat(components, " ")
end

return M