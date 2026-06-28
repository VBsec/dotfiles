-- Sensible default keymaps that LazyVim used to provide. Ported and trimmed to
-- what's useful here. Native Neovim only (VSCode owns these).
-- Plugin-specific keymaps (snacks, neotest, surround, lazygit, LSP) live in
-- config.plugins. UI toggles that need snacks live there too.

if vim.g.vscode then
  return
end

local map = vim.keymap.set

-- Better up/down (respect wrapped lines).
map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true, desc = "Down" })
map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true, desc = "Up" })

-- Window navigation (Ctrl+hjkl). Free now that tmux-navigator is gone; zellij
-- intercepts these only at the multiplexer boundary, nvim handles them within.
map("n", "<C-h>", "<C-w>h", { desc = "Go to left window", remap = true })
map("n", "<C-j>", "<C-w>j", { desc = "Go to lower window", remap = true })
map("n", "<C-k>", "<C-w>k", { desc = "Go to upper window", remap = true })
map("n", "<C-l>", "<C-w>l", { desc = "Go to right window", remap = true })

-- Window resize.
map("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase window height" })
map("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease window height" })
map("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease window width" })
map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase window width" })

-- Splits / window management.
map("n", "<leader>w", "<C-w>", { desc = "Windows", remap = true })
map("n", "<leader>|", "<C-W>v", { desc = "Split window right", remap = true })
map("n", "<leader>wd", "<C-W>c", { desc = "Delete window", remap = true })

-- Buffers.
map("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Prev buffer" })
map("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next buffer" })
map("n", "[b", "<cmd>bprevious<cr>", { desc = "Prev buffer" })
map("n", "]b", "<cmd>bnext<cr>", { desc = "Next buffer" })
map("n", "<leader>bb", "<cmd>e #<cr>", { desc = "Switch to other buffer" })
map("n", "<leader>`", "<cmd>e #<cr>", { desc = "Switch to other buffer" })
map("n", "<leader>bd", "<cmd>bdelete<cr>", { desc = "Delete buffer" })
map("n", "<leader>bD", "<cmd>bdelete!<cr>", { desc = "Delete buffer (force)" })

-- Save.
map({ "i", "x", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save file" })

-- Clear search highlight on <esc>.
map({ "i", "n", "s" }, "<esc>", function()
  vim.cmd("noh")
  return "<esc>"
end, { expr = true, desc = "Escape and clear hlsearch" })

-- Search results stay centered.
map("n", "n", "'Nn'[v:searchforward].'zv'", { expr = true, desc = "Next search result" })
map("n", "N", "'nN'[v:searchforward].'zv'", { expr = true, desc = "Prev search result" })

-- Keep visual selection when indenting.
map("x", "<", "<gv")
map("x", ">", ">gv")

-- Keywordprg.
map("n", "<leader>K", "<cmd>norm! K<cr>", { desc = "Keywordprg" })

-- New file.
map("n", "<leader>fn", "<cmd>enew<cr>", { desc = "New file" })

-- Quit.
map("n", "<leader>qq", "<cmd>qa<cr>", { desc = "Quit all" })

-- Quickfix / location list.
map("n", "[q", vim.cmd.cprev, { desc = "Previous quickfix" })
map("n", "]q", vim.cmd.cnext, { desc = "Next quickfix" })
-- <leader>xq (quickfix picker) is set in config.plugins via snacks.
map("n", "<leader>xl", "<cmd>lopen<cr>", { desc = "Location list" })

-- Diagnostics quickfix.
map("n", "<leader>xx", vim.diagnostic.setloclist, { desc = "Diagnostics (loclist)" })
