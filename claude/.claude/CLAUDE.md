# User-level guidance (applies across all projects)

## Git

- **Never override git commit identity on the command line.** Do not pass `-c user.name=...` /
  `-c user.email=...`, and do not set `user.name`/`user.email` for a repo. Git uses the global
  config — let it. Just run `git commit -m "..."`. (The global identity is configured
  intentionally; per-command overrides attribute commits wrongly.)

## Shell

- **The Bash tool runs `zsh`, not bash.** `$SHELL` is `/bin/zsh` (zsh 5.9); `$BASH_VERSION` is
  unset. Despite the tool's name, commands are executed by zsh, so bash-only constructs fail:
  `shopt`, `mapfile`/`readarray`, `${!var}` indirection, `[[ -v ... ]]`, bash `declare -A`
  semantics. Unquoted `$var` does **not** word-split in zsh — always quote, or use `${=var}` if
  splitting is actually wanted.
- When a script genuinely needs bash semantics, invoke it explicitly: `bash -c '...'` or
  `/bin/bash script.sh`. Don't assume and don't re-derive this each session.
