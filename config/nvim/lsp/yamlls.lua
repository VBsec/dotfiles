-- yaml-language-server (Red Hat): completion, hover, and JSON-schema
-- validation. Comes from mise (npm:yaml-language-server); if not installed
-- it simply won't attach. Formatting is left to dprint (conform), so the
-- LSP formatter is disabled.
--
-- SchemaStore (schemaStore.enable) auto-detects schemas for well-known files
-- (GitHub Actions workflows, docker-compose, .gitlab-ci.yml, etc.). The
-- explicit `schemas` map below pins the GitHub Actions + workflow schemas so
-- `.github/workflows/*` and `.github/actions/*/action.yml` validate even if the
-- store lookup misses.
return {
  cmd = { "yaml-language-server", "--stdio" },
  filetypes = { "yaml", "yaml.docker-compose", "yaml.gitlab" },
  root_markers = { ".git" },
  settings = {
    redhat = { telemetry = { enabled = false } },
    yaml = {
      format = { enable = false }, -- dprint owns formatting
      validate = true,
      keyOrdering = false,
      schemaStore = { enable = true, url = "https://www.schemastore.org/api/json/catalog.json" },
      schemas = {
        ["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*.{yml,yaml}",
        ["https://json.schemastore.org/github-action.json"] = "/.github/actions/*/action.{yml,yaml}",
      },
    },
  },
}
