# Neovim Configuration Migration Plan

## Current Plugin Analysis (96 total plugins)

### ✅ Core Infrastructure (KEEP)
- **lazy.nvim** - Plugin manager
- **plenary.nvim** - Lua utility library (required by many plugins)
- **nui.nvim** - UI component library

### 🔄 UI & Navigation (CONSOLIDATE)

#### Status & Buffers
- **KEEP**: `lualine.nvim` - Status line
- **KEEP**: `bufferline.nvim` - Buffer tabs
- **REMOVE**: `dashboard-nvim` → Use snacks.nvim dashboard

#### File Navigation  
- **REMOVE**: `telescope.nvim`, `telescope-dap.nvim` → Use snacks.nvim picker
- **REMOVE**: `fzf-lua` → Use snacks.nvim picker  
- **REMOVE**: `neo-tree.nvim` → Use oil.nvim or snacks.nvim explorer
- **KEEP**: `oil.nvim` - Buffer-like file editing (or use snacks explorer)
- **KEEP**: `harpoon` - Quick file navigation

#### UI Enhancements
- **KEEP**: `which-key.nvim` - Keybinding helper
- **REMOVE**: `dressing.nvim` - Snacks has input feature for better vim.ui.input
- **MAYBE**: `noice.nvim` - Enhanced UI (Snacks has notifier for vim.notify, but noice does more)
- **KEEP**: `trouble.nvim` - Diagnostics list
- **KEEP**: `todo-comments.nvim` - Highlight TODO comments
- **REMOVE**: `edgy.nvim` - Window layout manager
- **KEEP**: `mini.icons`

### 🎨 Colorschemes (CHOOSE 2-3)
Currently have 7 colorschemes installed:
- **KEEP**: `catppuccin` - Popular, well-maintained
- **KEEP**: `tokyonight.nvim` - Popular, by Folke
- **REMOVE**: Others unless specifically needed

### ✏️ Editing & Motion

#### Core Editing
- **KEEP**: `mini.ai` - Enhanced text objects
- **KEEP**: `mini.surround` - Surround operations
- **KEEP**: `mini.pairs` - Auto-pair brackets
- **KEEP**: `mini.move` - Move lines/selections
- **KEEP**: `flash.nvim` - Jump/navigation
- **KEEP**: `dial.nvim` - Increment/decrement
- **KEEP**: `yanky.nvim` - Yank history
- **KEEP**: `vim-visual-multi` - Multi-cursor
- **REMOVE**: `inc-rename.nvim` - Snacks has rename feature with LSP integration

#### Snippets & Completion
- **KEEP**: `blink.cmp` - Modern completion framework
- **KEEP**: `friendly-snippets` - Snippet collection
- **REMOVE**: LazyDev.nvim → blink.cmp has built-in support

### 🔧 LSP & Languages

#### Core LSP
- **KEEP**: `nvim-lspconfig` - LSP configuration
- **KEEP**: `mason.nvim`, `mason-lspconfig.nvim` - LSP installer
- **KEEP**: `nvim-treesitter`, `nvim-treesitter-textobjects` - Syntax/parsing
- **KEEP**: `ts-comments.nvim` - Context-aware commenting
- **KEEP**: `nvim-ts-autotag` - Auto-close HTML/JSX tags

#### Formatting & Linting
- **KEEP**: `conform.nvim` - Formatting
- **KEEP**: `nvim-lint` - Linting

#### Language-Specific (YOUR LANGUAGES)

**Go:**
- **KEEP**: `go.nvim` - Go development
- **REMOVE**: `gopher.nvim` - Redundant with go.nvim
- **KEEP**: `neotest-golang` - Go testing

**Rust:**
- **KEEP**: `rustaceanvim` - Rust development
- **KEEP**: `crates.nvim` - Cargo.toml helper

**Python:**
- **KEEP**: `venv-selector.nvim` - Virtual environment selector
- **KEEP**: `neotest-python` - Python testing
- **KEEP**: `nvim-dap-python` - Python debugging

**C/C++:**
- **KEEP**: `clangd_extensions.nvim` - Clangd enhancements (includes header/source switching via :ClangdSwitchSourceHeader)
- **KEEP**: `cmake-tools.nvim` - CMake integration

**TypeScript/JavaScript:**
- **KEEP**: Core LSP support via nvim-lspconfig
- **KEEP**: `SchemaStore.nvim` - JSON schemas
- **ADD**: `nvim-dap-node` or configure nvim-dap with node/chrome adapters for debugging

**Other Languages (REMOVE unless needed):**
- **REMOVE**: `nvim-jdtls` - Java
- **REMOVE**: `neotest-elixir` - Elixir
- **REMOVE**: `ouroboros` - C/C++ header switching (redundant - clangd_extensions has :ClangdSwitchSourceHeader)

