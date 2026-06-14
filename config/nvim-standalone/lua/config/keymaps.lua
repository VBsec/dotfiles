-- Keymaps. Split into:
--   textEditingMappings() -- active everywhere (terminal + VSCode)
--   neovimMappings()      -- native Neovim only
--   vscodeMappings()      -- VSCode-Neovim extension only
--
-- LSP keymaps live in config.plugins (LspAttach) so they only bind when a
-- server attaches. VSCode provides its own LSP, so those are skipped there.

-- Plain wrapper around vim.keymap.set (no plugin dependency).
local function map(mode, lhs, rhs, opts)
  opts = opts or {}
  if opts.silent == nil then
    opts.silent = true
  end
  vim.keymap.set(mode, lhs, rhs, opts)
end

local function ToggleWordWrap()
  vim.wo.wrap = not vim.wo.wrap
  print(vim.wo.wrap and "Word wrap enabled" or "Word wrap disabled")
end

local function copyToClipBoard()
  vim.cmd("set clipboard+=unnamedplus")
  vim.cmd("norm! y")
  vim.cmd("set clipboard-=unnamedplus")
  print("copied!")
end

local function callVSCodeFunction(vsCodeCommand)
  vim.cmd(vsCodeCommand)
end

-- Select-all + clipboard copy (both environments).
map("i", "<C-a>", function()
  vim.cmd("norm! ggVG")
  print("Selected all lines")
end, { remap = false, desc = "Select all lines in buffer" })
map({ "v", "i" }, "<D-c>", function()
  copyToClipBoard()
end, { remap = false, desc = "Copy selected text" })

-- Native-Neovim-only mappings.
local function neovimMappings()
  -- VSCode-Ctrl+D-style: replace word under cursor everywhere via :cgn.
  map("i", "<C-d>", function()
    local new_text = vim.fn.input("Replace with?: ")
    vim.cmd("normal! *Ncgn" .. new_text)
  end, { desc = "Replace word under cursor (Ctrl+D alt)" })

  map("i", "<C-f>", "<Esc>/", { remap = true })
  map("i", "jj", "<Esc>", { remap = true })

  map("n", "<leader>jj", "<cmd>qa<CR>", { desc = "Quit Neovim" })
  map("n", "<leader>ct", ToggleWordWrap, { desc = "Toggle word wrap" })
  map("n", "<leader>bc", "<cmd>BufferLinePick<CR>", { desc = "Pick buffer" })

  -- Symbols outline via snacks picker.
  map("n", "<leader>cs", function()
    Snacks.picker.lsp_symbols()
  end, { desc = "Document symbols" })

  -- Switch C/C++ header <-> source via clangd (native, no plugin).
  map("n", "<leader>ch", function()
    local params = { uri = vim.uri_from_bufnr(0) }
    local clients = vim.lsp.get_clients({ bufnr = 0, name = "clangd" })
    if #clients == 0 then
      vim.notify("clangd not attached", vim.log.levels.WARN)
      return
    end
    clients[1]:request("textDocument/switchSourceHeader", params, function(err, result)
      if err or not result then
        vim.notify("No corresponding header/source", vim.log.levels.WARN)
        return
      end
      vim.cmd.edit(vim.uri_to_fname(result))
    end, 0)
  end, { desc = "Switch header/source (clangd)" })

  -- Yank file paths.
  map("n", "<leader>yP", function()
    local path = vim.fn.expand("%:p")
    vim.fn.setreg("+", path)
    print("Copied: " .. path)
  end, { desc = "Yank absolute path" })
  map("n", "<leader>yp", function()
    local path = vim.fn.expand("%:.")
    vim.fn.setreg("+", path)
    print("Copied: " .. path)
  end, { desc = "Yank relative path" })
  map("n", "<leader>yf", function()
    local path = vim.fn.expand("%:t")
    vim.fn.setreg("+", path)
    print("Copied: " .. path)
  end, { desc = "Yank filename" })

  -- Oil file manager.
  map("n", "-", "<CMD>Oil --float .<CR>", { desc = "Oil to cwd" })
  map("n", "<leader>-", function()
    local open_buf = vim.api.nvim_buf_get_name(0)
    local dir_path = vim.fn.fnamemodify(open_buf, ":h")
    vim.cmd("Oil --float " .. dir_path)
  end, { desc = "Oil to current dir" })
end

