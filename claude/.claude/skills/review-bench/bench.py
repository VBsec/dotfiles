#!/usr/bin/env python3
"""Mechanical parts of /review-bench: prepare, blind, record, board.

Ledger and run artifacts live under ~/.claude/review-bench/ (never in the repo).
Stdlib only. Design: docs/design/2026-10-07-pr-review-benchmark.md in the innotrafik repo.

Safe for 2-3 sessions benching different PRs at once (each from its own worktree): ledger,
scoreboard and the CodeRabbit quota go through one file lock, and `cr` reserves its slot
before it starts.
"""

import contextlib
import fcntl
import fnmatch
import hashlib
import json
import random
import re
import subprocess
import sys
import time
from datetime import datetime, timedelta, timezone
from pathlib import Path

HOME = Path.home() / ".claude" / "review-bench"
LEDGER = HOME / "scores.jsonl"
BOARD = HOME / "scoreboard.md"
SETTINGS = HOME / "settings.json"
LOCK = HOME / ".lock"
CR_STARTS = HOME / "cr-starts.jsonl"  # local record of reviews started, for the quota
CR_PER_HOUR = 5
CR_MAX_WAIT = 65 * 60
MAX_FILES = 150
CALIBRATION_PRS = 10
POINTS = {"bug": 3, "minor": 1, "noise": -0.5, "false_positive": -2, "unverifiable": 0}
CONFIG_FILES = [".coderabbit.yaml", "REVIEW.md", "AGENTS.md"]


def sh(*args, check=True):
    r = subprocess.run(args, capture_output=True, text=True)
    if check and r.returncode != 0:
        sys.exit(f"command failed: {' '.join(args)}\n{r.stderr}")
    return r.stdout.strip()


@contextlib.contextmanager
def locked():
    """Serialise ledger, scoreboard and quota updates across parallel sessions."""
    HOME.mkdir(parents=True, exist_ok=True)
    with LOCK.open("a") as f:
        fcntl.flock(f, fcntl.LOCK_EX)
        try:
            yield
        finally:
            fcntl.flock(f, fcntl.LOCK_UN)


def ledger():
    if not LEDGER.exists():
        return []
    return [json.loads(line) for line in LEDGER.read_text().splitlines() if line.strip()]


def settings():
    if SETTINGS.exists():
        return json.loads(SETTINGS.read_text())
    return {"level": None}


def path_filters(root):
    """Negated globs from .coderabbit.yaml reviews.path_filters (minimal parser)."""
    text = (root / ".coderabbit.yaml").read_text()
    m = re.search(r"^  path_filters:\n((?:    - .*\n)+)", text, re.M)
    if not m:
        return []
    out = []
    for line in m.group(1).splitlines():
        g = line.strip()[2:].strip().strip("\"'")
        if g.startswith("!"):
            out.append(g[1:])
    return out


def glob_match(path, pattern):
    # fnmatch's * already crosses "/", so ** behaves like a recursive wildcard;
    # also let "**/x" match a top-level "x".
    return fnmatch.fnmatch(path, pattern) or (
        pattern.startswith("**/") and fnmatch.fnmatch(path, pattern[3:])
    )


def cr_remaining():
    out = sh("cr", "usage", check=False)
    m = re.search(r"Remaining\s*:\s*(\d+)\s+of\s+(\d+)", out)
    return int(m.group(1)) if m else None


def prepare():
    root = Path(sh("git", "rev-parse", "--show-toplevel"))
    if sh("git", "status", "--porcelain"):
        sys.exit("working tree not clean: commit first, the bench reviews committed changes only")
    pr = json.loads(sh("gh", "pr", "view", "--json", "number,title,url,author,headRefOid"))
    for attempt in range(4):  # sibling worktrees share refs; a parallel fetch can hold the lock
        if subprocess.run(["git", "fetch", "-q", "origin", "main"], capture_output=True).returncode == 0:
            break
        time.sleep(2 + attempt * 3)
    else:
        sh("git", "fetch", "-q", "origin", "main")
    base = sh("git", "merge-base", "origin/main", "HEAD")
    head = sh("git", "rev-parse", "HEAD")
    changed = [f for f in sh("git", "diff", "--name-only", base, head).splitlines() if f]
    filters = path_filters(root)
    reviewable = [f for f in changed if not any(glob_match(f, p) for p in filters)]
    run_id = f"{pr['number']}-{head[:9]}"
    run_dir = HOME / "runs" / run_id
    cfg_hash = hashlib.sha256(
        b"".join(sh("git", "show", f"{head}:{f}", check=False).encode() for f in CONFIG_FILES)
    ).hexdigest()[:12]

    skip = None
    if pr["author"]["login"].startswith("app/") or "renovate" in pr["author"]["login"]:
        skip = "bot PR"
    elif not reviewable or all(f.endswith(".md") for f in reviewable):
        skip = "docs-only or nothing reviewable"
    elif len(reviewable) > MAX_FILES:
        skip = f"{len(reviewable)} reviewable files > {MAX_FILES}"

    done = [r for r in ledger() if not r.get("skipped")]
    level = settings().get("level")
    levels = ["medium", "high"] if (len(done) < CALIBRATION_PRS or not level) else [level]

    info = {
        "root": str(root),
        "run_id": run_id,
        "run_dir": str(run_dir),
        "pr": pr["number"],
        "title": pr["title"],
        "url": pr["url"],
        "base": base,
        "head": head,
        "range": f"{base}...{head}",
        "changed_files": len(changed),
        "reviewable_files": len(reviewable),
        "config_hash": cfg_hash,
        "claude_levels": levels,
        "cr_version": sh("cr", "--version", check=False).splitlines()[0],
        "cr_remaining": None,
        "skip": skip,
    }
    if skip:
        with locked():
            if any(r.get("run_id") == run_id for r in ledger()):
                sys.exit(f"{run_id} is already in the ledger")
            append({**info, "date": now(), "skipped": skip})
            board()
    else:
        info["cr_remaining"] = cr_remaining()
        try:
            run_dir.mkdir(parents=True)
        except FileExistsError:
            sys.exit(f"{run_dir} exists: another session is benching this commit, or an earlier run "
                     "stopped. Delete the directory to start over.")
        (run_dir / "prepare.json").write_text(json.dumps(info, indent=2))
    print(json.dumps(info, indent=2))


