-- clangd for C (Zephyr RTOS / nRF / STM32 / SDCC). The real per-target tuning
-- (ARM vs 8051, flag removal, include paths) lives in each repo's .clangd file,
-- so here we only need the binary, flags, and root markers.
return {
  cmd = {
    vim.fn.exepath("clangd") ~= "" and vim.fn.exepath("clangd") or "clangd",
    "--background-index",
    "--clang-tidy",
    "--header-insertion=iwyu",
    "--completion-style=detailed",
    "--function-arg-placeholders",
    "--fallback-style=llvm",
  },
  filetypes = { "c", "cpp", "objc", "objcpp", "cuda", "proto" },
  root_markers = {
    "compile_commands.json",
    ".clangd",
    ".cproject", -- Eclipse / STM32CubeIDE
    "west.yml", -- Zephyr workspace
    "CMakeLists.txt",
    "Makefile",
    ".git",
  },
  capabilities = {
    offsetEncoding = { "utf-8", "utf-16" },
    textDocument = {
      completion = {
        editsNearCursor = true,
      },
    },
  },
  init_options = {
    usePlaceholders = true,
    completeUnimported = true,
    clangdFileStatus = true,
  },
}