### 🐛 Debugging (DAP)
- **KEEP**: `nvim-dap` - Core debugging
- **KEEP**: `nvim-dap-ui` - Debug UI
- **KEEP**: `nvim-dap-virtual-text` - Inline debug info
- **KEEP**: `nvim-dap-go` - Go debugging
- **KEEP**: `nvim-dap-python` - Python debugging
- **ADD**: Node.js debugging via `vscode-js-debug` adapter (installed via mason-nvim-dap)
- **KEEP**: `mason-nvim-dap.nvim` - DAP adapter installer (will install node adapter)

### 🔀 Git Integration
- **KEEP**: `vim-fugitive` - Comprehensive git
- **KEEP**: `mini.diff` - Git diff indicators

### 🔍 Search & Replace
- **KEEP**: `grug-far.nvim` - Powerful find and replace across files

### 🧪 Testing
- **KEEP**: `neotest` - Test framework
- **KEEP**: `neotest-golang` - Go test support
- **ADD**: `neotest-vitest` - Vitest support for modern JS/TS testing
- **REMOVE**: `jester` - Jest testing (replaced by neotest-vitest which handles both)

### 🔌 Utilities
- **KEEP**: `persistence.nvim` - Session management
- **KEEP**: `project.nvim` - Project management
- **REMOVE**: `toggleterm.nvim` - Snacks has terminal feature for floating/split terminals
- **KEEP**: `vim-tmux-navigator` - Tmux integration
- **REMOVE**: `aerial.nvim` - Code outline (or use symbols-outline)
- **REMOVE**: `symbols-outline.nvim` - Symbols sidebar (choose one)
- **REMOVE**: `overseer.nvim` - Task runner
- **REMOVE**: `remote-nvim.nvim` - Remote development
- **REMOVE**: `vim-dadbod*` - Database tools

### 🎄 The Snacks.nvim Consolidation
**folke/snacks.nvim** replaces these plugins:
- `telescope.nvim` + `fzf-lua` → **snacks picker** (file search, grep, LSP symbols, git)
- `neo-tree.nvim` → **snacks explorer** (file explorer with grep and terminal)
- `dashboard-nvim` → **snacks dashboard**
- `inc-rename.nvim` → **snacks rename** (LSP-integrated renaming)
- `dressing.nvim` → **snacks input** (better vim.ui.input)
- `toggleterm.nvim` → **snacks terminal** (floating/split terminals)
- `indent-blankline.nvim` → **snacks indent** (indent guides)
- Part of `noice.nvim` → **snacks notifier** (pretty vim.notify)

Additional snacks features:
- **words**: Auto-show LSP references and navigate between them
- **scroll**: Smooth scrolling
- **zen**: Distraction-free coding mode
- **git**: Browse files/commits in browser, lazygit integration
- **scope**: Text objects and jumping based on treesitter/indent
- **dim**: Dim inactive code (focus mode)
- Other small utilities

### 📦 Special/Custom
- **KEEP**: `dotenv.nvim` - Environment variables
- **KEEP**: `nvim-config-local` - Project-local config
- **REMOVE**: `claude-code.nvim` - AI assistant
- **REMOVE**: `kdl.vim`, `baleia.nvim`, etc. - Niche plugins

## Recommended Final Plugin Count: ~45-50 plugins

### Priority Removals (Save ~30-40 plugins):
1. Remove LazyVim framework dependency
2. Consolidate file pickers (use snacks.nvim)
3. Remove unused language plugins
4. Remove duplicate functionality
5. Remove unused colorschemes

### Migration Strategy:
1. **Phase 1**: Extract LazyVim configs to standalone files
2. **Phase 2**: Remove redundant plugins, migrate to snacks.nvim
3. **Phase 3**: Optimize language-specific setups
4. **Phase 4**: Clean up and reorganize configuration

## New Directory Structure
```
nvim/
├── init.lua                 # Entry point
├── lua/
│   ├── config/
│   │   ├── autocmds.lua    # Auto commands
│   │   ├── keymaps.lua     # Keybindings
│   │   ├── lazy.lua        # Plugin manager setup
│   │   └── options.lua     # Vim options
│   └── plugins/
│       ├── coding.lua      # Editing plugins
│       ├── colorscheme.lua # Theme configuration
│       ├── completion.lua  # Blink.cmp setup
│       ├── dap.lua        # Debugging setup
│       ├── git.lua        # Git integration
│       ├── lang/          # Language-specific
│       │   ├── go.lua
│       │   ├── rust.lua
│       │   ├── python.lua
│       │   ├── c.lua
│       │   └── typescript.lua
│       ├── lsp.lua        # LSP configuration
│       ├── snacks.lua     # Snacks.nvim config
│       ├── testing.lua    # Test runners
│       ├── treesitter.lua # Treesitter setup
│       └── ui.lua         # UI plugins
└── lazy-lock.json         # Lock file
```

## Next Steps:
1. Review this plan and adjust based on your preferences
2. Begin extracting LazyVim defaults into explicit configs
3. Test each language setup independently
4. Gradually migrate from telescope/fzf-lua to snacks.nvim
5. Remove LazyVim dependency once all configs are extracted
