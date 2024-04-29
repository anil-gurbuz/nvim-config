local plugins = {
	"tpope/vim-sleuth", -- Detect tabstop and shiftwidth automatically
	{
		"numToStr/Comment.nvim",
		opts = {

			toggler = { line = "gcc", block = nil },
			opleader = { line = "gc", block = nil },
		},
	},
	{
		-- Theme inspired by Atom
		"navarasu/onedark.nvim",
		priority = 1000,
		config = function()
			vim.cmd.colorscheme("onedark")
		end,
	},

	{
		"folke/todo-comments.nvim",
		event = "VimEnter",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = { signs = false },
	},
	-- local plugins need to be explicitly configured with dir
	-- { dir = "~/Downloads/ReplaceWithRegister.vim" },

	-- you can use a custom url to fetch a plugin
	-- { url = "git@github.com:Julian/vim-textobj-variable-segment.git" },
	-- { url = "https://github.com/Julian/vim-textobj-variable-segment.git" },
	--
	{ -- Adds git related signs to the gutter, as well as utilities for managing changes
		"lewis6991/gitsigns.nvim",
		opts = {
			signs = {
				add = { text = "+" },
				change = { text = "~" },
				delete = { text = "_" },
				topdelete = { text = "‾" },
				changedelete = { text = "~" },
			},
		},
	},
}

return plugins
