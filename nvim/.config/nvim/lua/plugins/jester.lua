return {
	"David-Kunz/jester",
	config = function()
		require("jester").setup({
			path_to_jest_run = "npm run test",
			terminal_cmd = ":split | terminal",
		})
	end,
}
