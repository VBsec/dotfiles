-- Plugin management via native vim.pack (Neovim 0.12). No lazy.nvim/LazyVim.
--
-- Loading model:
--   * vim.pack.add installs + sources plugins synchronously.
--   * VSCode: only the editing plugins below the `vscode` guard load.
--   * Terminal: everything loads. We keep startup light by configuring inside
--     ftplugin-style guards / events where it matters, but the plugin set is
--     small enough that eager setup is fine.

local gh = function(x)
  return "https://github.com/" .. x
end

-- Build hooks: run a plugin's install/update step after its code changes.
vim.api.nvim_create_autocmd("PackChanged", {
  callback = function(ev)
    local name = ev.data.spec.name
    local kind = ev.data.kind
    if (kind == "install" or kind == "update") and name == "markdown-preview.nvim" then
      vim.notify("Building markdown-preview.nvim…", vim.log.levels.INFO)
      vim.fn.system({ "npx", "--yes", "yarn", "install" }, ev.data.path .. "/app")
    end
  end,
})

-------------------------------------------------------------------------------
-- VSCode-Neovim: minimal plugin set (editing only). VSCode owns UI/LSP/cmp.
-------------------------------------------------------------------------------
if vim.g.vscode then
  vim.pack.add({
    { src = gh("nvim-mini/mini.surround") },
    { src = gh("mg979/vim-visual-multi") },
    { src = gh("vscode-neovim/vscode-multi-cursor.nvim") },
  })

  require("mini.surround").setup()
  require("vscode-multi-cursor").setup({})
  return
end

-------------------------------------------------------------------------------
-- Native Neovim: full set.
-------------------------------------------------------------------------------
vim.pack.add({
  -- Core libs / UI
  { src = gh("nvim-tree/nvim-web-devicons") },
  { src = gh("folke/snacks.nvim") },
  { src = gh("folke/tokyonight.nvim") },
  { src = gh("nvim-lualine/lualine.nvim") },
  { src = gh("akinsho/bufferline.nvim") },
  { src = gh("folke/which-key.nvim") },
  { src = gh("MunifTanjim/nui.nvim") }, -- noice dependency
  { src = gh("folke/noice.nvim") },

  -- Editing
  { src = gh("saghen/blink.cmp"), version = vim.version.range("1") },
  { src = gh("stevearc/conform.nvim") },
  { src = gh("nvim-mini/mini.pairs") },
  { src = gh("nvim-mini/mini.surround") },
  { src = gh("windwp/nvim-ts-autotag") },
  { src = gh("stevearc/oil.nvim") },
  { src = gh("mg979/vim-visual-multi") },

  -- Treesitter (stable master branch: keeps the configs.setup + auto-install API)
  { src = gh("nvim-treesitter/nvim-treesitter"), version = "master" },

  -- Markdown
  { src = gh("MeanderingProgrammer/render-markdown.nvim") },
  { src = gh("iamcco/markdown-preview.nvim") },

  -- Testing (vitest via neotest)
  { src = gh("nvim-lua/plenary.nvim") },
  { src = gh("nvim-neotest/nvim-nio") },
  { src = gh("nvim-neotest/neotest") },
  { src = gh("marilari88/neotest-vitest") },
})

-- Colorscheme ----------------------------------------------------------------
require("tokyonight").setup({
  transparent = true,
  style = "night",
  styles = {
    sidebars = "transparent",
    floats = "transparent",
  },
  on_highlights = function(hl, c)
    hl.NormalFloat = { bg = "NONE", fg = c.fg }
    hl.FloatBorder = { fg = c.blue, bg = "NONE" }
    hl.FloatTitle = { fg = c.cyan, bg = "NONE", bold = true }
    hl.FloatFooter = { fg = c.comment, bg = "NONE" }
    hl.LspInfoBorder = { fg = c.blue, bg = "NONE" }
    hl.NoiceCmdlinePopupBorder = { fg = c.blue, bg = "NONE" }
    hl.NoicePopupBorder = { fg = c.blue, bg = "NONE" }
  end,
})
vim.cmd.colorscheme("tokyonight")

-- Treesitter -----------------------------------------------------------------
require("nvim-treesitter.configs").setup({
  ensure_installed = {
    "c",
    "cmake",
    "devicetree",
    "kconfig",
    "python",
    "typescript",
    "tsx",
    "javascript",
    "json",
    "jsonc",
    "html",
    "css",
    "markdown",
    "markdown_inline",
    "yaml",
    "toml",
    "dockerfile",
    "lua",
    "luadoc",
    "bash",
    "vim",
    "vimdoc",
    "query",
  },
  auto_install = true,
  highlight = { enable = true },
  indent = { enable = true },
})

-- nvim-ts-autotag (html/jsx tag close/rename).
require("nvim-ts-autotag").setup({})

