return {
  {
    "ibhagwan/fzf-lua", 
    lazy = false,
    priority = 1000,
    init = function()
      -- Disable netrw before anything else loads
      vim.g.loaded_netrw = 1
      vim.g.loaded_netrwPlugin = 1
      
      -- Handle directory opening
      vim.api.nvim_create_autocmd("VimEnter", {
        callback = function()
          local arg = vim.fn.argv(0)
          if vim.fn.isdirectory(arg) == 1 then
            -- Change to the directory
            vim.cmd.cd(arg)
            -- Clear buffer
            vim.cmd("enew")
            vim.cmd("bdelete 1")
            -- Open fzf-lua
            vim.schedule(function()
              require("fzf-lua").files()
            end)
          end
        end,
        desc = "Open fzf-lua when starting with a directory",
      })
    end,
  },
}