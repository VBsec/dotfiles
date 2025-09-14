return {
  {
    "rcarriga/nvim-dap-ui",
    opts = {
      console = {
        open_on_start = true,
      },
      icons = { expanded = "▾", collapsed = "▸", current_frame = "▸" },
      mappings = {
        expand = { "<CR>", "<2-LeftMouse>" },
        open = "o",
        remove = "d",
        edit = "e",
        repl = "r",
        toggle = "t",
      },
      layouts = {
        {
          elements = {
            { id = "scopes", size = 0.25 },
            { id = "breakpoints", size = 0.25 },
            { id = "stacks", size = 0.25 },
            { id = "watches", size = 0.25 },
          },
          size = 40,
          position = "left",
        },
        {
          elements = {
            { id = "repl", size = 1.0 },     -- Full width for REPL (stdout shows here)
          },
          size = 30,  -- Make it even taller (30 lines)
          position = "bottom",
        },
      },
      windows = { indent = 1 },
      render = {
        max_type_length = nil,
        max_value_lines = 100,
        indent = 1,
      },
      floating = {
        border = "single",
        mappings = {
          close = { "q", "<Esc>" },
        },
      },
      element_mappings = {},
    },
  },
  {
    "mfussenegger/nvim-dap",
    opts = function()
      local dap = require("dap")
      
      -- Configure delve to output colors
      dap.adapters.go = {
        type = "server",
        port = "${port}",
        executable = {
          command = "dlv",
          args = { "dap", "-l", "127.0.0.1:${port}" },
          env = {
            TERM = "xterm-256color",
            COLORTERM = "truecolor",
          },
        },
        options = {
          initialize_timeout_sec = 20,
        },
      }
    end,
  },
}