-- Snacks (picker, explorer, image) -------------------------------------------
require("snacks").setup({
  image = {},
  scroll = { enabled = false },
  bigfile = { enabled = true },
  explorer = { replace_netrw = false },
  indent = { enabled = true },
  input = { enabled = true },
  notifier = { enabled = true },
  picker = { enabled = true, layout = "vertical" },
  lazygit = { enabled = true },
  terminal = {},
  gitbrowse = {},
  words = { enabled = true },
})

-- Helper: nearest package.json dir, else buffer dir (local-scope searches).
local function get_local_cwd()
  local current_file = vim.fn.expand("%:p")
  if current_file == "" then
    return vim.fn.getcwd()
  end
  local dir = vim.fn.fnamemodify(current_file, ":h")
  while dir ~= "/" do
    if vim.fn.filereadable(dir .. "/package.json") == 1 then
      return dir
    end
    local parent = vim.fn.fnamemodify(dir, ":h")
    if parent == dir then
      break
    end
    dir = parent
  end
  return vim.fn.fnamemodify(current_file, ":h")
end

local kmap = vim.keymap.set
kmap("n", "<leader><space>", function()
  Snacks.picker.smart()
end, { desc = "Smart find files" })
kmap("n", "<leader>fF", function()
  Snacks.picker.files()
end, { desc = "Find files (root)" })
kmap("n", "<leader>ff", function()
  Snacks.picker.files({ cwd = get_local_cwd() })
end, { desc = "Find files (local)" })
kmap("n", "<leader>fG", function()
  Snacks.picker.grep({ cwd = get_local_cwd() })
end, { desc = "Grep (local)" })
kmap("n", "<leader>fR", function()
  Snacks.picker.recent({ cwd = get_local_cwd() })
end, { desc = "Recent files (local)" })
kmap("n", "<leader>fe", function()
  Snacks.picker.files({
    title = "Env Files",
    hidden = true,
    ignored = true,
    exclude = { "node_modules", ".git", "*cache*", "dist", "build" },
    pattern = "^.env",
  })
end, { desc = "Find env files" })
kmap("n", "<leader>se", function()
  Snacks.picker.grep({
    title = "Grep Code Files",
    glob = { "*.ts", "*.tsx", "*.js", "*.go", "*.rs", "*.py", "*.c", "*.h" },
  })
end, { desc = "Grep code files" })

-- More snacks pickers (buffers, grep, recent, help, keymaps, diagnostics).
kmap("n", "<leader>,", function()
  Snacks.picker.buffers()
end, { desc = "Buffers" })
kmap("n", "<leader>/", function()
  Snacks.picker.grep()
end, { desc = "Grep (root)" })
kmap("n", "<leader>sg", function()
  Snacks.picker.grep()
end, { desc = "Grep (root)" })
kmap("n", "<leader>fr", function()
  Snacks.picker.recent()
end, { desc = "Recent files" })
kmap("n", "<leader>fb", function()
  Snacks.picker.buffers()
end, { desc = "Buffers" })
kmap("n", "<leader>sh", function()
  Snacks.picker.help()
end, { desc = "Help pages" })
kmap("n", "<leader>sk", function()
  Snacks.picker.keymaps()
end, { desc = "Keymaps" })
kmap("n", "<leader>sd", function()
  Snacks.picker.diagnostics()
end, { desc = "Diagnostics (all)" })
kmap("n", "<leader>sD", function()
  Snacks.picker.diagnostics_buffer()
end, { desc = "Diagnostics (buffer)" })

-- Project-wide diagnostics: run the project's own typecheck / lint into the
-- quickfix list (LSP only reports open-file diagnostics on big monorepos).
local project_check = require("config.project_check")
kmap("n", "<leader>cC", project_check.check_types, { desc = "Type-check package → quickfix" })
kmap("n", "<leader>cT", project_check.check_types_all, { desc = "Type-check monorepo (turbo) → quickfix" })
kmap("n", "<leader>cL", project_check.lint_biome, { desc = "Project biome lint → quickfix" })
kmap("n", "<leader>xq", function()
  Snacks.picker.qflist()
end, { desc = "Quickfix list" })
kmap("n", "<leader>sw", function()
  Snacks.picker.grep_word()
end, { desc = "Grep word under cursor" })
kmap("n", "<leader>:", function()
  Snacks.picker.command_history()
end, { desc = "Command history" })
kmap("n", "<leader>sc", function()
  Snacks.picker.command_history()
end, { desc = "Command history" })
kmap("n", "<leader>sC", function()
  Snacks.picker.commands()
end, { desc = "Commands" })
kmap("n", "<leader>s/", function()
  Snacks.picker.search_history()
end, { desc = "Search history" })
kmap("n", "<leader>sR", function()
  Snacks.picker.resume()
end, { desc = "Resume last picker" })
kmap("n", "<leader>sj", function()
  Snacks.picker.jumps()
end, { desc = "Jumps" })
kmap("n", "<leader>sm", function()
  Snacks.picker.marks()
end, { desc = "Marks" })
kmap('n', '<leader>s"', function()
  Snacks.picker.registers()
end, { desc = "Registers" })
kmap("n", "<leader>su", function()
  Snacks.picker.undo()
end, { desc = "Undo history" })
kmap("n", "<leader>e", function()
  Snacks.explorer()
end, { desc = "Explorer (root)" })

