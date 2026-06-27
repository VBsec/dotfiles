#!/usr/bin/env bash
#
# dump-brew.sh — snapshot manually-installed Homebrew packages for reinstall
# on a new machine.
#
# Outputs (next to this script):
#   leaves.txt   plain list of formulae you installed on request, one per line
#                (dependencies pulled in automatically are excluded)
#   Brewfile     full bundle: taps + manual formulae + casks + Mac App Store apps,
#                reinstallable with `brew bundle --file=Brewfile`
#
# Usage:
#   ./dump-brew.sh          # write both files
#   ./dump-brew.sh --check  # don't write; exit non-zero if files are stale (CI/pre-commit)
#
set -euo pipefail

cd "$(dirname "${BASH_SOURCE[0]}")"

command -v brew >/dev/null 2>&1 || { echo "error: brew not found in PATH" >&2; exit 1; }

# Formulae explicitly requested by the user, not auto-installed as dependencies.
gen_leaves() { brew leaves --installed-on-request; }

# Full reproducible bundle: taps + on-request formulae + casks + Mac App Store apps.
gen_brewfile() { brew bundle dump --file=- --force; }

if [[ "${1:-}" == "--check" ]]; then
  status=0
  diff <(gen_leaves)   leaves.txt >/dev/null 2>&1 || { echo "leaves.txt is stale — run ./dump-brew.sh" >&2; status=1; }
  diff <(gen_brewfile) Brewfile   >/dev/null 2>&1 || { echo "Brewfile is stale — run ./dump-brew.sh"   >&2; status=1; }
  exit $status
fi

gen_leaves   > leaves.txt
gen_brewfile > Brewfile

echo "Wrote leaves.txt ($(wc -l < leaves.txt | tr -d ' ') formulae) and Brewfile."
echo "Reinstall on a new machine with:  brew bundle --file=\"\$(dirname \"\$0\")/Brewfile\""
