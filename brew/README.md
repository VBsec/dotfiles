# brew

Snapshot of manually-installed Homebrew packages for reinstalling on a new machine.

Not a stow package — nothing here gets symlinked. It's a script plus its generated output, kept in version control.

## Files

- `dump-brew.sh` — regenerates the two files below.
- `leaves.txt` — formulae you installed on request (`brew leaves --installed-on-request`), one per line. Auto-installed dependencies are excluded.
- `Brewfile` — full reproducible bundle: taps, on-request formulae, casks, and Mac App Store apps.

## Update the snapshot

```bash
./dump-brew.sh
```

Run after installing/removing packages, then commit the changed files. `./dump-brew.sh --check` exits non-zero if the files are stale (handy for a pre-commit hook or CI).

## Reinstall on a new machine

```bash
brew bundle --file=brew/Brewfile
```

Or, for just the formulae without casks/taps:

```bash
xargs brew install < brew/leaves.txt
```
