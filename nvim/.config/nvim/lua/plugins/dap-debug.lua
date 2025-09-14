return {
  {
    "mfussenegger/nvim-dap",
    config = function()
      -- Override the launch function to inspect what's being sent
      local dap = require("dap")
      local original_launch = dap.launch
      
      dap.launch = function(adapter, config, opts)
        print("DAP Launch Config:")
        for k, v in pairs(config) do
          if type(v) ~= "function" then
            print(string.format("  %s = %s", k, vim.inspect(v)))
          else
            print(string.format("  %s = <function>", k))
          end
        end
        return original_launch(adapter, config, opts)
      end
    end,
  },
}