-- Git (lazygit + pickers via snacks).
kmap("n", "<leader>gg", function()
  Snacks.lazygit()
end, { desc = "Lazygit (root)" })
kmap("n", "<leader>gG", function()
  Snacks.lazygit({ cwd = vim.fn.getcwd() })
end, { desc = "Lazygit (cwd)" })
kmap("n", "<leader>gb", function()
  Snacks.picker.git_branches()
end, { desc = "Git branches" })
kmap("n", "<leader>gl", function()
  Snacks.picker.git_log()
end, { desc = "Git log" })
kmap("n", "<leader>gs", function()
  Snacks.picker.git_status()
end, { desc = "Git status" })
kmap({ "n", "x" }, "<leader>gB", function()
  Snacks.gitbrowse()
end, { desc = "Git browse (open in browser)" })

-- Terminal (root dir).
kmap({ "n", "t" }, "<c-/>", function()
  Snacks.terminal()
end, { desc = "Terminal" })

-- UI toggles (snacks.toggle).
Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>uL")
Snacks.toggle.line_number():map("<leader>ul")
Snacks.toggle.diagnostics():map("<leader>ud")
Snacks.toggle.treesitter():map("<leader>uT")
Snacks.toggle.inlay_hints():map("<leader>uh")
Snacks.toggle.zen():map("<leader>uz")
Snacks.toggle.zoom():map("<leader>uZ")
Snacks.toggle.option("conceallevel", {
  off = 0,
  on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2,
  name = "Conceal Level",
}):map("<leader>uc")

-- Statusline / bufferline ----------------------------------------------------
require("lualine").setup({
  options = {
    theme = "tokyonight",
    globalstatus = true,
    section_separators = "",
    component_separators = "",
  },
})
require("bufferline").setup({})

-- which-key ------------------------------------------------------------------
local wk = require("which-key")
wk.setup({
  preset = "helix",
  spec = {
    {
      mode = { "n", "x" },
      { "<leader>b", group = "buffer" },
      { "<leader>c", group = "code" },
      { "<leader>f", group = "file/find" },
      { "<leader>g", group = "git" },
      { "<leader>s", group = "search" },
      { "<leader>sn", group = "noice" },
      { "<leader>t", group = "test" },
      { "<leader>u", group = "ui" },
      { "<leader>w", group = "windows", proxy = "<c-w>" },
      { "<leader>x", group = "diagnostics/quickfix" },
      { "<leader>y", group = "yank" },
      { "[", group = "prev" },
      { "]", group = "next" },
      { "g", group = "goto" },
      { "gs", group = "surround" },
      { "z", group = "fold" },
    },
  },
})
wk.add({
  { "<leader>?", function() wk.show({ global = false }) end, desc = "Buffer keymaps (which-key)" },
})

-- noice ----------------------------------------------------------------------
require("noice").setup({
  presets = {
    lsp_doc_border = true,
  },
  views = {
    hover = {
      win_options = {
        winhighlight = {
          Normal = "NormalFloat",
          FloatBorder = "FloatBorder",
        },
      },
    },
  },
})

-- Noice message/notification keymaps (<leader>sn*).
kmap("n", "<leader>snl", function()
  require("noice").cmd("last")
end, { desc = "Noice last message" })
kmap("n", "<leader>snh", function()
  require("noice").cmd("history")
end, { desc = "Noice history" })
kmap("n", "<leader>sna", function()
  require("noice").cmd("all")
end, { desc = "Noice all" })
kmap("n", "<leader>snd", function()
  require("noice").cmd("dismiss")
end, { desc = "Dismiss all notifications" })
kmap("n", "<leader>snt", function()
  require("noice").cmd("pick")
end, { desc = "Noice picker" })
-- Notification history via snacks.
kmap("n", "<leader>sN", function()
  Snacks.notifier.show_history()
end, { desc = "Notification history" })