-- VSCode-Neovim-extension-only mappings.
local function vscodeMappings()
  map("i", "tab", function()
    callVSCodeFunction("editor.action.inlineSuggest.commit")
  end, { remap = false, desc = "Accept next suggestion" })

  map({ "n", "x", "i" }, "<D-d>", function()
    require("vscode-multi-cursor").addSelectionToNextFindMatch()
  end)

  map("n", "<leader>cs", function()
    callVSCodeFunction("call VSCodeCall('workbench.action.gotoSymbol')")
  end, { desc = "Go to symbols in editor" })

  map("n", "<S-l>", function()
    callVSCodeFunction("call VSCodeNotify('workbench.action.nextEditor')")
  end, { desc = "Next editor" })
  map("n", "<S-h>", function()
    callVSCodeFunction("call VSCodeNotify('workbench.action.previousEditor')")
  end, { desc = "Previous editor" })

  map("n", "gr", function()
    callVSCodeFunction("call VSCodeNotify('editor.action.referenceSearch.trigger')")
  end, { desc = "Peek references" })
  map("n", "<leader>cp", function()
    callVSCodeFunction("call VSCodeNotify('editor.action.triggerParameterHints')")
  end, { desc = "Trigger parameter hints" })
  map("n", "<leader>sd", function()
    callVSCodeFunction("call VSCodeNotify('workbench.action.problems.focus')")
  end, { desc = "Focus problems" })

  map("n", "<leader>e", function()
    callVSCodeFunction("call VSCodeNotify('workbench.files.action.focusFilesExplorer')")
  end, { desc = "Focus file explorer" })
  map("n", "<leader>fe", function()
    callVSCodeFunction("call VSCodeNotify('workbench.files.action.focusFilesExplorer')")
  end, { desc = "Focus file explorer" })
  map("n", "<leader>ff", function()
    callVSCodeFunction("call VSCodeNotify('workbench.action.quickOpen')")
  end, { desc = "Quick open files" })
  map("n", "<leader>fs", function()
    callVSCodeFunction("call VSCodeNotify('periscope.search')")
  end, { desc = "Search files" })

  map("n", "<leader>gg", function()
    callVSCodeFunction("call VSCodeNotify('workbench.view.scm')")
  end, { desc = "Open source control" })

  -- Bookmarks (VS Code Bookmarks extension).
  map("n", "<leader>sml", function()
    callVSCodeFunction("call VSCodeNotify('bookmarks.list')")
  end, { desc = "Bookmarks list (file)" })
  map("n", "<leader>smL", function()
    callVSCodeFunction("call VSCodeNotify('bookmarks.listFromAllFiles')")
  end, { desc = "Bookmarks list (all)" })
  map("n", "<leader>smm", function()
    callVSCodeFunction("call VSCodeNotify('bookmarks.toggle')")
  end, { desc = "Toggle bookmark" })
  map("n", "<leader>smn", function()
    callVSCodeFunction("call VSCodeNotify('bookmarks.jumpToNext')")
  end, { desc = "Next bookmark" })
  map("n", "<leader>smp", function()
    callVSCodeFunction("call VSCodeNotify('bookmarks.jumpToPrevious')")
  end, { desc = "Previous bookmark" })
  map("n", "<leader>smd", function()
    callVSCodeFunction("call VSCodeNotify('bookmarks.clear')")
  end, { desc = "Clear bookmarks (file)" })
  map("n", "<leader>smr", function()
    callVSCodeFunction("call VSCodeNotify('bookmarks.clearFromAllFiles')")
  end, { desc = "Clear bookmarks (all)" })

  map("n", "<leader>cr", function()
    callVSCodeFunction("call VSCodeNotify('editor.action.rename')")
  end, { desc = "Rename symbol" })
  map("n", "<leader>ca", function()
    callVSCodeFunction("call VSCodeNotify('editor.action.quickFix')")
  end, { desc = "Quick fix" })
  map("n", "<leader>cA", function()
    callVSCodeFunction("call VSCodeNotify('editor.action.sourceAction')")
  end, { desc = "Source action" })
  map("n", "<leader>ce", function()
    callVSCodeFunction("call VSCodeNotify('workbench.panel.markers.view.focus')")
  end, { desc = "Open problems" })
  map("n", "<leader>cd", function()
    callVSCodeFunction("call VSCodeNotify('editor.action.marker.next')")
  end, { desc = "Next diagnostic" })

  map({ "v" }, "<D-c>", function()
    callVSCodeFunction("call VSCodeNotify('editor.action.clipboardCopyAction')")
    print("📎")
  end, { desc = "Copy to clipboard" })
end

-- Quick end-of-line edits + line moves (both environments).
local function textEditingMappings()
  map("n", "g;", "A;<Esc>", { desc = "Add semicolon at EOL" })
  map("n", "g,", "A,<Esc>", { desc = "Add comma at EOL" })
  map("n", "g.", "A.<Esc>", { desc = "Add period at EOL" })
  map("n", "g:", "A:<Esc>", { desc = "Add colon at EOL" })
  map("n", "g)", "A)<Esc>", { desc = "Add ) at EOL" })
  map("n", "g]", "A]<Esc>", { desc = "Add ] at EOL" })
  map("n", "g}", "A}<Esc>", { desc = "Add } at EOL" })

  -- Move lines with Ctrl+Cmd+j/k (frees Option for Scandinavian compose).
  map("n", "<C-D-j>", "<cmd>m .+1<cr>==", { desc = "Move line down" })
  map("n", "<C-D-k>", "<cmd>m .-2<cr>==", { desc = "Move line up" })
  map("v", "<C-D-j>", ":m '>+1<cr>gv=gv", { desc = "Move selection down" })
  map("v", "<C-D-k>", ":m '<-2<cr>gv=gv", { desc = "Move selection up" })
end

textEditingMappings()

if vim.g.vscode then
  print("nvim ⚡")
  vscodeMappings()
else
  neovimMappings()
end
