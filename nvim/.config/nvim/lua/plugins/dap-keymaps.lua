return {
  {
    "mfussenegger/nvim-dap",
    keys = {
      {
        "<leader>dR",
        function()
          -- Toggle REPL focus - if in REPL, go back; if not, focus REPL
          local repl_buf = nil
          for _, buf in ipairs(vim.api.nvim_list_bufs()) do
            if vim.bo[buf].filetype == "dap-repl" then
              repl_buf = buf
              break
            end
          end
          
          if repl_buf and vim.api.nvim_get_current_buf() ~= repl_buf then
            -- Focus the REPL window
            for _, win in ipairs(vim.api.nvim_list_wins()) do
              if vim.api.nvim_win_get_buf(win) == repl_buf then
                vim.api.nvim_set_current_win(win)
                break
              end
            end
          else
            -- Go back to previous window
            vim.cmd("wincmd p")
          end
        end,
        desc = "DAP: Toggle REPL focus",
      },
    },
  },
}