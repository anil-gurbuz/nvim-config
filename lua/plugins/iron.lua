local plugin = { "Vigemus/iron.nvim" }
-- plugin.tag = 'v3.0'

function plugin.config()
	local configuration_options = {}
	configuration_options.scratch_repl = false -- if true cant be buflisted so pretty much those 2 are same things
	configuration_options.buflisted = true
	configuration_options.close_window_on_exit = true
	configuration_options.repl_definition = {
		python = require("iron.fts.python").ipython,

		-- Command to run below :IronRepl django
		django = {
			command = function()
				local venv = vim.fn.environ()["VIRTUAL_ENV"]
				if venv then
					return { vim.fn.resolve(venv .. "/bin/python"), "manage.py", "shell", "-i", "ipython" }
				else
					return { "python", "manage.py", "shell", "-i", "ipython" }
				end
			end,
		},

		-- Node.js REPL configuration
		-- Node.js REPL configuration
		javascript = {
			command = function()
				local history_file = vim.fn.expand("~/.node_repl_history")
				local config_file = vim.fn.expand("~/.config/nvim/lua/node_repl_init.js")
				return {
					"node",
					"--experimental-repl-await", -- Enable top-level await
					config_file,
					history_file,
				}
			end,
		},
	} -- Turns out ptpython also has nice features like autocomplition
	-- configuration_options.should_map_plug = true -- lets remapping of shortcuts
	configuration_options.repl_open_cmd = ""

	local keymaps = {
		send_line = "<leader>e",
		visual_send = "<leader>e",
	}
	local iron = require("iron.core")
	iron.setup({ config = configuration_options, keymaps = keymaps }) -- highlight = {italic = true}, ignore_blank_lines = true

	-- Function to determine REPL type based on filetype
	local function get_repl_type()
		local ft = vim.bo.filetype
		if ft == "javascript" or ft == "javascriptreact" or ft == "typescript" or ft == "typescriptreact" then
			return "javascript"
		elseif ft == "python" then
			return "python"
		else
			return "python" -- default fallback
		end
	end

	vim.keymap.set("n", "<leader>rr", "<cmd>IronRestart<cr>", { desc = "[R]EPL [R]estart" })
	vim.keymap.set("n", "<leader>ri", function()
		iron.send(nil, string.char(03))
	end, { desc = "[R]EPL [I]nterrupt" })
	vim.keymap.set("n", "<leader>rc", function()
		iron.send(nil, string.char(12))
	end, { desc = "[R]EPL [C]lear" })
	vim.keymap.set("n", "<leader>rs", function()
		local ftype = get_repl_type()
		iron.repl_here(ftype)
	end, { desc = "[R]EPL [S]tart" })
end

return plugin
