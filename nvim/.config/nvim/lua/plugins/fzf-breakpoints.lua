return {
  {
    "ibhagwan/fzf-lua",
    dependencies = { "mfussenegger/nvim-dap" },
    keys = {
      {
        "<leader>dB",
        function()
          local dap = require("dap")
          local fzf = require("fzf-lua")
          
          -- Get all breakpoints
          local breakpoints_by_buf = require("dap.breakpoints").get()
          local items = {}
          local has_breakpoints = false
          
          for bufnr, buf_bps in pairs(breakpoints_by_buf) do
            local filename = vim.api.nvim_buf_get_name(bufnr)
            if filename and filename ~= "" then
              for _, bp in ipairs(buf_bps) do
                has_breakpoints = true
                local icon = bp.verified and "●" or "○"
                local cond = bp.condition and (" [if: %s]"):format(bp.condition) or ""
                local log = bp.logMessage and (" [log: %s]"):format(bp.logMessage) or ""
                local hit = bp.hitCondition and (" [hit: %s]"):format(bp.hitCondition) or ""
                
                -- Format: filename:line icon condition info
                -- Use relative path from cwd for better readability
                local display_path = vim.fn.fnamemodify(filename, ":.")
                local entry = string.format(
                  "%s:%d %s%s%s%s",
                  display_path,  -- Relative path from cwd
                  bp.line,
                  icon,
                  cond,
                  log,
                  hit
                )
                
                table.insert(items, {
                  text = entry,
                  filename = filename,
                  lnum = bp.line,
                  bufnr = bufnr,
                })
              end
            end
          end
          
          if not has_breakpoints then
            vim.notify("No breakpoints set", vim.log.levels.INFO)
            return
          end
          
          fzf.fzf_exec(function(cb)
            for _, item in ipairs(items) do
              cb(item.text)
            end
          end, {
            prompt = "Breakpoints> ",
            previewer = "builtin",
            actions = {
              ["default"] = function(selected)
                if not selected or #selected == 0 then return end
                
                -- Parse the selected line to get file and line number
                local line = selected[1]
                local idx = 1
                for i, item in ipairs(items) do
                  if item.text == line then
                    idx = i
                    break
                  end
                end
                
                local bp = items[idx]
                if bp then
                  -- Jump to the breakpoint
                  vim.cmd("edit " .. bp.filename)
                  vim.api.nvim_win_set_cursor(0, { bp.lnum, 0 })
                  vim.cmd("normal! zz")
                end
              end,
              ["ctrl-x"] = function(selected)
                if not selected or #selected == 0 then return end
                
                -- Remove selected breakpoints
                local breakpoints = require("dap.breakpoints")
                for _, line in ipairs(selected) do
                  for _, item in ipairs(items) do
                    if item.text == line then
                      breakpoints.remove(item.bufnr, item.lnum)
                      break
                    end
                  end
                end
                vim.notify("Breakpoint(s) removed", vim.log.levels.INFO)
              end,
            },
            winopts = {
              height = 0.4,
              width = 0.6,
            },
            fzf_opts = {
              ["--multi"] = true,
              ["--delimiter"] = ":",
              ["--preview-window"] = "right:50%",
            },
          })
        end,
        desc = "FZF: Breakpoints",
      },
      {
        "<leader>dbf",
        function()
          -- List breakpoints in current file only
          local fzf = require("fzf-lua")
          local current_buf = vim.api.nvim_get_current_buf()
          local current_file = vim.fn.expand("%:p")
          
          local breakpoints_by_buf = require("dap.breakpoints").get()
          local file_breakpoints = breakpoints_by_buf[current_buf] or {}
          
          if #file_breakpoints == 0 then
            vim.notify("No breakpoints in current file", vim.log.levels.INFO)
            return
          end
          
          local items = {}
          for _, bp in ipairs(file_breakpoints) do
            local line_text = vim.fn.getline(bp.line)
            local icon = bp.verified and "●" or "○"
            local cond = bp.condition and (" [if: %s]"):format(bp.condition) or ""
            
            local entry = string.format(
              "%s %4d: %s%s",
              icon,
              bp.line,
              vim.trim(line_text),
              cond
            )
            
            table.insert(items, {
              text = entry,
              lnum = bp.line,
            })
          end
          
          fzf.fzf_exec(function(cb)
            for _, item in ipairs(items) do
              cb(item.text)
            end
          end, {
            prompt = "File Breakpoints> ",
            actions = {
              ["default"] = function(selected)
                if not selected or #selected == 0 then return end
                
                -- Find the matching item
                local line = selected[1]
                for _, item in ipairs(items) do
                  if item.text == line then
                    vim.api.nvim_win_set_cursor(0, { item.lnum, 0 })
                    vim.cmd("normal! zz")
                    break
                  end
                end
              end,
              ["ctrl-x"] = function(selected)
                if not selected or #selected == 0 then return end
                
                -- Remove selected breakpoints
                local breakpoints = require("dap.breakpoints")
                for _, line in ipairs(selected) do
                  local lnum = tonumber(line:match("^[●○]%s+(%d+):"))
                  if lnum then
                    breakpoints.remove(current_buf, lnum)
                  end
                end
                vim.notify("Breakpoint(s) removed", vim.log.levels.INFO)
              end,
            },
            winopts = {
              height = 0.4,
              width = 0.8,
            },
            fzf_opts = {
              ["--multi"] = true,
              ["--no-sort"] = true,
            },
          })
        end,
        desc = "FZF: Breakpoints (current file)",
      },
    },
  },
}