return {
  {
    "rcarriga/nvim-dap-ui",
    config = function(_, opts)
      local dapui = require("dapui")
      dapui.setup(opts)
      
      -- Add titles to DAP UI windows after they open
      local dap = require("dap")
      
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
        
        -- Add window titles
        vim.schedule(function()
          for _, win in ipairs(vim.api.nvim_list_wins()) do
            local buf = vim.api.nvim_win_get_buf(win)
            local ft = vim.bo[buf].filetype
            
            local titles = {
              ["dapui_scopes"] = " 󰠱 Scopes ",
              ["dapui_breakpoints"] = "  Breakpoints ",
              ["dapui_stacks"] = " 󰎠 Call Stack ",
              ["dapui_watches"] = " 󰂥 Watches ",
              ["dap-repl"] = " 󰞷 REPL / Output ",
              ["dapui_console"] = " 󰐪 Console ",
            }
            
            if titles[ft] then
              -- Get window configuration
              local config = vim.api.nvim_win_get_config(win)
              -- Only update if it's a split window (not floating)
              if config.relative == "" then
                -- Set a custom winbar for the title
                vim.wo[win].winbar = "%#DapUIHeader#" .. titles[ft] .. "%*"
              end
            end
          end
        end)
      end
      
      -- Define highlight for window titles
      vim.api.nvim_set_hl(0, "DapUIHeader", { 
        fg = "#7aa2f7", 
        bg = "NONE", 
        bold = true 
      })
    end,
  },
}