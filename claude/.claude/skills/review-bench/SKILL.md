---
name: review-bench
description:
  Johannes's personal PR review benchmark for the innotrafik repo. After a PR is opened, review
  it with Claude's built-in /code-review and the CodeRabbit CLI in parallel, have a blind judge
  grade every finding (false positives penalised), record the scores in
  ~/.claude/review-bench/ (never in the repo), then fix the valid findings on the PR branch.
  Use after opening a PR in innotrafik, when /work reaches its review step, or when invoked as
  /review-bench. Not for Miro's work or other repos.
---

# Review bench

Design: `docs/design/2026-10-07-pr-review-benchmark.md` in the innotrafik repo. It's the source of
truth; this file is the procedure. Helper: `python3 ~/.claude/skills/review-bench/bench.py`.

Scores and run artifacts live in `~/.claude/review-bench/`. Never write them into the repo.

## Parallel sessions

Two or three sessions may bench different PRs at the same time. Each works from its own PR
worktree (worktrunk), so run every command from that worktree, and use `root` from the prepare
output as the repo root, never the main checkout. `bench.py` locks the ledger and scoreboard,
refuses a second run on the same commit, and shares CodeRabbit's 5 reviews per hour between
sessions. Don't run `cr` yourself; use `bench.py cr`.

## 1. Prepare

On the PR branch, with a clean working tree and the PR already open:

```
python3 ~/.claude/skills/review-bench/bench.py prepare
```

It prints JSON with `run_dir`, `range`, `claude_levels`, `cr_remaining` and `skip`.

- If `skip` is set (bot PR, docs-only, or more than 150 reviewable files), the skip is already
  recorded. Tell the user in one line, then review the PR the normal way: `/code-review high`, and
  fix what it finds.
- If `cr_remaining` is `0`, carry on. `bench.py cr` waits for a slot in the rolling hour (up to
  65 minutes) while Claude reviews; tell the user in one line that CodeRabbit is queued. It never
  uses `--use-credits`.

## 2. Review in parallel

Start both, and note each start and end time.

**CodeRabbit**, as a background Bash command (`run_in_background`):

```
python3 ~/.claude/skills/review-bench/bench.py cr <run_dir>
```

It reserves a quota slot, runs `cr review --agent --deep --fresh --committed --base-commit <base>`
in `root`, writes `<run_dir>/raw-cr.jsonl` and records its own wall time.

**Claude**, in the same turn, once per level in `claude_levels` (during calibration that is
`medium` and `high`):

```
/code-review <level> <range>
```

Invoke it through the Skill tool (`code-review`, args `"<level> <range>"`). It runs as a forked
subagent that doesn't see this conversation. Don't add instructions to the args: everything after
the level is treated as the review target. Save each result verbatim to
`<run_dir>/raw-claude-<level>.md`.

Until both reviewers have finished, don't read, quote or summarise either output into the
conversation. Wait for the completion notifications.

Write the Claude wall times in seconds to `<run_dir>/timing.json`, e.g.
`{"claude-high": 380, "claude-medium": 250}`.

## 3. Normalise and blind

For each raw output, write `<run_dir>/norm-<name>.json`, where name is `cr`, `claude-medium` or
`claude-high`. Each is a list of findings shaped as:

```json
{ "file": "apps/x/y.ts", "line": 42, "summary": "one sentence", "detail": "the reviewer's reasoning, condensed" }
```

Rewrite each finding in neutral words: drop severity emojis, tool names, "CodeRabbit"/"Claude",
suggested-diff markup, and boilerplate. Keep every finding, including duplicates; the judge
handles those. Then:

```
python3 ~/.claude/skills/review-bench/bench.py blind <run_dir>
```

That writes `blind.json` with reviewers labelled A/B/C at random, and `mapping.json`. Don't open
`mapping.json` until scoring is done.

## 4. Judge

Spawn one subagent (`general-purpose`, fresh context) with this prompt, filling in the paths:

> You are grading code-review findings for PR range `<range>` in the repo at `<root>`. Read
> `<run_dir>/blind.json`. Each finding has an id; its reviewer is an anonymous letter. Don't
> open any other file in `<run_dir>`, and don't use `gh`, Linear or the web.
>
> For every finding, read the actual code (`git diff <range>`, `git show <head>:<file>`) and
> give exactly one grade:
>
> - `bug`: a real defect (wrong behaviour on a realistic input, a security issue, data loss)
> - `minor`: real and worth changing, but not a defect
> - `noise`: true but not worth acting on (nitpick, style, restating the code), or a repeat of
>   a finding the same reviewer already made
> - `false_positive`: the claim is wrong; the issue doesn't exist in this code
> - `unverifiable`: the code alone can't confirm or refute it
>
> Be strict. A plausible-sounding claim you can't confirm is not a bug. For `bug` and
> `false_positive`, cite the lines that prove it. Use the repo's `REVIEW.md` for what counts as
> Important and what to skip.
>
> Findings from different reviewers about the same underlying issue share a `group` string (a
> short slug). Give every `bug` and `minor` a group.
>
> Write `<run_dir>/grades.json` as
> `{"findings": [{"id": "A1", "grade": "bug", "group": "null-expiry", "evidence": "y.ts:88 …"}]}`
> covering every id, then reply with one line: the count per grade.

## 5. Record

```
python3 ~/.claude/skills/review-bench/bench.py record <run_dir>
```

This appends one line to `~/.claude/review-bench/scores.jsonl` and regenerates `scoreboard.md`.
Report to the user in three or four lines: the per-reviewer score, any bug only one reviewer
caught, and the path to the scoreboard.

If the output has `"calibration_done": true` (only the session whose record made it ten PRs gets
it), compare `claude-medium` and `claude-high` on the scoreboard, write the better level to
`~/.claude/review-bench/settings.json` as `{"level": "high"}`, tell the user, and add a
decisions-log line to the design doc. Runs prepared before that still review at both levels;
record them as usual.

## 6. Fix

Fix every `bug` and `minor` on the PR branch, using both reviewers' findings. Never act on
`noise`, `false_positive` or `unverifiable`. Commit (`fix: address review findings`), push, and
then stop. Merging stays with the human.