def cr_slot():
    """Reserve one included CodeRabbit review, waiting for the rolling hour if none is free.

    `cr usage` lags a review that started seconds ago, so the free count is also capped by the
    starts this machine recorded in the last hour.
    """
    deadline = time.time() + CR_MAX_WAIT
    while True:
        with locked():
            cutoff = datetime.now(timezone.utc) - timedelta(hours=1)
            starts = []
            if CR_STARTS.exists():
                starts = [datetime.fromisoformat(json.loads(line)["at"])
                          for line in CR_STARTS.read_text().splitlines() if line.strip()]
            recent = sorted(t for t in starts if t > cutoff)
            server = cr_remaining()
            free = min(server if server is not None else CR_PER_HOUR, CR_PER_HOUR - len(recent))
            if free > 0:
                with CR_STARTS.open("a") as f:
                    f.write(json.dumps({"at": now()}) + "\n")
                return
            wait = (recent[0] + timedelta(hours=1) - datetime.now(timezone.utc)).total_seconds() if recent else 120
        if time.time() + 60 > deadline:
            sys.exit("no included CodeRabbit review freed up within the hour; never --use-credits")
        print(f"CodeRabbit quota used up; waiting {int(max(wait, 60))}s", flush=True)
        time.sleep(min(max(wait, 60), 600))


def cr(run_dir):
    """Run CodeRabbit for a prepared run: quota-safe, fresh, never on credits. Run in background."""
    run_dir = Path(run_dir)
    info = json.loads((run_dir / "prepare.json").read_text())
    cr_slot()
    start = time.time()
    with (run_dir / "raw-cr.jsonl").open("w") as out:
        r = subprocess.run(
            ["cr", "review", "--agent", "--deep", "--fresh", "--committed", "--base-commit", info["base"]],
            cwd=info["root"], stdout=out, stderr=subprocess.STDOUT,
        )
    (run_dir / "timing-cr.json").write_text(json.dumps({"cr": round(time.time() - start)}))
    print(f"cr exited {r.returncode} after {round(time.time() - start)}s -> {run_dir / 'raw-cr.jsonl'}")
    sys.exit(r.returncode)


def blind(run_dir):
    """Shuffle normalised findings from every source into one unlabelled list."""
    run_dir = Path(run_dir)
    sources = {p.stem: json.loads(p.read_text()) for p in sorted(run_dir.glob("norm-*.json"))}
    labels = [chr(ord("A") + i) for i in range(len(sources))]
    rng = random.SystemRandom()
    rng.shuffle(labels)
    mapping = dict(zip(labels, [s.removeprefix("norm-") for s in sources]))
    items = []
    for label, (name, findings) in zip(labels, sources.items()):
        for i, f in enumerate(findings):
            items.append({"id": f"{label}{i + 1}", "reviewer": label, **f})
    rng.shuffle(items)
    (run_dir / "mapping.json").write_text(json.dumps(mapping, indent=2))
    (run_dir / "blind.json").write_text(json.dumps(items, indent=2))
    print(f"{len(items)} findings from {len(sources)} reviewers -> {run_dir / 'blind.json'}")


