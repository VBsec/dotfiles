# User-level guidance (applies across all projects)

## Git

- **Never override git commit identity on the command line.** Do not pass `-c user.name=...` /
  `-c user.email=...`, and do not set `user.name`/`user.email` for a repo. Git uses the global
  config — let it. Just run `git commit -m "..."`. (The global identity is configured
  intentionally; per-command overrides attribute commits wrongly.)
