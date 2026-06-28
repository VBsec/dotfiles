-- Project-wide diagnostics for large monorepos. The LSP (vtsls/biome) only
-- reports diagnostics for open files; for a full-project view we run the
-- project's own typecheck / lint command async and load results into the
-- quickfix list + snacks quickfix picker.

local M = {}

-- Walk up from `start` to find a dir containing `marker`. Returns dir or nil.
local function find_up(start, markers)
  local dir = start
  while dir and dir ~= "/" do
    for _, m in ipairs(markers) do
      if vim.fn.filereadable(dir .. "/" .. m) == 1 or vim.fn.isdirectory(dir .. "/" .. m) == 1 then
        return dir
      end
    end
    local parent = vim.fn.fnamemodify(dir, ":h")
    if parent == dir then
      break
    end
    dir = parent
  end
  return nil
end

-- Monorepo root (workspace markers) else nearest package.json else cwd.
local function project_root()
  local buf = vim.api.nvim_buf_get_name(0)
  local start = buf ~= "" and vim.fn.fnamemodify(buf, ":h") or vim.fn.getcwd()
  return find_up(start, { "pnpm-workspace.yaml", "turbo.json", ".git" })
    or find_up(start, { "package.json" })
    or vim.fn.getcwd()
end

-- Detect the package manager from lockfiles at root.
local function pkg_manager(root)
  if vim.fn.filereadable(root .. "/pnpm-lock.yaml") == 1 then
    return "pnpm"
  elseif vim.fn.filereadable(root .. "/yarn.lock") == 1 then
    return "yarn"
  elseif vim.fn.filereadable(root .. "/bun.lockb") == 1 or vim.fn.filereadable(root .. "/bun.lock") == 1 then
    return "bun"
  end
  return "npm"
end

-- Run a shell command at `root`, parse stdout+stderr through `efm` into the
-- quickfix list, then open the snacks qf picker. `filter` (optional) keeps only
-- lines that look like diagnostics, so wrapper/progress noise is dropped.
local function run_to_qf(cmd, root, title, efm, filter)
  vim.notify(title .. "…", vim.log.levels.INFO)
  local lines = {}
  vim.fn.jobstart(cmd, {
    cwd = root,
    stdout_buffered = true,
    stderr_buffered = true,
    on_stdout = function(_, data)
      if data then
        vim.list_extend(lines, data)
      end
    end,
    on_stderr = function(_, data)
      if data then
        vim.list_extend(lines, data)
      end
    end,
    on_exit = function(_, code)
      vim.schedule(function()
        if filter then
          lines = vim.tbl_filter(filter, lines)
        end
        vim.fn.setqflist({}, " ", {
          title = title,
          lines = lines,
          efm = efm,
        })
        -- Tools emit paths relative to their cwd (`root`). Resolve them to
        -- absolute so quickfix jumps work regardless of nvim's cwd, and drop
        -- anything that didn't resolve to a real, in-range file:line.
        local valid = {}
        for _, it in ipairs(vim.fn.getqflist()) do
          if it.valid == 1 and it.bufnr > 0 then
            local fname = vim.fn.bufname(it.bufnr)
            local abs = vim.fs.normalize(fname)
            if abs:sub(1, 1) ~= "/" then
              abs = vim.fs.normalize(root .. "/" .. fname)
            end
            if vim.fn.filereadable(abs) == 1 then
              valid[#valid + 1] = {
                filename = abs,
                lnum = math.max(it.lnum, 1),
                col = math.max(it.col, 1),
                type = it.type ~= "" and it.type or "E",
                text = it.text,
              }
            end
          end
        end
        vim.fn.setqflist({}, "r", { title = title, items = valid })
        local n = #valid
        if n == 0 then
          vim.notify(title .. ": clean ✓ (exit " .. code .. ")", vim.log.levels.INFO)
        else
          vim.notify(title .. ": " .. n .. " items", vim.log.levels.WARN)
          if Snacks and Snacks.picker then
            Snacks.picker.qflist()
          else
            vim.cmd("copen")
          end
        end
      end)
    end,
  })
end

