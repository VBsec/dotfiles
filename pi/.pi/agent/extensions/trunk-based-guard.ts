/**
 * Trunk-Based Guard
 *
 * innotrafik rule (CLAUDE.md): trunk-based development — commit directly to
 * `main`, do NOT create feature branches. Hosted models default to branching,
 * so this blocks branch creation and explains the workflow.
 */

import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";

// `git checkout -b <name>`, `git switch -c <name>`, or `git branch <name>`
// (bare `git branch` listing is allowed; only branch *creation* is blocked).
const CREATE_BRANCH = /\bgit\s+(checkout\s+-b|switch\s+-c|branch\s+(?!-[adlr]|--list|--show-current|-v|--all)\S)/;

export default function (pi: ExtensionAPI) {
	pi.on("tool_call", async (event) => {
		if (event.toolName !== "bash") return;
		const command: string = event.input?.command ?? "";
		if (CREATE_BRANCH.test(command)) {
			return {
				block: true,
				reason: "This repo is trunk-based: commit directly to main, do not create feature branches. If you need to commit, do it on main.",
			};
		}
	});
}