def record(run_dir):
    run_dir = Path(run_dir)
    info = json.loads((run_dir / "prepare.json").read_text())
    mapping = json.loads((run_dir / "mapping.json").read_text())
    grades = json.loads((run_dir / "grades.json").read_text())["findings"]
    timing = {}
    for name in ("timing-cr.json", "timing.json"):
        if (run_dir / name).exists():
            timing |= json.loads((run_dir / name).read_text())
    per = {}
    groups = {}  # match group -> set of reviewers that found it with grade bug/minor
    for g in grades:
        name = mapping[g["id"][0]]
        r = per.setdefault(name, {k: 0 for k in POINTS} | {"score": 0.0})
        r[g["grade"]] += 1
        r["score"] += POINTS[g["grade"]]
        if g["grade"] in ("bug", "minor") and g.get("group"):
            groups.setdefault(g["group"], {})[name] = g["grade"]
    for name in mapping.values():
        r = per.setdefault(name, {k: 0 for k in POINTS} | {"score": 0.0})
        graded = sum(r[k] for k in POINTS if k != "unverifiable")
        r["precision"] = round((r["bug"] + r["minor"]) / graded, 3) if graded else None
        r["unique_valid"] = sum(1 for found in groups.values() if list(found) == [name])
        r["seconds"] = timing.get(name)
    cr_bugs = [found for found in groups.values() if found.get("cr") == "bug"]
    for name in mapping.values():
        if name != "cr":
            per[name]["cr_bug_recall"] = (
                round(sum(1 for f in cr_bugs if name in f) / len(cr_bugs), 3) if cr_bugs else None
            )
            per[name]["cr_bugs"] = len(cr_bugs)
    entry = ({k: info[k] for k in ("run_id", "pr", "title", "head", "reviewable_files", "config_hash", "cr_version")}
             | {"date": now(), "reviewers": per})
    with locked():
        rows = ledger()
        if any(r.get("run_id") == info["run_id"] for r in rows):
            sys.exit(f"{info['run_id']} is already in the ledger")
        append(entry)
        scored = sum(1 for r in rows if not r.get("skipped")) + 1
        board()
    # Exactly one record crosses the threshold, so only that session picks the level.
    out = {"reviewers": per, "scored_prs": scored,
           "calibration_done": scored == CALIBRATION_PRS and not settings().get("level")}
    print(json.dumps(out, indent=2))


def append(entry):
    HOME.mkdir(parents=True, exist_ok=True)
    with LEDGER.open("a") as f:
        f.write(json.dumps(entry) + "\n")


def now():
    return datetime.now(timezone.utc).isoformat(timespec="seconds")


def board():
    rows = ledger()
    runs = [r for r in rows if not r.get("skipped")]
    tot = {}
    for r in runs:
        for name, s in r["reviewers"].items():
            t = tot.setdefault(name, {"prs": 0, "score": 0.0, "bug": 0, "minor": 0, "noise": 0,
                                      "false_positive": 0, "unverifiable": 0, "unique_valid": 0,
                                      "cr_bugs": 0, "cr_bugs_caught": 0})
            t["prs"] += 1
            for k in ("score", "bug", "minor", "noise", "false_positive", "unverifiable", "unique_valid"):
                t[k] += s.get(k) or 0
            if s.get("cr_bug_recall") is not None:
                t["cr_bugs"] += s["cr_bugs"]
                t["cr_bugs_caught"] += round(s["cr_bug_recall"] * s["cr_bugs"])
    lines = [
        "# Review bench scoreboard",
        "",
        f"_Regenerated {now()}. {len(runs)} PRs scored, {len(rows) - len(runs)} skipped._",
        "",
        "Points: bug +3, minor +1, noise −0.5, false positive −2, unverifiable 0.",
        "",
        "| reviewer | PRs | score | score/PR | precision | bug | minor | noise | FP | unique valid | CR-bug recall |",
        "| -------- | --: | ----: | -------: | --------: | --: | ----: | ----: | -: | -----------: | ------------: |",
    ]
    for name, t in sorted(tot.items()):
        graded = t["bug"] + t["minor"] + t["noise"] + t["false_positive"]
        prec = f"{(t['bug'] + t['minor']) / graded:.2f}" if graded else "–"
        rec = f"{t['cr_bugs_caught']}/{t['cr_bugs']}" if name != "cr" and t["cr_bugs"] else "–"
        lines.append(
            f"| {name} | {t['prs']} | {t['score']:.1f} | {t['score'] / t['prs']:.2f} | {prec} | {t['bug']} | "
            f"{t['minor']} | {t['noise']} | {t['false_positive']} | {t['unique_valid']} | {rec} |"
        )
    lines += ["", "## Last 10 PRs", "", "| date | PR | files | config | result |", "| ---- | -: | ----: | ------ | ------ |"]
    for r in rows[-10:][::-1]:
        res = r.get("skipped") or ", ".join(
            f"{n} {s['score']:+.1f}" for n, s in sorted(r["reviewers"].items())
        )
        lines.append(f"| {r['date'][:10]} | #{r['pr']} | {r.get('reviewable_files', '')} | "
                     f"{r.get('config_hash', '')} | {res} |")
    lines += [
        "",
        "Switch rule (design doc): over ≥ 20 PRs, Claude's total score ≥ CodeRabbit's, CR-bug recall",
        "≥ 80%, and precision ≥ CodeRabbit's. A config hash change marks a break in the series.",
        "",
    ]
    HOME.mkdir(parents=True, exist_ok=True)
    tmp = BOARD.with_suffix(".tmp")
    tmp.write_text("\n".join(lines))
    tmp.replace(BOARD)


if __name__ == "__main__":
    cmd, *rest = sys.argv[1:] or ["board"]
    {"prepare": prepare, "cr": cr, "blind": blind, "record": record, "board": board}[cmd](*rest)
