return {
	"kylechui/nvim-surround",
	version = "*", -- Use for stability; omit to use `main` branch for the latest features
	event = "VeryLazy",
	config = function()
		require("nvim-surround").setup({

			-- the general rule is that if the key ends in "_line", the delimiter pair is added
			-- on new lines. If the key ends in "_cur", the surround is performed around the
			-- current line.
			keymaps = {
				-- insert = "<C-g>s",
				-- insert_line = "<C-g>S",
				normal = "ys",
				normal_cur = "yss",
				-- normal_line = "yS",
				-- normal_cur_line = "ySS",
				visual = "S",
				-- visual_line = "gS",
				delete = "ds",
				change = "cs",
				-- change_line = "cS",
			},
		})

		vim.keymap.del("i", "<C-g>s") -- insert
		vim.keymap.del("i", "<C-g>S") -- insert_line
		vim.keymap.del("n", "yS") -- normal_line
		vim.keymap.del("n", "ySS") -- normal_cur_line
		vim.keymap.del("v", "gS") -- visual_line
		vim.keymap.del("n", "cS") -- change_line
	end,
}
