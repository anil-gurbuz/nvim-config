return {
	"smoka7/multicursors.nvim",
	event = "VeryLazy",
	dependencies = {
		"smoka7/hydra.nvim",
	},
	opts = { nowait = false },
	cmd = { "MCstart", "MCvisual", "MCclear", "MCpattern", "MCvisualPattern", "MCunderCursor" },
	keys = {
		{
			mode = "v",
			"<leader>m",
			"<cmd>MCstart<cr>",
			desc = "Multi-Cursor",
		},
	},
}
