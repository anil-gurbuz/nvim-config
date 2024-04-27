local plugin = { "Vigemus/iron.nvim" }
-- plugin.tag = 'v3.0'

function plugin.config()
	local configuration_options = {}
	configuration_options.scratch_repl = false -- if true cant be buflisted so pretty much those 2 are same things
	configuration_options.buflisted = true
	configuration_options.close_window_on_exit = true
	configuration_options.repl_definition = { python = require("iron.fts.python").ipython } -- Turns out ptpython also has nice features like autocomplition
	-- configuration_options.should_map_plug = true -- lets remapping of shortcuts
	configuration_options.repl_open_cmd = ""

	local keymaps = {
		send_line = "<leader>e",
		visual_send = "<leader>e",
	}
	local iron = require("iron.core")
	iron.setup({ config = configuration_options, keymaps = keymaps }) -- highlight = {italic = true}, ignore_blank_lines = true

	local ftype = "python" -- NOTE: ASSUMES PYTHON ONLY
	vim.keymap.set("n", "<leader>rr", "<cmd>IronRestart<cr>", { desc = "[R]EPL [R]estart" })
	vim.keymap.set("n", "<leader>ri", function()
		iron.send(nil, string.char(03))
	end, { desc = "[R]EPL [I]nterrupt" })
	vim.keymap.set("n", "<leader>rc", function()
		iron.send(nil, string.char(12))
	end, { desc = "[R]EPL [C]lear" })
	vim.keymap.set("n", "<leader>rs", function()
		iron.repl_here(ftype)
	end, { desc = "[R]EPL [S]tart" })
end

return plugin