-- Type-check the nearest package directly with tsc/tsgo (not through turbo,
-- which adds package prefixes + progress noise). Runs against the package's
-- tsconfig for clean, parseable `file(line,col): error TSxxxx` output.
function M.check_types()
  local buf = vim.api.nvim_buf_get_name(0)
  local start = buf ~= "" and vim.fn.fnamemodify(buf, ":h") or vim.fn.getcwd()
  -- Nearest dir that actually has a tsconfig (the package being edited).
  local pkg = find_up(start, { "tsconfig.json" }) or find_up(start, { "package.json" }) or vim.fn.getcwd()

  -- Prefer tsgo (fast native compiler) if present in node_modules, else tsc.
  local bin = "tsc"
  local mono = find_up(pkg, { "node_modules" })
  if mono and vim.fn.executable(mono .. "/node_modules/.bin/tsgo") == 1 then
    bin = mono .. "/node_modules/.bin/tsgo"
  elseif mono and vim.fn.executable(mono .. "/node_modules/.bin/tsc") == 1 then
    bin = mono .. "/node_modules/.bin/tsc"
  end

  -- A tsconfig.app.json (build-time) is common in this monorepo; prefer it.
  local tsconfig = "tsconfig.json"
  if vim.fn.filereadable(pkg .. "/tsconfig.app.json") == 1 then
    tsconfig = "tsconfig.app.json"
  end

  local cmd = { bin, "--noEmit", "--pretty", "false", "-p", tsconfig }
  -- tsc: `file(line,col): error TSxxxx: msg` and `: warning`.
  local efm = "%f(%l\\,%c): %trror %m,%f(%l\\,%c): %tarning %m"
  -- Keep only lines that look like a tsc diagnostic.
  local filter = function(l)
    return type(l) == "string" and l:match("%(%d+,%d+%): %a+ TS%d+")
  end
  run_to_qf(cmd, pkg, "Type check (" .. vim.fn.fnamemodify(bin, ":t") .. " " .. tsconfig .. ")", efm, filter)
end

-- Monorepo-wide type-check via turbo. Turbo prefixes every line with
-- `<pkg>:check-types: ` and emits paths relative to each package's own dir, so
-- a plain errorformat can't resolve them. We parse manually: build a
-- package→dir map from turbo's own `> <pkg>@ver check-types <abs-dir>` lines,
-- then resolve each `<pkg>:check-types: <relpath>(l,c): error` to an absolute
-- path. Respects turbo's cache (fast when nothing changed); cached packages
-- replay their logs, so previously-found errors still surface.
function M.check_types_all()
  local root = project_root()
  local title = "Type check (turbo, all packages)"
  vim.notify(title .. "… (may take a moment)", vim.log.levels.INFO)

  local lines = {}
  vim.fn.jobstart({ "turbo", "check-types", "--output-logs=errors-only" }, {
    cwd = root,
    stdout_buffered = true,
    stderr_buffered = true,
    on_stdout = function(_, d)
      if d then
        vim.list_extend(lines, d)
      end
    end,
    on_stderr = function(_, d)
      if d then
        vim.list_extend(lines, d)
      end
    end,
    on_exit = function(_, code)
      vim.schedule(function()
        -- 1) pkg -> absolute dir, from turbo's script-echo lines:
        --    `<pkg>:check-types: > @scope/name@1.0.0 check-types /abs/dir`
        local pkg_dir = {}
        for _, line in ipairs(lines) do
          local pkg, dir = line:match("^([^:]+):check%-types: > .+ check%-types%s+(/%S+)")
          if pkg and dir then
            pkg_dir[pkg] = dir
          end
        end

        -- 2) parse prefixed tsc diagnostics and resolve paths.
        --    `<pkg>:check-types: <relpath>(line,col): error TSxxxx: msg`
        local items = {}
        for _, line in ipairs(lines) do
          local pkg, rel, l, c, sev, msg =
            line:match("^([^:]+):check%-types:%s+(.-)%((%d+),(%d+)%): (%a+) (.+)$")
          if pkg and rel and l and pkg_dir[pkg] then
            local abs = vim.fs.normalize(pkg_dir[pkg] .. "/" .. rel)
            if vim.fn.filereadable(abs) == 1 then
              items[#items + 1] = {
                filename = abs,
                lnum = math.max(tonumber(l) or 1, 1),
                col = math.max(tonumber(c) or 1, 1),
                type = sev == "error" and "E" or "W",
                text = msg,
              }
            end
          end
        end

        vim.fn.setqflist({}, "r", { title = title, items = items })
        if #items == 0 then
          vim.notify(title .. ": clean ✓ (exit " .. code .. ")", vim.log.levels.INFO)
        else
          vim.notify(title .. ": " .. #items .. " items", vim.log.levels.WARN)
          if Snacks and Snacks.picker then
            Snacks.picker.qflist()
          else
            vim.cmd("copen")
          end
        end
      end)
    end,
  })
end

-- Run biome lint on the project into quickfix (GitHub reporter = parseable).
function M.lint_biome()
  local root = project_root()
  -- biome's github reporter emits: ::error file=PATH,line=L,col=C::MESSAGE
  -- Translate that with a tolerant efm; fall back to plain biome output.
  local efm = "::%trror file=%f\\,line=%l\\,col=%c\\,%m,::%tarning file=%f\\,line=%l\\,col=%c\\,%m"
  local filter = function(l)
    return type(l) == "string" and l:match("^::%a+ file=")
  end
  run_to_qf({ "biome", "check", "--reporter=github", "." }, root, "Biome lint", efm, filter)
end

return M
