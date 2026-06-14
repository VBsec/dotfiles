-- Biome: lint + format + LSP for TS/JS/JSON. Owns formatting for these
-- filetypes (conform routes them to the `biome` formatter too).
return {
  cmd = { "biome", "lsp-proxy" },
  filetypes = {
    "javascript",
    "javascriptreact",
    "typescript",
    "typescriptreact",
    "json",
    "jsonc",
    "css",
  },
  root_markers = { "biome.json", "biome.jsonc" },
}
