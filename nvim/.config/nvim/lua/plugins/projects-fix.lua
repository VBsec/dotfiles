-- Fix project.nvim to auto-detect and save projects
return {
	{
		"ahmedkhalf/project.nvim",
		opts = {
			-- Change from manual_mode = true to false to auto-detect projects
			manual_mode = false,

			-- Detection methods - will try LSP first, then patterns
			detection_methods = { "lsp", "pattern" },

			-- Patterns to detect root directory
			patterns = {
				".git",
				"_darcs",
				".hg",
				".bzr",
				".svn",
				"Makefile",
				"Taskfile",
				"CMakeLists.txt",
				"package.json",
				"pom.xml",
				"build.gradle",
				"pyproject.toml",
				"setup.py",
				"setup.cfg",
				"requirements.txt",
				"Pipfile",
				"Cargo.toml",
				"go.mod",
				".project",
				".cproject",
			},

			-- Don't change directory when opening dashboard
			exclude_dirs = { "~/", "~/Downloads", "/tmp" },

			-- Show hidden files in telescope
			show_hidden = false,

			-- Don't echo messages when changing directory
			silent_chdir = true,

			-- Path to store project history
			datapath = vim.fn.stdpath("data"),
		},
	},
}

