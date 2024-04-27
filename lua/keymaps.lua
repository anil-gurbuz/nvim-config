vim.g.mapleader = " "
vim.g.maplocalleader = " "

--  See `:help wincmd` for a list of all window commands
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

-- Buffer navigation
vim.keymap.set("n", "<S-j>", ":bn<cr>", { desc = "Next Buffer" })
vim.keymap.set("n", "<S-k>", ":bp<cr>", { desc = "Previous Buffer" })

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

vim.keymap.set("n", "<C-w>", ":bd<cr>:bp<cr>", { desc = "Delete Current Buffer" })
vim.keymap.set("n", "<leader><C-w>", ":bd!<cr>:bp<cr>", { desc = "Force Delete Current Buffer" })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

vim.keymap.set("n", "<leader>q", "@", { desc = "Run the Macro ..." })
vim.keymap.set("n", "<leader>m", "`", { desc = "Move to Mark ..." })

vim.keymap.set("n", "<leader>a", "gg0vG$", { desc = "Select whole buffer" })
