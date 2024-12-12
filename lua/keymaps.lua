vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- NOTE: Window navigation
--  See `:help wincmd` for a list of all window commands
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "which_key_ignore", silent = true })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "which_key_ignore", silent = true })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "which_key_ignore", silent = true })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "which_key_ignore", silent = true })

-- NOTE: Buffer navigation
vim.keymap.set("n", "<S-j>", ":bn<cr>", { desc = "which_key_ignore", silent = true })
vim.keymap.set("n", "<S-k>", ":bp<cr>", { desc = "which_key_ignore", silent = true })

-- NOTE: Window management
vim.keymap.set("n", "<C-b>+", "<C-w>+", { desc = "height ++" })
vim.keymap.set("n", "<C-b>-", "<C-w>-", { desc = "height --" })
vim.keymap.set("n", "<C-b>_", "<C-w>_", { desc = "Max height" })

vim.keymap.set("n", "<C-b><", "<C-w><", { desc = "width --" })
vim.keymap.set("n", "<C-b>>", "<C-w>>", { desc = "width ++" })
vim.keymap.set("n", "<C-b>|", "<C-w>|", { desc = "Max width" })

vim.keymap.set("n", "<C-b>=", "<C-w>=", { desc = "Equal heigh&width" })

vim.keymap.set("n", "<C-b>q", "<C-w>q", { desc = "Quit" })
vim.keymap.set("n", "<C-b>o", "<C-w>o", { desc = "Close all other windows" })

vim.keymap.set("n", "<C-b>s", "<C-w>s", { desc = "Horizontal split" })
vim.keymap.set("n", "<C-b>v", "<C-w>v", { desc = "Vertical split" })

vim.keymap.set("n", "<C-b>w", "<C-w>w", { desc = "Switch focus" })
vim.keymap.set("n", "<C-b>x", "<C-w>x", { desc = "Swap windows" })

vim.keymap.set("n", "<C-b>T", "<C-w>T", { desc = "To a new tab" })

vim.keymap.set("n", "<C-w>", ":bd<cr>:bp<cr>", { desc = "which_key_ignore" })
vim.keymap.set("n", "<leader><C-w>", ":bd!<cr>:bp<cr>", { desc = "Force Delete Current Buffer" })

-- NOTE: Misc
-- This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

vim.keymap.set("n", "<leader>q", "@", { desc = "Run the Macro ..." })
-- vim.keymap.set("n", "<leader>m", "`", { desc = "Move to Mark ..." })

vim.keymap.set("n", "<leader>a", "gg0vG$", { desc = "which_key_ignore" })

-- Allow pasting with <C-v> in command line mode
vim.cmd("cnoremap <C-v> <C-r>*")

-- NOTE: Motions
-- vim.keymap.set({ "n", "v" }, "gS{", "[{", { desc = "Previous {" })
-- vim.keymap.set({ "n", "v" }, "gs{", "]{", { desc = "Next {" })
--
-- vim.keymap.set({ "n", "v" }, "gS(", "[(", { desc = "Previous (" })
-- vim.keymap.set({ "n", "v" }, "gs(", "](", { desc = "Next (" })
--
-- vim.keymap.set({ "n", "v" }, "gS<lt>", "[<lt>", { desc = "Previous <" })
-- vim.keymap.set({ "n", "v" }, "gs<lt>", "]<lt>", { desc = "Next <" })
--
-- vim.keymap.set({ "n", "v" }, "gS%", "[%", { desc = "Previous unmached group" })
-- vim.keymap.set({ "n", "v" }, "gs%", "]%", { desc = "Next unmached group" })
--
vim.api.nvim_create_user_command("DiffOrig", function()
	local scratch_buffer = vim.api.nvim_create_buf(false, true)
	local current_ft = vim.bo.filetype
	vim.cmd("vertical sbuffer" .. scratch_buffer)
	vim.bo[scratch_buffer].filetype = current_ft
	vim.cmd("read ++edit #") -- load contents of previous buffer into scratch_buffer
	vim.cmd.normal('1G"_d_') -- delete extra newline at top of scratch_buffer without overriding register
	vim.cmd.diffthis() -- scratch_buffer
	vim.cmd.wincmd("p")
	vim.cmd.diffthis() -- current buffer
end, {})

-- Remove the default mark jumping mapping
-- vim.keymap.set("n", "<leader>m", "`", { desc = "Move to Mark ..." })
-- Swap global/local mark creation and jumping
for i = 0, 25 do
	local lower = string.char(97 + i) -- a-z
	local upper = string.char(65 + i) -- A-Z

	-- When using lowercase, set uppercase (global) mark
	vim.keymap.set("n", "m" .. lower, function()
		vim.cmd("mark " .. upper)
	end, { desc = "Set global mark " .. upper })

	-- When using uppercase, set lowercase (local) mark
	vim.keymap.set("n", "m" .. upper, function()
		vim.cmd("mark " .. lower)
	end, { desc = "Set local mark " .. lower })

	-- Jump to marks with leader
	vim.keymap.set("n", "<leader>m" .. lower, "`" .. upper, { desc = "Jump to global mark " .. upper })
	vim.keymap.set("n", "<leader>m" .. upper, "`" .. lower, { desc = "Jump to local mark " .. lower })
end
