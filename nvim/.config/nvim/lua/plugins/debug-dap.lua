-- Debug helper to inspect DAP configurations
return {
  {
    "mfussenegger/nvim-dap",
    keys = {
      {
        "<leader>dD",
        function()
          local dap = require("dap")
          if dap.configurations.go then
            print("Go DAP Configurations:")
            for i, config in ipairs(dap.configurations.go) do
              print(string.format("\n[%d] %s:", i, config.name or "unnamed"))
              for k, v in pairs(config) do
                if type(v) ~= "function" then
                  print(string.format("  %s = %s", k, vim.inspect(v)))
                else
                  print(string.format("  %s = <function>", k))
                end
              end
            end
          else
            print("No Go DAP configurations found")
          end
        end,
        desc = "Debug: Show Go DAP configs",
      },
    },
  },
}