-- Configure root detection for LazyVim and pickers
return {
  {
    "LazyVim/LazyVim",
    opts = {
      -- Configure root detection patterns
      root = {
        -- Root patterns for :LazyRoot
        patterns = {
          -- Monorepo markers (highest priority - check these first)
          { "pnpm-workspace.yaml" },
          { "turbo.json" },
          { "lerna.json" },
          { "nx.json" },
          { "rush.json" },
          { "yarn.workspaces" },
          { "go.work" },
          { ".git" },
          -- LSP and cwd come after
        },
      },
    },
  },
}