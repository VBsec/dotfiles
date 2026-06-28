-- JSON language server (vscode-langservers-extracted): schema validation +
-- completion. Biome owns JSON formatting, so disable the LSP formatter.
return {
  cmd = { "vscode-json-language-server", "--stdio" },
  filetypes = { "json", "jsonc" },
  root_markers = { ".git" },
  init_options = { provideFormatter = false },
}
