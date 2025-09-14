return {
  {
    "mfussenegger/nvim-dap",
    opts = function()
      -- Disable loading .vscode/launch.json files
      -- They use "mode": "auto" which is incompatible with nvim-dap-go
      require("dap.ext.vscode").load_launchjs = function()
        -- Do nothing, skip loading launch.json
      end
    end,
  },
}