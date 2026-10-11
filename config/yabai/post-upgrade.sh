#!/bin/bash
# Run after every yabai install/upgrade. The formula ad-hoc signs the binary, which
# makes macOS treat each build as a new app (new Accessibility entry). Re-signing with
# a stable self-signed cert (login keychain, "yabai-cert", Code Signing) keeps the grant.
# Sign first: signing changes the binary, so the sudoers hash must be taken after.
set -e
codesign -fs yabai-cert "$(readlink -f "$(which yabai)")"
echo "$(whoami) ALL=(root) NOPASSWD: sha256:$(shasum -a 256 $(which yabai) | cut -d " " -f 1) $(which yabai) --load-sa" | sudo tee /private/etc/sudoers.d/yabai >/dev/null
