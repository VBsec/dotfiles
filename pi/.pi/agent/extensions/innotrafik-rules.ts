/**
 * Innotrafik Rules Extension (adapted from pi's claude-rules.ts example)
 *
 * This monorepo keeps domain rules in `rules/` (NOT `.claude/rules/`), indexed
 * from CLAUDE.md/AGENTS.md. pi already auto-loads CLAUDE.md, but the rules/
 * files are read-on-demand. This lists them in the system prompt so the agent
 * knows they exist and can `read` the relevant one for the area it's working in.
 */

import * as fs from "node:fs";
import * as path from "node:path";
import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";

function findMarkdownFiles(dir: string, basePath = ""): string[] {
	const results: string[] = [];
	if (!fs.existsSync(dir)) return results;

	for (const entry of fs.readdirSync(dir, { withFileTypes: true })) {
		const rel = basePath ? `${basePath}/${entry.name}` : entry.name;
		if (entry.isDirectory()) {
			results.push(...findMarkdownFiles(path.join(dir, entry.name), rel));
		} else if (entry.isFile() && entry.name.endsWith(".md")) {
			results.push(rel);
		}
	}
	return results;
}

export default function innotrafikRulesExtension(pi: ExtensionAPI) {
	let ruleFiles: string[] = [];

	pi.on("session_start", async (_event, ctx) => {
		const rulesDir = path.join(ctx.cwd, "rules");
		ruleFiles = findMarkdownFiles(rulesDir);
		if (ruleFiles.length > 0) {
			ctx.ui.notify(`Found ${ruleFiles.length} domain rule(s) in rules/`, "info");
		}
	});

	pi.on("before_agent_start", async (event) => {
		if (ruleFiles.length === 0) return;

		const rulesList = ruleFiles.map((f) => `- rules/${f}`).join("\n");
		return {
			systemPrompt:
				event.systemPrompt +
				`

## Domain Rules (read on demand)

This repo documents domain knowledge in rules/. Load the relevant file with the read tool when working in that area:

${rulesList}
`,
		};
	});
}
