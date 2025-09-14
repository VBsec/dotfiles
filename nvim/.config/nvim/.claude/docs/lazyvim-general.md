[Skip to main content](https://www.lazyvim.org/configuration/general#__docusaurus_skipToContent_fallback)

On this page

# General Settings

The files `autocmds.lua`, `keymaps.lua`, `lazy.lua` and `options.lua` under `lua/config` will be automatically loaded at the appropriate time,
so you don't need to require those files manually.
**LazyVim** comes with a set of default config files that will be loaded
**_before_** your own.

```codeBlockLines_e6Vv
~/.config/nvim
├── lua
│   ├── config
│   │   ├── autocmds.lua
│   │   ├── keymaps.lua
│   │   ├── lazy.lua
│   │   └── options.lua
│   └── plugins
│       ├── spec1.lua
│       ├── **
│       └── spec2.lua
└── init.lua

```

danger

Do not `require` `autocmds`, `keymaps`, `lazy` or `options` under `lua/config/` or `lazyvim.config` manually.
**LazyVim** will load those files automatically.

## Options [​](https://www.lazyvim.org/configuration/general\#options "Direct link to Options")

- Custom Options
- Default Options

lua/config/options.lua

```codeBlockLines_e6Vv
-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

```

## Keymaps [​](https://www.lazyvim.org/configuration/general\#keymaps "Direct link to Keymaps")

- Custom Keymaps
- Default Keymaps

lua/config/keymaps.lua

```codeBlockLines_e6Vv
-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

```

## Auto Commands [​](https://www.lazyvim.org/configuration/general\#auto-commands "Direct link to Auto Commands")

- Custom Auto Commands
- Default Auto Commands

lua/config/autocmds.lua

```codeBlockLines_e6Vv
-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

```

- [Options](https://www.lazyvim.org/configuration/general#options)
- [Keymaps](https://www.lazyvim.org/configuration/general#keymaps)
- [Auto Commands](https://www.lazyvim.org/configuration/general#auto-commands)