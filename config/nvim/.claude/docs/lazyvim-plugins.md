[Skip to main content](https://www.lazyvim.org/configuration/plugins#__docusaurus_skipToContent_fallback)

On this page

# Plugins

Configuring **LazyVim** plugins is exactly the same as using **lazy.nvim** to build
a config from scratch.

For the full plugin spec documentation please check the **lazy.nvim** [readme](https://github.com/folke/lazy.nvim).

Refer to the **plugins** section in the sidebar for configuring
included plugins.

## ➕ Adding Plugins [​](https://www.lazyvim.org/configuration/plugins\#-adding-plugins "Direct link to ➕ Adding Plugins")

Adding a plugin is as simple as adding the plugin spec to one of the files
under `lua/plugins/*.lua`. You can create as many files there as you want.

You can structure your `lua/plugins` folder with a file per plugin,
or a separate file containing all the plugin specs for some functionality.

lua/plugins/lsp.lua

```codeBlockLines_e6Vv
return {
  -- add symbols-outline
  {
    "simrat39/symbols-outline.nvim",
    cmd = "SymbolsOutline",
    keys = { { "<leader>cs", "<cmd>SymbolsOutline<cr>", desc = "Symbols Outline" } },
    opts = {
      -- add your options that should be passed to the setup() function here
      position = "right",
    },
  },
}

```

## ❌ Disabling Plugins [​](https://www.lazyvim.org/configuration/plugins\#-disabling-plugins "Direct link to ❌ Disabling Plugins")

In order to disable a plugin, add a spec with `enabled=false`

lua/plugins/disabled.lua

```codeBlockLines_e6Vv
return {
  -- disable trouble
  { "folke/trouble.nvim", enabled = false },
}

```

## ✏️ Customizing Plugin Specs [​](https://www.lazyvim.org/configuration/plugins\#%EF%B8%8F-customizing-plugin-specs "Direct link to ✏️ Customizing Plugin Specs")

Defaults merging rules:

- **cmd**: the list of commands will be extended with your custom commands
- **event**: the list of events will be extended with your custom events
- **ft**: the list of filetypes will be extended with your custom filetypes
- **keys**: the list of keymaps will be extended with your custom keymaps
- **opts**: your custom opts will be merged with the default opts
- **dependencies**: the list of dependencies will be extended with your custom dependencies
- **_any other property will override the defaults_**

For `ft`, `event`, `keys`, `cmd` and `opts` you can instead also specify a `values` function
that can make changes to the default values, or return new values to be used instead.

```codeBlockLines_e6Vv
return {
  -- change trouble config
  {
    "folke/trouble.nvim",
    -- opts will be merged with the parent spec
    opts = { use_diagnostic_signs = true },
  }

  -- add cmp-emoji
  {
    "hrsh7th/nvim-cmp",
    dependencies = { "hrsh7th/cmp-emoji" },
    ---@param opts cmp.ConfigSchema
    opts = function(_, opts)
      table.insert(opts.sources, { name = "emoji" })
    end,
  }
}

```

## ⌨️ Adding & Disabling Plugin Keymaps [​](https://www.lazyvim.org/configuration/plugins\#%EF%B8%8F-adding--disabling-plugin-keymaps "Direct link to ⌨️ Adding & Disabling Plugin Keymaps")

Adding `keys=` follows the rules as explained above.

You can also disable a default keymap by setting it to `false`.
To override a keymap, simply add one with the same `lhs` and a new `rhs`.

lua/plugins/telescope.lua

```codeBlockLines_e6Vv
return {
  "nvim-telescope/telescope.nvim",
  keys = {
    -- disable the keymap to grep files
    {"<leader>/", false},
    -- change a keymap
    { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find Files" },
    -- add a keymap to browse plugin files
    {
      "<leader>fp",
      function() require("telescope.builtin").find_files({ cwd = require("lazy.core.config").options.root }) end,
      desc = "Find Plugin File",
    },
  },
},

```

caution

Make sure to use the exact same mode as the keymap you want to disable.
You don't have to specify a mode for `normal` mode keymaps.

lua/plugins/flash.lua

```codeBlockLines_e6Vv
return {
  "folke/flash.nvim",
  keys = {
    -- disable the default flash keymap
    { "s", mode = { "n", "x", "o" }, false },
  },
}

```

You can also return a whole new set of keymaps to be used instead.
Or return `{}` to disable all keymaps for a plugin.

lua/plugins/telescope.lua

```codeBlockLines_e6Vv
return {
  "nvim-telescope/telescope.nvim",
  -- replace all Telescope keymaps with only one mapping
  keys = function()
    return {
      { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find Files" },
    }
  end,
},

```

- [➕ Adding Plugins](https://www.lazyvim.org/configuration/plugins#-adding-plugins)
- [❌ Disabling Plugins](https://www.lazyvim.org/configuration/plugins#-disabling-plugins)
- [✏️ Customizing Plugin Specs](https://www.lazyvim.org/configuration/plugins#%EF%B8%8F-customizing-plugin-specs)
- [⌨️ Adding & Disabling Plugin Keymaps](https://www.lazyvim.org/configuration/plugins#%EF%B8%8F-adding--disabling-plugin-keymaps)