return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        cssls = {},
        tailwindcss = {
          filetypes_exclude = { "markdown" },
          filetypes_include = {},
        },
        yamlls = {
          settings = {
            yaml = {
              keyOrdering = false,
            },
          },
        },
        marksman = {},
      },
    },
  },
}