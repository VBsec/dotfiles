-- taplo: TOML language server. Provides completion, hover, and schema
-- validation (Cargo.toml, pyproject.toml, etc.). Comes from mise
-- (aqua:tamasfe/taplo); if not installed it simply won't attach.
-- Formatting is left to dprint (conform), so taplo's formatter is unused.
return {
  cmd = { "taplo", "lsp", "stdio" },
  filetypes = { "toml" },
  root_markers = { ".taplo.toml", "taplo.toml", ".git" },
}
