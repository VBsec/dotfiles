#!/usr/bin/env python3
"""
PreToolUse hook: block `op run --no-masking`.

`op run` masks known secret values on the subprocess's stdout/stderr before they
reach the terminal (and therefore the agent transcript). `--no-masking` disables
that protection, which would let secrets leak into the session. Deny it in any form:
standalone, chained (&&, ||, ;), piped, subshells, and xargs.
"""

import json
import re
import sys


# Match an `op run` invocation that carries a --no-masking flag anywhere after it.
# - \bop\s+run\b : the op run command (word boundary avoids matching e.g. "stop run")
# - [^;&|]*      : its own args, not crossing into a chained command
# - --no-masking : the flag (optionally =true / =1), abbreviations tolerated via --no-mask
OP_RUN_NO_MASK_RE = re.compile(
    r"\bop\s+run\b[^;&|]*--no-mask(?:ing)?\b",
)


def deny(reason: str):
    print(json.dumps({"decision": "block", "reason": reason}))
    sys.exit(0)


def main():
    try:
        data = json.load(sys.stdin)
    except (json.JSONDecodeError, ValueError):
        sys.exit(0)

    tool_name = data.get("tool_name", "")
    tool_input = data.get("tool_input")

    if tool_name != "Bash" or not isinstance(tool_input, dict):
        sys.exit(0)

    command = tool_input.get("command", "")
    flat = command.replace("\n", " ")

    if OP_RUN_NO_MASK_RE.search(flat):
        deny(
            "`op run --no-masking` is not allowed — it disables 1Password's secret "
            "masking and would leak secrets into the session. Run `op run` without "
            "--no-masking so values stay concealed."
        )


if __name__ == "__main__":
    main()
