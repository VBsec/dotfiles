-- Options configuration
-- No LazyVim dependency - all options explicitly set

local opt = vim.opt

-- General
opt.autowrite = true -- Enable auto write
opt.clipboard = vim.env.SSH_TTY and "" or "unnamedplus" -- Sync with system clipboard
opt.completeopt = "menu,menuone,noselect"
opt.conceallevel = 2 -- Hide * markup for bold and italic, but not markers with substitutions
opt.confirm = true -- Confirm to save changes before exiting modified buffer
opt.cursorline = true -- Enable highlighting of the current line
opt.expandtab = true -- Use spaces instead of tabs
opt.formatoptions = "jcroqlnt" -- tcqj
opt.grepformat = "%f:%l:%c:%m"
opt.grepprg = "rg --vimgrep"
opt.ignorecase = true -- Ignore case
opt.inccommand = "nosplit" -- preview incremental substitute
opt.jumpoptions = "view"
opt.laststatus = 3 -- global statusline
opt.linebreak = true -- Wrap lines at convenient points
opt.list = true -- Show some invisible characters (tabs...
opt.mouse = "a" -- Enable mouse mode
opt.number = true -- Print line number
opt.pumblend = 10 -- Popup blend
opt.pumheight = 10 -- Maximum number of entries in a popup
opt.relativenumber = true -- Relative line numbers
opt.scrolloff = 4 -- Lines of context
opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp", "folds" }
opt.shiftround = true -- Round indent
opt.shiftwidth = 2 -- Size of an indent
opt.shortmess:append({ W = true, I = true, c = true, C = true })
opt.showmode = false -- Dont show mode since we have a statusline
opt.sidescrolloff = 8 -- Columns of context
opt.signcolumn = "yes" -- Always show the signcolumn, otherwise it would shift the text each time
opt.smartcase = true -- Don't ignore case with capitals
opt.smartindent = true -- Insert indents automatically
opt.spelllang = { "en" }
opt.splitbelow = true -- Put new windows below current
opt.splitkeep = "screen"
opt.splitright = true -- Put new windows right of current
opt.statuscolumn = [[%!v:lua.require'config.ui'.statuscolumn()]]
opt.tabstop = 2 -- Number of spaces tabs count for
opt.termguicolors = true -- True color support
opt.timeoutlen = 300
opt.undofile = false -- Disable persistent undo (personal preference from your config)
opt.undolevels = 10000
opt.updatetime = 200 -- Save swap file and trigger CursorHold
opt.virtualedit = "block" -- Allow cursor to move where there is no text in visual block mode
opt.wildmode = "longest:full,full" -- Command-line completion mode
opt.winminwidth = 5 -- Minimum window width
opt.wrap = false -- Disable line wrap

-- Fix markdown indentation settings
vim.g.markdown_recommended_style = 0

-- Shell configuration (from your config)
if vim.fn.executable("pwsh") == 1 then
  vim.cmd([[
    set shell=pwsh
    set shellcmdflag=-command
    set shellquote=\"
    set shellxquote=
  ]])
else
  vim.cmd([[
    set shell=zsh
  ]])
end

-- Filetype additions (from your config)
vim.filetype.add({
  extension = {
    h = "c",
  },
})

-- Diagnostic configuration (from your config)
vim.diagnostic.config({ virtual_text = true })

-- Folding
opt.foldlevel = 99
opt.foldlevelstart = 99
opt.foldenable = true

-- Fill chars
opt.fillchars = {
  foldopen = "v",
  foldclose = ">",
  fold = " ",
  foldsep = " ",
  diff = "╱",
  eob = " ",
}

-- Smooth scrolling
if vim.fn.has("nvim-0.10") == 1 then
  opt.smoothscroll = true
end

-- Global statusline
opt.laststatus = 3

-- LSP Server to use for Python
vim.g.lazyvim_python_lsp = vim.g.lazyvim_python_lsp or "basedpyright"
vim.g.lazyvim_python_ruff = vim.g.lazyvim_python_ruff or "ruff"