vim.opt.nu = true -- line number
vim.opt.relativenumber = true -- relative line numbers
vim.opt.clipboard = "unnamedplus"

-- disable netrw (default nvim file explorer) to avoid problems with nvim-tree
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
-- optionally enable 24-bit colour
vim.opt.termguicolors = true

-- Mouse is usuable in [a]ll modes
vim.opt.mouse = "a"

-- Wrapped lines are indented just like the first line -- improved readability
vim.opt.breakindent = true

-- Access undo history even after closing and reopening nvim
vim.opt.undofile = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Keep signcolumn (column before the line numbers that shows git, error infor etc.)
vim.opt.signcolumn = "yes"

-- Decrease update time from default 400 -- Time for no activity until swap file is written to disk
vim.opt.updatetime = 250

-- Decrease mapped sequence wait time
-- Displays which-key popup sooner
vim.opt.timeoutlen = 300

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Sets how neovim will display certain whitespace characters in the editor.
vim.opt.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

-- Highlights the line that cursor is at
vim.opt.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 10

-- Set highlight on search, but clear on pressing <Esc> in normal mode
vim.opt.hlsearch = true
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

vim.opt.autoindent = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true

-- For a better experience with autosessions
vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"

-- vim.wo.foldexpr = "nvim_treesitter#foldexpr()"
-- vim.wo.foldtext = [[v:lua.FirstLineFoldText()]]
-- _G.FirstLineFoldText = function()
-- 	local line = vim.fn.getline(vim.v.foldstart)
-- 	return line
-- end
--

-- vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
-- vim.opt.foldtext = "v:lua.vim.treesitter.foldtext()"
