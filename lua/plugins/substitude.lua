local plugin = {
	"gbprod/substitute.nvim",
	opts = {},
}

function plugin.config()
	require("substitute").setup({})
	-- Lua
	vim.keymap.set("n", "gr", require("substitute").operator, { noremap = true })
	vim.keymap.set("n", "grr", require("substitute").line, { noremap = true })
	--
	vim.keymap.set("n", "sx", require("substitute.exchange").operator, { noremap = true })
	vim.keymap.set("n", "sxx", require("substitute.exchange").line, { noremap = true })
end
--
return plugin
