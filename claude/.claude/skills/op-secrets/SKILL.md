---
name: op-secrets
description: Run a command with work secrets injected from the 1Password "innotrafik" Environment, without leaking values into the session. Use whenever a command needs a work credential (device passwords like camera root / Tailscale, API keys, tokens) that lives in 1Password rather than innoenv/Infisical. Triggers — the user asks to "run with op", "inject the secret", "use the 1Password env", or a command errors with a missing credential that is a personal/device secret.
---

# op-secrets — inject 1Password Environment secrets safely

Runs commands with secrets from the personal **`innotrafik`** 1Password Environment
injected into the subprocess only. `op run` masks any secret value that would hit
stdout/stderr, so it never reaches the terminal or this transcript.

This is the **device/personal** secret path (camera root passwords, Tailscale, personal
API keys). Project/infra secrets use `innoenv run` (Infisical) instead — the two compose.

## The environment

- **Name:** `innotrafik`
- **UUID (stable — prefer this):** `bsqvsco6zxs2elbnqp3vt2zkx4`

Use the UUID, not the name — it survives a rename.

## How to run a command with secrets

```bash
op run --environment bsqvsco6zxs2elbnqp3vt2zkx4 -- <command>
```

Examples:

```bash
# Provision Axis cameras (camera root pw comes from the env)
op run --environment bsqvsco6zxs2elbnqp3vt2zkx4 -- \
  uv run python main.py provision --config site.luonnonmaa.yaml

# Compose with innoenv when a command needs BOTH device + project secrets
op run --environment bsqvsco6zxs2elbnqp3vt2zkx4 -- innoenv run platform -- <command>
```

The config/script references the secret by name (e.g. `${AXIS_ROOT_PASSWORD}`); `op run`
supplies the value into the subprocess env. The literal never appears in the file or the
command line.

## ALWAYS announce which secrets are being accessed (authorization visibility)

`op run` prompts for biometric approval and the full command is often **truncated** in the
user's UI — so they can't see what they're authorizing. **Before every `op run`, print a
short line naming the secrets that will be injected**, so the visible context precedes the
(possibly truncated) command and the biometric prompt.

Echo the **names only** — never the values:

```bash
# Announce, then run — the echo is visible even if the op run line is truncated.
echo "🔑 op[innotrafik]: injecting AXIS_ROOT_PASSWORD → camera provisioning" && \
op run --environment bsqvsco6zxs2elbnqp3vt2zkx4 -- \
  uv run python main.py provision --config site.luonnonmaa.yaml
```

The announce line should state: **which env** (`innotrafik`), **which secret name(s)** the
command consumes, and **what the command does** in a few words. Keep it to one line so it
stays above the fold. If unsure exactly which names a command reads, list the candidates
(or show the full inventory first — see below) rather than staying silent.

## Batch work under ONE `op run` (biometric cost)

`op run` triggers a **biometric prompt per invocation** (~5–10 s, requires the user
present). It authorizes **once per `op run`**, and all injected vars are available for the
whole subprocess. So:

- **Wrap multi-step work in a single `op run`**, not one per step:
  ```bash
  echo "🔑 op[innotrafik]: injecting AXIS_ROOT_PASSWORD → provision all 3 cameras" && \
  op run --environment bsqvsco6zxs2elbnqp3vt2zkx4 -- bash -c '
    uv run python main.py provision --config site.luonnonmaa.yaml --camera kamera-1 &&
    uv run python main.py provision --config site.luonnonmaa.yaml --camera kamera-2 &&
    uv run python main.py provision --config site.luonnonmaa.yaml --camera kamera-3
  '
  ```
- Don't loop `op run` over items — loop *inside* one `op run`.
- It is **interactive only** — an agent running `op run` stalls until the user approves
  (a feature: secrets require user presence). **Not usable for unattended/cron/CI runs**;
  those need a service account token, which is out of scope for this interactive skill.

## Discovering what's in the env

```bash
op environment read bsqvsco6zxs2elbnqp3vt2zkx4 | sed 's/=.*/=<redacted>/'
```

Always pipe through `sed 's/=.*/=<redacted>/'` (or similar) to see **names only**.
`op environment read` prints real values to stdout and is NOT masked the way `op run` is.

## Rules

- **Always** precede an `op run` with a one-line announce of the env + secret name(s) +
  what the command does — the command is often truncated in the UI and the user is about to
  approve it with biometrics. Names only, never values.
- **Always** batch multi-step work under a single `op run` — each invocation costs a
  biometric prompt and needs the user present.
- **Never** add `--no-masking` to `op run` — it disables the protection (a hook blocks it).
- **Never** print, `echo`, `base64`, or substring a secret value — `op run` only masks the
  *exact* literal; a transformed form slips through. Let commands consume secrets internally
  (auth headers, file writes), not emit them.
- **Never** read raw values with `op environment read` / `op read` without redacting the
  output, and never paste a secret into the prompt yourself — no tool can mask that.
- If a command fails on a missing credential that is a device/personal secret, wrap it in
  `op run --environment bsqvsco6zxs2elbnqp3vt2zkx4 -- ...` rather than asking for the value.
- First use in a session may require `op signin` (or desktop-app/Touch ID auth).
