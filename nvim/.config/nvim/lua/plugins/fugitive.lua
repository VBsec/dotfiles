return {
  "tpope/vim-fugitive",
  cmd = { "Git", "G", "Gstatus", "Gblame", "Gpush", "Gpull", "Gcommit", "Glog", "Gdiffsplit", "Gread", "Gclog" },
  keys = {
    -- Enhanced file history browsing
    { "<leader>gF", "<cmd>0Gclog<cr>", desc = "File history (fugitive)" },
    { "<leader>gv", "<cmd>0Gclog!<cr>", desc = "File history (visual selection)", mode = "v" },
    { "<leader>gB", "<cmd>Git blame<cr>", desc = "Git blame (fugitive)" },
    
    -- Additional git operations
    { "<leader>gd", "<cmd>Gdiffsplit<cr>", desc = "Git diff split" },
    { "<leader>gD", "<cmd>Gdiffsplit HEAD<cr>", desc = "Git diff with HEAD" },
    { "<leader>gR", "<cmd>Gread<cr>", desc = "Git checkout file" },
    { "<leader>gw", "<cmd>Gwrite<cr>", desc = "Git add file" },
    
    -- Git log with graph
    { "<leader>gG", "<cmd>Git log --graph --oneline --all<cr>", desc = "Git graph" },
    
    -- Restore file from history
    { "<leader>gr", function()
      -- Get the commit hash from current line in quickfix or fugitive buffer
      local line = vim.fn.getline(".")
      local commit = line:match("^(%x+)")
      if commit and vim.bo.filetype == "qf" then
        -- Close quickfix
        vim.cmd("cclose")
        -- Restore file from that commit
        vim.cmd("Gread " .. commit .. ":%")
      else
        vim.cmd("Gread")
      end
    end, desc = "Restore file from commit" },
  },
  config = function()
    -- Fugitive-specific settings
    vim.api.nvim_create_autocmd("FileType", {
      pattern = { "fugitive", "git" },
      callback = function()
        local opts = { buffer = true }
        -- Quick close with q
        vim.keymap.set("n", "q", "<cmd>close<cr>", opts)
        -- Navigate commits in fugitive buffers
        vim.keymap.set("n", "<Tab>", "=", opts)
      end,
    })
    
    -- For browsing file history in quickfix
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "qf",
      callback = function()
        local opts = { buffer = true }
        -- Press enter to view commit, o to open in split
        vim.keymap.set("n", "o", "<cr><C-w>p", opts)
        -- Quick close
        vim.keymap.set("n", "q", "<cmd>cclose<cr>", opts)
      end,
    })
  end,
}