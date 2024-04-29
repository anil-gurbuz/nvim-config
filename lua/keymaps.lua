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
vim.keymap.set("n", "<C-v>+", "<C-w>+", { desc = "height ++" })
vim.keymap.set("n", "<C-v>-", "<C-w>-", { desc = "height --" })
vim.keymap.set("n", "<C-v>_", "<C-w>_", { desc = "Max height" })

vim.keymap.set("n", "<C-v><", "<C-w><", { desc = "width --" })
vim.keymap.set("n", "<C-v>>", "<C-w>>", { desc = "width ++" })
vim.keymap.set("n", "<C-v>|", "<C-w>|", { desc = "Max width" })

vim.keymap.set("n", "<C-v>=", "<C-w>=", { desc = "Equal heigh&width" })

vim.keymap.set("n", "<C-v>q", "<C-w>q", { desc = "Quit" })
vim.keymap.set("n", "<C-v>o", "<C-w>o", { desc = "Close all other windows" })

vim.keymap.set("n", "<C-v>s", "<C-w>s", { desc = "Horizontal split" })
vim.keymap.set("n", "<C-v>v", "<C-w>v", { desc = "Vertical split" })

vim.keymap.set("n", "<C-v>w", "<C-w>w", { desc = "Switch focus" })
vim.keymap.set("n", "<C-v>x", "<C-w>x", { desc = "Swap windows" })

vim.keymap.set("n", "<C-v>T", "<C-w>T", { desc = "To a new tab" })

vim.keymap.set("n", "<C-w>", ":bd<cr>:bp<cr>", { desc = "which_key_ignore" })
vim.keymap.set("n", "<leader><C-w>", ":bd!<cr>:bp<cr>", { desc = "Force Delete Current Buffer" })

-- NOTE: Misc
-- This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

vim.keymap.set("n", "<leader>q", "@", { desc = "Run the Macro ..." })
vim.keymap.set("n", "<leader>m", "`", { desc = "Move to Mark ..." })

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
