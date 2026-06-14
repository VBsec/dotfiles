/**
 * Secret Path Guard
 *
 * Blocks the edit/write tools from touching innotrafik secret material:
 * encrypted vault files, local env overrides, and pi's own auth file.
 * Reads are allowed (the agent may need to reason about structure), but
 * mutations are blocked to prevent accidental secret leakage or corruption.
 *
 * Note: this only guards the structured edit/write tools. bash can still
 * read/write anything — that's intentional (e.g. `innoenv sync` writes the
 * vault). This is a guard against the model silently editing secrets, not a
 * sandbox.
 */

import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";

const PROTECTED = [
	/vault\/secrets\.[^/]+\.enc$/, // encrypted Infisical vault
	/(^|\/)env\.local\.toml$/, // local machine overrides (gitignored, sensitive)
	/\.pi\/agent\/auth\.json$/, // pi provider credentials
	/(^|\/)\.env(\.|$)/, // any .env file
];

export default function (pi: ExtensionAPI) {
	pi.on("tool_call", async (event) => {
		if (event.toolName !== "edit" && event.toolName !== "write") return;
		const filePath: string = event.input?.file_path ?? event.input?.path ?? "";
		if (PROTECTED.some((re) => re.test(filePath))) {
			return {
				block: true,
				reason: `Refusing to ${event.toolName} secret/credential file: ${filePath}. These are managed via innoenv/Infisical (run \`innoenv sync\`), not edited directly.`,
			};
		}
	});
}
