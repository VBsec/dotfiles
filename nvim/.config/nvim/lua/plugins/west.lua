-- West build tool integration for Zephyr RTOS
return {
  -- Terminal integration for West commands
  {
    "akinsho/toggleterm.nvim",
    opts = {
      size = function(term)
        if term.direction == "horizontal" then
          return 15
        elseif term.direction == "vertical" then
          return vim.o.columns * 0.4
        end
      end,
    },
    keys = {
      {
        "<leader>wt",
        function()
          local Terminal = require("toggleterm.terminal").Terminal
          local west = Terminal:new({
            cmd = "west",
            dir = "/Users/vbsec/golioth",
            hidden = true,
            direction = "float",
            float_opts = {
              border = "double",
              width = math.floor(vim.o.columns * 0.8),
              height = math.floor(vim.o.lines * 0.8),
            },
            on_open = function(term)
              vim.cmd("startinsert!")
              vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true })
            end,
          })
          west:toggle()
        end,
        desc = "West interactive terminal",
      },
    },
  },

  -- Overseer for task running
  {
    "stevearc/overseer.nvim",
    opts = {
      templates = { "builtin" },
      task_list = {
        direction = "bottom",
        min_height = 10,
        max_height = 20,
      },
    },
    config = function(_, opts)
      local overseer = require("overseer")
      overseer.setup(opts)

      -- Register West build templates
      overseer.register_template({
        name = "west build",
        builder = function(params)
          return {
            cmd = "west",
            args = { "build", "-b", params.board or "nrf9160dk_nrf9160_ns", "apps/iot-connector" },
            cwd = "/Users/vbsec/golioth",
            components = {
              { "on_output_quickfix", open = false },
              "on_exit_set_status",
              { "on_complete_notify", on_change = false },
              "default",
            },
          }
        end,
        desc = "Build Zephyr application with West",
        params = {
          board = {
            type = "string",
            default = "nrf9160dk_nrf9160_ns",
            desc = "Target board",
            optional = true,
          },
        },
      })

      overseer.register_template({
        name = "west flash",
        builder = function(params)
          return {
            cmd = "west",
            args = params.runner and { "flash", "--runner", params.runner } or { "flash" },
            cwd = "/Users/vbsec/golioth",
            components = { "default" },
          }
        end,
        desc = "Flash Zephyr application",
        params = {
          runner = {
            type = "enum",
            choices = { "jlink", "nrfjprog", "pyocd" },
            optional = true,
            desc = "Flash runner",
          },
        },
      })

      overseer.register_template({
        name = "west clean",
        builder = function()
          return {
            cmd = "rm",
            args = { "-rf", "apps/iot-connector/build" },
            cwd = "/Users/vbsec/golioth",
            components = { "default" },
          }
        end,
        desc = "Clean build directory",
      })
    end,
    keys = {
      { "<leader>wr", "<cmd>OverseerRun<cr>", desc = "Run West task" },
      { "<leader>wl", "<cmd>OverseerToggle<cr>", desc = "West task list" },
    },
  },

  -- Which-key descriptions for West commands
  {
    "folke/which-key.nvim",
    opts = {
      spec = {
        { "<leader>w", group = "west", icon = "🔧" },
        { "<leader>g", group = "goto project files", icon = "📁" },
      },
    },
  },
}