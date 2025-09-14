return {
  {
    "m00qek/baleia.nvim",
    version = "*",
    config = function()
      local baleia = require("baleia").setup({})

      -- Automatically colorize DAP console output
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "dap-repl",
        callback = function()
          baleia.automatically(vim.api.nvim_get_current_buf())
        end,
      })

      -- Colorize DAP console buffer
      vim.api.nvim_create_autocmd("BufWinEnter", {
        pattern = "\\[dap-console\\]",
        callback = function()
          baleia.automatically(vim.api.nvim_get_current_buf())
        end,
      })
      
      -- Also handle the DAP UI console window
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "dapui_console",
        callback = function()
          baleia.automatically(vim.api.nvim_get_current_buf())
        end,
      })
    end,
  },
}