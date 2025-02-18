local plugin = {
	"gbprod/substitute.nvim",
	opts = {},
}

function plugin.config()
	require("substitute").setup({})
	-- Lua
	vim.keymap.set({ "v", "n" }, "gr", require("substitute").operator, { noremap = true, desc = "[G]o [R]eplace" })
	vim.keymap.set("n", "grr", require("substitute").line, { noremap = true, desc = "which_key_ignore" })
	--
	vim.keymap.set(
		{ "v", "n" },
		"sx",
		require("substitute.exchange").operator,
		{ noremap = true, desc = "[S]ubstitute e[X]change" }
	)
	vim.keymap.set(
		"n",
		"sxx",
		require("substitute.exchange").line,
		{ noremap = true, desc = "[S]ubstitut e[X]change line" }
	)
end
--
return plugin
