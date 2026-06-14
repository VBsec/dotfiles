-- Helper function to find closest package.json or use buffer's directory
local function get_local_cwd()
  local current_file = vim.fn.expand("%:p")

  -- If no file is open, use current working directory
  if current_file == "" then
    return vim.fn.getcwd()
  end

  local current_dir = vim.fn.fnamemodify(current_file, ":h")
  local dir = current_dir

  -- Walk up looking for package.json
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

  -- No package.json found, return current buffer's directory
  return current_dir
end

-- Override default picker keymaps to provide both root and local cwd search
return {
  {
    "folke/snacks.nvim",
    keys = {
      {
        "<leader><space>",
        function()
          Snacks.picker.smart()
        end,
        desc = "Smart Find Files",
      },
      {
        "<leader>fF",
        function()
          Snacks.picker.files()
        end,
        desc = "Find Files (root)",
      },
      -- Local searches (closest package.json or buffer dir)
      {
        "<leader>ff",
        function()
          Snacks.picker.files({ cwd = get_local_cwd() })
        end,
        desc = "Find Files (local)",
      },
      {
        "<leader>fG",
        function()
          Snacks.picker.grep({ cwd = get_local_cwd() })
        end,
        desc = "Grep (local)",
      },
      {
        "<leader>fR",
        function()
          Snacks.picker.recent({ cwd = get_local_cwd() })
        end,
        desc = "Recent Files (local)",
      },
    },
  },
}

