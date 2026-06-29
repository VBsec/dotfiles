-- marksman: markdown language server. Provides go-to-definition for
-- [text](#anchor) heading links, wikilinks, and reference links, plus
-- document symbols and completion. Comes from mise (aqua:artempyanykh/marksman);
-- if not installed it simply won't attach.
return {
  cmd = { "marksman", "server" },
  filetypes = { "markdown", "markdown.mdx" },
  root_markers = { ".marksman.toml", ".git" },
}
