-- Setup lazy.nvim plugin manager
require("lazy").setup({
  spec = {
    -- Import plugin specs from lua/plugins/*.lua
    { import = "plugins" },
  },
  defaults = {
    lazy = false, -- Don't lazy-load by default
    version = false, -- Always use the latest git commit
  },
  install = {
    colorscheme = { "tokyonight", "catppuccin" },
  },
  checker = {
    enabled = true, -- Check for plugin updates
    notify = false, -- Don't notify on startup
  },
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
  ui = {
    backdrop = 100,
    icons = {
      cmd = " ",
      config = "",
      event = " ",
      ft = " ",
      init = " ",
      import = " ",
      keys = " ",
      lazy = "󰒲 ",
      loaded = "●",
      not_loaded = "○",
      plugin = " ",
      runtime = " ",
      require = "󰢱 ",
      source = " ",
      start = " ",
      task = "✔ ",
      list = {
        "●",
        "➜",
        "★",
        "‒",
      },
    },
  },
})