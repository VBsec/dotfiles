return {
  -- Harpoon for quick file navigation
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    keys = {
      { "<leader>h", function() require("harpoon"):list():add() end, desc = "Harpoon File" },
      { "<leader>H", function() local harpoon = require("harpoon") harpoon.ui:toggle_quick_menu(harpoon:list()) end, desc = "Harpoon Quick Menu" },
      { "<leader>1", function() require("harpoon"):list():select(1) end, desc = "Harpoon to File 1" },
      { "<leader>2", function() require("harpoon"):list():select(2) end, desc = "Harpoon to File 2" },
      { "<leader>3", function() require("harpoon"):list():select(3) end, desc = "Harpoon to File 3" },
      { "<leader>4", function() require("harpoon"):list():select(4) end, desc = "Harpoon to File 4" },
      { "<leader>5", function() require("harpoon"):list():select(5) end, desc = "Harpoon to File 5" },
      { "[h", function() require("harpoon"):list():prev() end, desc = "Harpoon Prev" },
      { "]h", function() require("harpoon"):list():next() end, desc = "Harpoon Next" },
    },
    opts = {
      settings = {
        save_on_toggle = false,
        sync_on_ui_close = false,
      },
    },
  },

  -- Session management
  {
    "folke/persistence.nvim",
    event = "BufReadPre",
    opts = {},
    keys = {
      { "<leader>qs", function() require("persistence").load() end, desc = "Restore Session" },
      { "<leader>qS", function() require("persistence").select() end, desc = "Select Session" },
      { "<leader>ql", function() require("persistence").load({ last = true }) end, desc = "Restore Last Session" },
      { "<leader>qd", function() require("persistence").stop() end, desc = "Don't Save Current Session" },
    },
  },

  -- Project management
  {
    "ahmedkhalf/project.nvim",
    opts = {
      manual_mode = false,
      detection_methods = { "pattern", "lsp" },
      patterns = { ".git", "_darcs", ".hg", ".bzr", ".svn", "Makefile", "package.json", "go.mod", "cargo.toml" },
    },
    event = "VeryLazy",
    config = function(_, opts)
      require("project_nvim").setup(opts)
    end,
  },

  -- Tmux integration
  {
    "christoomey/vim-tmux-navigator",
    cond = vim.env.TMUX ~= nil,
    keys = {
      { "<C-h>", "<cmd>TmuxNavigateLeft<cr>", desc = "Navigate Left" },
      { "<C-j>", "<cmd>TmuxNavigateDown<cr>", desc = "Navigate Down" },
      { "<C-k>", "<cmd>TmuxNavigateUp<cr>", desc = "Navigate Up" },
      { "<C-l>", "<cmd>TmuxNavigateRight<cr>", desc = "Navigate Right" },
    },
  },

  -- Git integration
  {
    "tpope/vim-fugitive",
    cmd = { "Git", "G", "Gvdiffsplit", "Gdiffsplit" },
    keys = {
      { "<leader>gG", "<cmd>Git<cr>", desc = "Git Status" },
      { "<leader>gB", "<cmd>Git blame<cr>", desc = "Git Blame" },
      { "<leader>gd", "<cmd>Gvdiffsplit<cr>", desc = "Git Diff Split" },
      { "<leader>gh", "<cmd>diffget //2<cr>", desc = "Get from left (in merge)" },
      { "<leader>gl", "<cmd>diffget //3<cr>", desc = "Get from right (in merge)" },
    },
  },

  -- Find and replace
  {
    "MagicDuck/grug-far.nvim",
    cmd = "GrugFar",
    keys = {
      {
        "<leader>sr",
        function()
          local grug = require("grug-far")
          local ext = vim.bo.buftype == "" and vim.fn.expand("%:e")
          grug.open({
            transient = true,
            prefills = {
              filesFilter = ext and ext ~= "" and "*." .. ext or nil,
            },
          })
        end,
        mode = { "n", "v" },
        desc = "Search and Replace",
      },
    },
    opts = {
      headerMaxWidth = 80,
      icons = {
        enabled = true,
      },
      keymaps = {
        replace = { n = "<localleader>r" },
        qflist = { n = "<localleader>q" },
        syncLocations = { n = "<localleader>s" },
        syncLine = { n = "<localleader>l" },
        close = { n = "<localleader>c" },
        historyOpen = { n = "<localleader>t" },
        historyAdd = { n = "<localleader>a" },
        refresh = { n = "<localleader>f" },
        openLocation = { n = "<localleader>o" },
        gotoLocation = { n = "<enter>" },
        pickHistoryEntry = { n = "<enter>" },
        abort = { n = "<localleader>b" },
        help = { n = "g?" },
        toggleShowCommand = { n = "<localleader>p" },
        swapEngine = { n = "<localleader>e" },
      },
    },
  },

  -- Oil.nvim for file management
  {
    "stevearc/oil.nvim",
    cmd = "Oil",
    keys = {
      { "-", "<cmd>Oil<cr>", desc = "Open parent directory" },
      { "<leader>-", function() require("oil").open(vim.fn.getcwd()) end, desc = "Open oil in cwd" },
    },
    opts = {
      default_file_explorer = false,
      delete_to_trash = true,
      skip_confirm_for_simple_edits = true,
      view_options = {
        show_hidden = true,
        natural_order = true,
        is_always_hidden = function(name, _)
          return name == ".." or name == ".git"
        end,
      },
      float = {
        padding = 2,
        max_width = 90,
        max_height = 0,
      },
      win_options = {
        wrap = true,
        winblend = 0,
      },
      keymaps = {
        ["<C-c>"] = false,
        ["q"] = "actions.close",
      },
    },
  },

  -- Dotenv support
  {
    "ellisonleao/dotenv.nvim",
    event = "VeryLazy",
    opts = {
      enable_on_load = true,
      verbose = false,
    },
  },

  -- Project-local config
  {
    "klen/nvim-config-local",
    event = "VeryLazy",
    opts = {
      config_files = { ".nvim.lua", ".nvimrc", ".exrc" },
      hashfile = vim.fn.stdpath("cache") .. "/config-local",
      autocommands_create = true,
      commands_create = true,
      silent = false,
      lookup_parents = false,
    },
    config = function(_, opts)
      require("config-local").setup(opts)
    end,
  },

  -- Plenary (required by many plugins)
  {
    "nvim-lua/plenary.nvim",
    lazy = true,
  },
}