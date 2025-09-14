return {
  {
    "mfussenegger/nvim-dap",
    keys = {
      {
        "<leader>dq",
        function()
          require("dap").terminate()
          require("dapui").close()
        end,
        desc = "Quit Debug (terminate + close UI)",
      },
    },
  },
}