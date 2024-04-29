function _G.dump(...)
	local objects = vim.tbl_map(vim.inspect, { ... })
	print(unpack(objects))
end

local plugin = { "nvim-telescope/telescope.nvim" }
plugin.event = "VimEnter"
plugin.branch = "0.1.x"

plugin.dependencies =
	{ "nvim-lua/plenary.nvim", "nvim-telescope/telescope-ui-select.nvim", "nvim-tree/nvim-web-devicons" } -- if web-deviconds doesn't work add enabled=true

local extra_dependency = { "nvim-telescope/telescope-fzf-native.nvim" }
extra_dependency.build = "make"
extra_dependency.cond = function()
	return vim.fn.executable("make") == 1
end

table.insert(plugin.dependencies, extra_dependency)

function plugin.config()
	local configuration_options = {}
	configuration_options.defaults = {}
	configuration_options.defaults.mappings = {}
	configuration_options.defaults.mappings.n = { ["dd"] = require("telescope.actions").delete_buffer }
	configuration_options.extensions = { ["ui-select"] = { require("telescope.themes").get_dropdown() } }

	require("telescope").setup(configuration_options)

	pcall(require("telescope").load_extension, "fzf")
	pcall(require("telescope").load_extension, "ui-select")

	local builtin = require("telescope.builtin")
	vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "[S]earch [H]elp" })
	vim.keymap.set("n", "<leader>sk", builtin.keymaps, { desc = "[S]earch [K]eymaps" })
	vim.keymap.set("n", "<leader>sf", builtin.find_files, { desc = "[S]earch [F]iles" })
	vim.keymap.set("n", "<leader>sw", builtin.grep_string, { desc = "[S]earch current [W]ord" })
	vim.keymap.set("n", "<leader>sg", builtin.live_grep, { desc = "[S]earch by [G]rep" })
	vim.keymap.set("n", "<leader>sd", builtin.diagnostics, { desc = "[S]earch [D]iagnostics" })
	vim.keymap.set("n", "<leader>s.", builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
	vim.keymap.set("n", "<leader>sr", builtin.resume, { desc = "[S]earch [R]esume" })
	vim.keymap.set("n", "<leader><leader>", builtin.buffers, { desc = "[ ] Find existing buffers" })
	vim.keymap.set("n", "<leader>sn", function()
		builtin.find_files({ cwd = vim.fn.stdpath("config") })
	end, { desc = "[S]earch [N]eovim files" })

	local function lvgrp()
		builtin.live_grep({ grep_open_files = true, prompt_title = "Live Grep in Open Files" })
	end
	vim.keymap.set("n", "<leader>s/", lvgrp, { desc = "[S]earch [/] in Open Files" })
end

return plugin
