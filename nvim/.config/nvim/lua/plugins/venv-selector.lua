return {
  {
    "linux-cultist/venv-selector.nvim",
    branch = "main",
    dependencies = {
      "neovim/nvim-lspconfig",
      "ibhagwan/fzf-lua",
    },
    cmd = "VenvSelect",
    opts = {
      settings = {
        options = {
          notify_user_on_venv_activation = true,
        },
        search = {
          -- UV tool environments
          uv_tool = {
            command = "fd python$ ~/.local/share/uv/tools",
            type = "virtualenvs",
          },
          -- UV project environments  
          uv = {
            command = "fd python$ .venv",
            type = "virtualenvs",
          },
        },
      },
    },
    ft = "python",
    keys = { { "<leader>cv", "<cmd>:VenvSelect<cr>", desc = "Select VirtualEnv", ft = "python" } },
  },
}