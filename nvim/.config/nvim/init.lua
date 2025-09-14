-- bootstrap lazy.nvim, LazyVim and your plugins
if vim.g.vscode then
	-- VSCode extension
	require("config.lazy")
	-- 	vim.api.nvim_exec(
	-- 		[[
	--     " THEME CHANGER
	--     function! SetCursorLineNrColorInsert(mode)
	--         " Insert mode: blue
	--         if a:mode == "i"
	--             call VSCodeNotify('nvim-theme.insert')
	--
	--         " Replace mode: red
	--         elseif a:mode == "r"
	--             call VSCodeNotify('nvim-theme.replace')
	--         endif
	--     endfunction
	--
	--     augroup CursorLineNrColorSwap
	--         autocmd!
	--         autocmd ModeChanged *:[vV\x16]* call VSCodeNotify('nvim-theme.visual')
	--         autocmd ModeChanged *:[R]* call VSCodeNotify('nvim-theme.replace')
	--         autocmd InsertEnter * call SetCursorLineNrColorInsert(v:insertmode)
	--         autocmd InsertLeave * call VSCodeNotify('nvim-theme.normal')
	--         autocmd CursorHold * call VSCodeNotify('nvim-theme.normal')
	--         autocmd ModeChanged [vV\x16]*:* call VSCodeNotify('nvim-theme.normal')
	--     augroup END
	-- ]],
	-- 		false
	-- 	)
	-- LazyVim.format.snacks_toggle = function()
	-- 	return { map = function() end }
	-- end
	-- _G.Snacks = {
	-- 	toggle = {
	--
	-- 		map = function() end, -- No-op for key mapping
	-- 		option = function()
	-- 			return { map = function() end }
	-- 		end,
	-- 		diagnostics = function()
	-- 			return { map = function() end }
	-- 		end,
	-- 		line_number = function()
	-- 			return { map = function() end }
	-- 		end,
	-- 		treesitter = function()
	-- 			return { map = function() end }
	-- 		end,
	-- 		inlay_hints = function()
	-- 			return { map = function() end }
	-- 		end,
	-- 	},
	-- }
else
	require("config.lazy")
	require("nvim-ts-autotag").setup({})
	vim.api.nvim_command("highlight LineNr guifg=#bae67e ctermfg=149")
	vim.api.nvim_command("highlight CursorLineNr guifg=#ef6b73 ctermfg=203")
	vim.api.nvim_command("highlight CursorLine guibg=#1C1C3E")
end
