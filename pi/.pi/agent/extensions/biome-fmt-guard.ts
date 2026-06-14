/**
 * Biome Format Guard
 *
 * innotrafik rule (CLAUDE.md): never run Biome on individual files — always
 * `pnpm fmt` from the workspace root. Hosted models don't know this override,
 * so this blocks single-file biome invocations and nudges to the right command.
 */

import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";

// Matches `biome` / `npx biome` / `pnpm biome` followed by a path-looking arg
// (i.e. targeting specific files), but allows the root `pnpm fmt` script.
const SINGLE_FILE_BIOME = /\b(npx\s+|pnpm\s+(exec\s+)?|bunx\s+)?biome\s+(format|check|lint)\b[^|&;]*\.(ts|tsx|js|jsx|json|css)\b/;

export default function (pi: ExtensionAPI) {
	pi.on("tool_call", async (event) => {
		if (event.toolName !== "bash") return;
		const command: string = event.input?.command ?? "";
		if (SINGLE_FILE_BIOME.test(command)) {
			return {
				block: true,
				reason: "Never run Biome on individual files. Use `pnpm fmt` from the workspace root (formats the whole repo, fast). For markdown/TOML/YAML use `pnpm fmt:markup`; before committing `pnpm fmt:all`.",
			};
		}
	});
}
