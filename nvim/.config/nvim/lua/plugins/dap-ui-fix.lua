return {
  -- Fix DAP UI selection
  {
    "mfussenegger/nvim-dap",
    opts = function()
      local dap = require("dap")
      -- Use telescope for dap selection instead of built-in UI
      dap.defaults.fallback.terminal_win_cmd = "50vsplit new"
      
      -- Override the default UI select behavior
      vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DapBreakpoint", linehl = "", numhl = "" })
      vim.fn.sign_define("DapBreakpointCondition", { text = "●", texthl = "DapBreakpointCondition", linehl = "", numhl = "" })
      vim.fn.sign_define("DapLogPoint", { text = "◆", texthl = "DapLogPoint", linehl = "", numhl = "" })
      vim.fn.sign_define("DapStopped", { text = "▶", texthl = "DapStopped", linehl = "DapStopped", numhl = "DapStopped" })
      vim.fn.sign_define("DapBreakpointRejected", { text = "●", texthl = "DapBreakpointRejected", linehl = "", numhl = "" })
      
      return {}
    end,
  },
  
  -- Use telescope for DAP configuration selection
  {
    "nvim-telescope/telescope-dap.nvim",
    dependencies = {
      "mfussenegger/nvim-dap",
      "nvim-telescope/telescope.nvim",
    },
    config = function()
      require("telescope").load_extension("dap")
      
      -- Override the default continue function to use telescope
      local dap = require("dap")
      local original_continue = dap.continue
      
      dap.continue = function()
        if not next(dap.configurations[vim.bo.filetype] or {}) then
          original_continue()
          return
        end
        
        -- Use telescope for configuration selection
        require("telescope").extensions.dap.configurations({
          language_filter = vim.bo.filetype,
        })
      end
    end,
  },
  
  -- Better UI select for non-telescope fallback
  {
    "stevearc/dressing.nvim",
    opts = {
      select = {
        enabled = true,
        backend = { "telescope", "fzf_lua", "builtin" },
        telescope = {
          theme = "dropdown",
        },
      },
    },
  },
}