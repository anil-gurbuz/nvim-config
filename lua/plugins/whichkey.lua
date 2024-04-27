local plugin = { "folke/which-key.nvim" }

plugin.event = "VeryLazy"

function plugin.config()
	local keymaps = {
		["<leader>l"] = { name = "[L]ayout", _ = "which_key_ignore" },
		["<leader>c"] = { name = "[C]ode", _ = "which_key_ignore" },
		["<leader>s"] = { name = "[S]earch", _ = "which_key_ignore" },
	}

	require("which-key").setup()
	require("which-key").register(keymaps)

	vim.keymap.set("n", "<leader>p", ":WhichKey<cr>", { desc = "[P]ossible Keys" })
end

return plugin

-- [";"] = { desc = "Repeat f, t, F or T N times" },
-- [","] = { desc = "Repeat f, t, F or T N times backwards" },
