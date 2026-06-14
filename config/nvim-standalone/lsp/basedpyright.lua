-- basedpyright: Python type-checking + completion + inlay hints.
-- Projects use uv / poetry / FastAPI plus loose build scripts.
return {
  cmd = { "basedpyright-langserver", "--stdio" },
  filetypes = { "python" },
  root_markers = {
    "pyproject.toml",
    "setup.py",
    "setup.cfg",
    "Pipfile",
    "pyrightconfig.json",
    "uv.lock",
    ".git",
  },
  settings = {
    basedpyright = {
      analysis = {
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
        diagnosticMode = "openFilesOnly",
        -- "standard" avoids basedpyright's very strict default ruleset.
        typeCheckingMode = "standard",
      },
    },
  },
}