-- blink.cmp ------------------------------------------------------------------
require("blink.cmp").setup({
  keymap = {
    preset = "none",
    ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
    ["<C-e>"] = { "hide" },
    ["<Tab>"] = { "select_and_accept", "snippet_forward", "fallback" },
    ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
    ["<Up>"] = { "select_prev", "fallback" },
    ["<Down>"] = { "select_next", "fallback" },
    ["<C-p>"] = { "select_prev", "fallback" },
    ["<C-n>"] = { "select_next", "fallback" },
    ["<C-b>"] = { "scroll_documentation_up", "fallback" },
    ["<C-f>"] = { "scroll_documentation_down", "fallback" },
    ["<CR>"] = { "fallback" },
  },
  appearance = { nerd_font_variant = "mono" },
  completion = {
    documentation = { auto_show = true },
  },
  sources = {
    default = { "lsp", "path", "snippets", "buffer" },
  },
  fuzzy = { implementation = "prefer_rust_with_warning" },
})

-- conform.nvim (format-on-save) ----------------------------------------------
require("conform").setup({
  formatters_by_ft = {
    typescript = { "biome" },
    typescriptreact = { "biome" },
    javascript = { "biome" },
    javascriptreact = { "biome" },
    json = { "biome" },
    jsonc = { "biome" },
    markdown = { "dprint" },
    yaml = { "dprint" },
    toml = { "dprint" },
    dockerfile = { "dprint" },
    html = { "dprint" },
    css = { "dprint" },
    c = { "clang_format" },
    cpp = { "clang_format" },
    python = { "ruff_format" },
    lua = { "stylua" },
  },
  format_on_save = {
    timeout_ms = 1500,
    lsp_format = "fallback",
  },
})

-- mini.pairs / mini.surround -------------------------------------------------
require("mini.pairs").setup({
  modes = { insert = true, command = false, terminal = false },
})
kmap("n", "<leader>up", function()
  vim.g.minipairs_disable = not vim.g.minipairs_disable
  vim.notify((vim.g.minipairs_disable and "Disabled" or "Enabled") .. " auto pairs")
end, { desc = "Toggle auto pairs" })

-- mini.surround with LazyVim-style gs* mappings (gsa add, gsd delete, gsr
-- replace, gsf/gsF find, gsh highlight, gsn update n_lines).
require("mini.surround").setup({
  mappings = {
    add = "gsa",
    delete = "gsd",
    find = "gsf",
    find_left = "gsF",
    highlight = "gsh",
    replace = "gsr",
    update_n_lines = "gsn",
  },
})

-- oil.nvim -------------------------------------------------------------------
require("oil").setup({
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
})

-- render-markdown ------------------------------------------------------------
require("render-markdown").setup({
  completions = { lsp = { enabled = true } },
})

-- markdown-preview (browser preview server) ----------------------------------
-- Plugin provides :MarkdownPreview / :MarkdownPreviewStop. Build runs via the
-- PackChanged hook above. No global config needed; set behaviour vars here.
vim.g.mkdp_auto_close = 1
vim.g.mkdp_theme = "dark"

-- neotest + vitest -----------------------------------------------------------
require("neotest").setup({
  adapters = {
    require("neotest-vitest"),
  },
})
local neotest = require("neotest")
kmap("n", "<leader>tt", function()
  neotest.run.run()
end, { desc = "Run nearest test" })
kmap("n", "<leader>tf", function()
  neotest.run.run(vim.fn.expand("%"))
end, { desc = "Run file tests" })
kmap("n", "<leader>ts", function()
  neotest.summary.toggle()
end, { desc = "Toggle test summary" })
kmap("n", "<leader>to", function()
  neotest.output.open({ enter = true })
end, { desc = "Show test output" })
kmap("n", "<leader>tw", function()
  neotest.watch.toggle(vim.fn.expand("%"))
end, { desc = "Toggle test watch" })

-- LSP keymaps + UX on attach -------------------------------------------------
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(ev)
    local buf = ev.buf
    local function m(lhs, rhs, desc)
      vim.keymap.set("n", lhs, rhs, { buffer = buf, desc = desc, silent = true })
    end
    m("K", vim.lsp.buf.hover, "Hover")
    m("gd", vim.lsp.buf.definition, "Go to definition")
    m("gD", vim.lsp.buf.declaration, "Go to declaration")
    m("gi", vim.lsp.buf.implementation, "Go to implementation")
    m("gr", vim.lsp.buf.references, "References")
    m("<leader>cr", vim.lsp.buf.rename, "Rename symbol")
    m("<leader>ca", vim.lsp.buf.code_action, "Code action")
    m("<leader>cd", vim.diagnostic.open_float, "Line diagnostics")
    m("[d", function()
      vim.diagnostic.jump({ count = -1 })
    end, "Prev diagnostic")
    m("]d", function()
      vim.diagnostic.jump({ count = 1 })
    end, "Next diagnostic")

    -- Native LSP completion as a fallback layer (blink is primary).
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if client and client:supports_method("textDocument/completion") then
      vim.lsp.completion.enable(true, client.id, buf, { autotrigger = false })
    end
  end,
})
