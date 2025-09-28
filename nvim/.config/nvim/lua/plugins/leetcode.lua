return {
  {
    "kawre/leetcode.nvim",
    build = ":TSUpdate html",
    lazy = vim.fn.argv(0, -1) ~= "leetcode.nvim",
    dependencies = {
      "folke/snacks.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
    cmd = "Leet",
    opts = {
      arg = "leetcode.nvim",
      lang = "golang",
      cn = {
        enabled = false,
      },
      storage = {
        home = vim.fn.stdpath("data") .. "/leetcode",
        cache = vim.fn.stdpath("cache") .. "/leetcode",
      },
      plugins = {
        non_standalone = false,
      },
      logging = true,
    },
    keys = {
      { "<leader>Lt", "<cmd>Leet<cr>", desc = "Leetcode Toggle" },
      { "<leader>Lm", "<cmd>Leet menu<cr>", desc = "Leetcode Menu" },
      { "<leader>Lc", "<cmd>Leet console<cr>", desc = "Leetcode Console" },
      { "<leader>Li", "<cmd>Leet info<cr>", desc = "Leetcode Info" },
      { "<leader>Ll", "<cmd>Leet language<cr>", desc = "Leetcode Language" },
      { "<leader>Ld", "<cmd>Leet description<cr>", desc = "Leetcode Description" },
      { "<leader>Lr", "<cmd>Leet run<cr>", desc = "Leetcode Run" },
      { "<leader>Ls", "<cmd>Leet submit<cr>", desc = "Leetcode Submit" },
      { "<leader>Lo", "<cmd>Leet open<cr>", desc = "Leetcode Open in Browser" },
      { "<leader>Ly", "<cmd>Leet yank<cr>", desc = "Leetcode Yank Solution" },
      { "<leader>LR", "<cmd>Leet reset<cr>", desc = "Leetcode Reset" },
      { "<leader>LS", "<cmd>Leet last<cr>", desc = "Leetcode Last Submit" },
      { "<leader>Lu", "<cmd>Leet restore<cr>", desc = "Leetcode Restore default code" },
      {
        "<leader>Lh",
        function()
          local leetcode_dir = vim.fn.stdpath("data") .. "/leetcode"
          local cmd = string.format(
            "find %s -maxdepth 1 -type f \\( -name '*.go' -o -name '*.py' -o -name '*.cpp' -o -name '*.java' -o -name '*.js' -o -name '*.ts' \\) -exec stat -f '%%m %%N' {} + 2>/dev/null | sort -rn | head -10 | cut -d' ' -f2-",
            leetcode_dir
          )
          local output = vim.fn.system(cmd)

          if output ~= "" then
            local files = {}
            local items = {}
            for line in output:gmatch("[^\r\n]+") do
              local filename = line:match("/([^/]+)$")
              if filename then
                local problem = filename:gsub("%.%w+$", "")
                local ext = filename:match("%.(%w+)$")
                table.insert(files, line)
                table.insert(items, string.format("%-50s [%s]", problem, ext or "?"))
              end
            end

            if #items > 0 then
              require("snacks.picker").select(items, {
                prompt = "Recent LeetCode problems> ",
                on_confirm = function(selected)
                  if selected then
                    local idx = nil
                    for i, item in ipairs(items) do
                      if item == selected then
                        idx = i
                        break
                      end
                    end
                    if idx and files[idx] then
                      -- Extract problem title-slug from filename
                      local filename = files[idx]:match("/([^/]+)$")
                      if filename then
                        -- Remove number prefix and extension to get title-slug
                        -- e.g., "2.add-two-numbers.go" -> "add-two-numbers"
                        local title_slug = filename:gsub("^%d+%.", ""):gsub("%.%w+$", "")

                        -- Use leetcode's API to properly open the problem
                        local ok, problemlist = pcall(require, "leetcode.cache.problemlist")
                        if ok then
                          local question = problemlist.get_by_title_slug(title_slug)
                          if question then
                            local question_picker = require("leetcode.picker.question")
                            question_picker.select(question)
                          else
                            vim.notify("Problem not found: " .. title_slug, vim.log.levels.WARN)
                          end
                        else
                          -- Fallback to direct file edit if API not available
                          vim.cmd("edit " .. files[idx])
                        end
                      end
                    end
                  end
                end,
              })
            else
              print("No LeetCode problems found")
            end
          else
            print("No LeetCode files found in: " .. leetcode_dir)
          end
        end,
        desc = "Show recent LeetCode problems",
      },
    },
  },
}
