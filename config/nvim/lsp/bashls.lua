-- bash-language-server. Detaches from .env files (they aren't shell scripts
-- and trigger noisy diagnostics). bashls must be available on PATH; if not
-- installed it simply won't attach.
return {
  cmd = { "bash-language-server", "start" },
  filetypes = { "sh", "bash" },
  root_markers = { ".git" },
  on_init = function(client)
    local file_path = vim.api.nvim_buf_get_name(0)
    if file_path:match("%.env") then
      client:stop()
    end
  end,
}
