local plugin = {
	"nvim-treesitter/nvim-treesitter-textobjects",
	after = "nvim-treesitter",
	requires = "nvim-treesitter/nvim-treesitter",
}

function plugin.config()
	require("nvim-treesitter.configs").setup({
		textobjects = {
			select = {
				enable = true,

				-- Automatically jump forward to textobj, similar to targets.vim
				lookahead = true,

				keymaps = {
					-- You can use the capture groups defined in textobjects.scm
					["if"] = { query = "@function.inner", desc = "Select [I]nner [F]unction" },
					["af"] = { query = "@function.outer", desc = "Select [A] [F]unction" },
					["ic"] = { query = "@class.inner", desc = "Select [I]nner [C]lass" },
					["ac"] = { query = "@class.outer", desc = "Select [A] [C]lass" },
					-- You can also use captures from other query groups like `locals.scm`
					["as"] = { query = "@scope", query_group = "locals", desc = "Select [A] [S]cope" },
				},
				selection_modes = {
					["@parameter.outer"] = "v", -- charwise
					["@function.outer"] = "V", -- linewise
					["@class.outer"] = "v", --"<c-v>", -- blockwise
				},
				include_surrounding_whitespace = true,
			},
			move = {
				enable = true,
				set_jumps = false,
				goto_next_start = {
					["gsf"] = { query = "@function.outer", desc = "[G]o [S]tart [F]unction" },
					["gsc"] = { query = "@class.outer", desc = "[G]o [S]tart [C]lass" },
					["gss"] = { query = "@scope", query_group = "locals", desc = "[G]o [S]tart [S]cope" },
					["gsz"] = { query = "@fold", query_group = "folds", desc = "[G]o [S]tart [Z]old" },
				},
				goto_next_end = {},
				goto_previous_start = {
					["gSf"] = { query = "@function.outer", desc = "Go Previous [F]unction" },
					["gSc"] = { query = "@class.outer", desc = "Go Previous [C]lass" },
					["gSs"] = { query = "@scope", query_group = "locals", desc = "Go Previous [S]cope" },
					["gSz"] = { query = "@fold", query_group = "folds", desc = "Go Previous [Z]old" },
				},
				goto_previous_end = {},
			},
		},
	})
end

return plugin
