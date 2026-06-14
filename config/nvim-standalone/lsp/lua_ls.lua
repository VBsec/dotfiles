-- lua-language-server, configured for editing this Neovim config (replaces
-- the old neoconf/neodev role). stylua handles formatting.
return {
  cmd = { "lua-language-server" },
  filetypes = { "lua" },
  root_markers = { ".luarc.json", ".luarc.jsonc", "stylua.toml", ".git" },
  settings = {
    Lua = {
      runtime = { version = "LuaJIT" },
      workspace = {
        checkThirdParty = false,
        library = {
          vim.env.VIMRUNTIME,
          "${3rd}/luv/library",
        },
      },
      diagnostics = { globals = { "vim", "Snacks" } },
      hint = { enable = true },
      format = { enable = false },
    },
  },
}
