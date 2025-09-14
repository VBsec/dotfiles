[Skip to main content](https://www.lazyvim.org/keymaps#__docusaurus_skipToContent_fallback)

On this page

# ⌨️ Keymaps

**LazyVim** uses [which-key.nvim](https://github.com/folke/which-key.nvim) to help you remember your
keymaps. Just press any key like `<space>` and you'll see a popup with all
possible keymaps starting with `<space>`.

![image](https://user-images.githubusercontent.com/292349/211862473-1ff5ee7a-3bb9-4782-a9f6-014f0e5d4474.png)

- default `<leader>` is `<space>`
- default `<localleader>` is `\`

## General [​](https://www.lazyvim.org/keymaps\#general "Direct link to General")

| Key | Description | Mode |
| --- | --- | --- |
| `j` | Down | **n**, **x** |
| `<Down>` | Down | **n**, **x** |
| `k` | Up | **n**, **x** |
| `<Up>` | Up | **n**, **x** |
| `<C-h>` | Go to Left Window | **n** |
| `<C-j>` | Go to Lower Window | **n** |
| `<C-k>` | Go to Upper Window | **n** |
| `<C-l>` | Go to Right Window | **n** |
| `<C-Up>` | Increase Window Height | **n** |
| `<C-Down>` | Decrease Window Height | **n** |
| `<C-Left>` | Decrease Window Width | **n** |
| `<C-Right>` | Increase Window Width | **n** |
| `<A-j>` | Move Down | **n**, **i**, **v** |
| `<A-k>` | Move Up | **n**, **i**, **v** |
| `<S-h>` | Prev Buffer | **n** |
| `<S-l>` | Next Buffer | **n** |
| `[b` | Prev Buffer | **n** |\
| `]b` | Next Buffer | **n** |
| `<leader>bb` | Switch to Other Buffer | **n** |
| ``<leader>` `` | Switch to Other Buffer | **n** |
| `<leader>bd` | Delete Buffer | **n** |
| `<leader>bo` | Delete Other Buffers | **n** |
| `<leader>bD` | Delete Buffer and Window | **n** |
| `<esc>` | Escape and Clear hlsearch | **i**, **n**, **s** |
| `<leader>ur` | Redraw / Clear hlsearch / Diff Update | **n** |
| `n` | Next Search Result | **n**, **x**, **o** |
| `N` | Prev Search Result | **n**, **x**, **o** |
| `<C-s>` | Save File | **i**, **x**, **n**, **s** |
| `<leader>K` | Keywordprg | **n** |
| `gco` | Add Comment Below | **n** |
| `gcO` | Add Comment Above | **n** |
| `<leader>l` | Lazy | **n** |
| `<leader>fn` | New File | **n** |
| `<leader>xl` | Location List | **n** |
| `<leader>xq` | Quickfix List | **n** |
| `[q` | Previous Quickfix | **n** |\
| `]q` | Next Quickfix | **n** |
| `<leader>cf` | Format | **n**, **v** |
| `<leader>cd` | Line Diagnostics | **n** |
| `]d` | Next Diagnostic | **n** |
| `[d` | Prev Diagnostic | **n** |\
| `]e` | Next Error | **n** |
| `[e` | Prev Error | **n** |\
| `]w` | Next Warning | **n** |
| `[w` | Prev Warning | **n** |\
| `<leader>uf` | Toggle Auto Format (Global) | **n** |\
| `<leader>uF` | Toggle Auto Format (Buffer) | **n** |\
| `<leader>us` | Toggle Spelling | **n** |\
| `<leader>uw` | Toggle Wrap | **n** |\
| `<leader>uL` | Toggle Relative Number | **n** |\
| `<leader>ud` | Toggle Diagnostics | **n** |\
| `<leader>ul` | Toggle Line Numbers | **n** |\
| `<leader>uc` | Toggle Conceal Level | **n** |\
| `<leader>uA` | Toggle Tabline | **n** |\
| `<leader>uT` | Toggle Treesitter Highlight | **n** |\
| `<leader>ub` | Toggle Dark Background | **n** |\
| `<leader>uD` | Toggle Dimming | **n** |\
| `<leader>ua` | Toggle Animations | **n** |\
| `<leader>ug` | Toggle Indent Guides | **n** |\
| `<leader>uS` | Toggle Smooth Scroll | **n** |\
| `<leader>dpp` | Toggle Profiler | **n** |\
| `<leader>dph` | Toggle Profiler Highlights | **n** |\
| `<leader>uh` | Toggle Inlay Hints | **n** |\
| `<leader>gb` | Git Blame Line | **n** |\
| `<leader>gB` | Git Browse (open) | **n**, **x** |\
| `<leader>gY` | Git Browse (copy) | **n**, **x** |\
| `<leader>qq` | Quit All | **n** |\
| `<leader>ui` | Inspect Pos | **n** |\
| `<leader>uI` | Inspect Tree | **n** |\
| `<leader>L` | LazyVim Changelog | **n** |\
| `<leader>fT` | Terminal (cwd) | **n** |\
| `<leader>ft` | Terminal (Root Dir) | **n** |\
| `<c-/>` | Terminal (Root Dir) | **n** |\
| `<c-_>` | which\_key\_ignore | **n**, **t** |\
| `<C-/>` | Hide Terminal | **t** |\
| `<leader>-` | Split Window Below | **n** |\
| `<leader>|` | Split Window Right | **n** |\
| `<leader>wd` | Delete Window | **n** |\
| `<leader>wm` | Toggle Zoom Mode | **n** |\
| `<leader>uZ` | Toggle Zoom Mode | **n** |\
| `<leader>uz` | Toggle Zen Mode | **n** |\
| `<leader><tab>l` | Last Tab | **n** |\
| `<leader><tab>o` | Close Other Tabs | **n** |\
| `<leader><tab>f` | First Tab | **n** |\
| `<leader><tab><tab>` | New Tab | **n** |\
| `<leader><tab>]` | Next Tab | **n** |
| `<leader><tab>d` | Close Tab | **n** |
| `<leader><tab>[` | Previous Tab | **n** |\
\
## LSP [​](https://www.lazyvim.org/keymaps\#lsp "Direct link to LSP")\
\
| Key | Description | Mode |\
| --- | --- | --- |\
| `<leader>cl` | Lsp Info | **n** |\
| `gd` | Goto Definition | **n** |\
| `gr` | References | **n** |\
| `gI` | Goto Implementation | **n** |\
| `gy` | Goto T\[y\]pe Definition | **n** |\
| `gD` | Goto Declaration | **n** |\
| `K` | Hover | **n** |\
| `gK` | Signature Help | **n** |\
| `<c-k>` | Signature Help | **i** |\
| `<leader>ca` | Code Action | **n**, **v** |\
| `<leader>cc` | Run Codelens | **n**, **v** |\
| `<leader>cC` | Refresh & Display Codelens | **n** |\
| `<leader>cR` | Rename File | **n** |\
| `<leader>cr` | Rename | **n** |\
| `<leader>cA` | Source Action | **n** |\
| `]]` | Next Reference | **n** |
| `[[` | Prev Reference | **n** |\
| `<a-n>` | Next Reference | **n** |\
| `<a-p>` | Prev Reference | **n** |\
\
## [bufferline.nvim](https://github.com/akinsho/bufferline.nvim.git) [​](https://www.lazyvim.org/keymaps\#bufferlinenvim "Direct link to bufferlinenvim")\
\
| Key | Description | Mode |\
| --- | --- | --- |\
| `<leader>bl` | Delete Buffers to the Left | **n** |\
| `<leader>bp` | Toggle Pin | **n** |\
| `<leader>bP` | Delete Non-Pinned Buffers | **n** |\
| `<leader>br` | Delete Buffers to the Right | **n** |\
| `[b` | Prev Buffer | **n** |\
| `[B` | Move buffer prev | **n** |\
| `]b` | Next Buffer | **n** |\
| `]B` | Move buffer next | **n** |\
| `<S-h>` | Prev Buffer | **n** |\
| `<S-l>` | Next Buffer | **n** |\
\
## [conform.nvim](https://github.com/stevearc/conform.nvim.git) [​](https://www.lazyvim.org/keymaps\#conformnvim "Direct link to conformnvim")\
\
| Key | Description | Mode |\
| --- | --- | --- |\
| `<leader>cF` | Format Injected Langs | **n**, **v** |\
\
## [flash.nvim](https://github.com/folke/flash.nvim.git) [​](https://www.lazyvim.org/keymaps\#flashnvim "Direct link to flashnvim")\
\
| Key | Description | Mode |\
| --- | --- | --- |\
| `<c-s>` | Toggle Flash Search | **c** |\
| `r` | Remote Flash | **o** |\
| `R` | Treesitter Search | **o**, **x** |\
| `s` | Flash | **n**, **o**, **x** |\
| `S` | Flash Treesitter | **n**, **o**, **x** |\
\
## [grug-far.nvim](https://github.com/MagicDuck/grug-far.nvim.git) [​](https://www.lazyvim.org/keymaps\#grug-farnvim "Direct link to grug-farnvim")\
\
| Key | Description | Mode |\
| --- | --- | --- |\
| `<leader>sr` | Search and Replace | **n**, **v** |\
\
## [mason.nvim](https://github.com/mason-org/mason.nvim.git) [​](https://www.lazyvim.org/keymaps\#masonnvim "Direct link to masonnvim")\
\
| Key | Description | Mode |\
| --- | --- | --- |\
| `<leader>cm` | Mason | **n** |\
\
## [noice.nvim](https://github.com/folke/noice.nvim.git) [​](https://www.lazyvim.org/keymaps\#noicenvim "Direct link to noicenvim")\
\
| Key | Description | Mode |\
| --- | --- | --- |\
| `<c-b>` | Scroll Backward | **n**, **i**, **s** |\
| `<c-f>` | Scroll Forward | **n**, **i**, **s** |\
| `<leader>sn` | +noice | **n** |\
| `<leader>sna` | Noice All | **n** |\
| `<leader>snd` | Dismiss All | **n** |\
| `<leader>snh` | Noice History | **n** |\
| `<leader>snl` | Noice Last Message | **n** |\
| `<leader>snt` | Noice Picker (Telescope/FzfLua) | **n** |\
| `<S-Enter>` | Redirect Cmdline | **c** |\
\
## [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter.git) [​](https://www.lazyvim.org/keymaps\#nvim-treesitter "Direct link to nvim-treesitter")\
\
| Key | Description | Mode |\
| --- | --- | --- |\
| `<bs>` | Decrement Selection | **x** |\
| `<c-space>` | Increment Selection | **n** |\
\
## [persistence.nvim](https://github.com/folke/persistence.nvim.git) [​](https://www.lazyvim.org/keymaps\#persistencenvim "Direct link to persistencenvim")\
\
| Key | Description | Mode |\
| --- | --- | --- |\
| `<leader>qd` | Don't Save Current Session | **n** |\
| `<leader>ql` | Restore Last Session | **n** |\
| `<leader>qs` | Restore Session | **n** |\
| `<leader>qS` | Select Session | **n** |\
\
## [snacks.nvim](https://github.com/folke/snacks.nvim.git) [​](https://www.lazyvim.org/keymaps\#snacksnvim "Direct link to snacksnvim")\
\
| Key | Description | Mode |\
| --- | --- | --- |\
| `<leader><space>` | Find Files (Root Dir) | **n** |\
| `<leader>,` | Buffers | **n** |\
| `<leader>.` | Toggle Scratch Buffer | **n** |\
| `<leader>/` | Grep (Root Dir) | **n** |\
| `<leader>:` | Command History | **n** |\
| `<leader>dps` | Profiler Scratch Buffer | **n** |\
| `<leader>e` | Explorer Snacks (root dir) | **n** |\
| `<leader>E` | Explorer Snacks (cwd) | **n** |\
| `<leader>fb` | Buffers | **n** |\
| `<leader>fB` | Buffers (all) | **n** |\
| `<leader>fc` | Find Config File | **n** |\
| `<leader>fe` | Explorer Snacks (root dir) | **n** |\
| `<leader>fE` | Explorer Snacks (cwd) | **n** |\
| `<leader>ff` | Find Files (Root Dir) | **n** |\
| `<leader>fF` | Find Files (cwd) | **n** |\
| `<leader>fg` | Find Files (git-files) | **n** |\
| `<leader>fp` | Projects | **n** |\
| `<leader>fr` | Recent | **n** |\
| `<leader>fR` | Recent (cwd) | **n** |\
| `<leader>gd` | Git Diff (hunks) | **n** |\
| `<leader>gs` | Git Status | **n** |\
| `<leader>gS` | Git Stash | **n** |\
| `<leader>n` | Notification History | **n** |\
| `<leader>S` | Select Scratch Buffer | **n** |\
| `<leader>s"` | Registers | **n** |\
| `<leader>s/` | Search History | **n** |\
| `<leader>sa` | Autocmds | **n** |\
| `<leader>sb` | Buffer Lines | **n** |\
| `<leader>sB` | Grep Open Buffers | **n** |\
| `<leader>sc` | Command History | **n** |\
| `<leader>sC` | Commands | **n** |\
| `<leader>sd` | Diagnostics | **n** |\
| `<leader>sD` | Buffer Diagnostics | **n** |\
| `<leader>sg` | Grep (Root Dir) | **n** |\
| `<leader>sG` | Grep (cwd) | **n** |\
| `<leader>sh` | Help Pages | **n** |\
| `<leader>sH` | Highlights | **n** |\
| `<leader>si` | Icons | **n** |\
| `<leader>sj` | Jumps | **n** |\
| `<leader>sk` | Keymaps | **n** |\
| `<leader>sl` | Location List | **n** |\
| `<leader>sm` | Marks | **n** |\
| `<leader>sM` | Man Pages | **n** |\
| `<leader>sp` | Search for Plugin Spec | **n** |\
| `<leader>sq` | Quickfix List | **n** |\
| `<leader>sR` | Resume | **n** |\
| `<leader>su` | Undotree | **n** |\
| `<leader>sw` | Visual selection or word (Root Dir) | **n**, **x** |\
| `<leader>sW` | Visual selection or word (cwd) | **n**, **x** |\
| `<leader>uC` | Colorschemes | **n** |\
| `<leader>un` | Dismiss All Notifications | **n** |\
\
## [todo-comments.nvim](https://github.com/folke/todo-comments.nvim.git) [​](https://www.lazyvim.org/keymaps\#todo-commentsnvim "Direct link to todo-commentsnvim")\
\
| Key | Description | Mode |\
| --- | --- | --- |\
| `<leader>st` | Todo | **n** |\
| `<leader>sT` | Todo/Fix/Fixme | **n** |\
| `<leader>xt` | Todo (Trouble) | **n** |\
| `<leader>xT` | Todo/Fix/Fixme (Trouble) | **n** |\
| `[t` | Previous Todo Comment | **n** |\
| `]t` | Next Todo Comment | **n** |\
\
## [trouble.nvim](https://github.com/folke/trouble.nvim.git) [​](https://www.lazyvim.org/keymaps\#troublenvim "Direct link to troublenvim")\
\
| Key | Description | Mode |\
| --- | --- | --- |\
| `<leader>cs` | Symbols (Trouble) | **n** |\
| `<leader>cS` | LSP references/definitions/... (Trouble) | **n** |\
| `<leader>xL` | Location List (Trouble) | **n** |\
| `<leader>xQ` | Quickfix List (Trouble) | **n** |\
| `<leader>xx` | Diagnostics (Trouble) | **n** |\
| `<leader>xX` | Buffer Diagnostics (Trouble) | **n** |\
| `[q` | Previous Trouble/Quickfix Item | **n** |\
| `]q` | Next Trouble/Quickfix Item | **n** |\
\
## [which-key.nvim](https://github.com/folke/which-key.nvim.git) [​](https://www.lazyvim.org/keymaps\#which-keynvim "Direct link to which-keynvim")\
\
| Key | Description | Mode |\
| --- | --- | --- |\
| `<c-w><space>` | Window Hydra Mode (which-key) | **n** |\
| `<leader>?` | Buffer Keymaps (which-key) | **n** |\
\
## [CopilotChat.nvim](https://github.com/CopilotC-Nvim/CopilotChat.nvim.git) [​](https://www.lazyvim.org/keymaps\#copilotchatnvim "Direct link to copilotchatnvim")\
\
Part of [lazyvim.plugins.extras.ai.copilot-chat](https://www.lazyvim.org/extras/ai/copilot-chat)\
\
| Key | Description | Mode |\
| --- | --- | --- |\
| `<c-s>` | Submit Prompt | **n** |\
| `<leader>a` | +ai | **n**, **v** |\
| `<leader>aa` | Toggle (CopilotChat) | **n**, **v** |\
| `<leader>ap` | Prompt Actions (CopilotChat) | **n**, **v** |\
| `<leader>aq` | Quick Chat (CopilotChat) | **n**, **v** |\
| `<leader>ax` | Clear (CopilotChat) | **n**, **v** |\
\
## [mini.surround](https://github.com/echasnovski/mini.surround.git) [​](https://www.lazyvim.org/keymaps\#minisurround "Direct link to minisurround")\
\
Part of [lazyvim.plugins.extras.coding.mini-surround](https://www.lazyvim.org/extras/coding/mini-surround)\
\
| Key | Description | Mode |\
| --- | --- | --- |\
| `gsa` | Add Surrounding | **n**, **v** |\
| `gsd` | Delete Surrounding | **n** |\
| `gsf` | Find Right Surrounding | **n** |\
| `gsF` | Find Left Surrounding | **n** |\
| `gsh` | Highlight Surrounding | **n** |\
| `gsn` | Update `MiniSurround.config.n_lines` | **n** |\
| `gsr` | Replace Surrounding | **n** |\
\
## [neogen](https://github.com/danymat/neogen.git) [​](https://www.lazyvim.org/keymaps\#neogen "Direct link to neogen")\
\
Part of [lazyvim.plugins.extras.coding.neogen](https://www.lazyvim.org/extras/coding/neogen)\
\
| Key | Description | Mode |\
| --- | --- | --- |\
| `<leader>cn` | Generate Annotations (Neogen) | **n** |\
\
## [yanky.nvim](https://github.com/gbprod/yanky.nvim.git) [​](https://www.lazyvim.org/keymaps\#yankynvim "Direct link to yankynvim")\
\
Part of [lazyvim.plugins.extras.coding.yanky](https://www.lazyvim.org/extras/coding/yanky)\
\
| Key | Description | Mode |\
| --- | --- | --- |\
| `<leader>p` | Open Yank History | **n**, **x** |\
| `<p` | Put and Indent Left | **n** |\
| `<P` | Put Before and Indent Left | **n** |\
| `=p` | Put After Applying a Filter | **n** |\
| `=P` | Put Before Applying a Filter | **n** |\
| `>p` | Put and Indent Right | **n** |\
| `>P` | Put Before and Indent Right | **n** |\
| `[p` | Put Indented Before Cursor (Linewise) | **n** |\
| `[P` | Put Indented Before Cursor (Linewise) | **n** |\
| `[y` | Cycle Forward Through Yank History | **n** |\
| `]p` | Put Indented After Cursor (Linewise) | **n** |\
| `]P` | Put Indented After Cursor (Linewise) | **n** |\
| `]y` | Cycle Backward Through Yank History | **n** |\
| `gp` | Put Text After Selection | **n**, **x** |\
| `gP` | Put Text Before Selection | **n**, **x** |\
| `p` | Put Text After Cursor | **n**, **x** |\
| `P` | Put Text Before Cursor | **n**, **x** |\
| `y` | Yank Text | **n**, **x** |\
\
## [nvim-dap](https://github.com/mfussenegger/nvim-dap.git) [​](https://www.lazyvim.org/keymaps\#nvim-dap "Direct link to nvim-dap")\
\
Part of [lazyvim.plugins.extras.dap.core](https://www.lazyvim.org/extras/dap/core)\
\
| Key | Description | Mode |\
| --- | --- | --- |\
| `<leader>da` | Run with Args | **n** |\
| `<leader>db` | Toggle Breakpoint | **n** |\
| `<leader>dB` | Breakpoint Condition | **n** |\
| `<leader>dc` | Run/Continue | **n** |\
| `<leader>dC` | Run to Cursor | **n** |\
| `<leader>dg` | Go to Line (No Execute) | **n** |\
| `<leader>di` | Step Into | **n** |\
| `<leader>dj` | Down | **n** |\
| `<leader>dk` | Up | **n** |\
| `<leader>dl` | Run Last | **n** |\
| `<leader>do` | Step Out | **n** |\
| `<leader>dO` | Step Over | **n** |\
| `<leader>dP` | Pause | **n** |\
| `<leader>dr` | Toggle REPL | **n** |\
| `<leader>ds` | Session | **n** |\
| `<leader>dt` | Terminate | **n** |\
| `<leader>dw` | Widgets | **n** |\
\
## [nvim-dap-ui](https://github.com/rcarriga/nvim-dap-ui.git) [​](https://www.lazyvim.org/keymaps\#nvim-dap-ui "Direct link to nvim-dap-ui")\
\
Part of [lazyvim.plugins.extras.dap.core](https://www.lazyvim.org/extras/dap/core)\
\
| Key | Description | Mode |\
| --- | --- | --- |\
| `<leader>de` | Eval | **n**, **v** |\
| `<leader>du` | Dap UI | **n** |\
\
## [aerial.nvim](https://github.com/stevearc/aerial.nvim.git) [​](https://www.lazyvim.org/keymaps\#aerialnvim "Direct link to aerialnvim")\
\
Part of [lazyvim.plugins.extras.editor.aerial](https://www.lazyvim.org/extras/editor/aerial)\
\
| Key | Description | Mode |\
| --- | --- | --- |\
| `<leader>cs` | Aerial (Symbols) | **n** |\
\
## [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim.git) [​](https://www.lazyvim.org/keymaps\#telescopenvim "Direct link to telescopenvim")\
\
Part of [lazyvim.plugins.extras.editor.aerial](https://www.lazyvim.org/extras/editor/aerial)\
\
| Key | Description | Mode |\
| --- | --- | --- |\
| `<leader>ss` | Goto Symbol (Aerial) | **n** |\
\
## [dial.nvim](https://github.com/monaqa/dial.nvim.git) [​](https://www.lazyvim.org/keymaps\#dialnvim "Direct link to dialnvim")\
\
Part of [lazyvim.plugins.extras.editor.dial](https://www.lazyvim.org/extras/editor/dial)\
\
| Key | Description | Mode |\
| --- | --- | --- |\
| `<C-a>` | Increment | **n**, **v** |\
| `<C-x>` | Decrement | **n**, **v** |\
| `g<C-a>` | Increment | **n**, **v** |\
| `g<C-x>` | Decrement | **n**, **v** |\
\
## [harpoon](https://github.com/ThePrimeagen/harpoon.git) [​](https://www.lazyvim.org/keymaps\#harpoon "Direct link to harpoon")\
\
Part of [lazyvim.plugins.extras.editor.harpoon2](https://www.lazyvim.org/extras/editor/harpoon2)\
\
| Key | Description | Mode |\
| --- | --- | --- |\
| `<leader>1` | Harpoon to File 1 | **n** |\
| `<leader>2` | Harpoon to File 2 | **n** |\
| `<leader>3` | Harpoon to File 3 | **n** |\
| `<leader>4` | Harpoon to File 4 | **n** |\
| `<leader>5` | Harpoon to File 5 | **n** |\
| `<leader>h` | Harpoon Quick Menu | **n** |\
| `<leader>H` | Harpoon File | **n** |\
\
## [vim-illuminate](https://github.com/RRethy/vim-illuminate.git) [​](https://www.lazyvim.org/keymaps\#vim-illuminate "Direct link to vim-illuminate")\
\
Part of [lazyvim.plugins.extras.editor.illuminate](https://www.lazyvim.org/extras/editor/illuminate)\
\
| Key | Description | Mode |\
| --- | --- | --- |\
| `[[` | Prev Reference | **n** |\
| `]]` | Next Reference | **n** |\
\
## [leap.nvim](https://github.com/ggandor/leap.nvim.git) [​](https://www.lazyvim.org/keymaps\#leapnvim "Direct link to leapnvim")\
\
Part of [lazyvim.plugins.extras.editor.leap](https://www.lazyvim.org/extras/editor/leap)\
\
| Key | Description | Mode |\
| --- | --- | --- |\
| `gs` | Leap from Windows | **n**, **o**, **x** |\
| `s` | Leap Forward to | **n**, **o**, **x** |\
| `S` | Leap Backward to | **n**, **o**, **x** |\
\
## [mini.surround](https://github.com/echasnovski/mini.surround.git) [​](https://www.lazyvim.org/keymaps\#minisurround-1 "Direct link to minisurround-1")\
\
Part of [lazyvim.plugins.extras.editor.leap](https://www.lazyvim.org/extras/editor/leap)\
\
| Key | Description | Mode |\
| --- | --- | --- |\
| `gz` | +surround | **n** |\
\
## [mini.diff](https://github.com/echasnovski/mini.diff.git) [​](https://www.lazyvim.org/keymaps\#minidiff "Direct link to minidiff")\
\
Part of [lazyvim.plugins.extras.editor.mini-diff](https://www.lazyvim.org/extras/editor/mini-diff)\
\
| Key | Description | Mode |\
| --- | --- | --- |\
| `<leader>go` | Toggle mini.diff overlay | **n** |\
\
## [mini.files](https://github.com/echasnovski/mini.files.git) [​](https://www.lazyvim.org/keymaps\#minifiles "Direct link to minifiles")\
\
Part of [lazyvim.plugins.extras.editor.mini-files](https://www.lazyvim.org/extras/editor/mini-files)\
\
| Key | Description | Mode |\
| --- | --- | --- |\
| `<leader>fm` | Open mini.files (Directory of Current File) | **n** |\
| `<leader>fM` | Open mini.files (cwd) | **n** |\
\
## [outline.nvim](https://github.com/hedyhli/outline.nvim.git) [​](https://www.lazyvim.org/keymaps\#outlinenvim "Direct link to outlinenvim")\
\
Part of [lazyvim.plugins.extras.editor.outline](https://www.lazyvim.org/extras/editor/outline)\
\
| Key | Description | Mode |\
| --- | --- | --- |\
| `<leader>cs` | Toggle Outline | **n** |\
\
## [overseer.nvim](https://github.com/stevearc/overseer.nvim.git) [​](https://www.lazyvim.org/keymaps\#overseernvim "Direct link to overseernvim")\
\
Part of [lazyvim.plugins.extras.editor.overseer](https://www.lazyvim.org/extras/editor/overseer)\
\
| Key | Description | Mode |\
| --- | --- | --- |\
| `<leader>ob` | Task builder | **n** |\
| `<leader>oc` | Clear cache | **n** |\
| `<leader>oi` | Overseer Info | **n** |\
| `<leader>oo` | Run task | **n** |\
| `<leader>oq` | Action recent task | **n** |\
| `<leader>ot` | Task action | **n** |\
| `<leader>ow` | Task list | **n** |\
\
## [refactoring.nvim](https://github.com/ThePrimeagen/refactoring.nvim.git) [​](https://www.lazyvim.org/keymaps\#refactoringnvim "Direct link to refactoringnvim")\
\
Part of [lazyvim.plugins.extras.editor.refactoring](https://www.lazyvim.org/extras/editor/refactoring)\
\
| Key | Description | Mode |\
| --- | --- | --- |\
| `<leader>r` | +refactor | **n**, **v** |\
| `<leader>rb` | Extract Block | **n** |\
| `<leader>rc` | Debug Cleanup | **n** |\
| `<leader>rf` | Extract Block To File | **n** |\
| `<leader>rf` | Extract Function | **v** |\
| `<leader>rF` | Extract Function To File | **v** |\
| `<leader>ri` | Inline Variable | **n**, **v** |\
| `<leader>rp` | Debug Print Variable | **n**, **v** |\
| `<leader>rP` | Debug Print | **n** |\
| `<leader>rs` | Refactor | **v** |\
| `<leader>rx` | Extract Variable | **v** |\
\
## [snacks.nvim](https://github.com/folke/snacks.nvim.git) [​](https://www.lazyvim.org/keymaps\#snacksnvim-1 "Direct link to snacksnvim-1")\
\
Part of [lazyvim.plugins.extras.editor.snacks\_explorer](https://www.lazyvim.org/extras/editor/snacks_explorer)\
\
| Key | Description | Mode |\
| --- | --- | --- |\
| `<leader>e` | Explorer Snacks (root dir) | **n** |\
| `<leader>E` | Explorer Snacks (cwd) | **n** |\
| `<leader>fe` | Explorer Snacks (root dir) | **n** |\
| `<leader>fE` | Explorer Snacks (cwd) | **n** |\
\
## [snacks.nvim](https://github.com/folke/snacks.nvim.git) [​](https://www.lazyvim.org/keymaps\#snacksnvim-2 "Direct link to snacksnvim-2")\
\
Part of [lazyvim.plugins.extras.editor.snacks\_picker](https://www.lazyvim.org/extras/editor/snacks_picker)\
\
| Key | Description | Mode |\
| --- | --- | --- |\
| `<leader><space>` | Find Files (Root Dir) | **n** |\
| `<leader>,` | Buffers | **n** |\
| `<leader>/` | Grep (Root Dir) | **n** |\
| `<leader>:` | Command History | **n** |\
| `<leader>fb` | Buffers | **n** |\
| `<leader>fB` | Buffers (all) | **n** |\
| `<leader>fc` | Find Config File | **n** |\
| `<leader>ff` | Find Files (Root Dir) | **n** |\
| `<leader>fF` | Find Files (cwd) | **n** |\
| `<leader>fg` | Find Files (git-files) | **n** |\
| `<leader>fp` | Projects | **n** |\
| `<leader>fr` | Recent | **n** |\
| `<leader>fR` | Recent (cwd) | **n** |\
| `<leader>gd` | Git Diff (hunks) | **n** |\
| `<leader>gs` | Git Status | **n** |\
| `<leader>gS` | Git Stash | **n** |\
| `<leader>n` | Notification History | **n** |\
| `<leader>s"` | Registers | **n** |\
| `<leader>s/` | Search History | **n** |\
| `<leader>sa` | Autocmds | **n** |\
| `<leader>sb` | Buffer Lines | **n** |\
| `<leader>sB` | Grep Open Buffers | **n** |\
| `<leader>sc` | Command History | **n** |\
| `<leader>sC` | Commands | **n** |\
| `<leader>sd` | Diagnostics | **n** |\
| `<leader>sD` | Buffer Diagnostics | **n** |\
| `<leader>sg` | Grep (Root Dir) | **n** |\
| `<leader>sG` | Grep (cwd) | **n** |\
| `<leader>sh` | Help Pages | **n** |\
| `<leader>sH` | Highlights | **n** |\
| `<leader>si` | Icons | **n** |\
| `<leader>sj` | Jumps | **n** |\
| `<leader>sk` | Keymaps | **n** |\
| `<leader>sl` | Location List | **n** |\
| `<leader>sm` | Marks | **n** |\
| `<leader>sM` | Man Pages | **n** |\
| `<leader>sp` | Search for Plugin Spec | **n** |\
| `<leader>sq` | Quickfix List | **n** |\
| `<leader>sR` | Resume | **n** |\
| `<leader>su` | Undotree | **n** |\
| `<leader>sw` | Visual selection or word (Root Dir) | **n**, **x** |\
| `<leader>sW` | Visual selection or word (cwd) | **n**, **x** |\
| `<leader>uC` | Colorschemes | **n** |\
\
## [todo-comments.nvim](https://github.com/folke/todo-comments.nvim.git) [​](https://www.lazyvim.org/keymaps\#todo-commentsnvim-1 "Direct link to todo-commentsnvim-1")\
\
Part of [lazyvim.plugins.extras.editor.snacks\_picker](https://www.lazyvim.org/extras/editor/snacks_picker)\
\
| Key | Description | Mode |\
| --- | --- | --- |\
| `<leader>st` | Todo | **n** |\
| `<leader>sT` | Todo/Fix/Fixme | **n** |\
\
## [nvim-ansible](https://github.com/mfussenegger/nvim-ansible.git) [​](https://www.lazyvim.org/keymaps\#nvim-ansible "Direct link to nvim-ansible")\
\
Part of [lazyvim.plugins.extras.lang.ansible](https://www.lazyvim.org/extras/lang/ansible)\
\
| Key | Description | Mode |\
| --- | --- | --- |\
| `<leader>ta` | Ansible Run Playbook/Role | **n** |\
\
## [markdown-preview.nvim](https://github.com/iamcco/markdown-preview.nvim.git) [​](https://www.lazyvim.org/keymaps\#markdown-previewnvim "Direct link to markdown-previewnvim")\
\
Part of [lazyvim.plugins.extras.lang.markdown](https://www.lazyvim.org/extras/lang/markdown)\
\
| Key | Description | Mode |\
| --- | --- | --- |\
| `<leader>cp` | Markdown Preview | **n** |\
\
## [nvim-dap-python](https://github.com/mfussenegger/nvim-dap-python.git) [​](https://www.lazyvim.org/keymaps\#nvim-dap-python "Direct link to nvim-dap-python")\
\
Part of [lazyvim.plugins.extras.lang.python](https://www.lazyvim.org/extras/lang/python)\
\
| Key | Description | Mode |\
| --- | --- | --- |\
| `<leader>dPc` | Debug Class | **n** |\
| `<leader>dPt` | Debug Method | **n** |\
\
## [vim-dadbod-ui](https://github.com/kristijanhusak/vim-dadbod-ui.git) [​](https://www.lazyvim.org/keymaps\#vim-dadbod-ui "Direct link to vim-dadbod-ui")\
\
Part of [lazyvim.plugins.extras.lang.sql](https://www.lazyvim.org/extras/lang/sql)\
\
| Key | Description | Mode |\
| --- | --- | --- |\
| `<leader>D` | Toggle DBUI | **n** |\
\
## [vimtex](https://github.com/lervag/vimtex.git) [​](https://www.lazyvim.org/keymaps\#vimtex "Direct link to vimtex")\
\
Part of [lazyvim.plugins.extras.lang.tex](https://www.lazyvim.org/extras/lang/tex)\
\
| Key | Description | Mode |\
| --- | --- | --- |\
| `<localLeader>l` | +vimtex | **n** |\
\
## [neotest](https://github.com/nvim-neotest/neotest.git) [​](https://www.lazyvim.org/keymaps\#neotest "Direct link to neotest")\
\
Part of [lazyvim.plugins.extras.test.core](https://www.lazyvim.org/extras/test/core)\
\
| Key | Description | Mode |\
| --- | --- | --- |\
| `<leader>t` | +test | **n** |\
| `<leader>tl` | Run Last (Neotest) | **n** |\
| `<leader>to` | Show Output (Neotest) | **n** |\
| `<leader>tO` | Toggle Output Panel (Neotest) | **n** |\
| `<leader>tr` | Run Nearest (Neotest) | **n** |\
| `<leader>ts` | Toggle Summary (Neotest) | **n** |\
| `<leader>tS` | Stop (Neotest) | **n** |\
| `<leader>tt` | Run File (Neotest) | **n** |\
| `<leader>tT` | Run All Test Files (Neotest) | **n** |\
| `<leader>tw` | Toggle Watch (Neotest) | **n** |\
\
## [nvim-dap](https://github.com/mfussenegger/nvim-dap.git) [​](https://www.lazyvim.org/keymaps\#nvim-dap-1 "Direct link to nvim-dap-1")\
\
Part of [lazyvim.plugins.extras.test.core](https://www.lazyvim.org/extras/test/core)\
\
| Key | Description | Mode |\
| --- | --- | --- |\
| `<leader>td` | Debug Nearest | **n** |\
\
## [edgy.nvim](https://github.com/folke/edgy.nvim.git) [​](https://www.lazyvim.org/keymaps\#edgynvim "Direct link to edgynvim")\
\
Part of [lazyvim.plugins.extras.ui.edgy](https://www.lazyvim.org/extras/ui/edgy)\
\
| Key | Description | Mode |\
| --- | --- | --- |\
| `<leader>ue` | Edgy Toggle | **n** |\
| `<leader>uE` | Edgy Select Window | **n** |\
\
## [chezmoi.nvim](https://github.com/xvzc/chezmoi.nvim.git) [​](https://www.lazyvim.org/keymaps\#chezmoinvim "Direct link to chezmoinvim")\
\
Part of [lazyvim.plugins.extras.util.chezmoi](https://www.lazyvim.org/extras/util/chezmoi)\
\
| Key | Description | Mode |\
| --- | --- | --- |\
| `<leader>sz` | Chezmoi | **n** |\
\
## [mason.nvim](https://github.com/mason-org/mason.nvim.git) [​](https://www.lazyvim.org/keymaps\#masonnvim-1 "Direct link to masonnvim-1")\
\
Part of [lazyvim.plugins.extras.util.gitui](https://www.lazyvim.org/extras/util/gitui)\
\
| Key | Description | Mode |\
| --- | --- | --- |\
| `<leader>gg` | GitUi (Root Dir) | **n** |\
| `<leader>gG` | GitUi (cwd) | **n** |\
\
## [octo.nvim](https://github.com/pwntester/octo.nvim.git) [​](https://www.lazyvim.org/keymaps\#octonvim "Direct link to octonvim")\
\
Part of [lazyvim.plugins.extras.util.octo](https://www.lazyvim.org/extras/util/octo)\
\
| Key | Description | Mode |\
| --- | --- | --- |\
| `<leader>gi` | List Issues (Octo) | **n** |\
| `<leader>gI` | Search Issues (Octo) | **n** |\
| `<leader>gp` | List PRs (Octo) | **n** |\
| `<leader>gP` | Search PRs (Octo) | **n** |\
| `<leader>gr` | List Repos (Octo) | **n** |\
| `<leader>gS` | Search (Octo) | **n** |\
| `<localleader>a` | +assignee (Octo) | **n** |\
| `<localleader>c` | +comment/code (Octo) | **n** |\
| `<localleader>g` | +goto\_issue (Octo) | **n** |\
| `<localleader>i` | +issue (Octo) | **n** |\
| `<localleader>l` | +label (Octo) | **n** |\
| `<localleader>p` | +pr (Octo) | **n** |\
| `<localleader>pr` | +rebase (Octo) | **n** |\
| `<localleader>ps` | +squash (Octo) | **n** |\
| `<localleader>r` | +react (Octo) | **n** |\
| `<localleader>v` | +review (Octo) | **n** |\
\
## [fzf-lua](https://github.com/ibhagwan/fzf-lua.git) [​](https://www.lazyvim.org/keymaps\#fzf-lua "Direct link to fzf-lua")\
\
Part of [lazyvim.plugins.extras.util.project](https://www.lazyvim.org/extras/util/project)\
\
| Key | Description | Mode |\
| --- | --- | --- |\
| `<leader>fp` | Projects | **n** |\
\
## [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim.git) [​](https://www.lazyvim.org/keymaps\#telescopenvim-1 "Direct link to telescopenvim-1")\
\
Part of [lazyvim.plugins.extras.util.project](https://www.lazyvim.org/extras/util/project)\
\
| Key | Description | Mode |\
| --- | --- | --- |\
| `<leader>fp` | Projects | **n** |\
\
## [kulala.nvim](https://github.com/mistweaverco/kulala.nvim.git) [​](https://www.lazyvim.org/keymaps\#kulalanvim "Direct link to kulalanvim")\
\
Part of [lazyvim.plugins.extras.util.rest](https://www.lazyvim.org/extras/util/rest)\
\
| Key | Description | Mode |\
| --- | --- | --- |\
| `<leader>R` | +Rest | **n** |\
| `<leader>Rb` | Open scratchpad | **n** |\
| `<leader>Rc` | Copy as cURL | **n** |\
| `<leader>RC` | Paste from curl | **n** |\
| `<leader>Rg` | Download GraphQL schema | **n** |\
| `<leader>Ri` | Inspect current request | **n** |\
| `<leader>Rn` | Jump to next request | **n** |\
| `<leader>Rp` | Jump to previous request | **n** |\
| `<leader>Rq` | Close window | **n** |\
| `<leader>Rr` | Replay the last request | **n** |\
| `<leader>Rs` | Send the request | **n** |\
| `<leader>RS` | Show stats | **n** |\
| `<leader>Rt` | Toggle headers/body | **n** |\
\
- [General](https://www.lazyvim.org/keymaps#general)\
- [LSP](https://www.lazyvim.org/keymaps#lsp)\
- [bufferline.nvim](https://www.lazyvim.org/keymaps#bufferlinenvim)\
- [conform.nvim](https://www.lazyvim.org/keymaps#conformnvim)\
- [flash.nvim](https://www.lazyvim.org/keymaps#flashnvim)\
- [grug-far.nvim](https://www.lazyvim.org/keymaps#grug-farnvim)\
- [mason.nvim](https://www.lazyvim.org/keymaps#masonnvim)\
- [noice.nvim](https://www.lazyvim.org/keymaps#noicenvim)\
- [nvim-treesitter](https://www.lazyvim.org/keymaps#nvim-treesitter)\
- [persistence.nvim](https://www.lazyvim.org/keymaps#persistencenvim)\
- [snacks.nvim](https://www.lazyvim.org/keymaps#snacksnvim)\
- [todo-comments.nvim](https://www.lazyvim.org/keymaps#todo-commentsnvim)\
- [trouble.nvim](https://www.lazyvim.org/keymaps#troublenvim)\
- [which-key.nvim](https://www.lazyvim.org/keymaps#which-keynvim)\
- [CopilotChat.nvim](https://www.lazyvim.org/keymaps#copilotchatnvim)\
- [mini.surround](https://www.lazyvim.org/keymaps#minisurround)\
- [neogen](https://www.lazyvim.org/keymaps#neogen)\
- [yanky.nvim](https://www.lazyvim.org/keymaps#yankynvim)\
- [nvim-dap](https://www.lazyvim.org/keymaps#nvim-dap)\
- [nvim-dap-ui](https://www.lazyvim.org/keymaps#nvim-dap-ui)\
- [aerial.nvim](https://www.lazyvim.org/keymaps#aerialnvim)\
- [telescope.nvim](https://www.lazyvim.org/keymaps#telescopenvim)\
- [dial.nvim](https://www.lazyvim.org/keymaps#dialnvim)\
- [harpoon](https://www.lazyvim.org/keymaps#harpoon)\
- [vim-illuminate](https://www.lazyvim.org/keymaps#vim-illuminate)\
- [leap.nvim](https://www.lazyvim.org/keymaps#leapnvim)\
- [mini.surround](https://www.lazyvim.org/keymaps#minisurround-1)\
- [mini.diff](https://www.lazyvim.org/keymaps#minidiff)\
- [mini.files](https://www.lazyvim.org/keymaps#minifiles)\
- [outline.nvim](https://www.lazyvim.org/keymaps#outlinenvim)\
- [overseer.nvim](https://www.lazyvim.org/keymaps#overseernvim)\
- [refactoring.nvim](https://www.lazyvim.org/keymaps#refactoringnvim)\
- [snacks.nvim](https://www.lazyvim.org/keymaps#snacksnvim-1)\
- [snacks.nvim](https://www.lazyvim.org/keymaps#snacksnvim-2)\
- [todo-comments.nvim](https://www.lazyvim.org/keymaps#todo-commentsnvim-1)\
- [nvim-ansible](https://www.lazyvim.org/keymaps#nvim-ansible)\
- [markdown-preview.nvim](https://www.lazyvim.org/keymaps#markdown-previewnvim)\
- [nvim-dap-python](https://www.lazyvim.org/keymaps#nvim-dap-python)\
- [vim-dadbod-ui](https://www.lazyvim.org/keymaps#vim-dadbod-ui)\
- [vimtex](https://www.lazyvim.org/keymaps#vimtex)\
- [neotest](https://www.lazyvim.org/keymaps#neotest)\
- [nvim-dap](https://www.lazyvim.org/keymaps#nvim-dap-1)\
- [edgy.nvim](https://www.lazyvim.org/keymaps#edgynvim)\
- [chezmoi.nvim](https://www.lazyvim.org/keymaps#chezmoinvim)\
- [mason.nvim](https://www.lazyvim.org/keymaps#masonnvim-1)\
- [octo.nvim](https://www.lazyvim.org/keymaps#octonvim)\
- [fzf-lua](https://www.lazyvim.org/keymaps#fzf-lua)\
- [telescope.nvim](https://www.lazyvim.org/keymaps#telescopenvim-1)\
- [kulala.nvim](https://www.lazyvim.org/keymaps#kulalanvim)