local plugin = { "folke/which-key.nvim" }

plugin.event = "VeryLazy"

function plugin.config()
	local keymaps = {
		["<leader>l"] = { name = "[L]ayout", _ = "which_key_ignore" },
		["<leader>c"] = { name = "[C]ode", _ = "which_key_ignore" },
		["<leader>s"] = { name = "[S]earch", _ = "which_key_ignore" },
		["<leader>d"] = { name = "[D]ebugger", _ = "which_key_ignore" },
		["<leader>r"] = { name = "[R]EPL", _ = "which_key_ignore" },
		["<leader>j"] = { name = "[J]droid", _ = "which_key_ignore" },
		["<leader>jv"] = { name = "[J]droid [V]isual", _ = "which_key_ignore" },
		["<leader>jm"] = { name = "[J]droid [M]odel", _ = "which_key_ignore" },
		["<leader>jn"] = { name = "[J]droid [N]ormal", _ = "which_key_ignore" },
		["ys"] = { name = "Add [S]urround" },
		["ds"] = { name = "[D]elete [S]urround" },
		["cs"] = { name = "[C]hange [S]urround" },

		z = {
			["<CR>"] = "which_key_ignore",
			o = "which_key_ignore",
			O = "which_key_ignore",
			c = "which_key_ignore",
			C = "which_key_ignore",
			M = "which_key_ignore",
			R = "which_key_ignore",
			m = "which_key_ignore",
			r = "which_key_ignore",
			x = "which_key_ignore",
			z = "which_key_ignore",
			t = "which_key_ignore",
			b = "which_key_ignore",
			e = "which_key_ignore",
			s = "which_key_ignore",
			H = "which_key_ignore",
			L = "which_key_ignore",
		},

		-- ["[{"] = "which_key_ignore",
		-- ["[("] = "which_key_ignore",
		-- ["[<lt>"] = "which_key_ignore",
		-- ["[m"] = "which_key_ignore",
		-- ["[M"] = "which_key_ignore",
		-- ["[%"] = "which_key_ignore",
		-- ["]{"] = "which_key_ignore",
		-- ["]("] = "which_key_ignore",
		-- ["]<lt>"] = "which_key_ignore",
		-- ["]m"] = "which_key_ignore",
		-- ["]M"] = "which_key_ignore",
		-- ["]%"] = "which_key_ignore",
		["H"] = "which_key_ignore",
		["M"] = "which_key_ignore",
		["L"] = "which_key_ignore",

		["gf"] = "which_key_ignore",
		["gx"] = "which_key_ignore",
		["gn"] = "which_key_ignore",
		["gN"] = "which_key_ignore",
		["g%"] = "which_key_ignore",
	}

	local presets = require("which-key.plugins.presets")

	presets.operators["d"] = "which_key_ignore"
	presets.operators["c"] = "which_key_ignore"
	presets.operators["y"] = "which_key_ignore"
	presets.operators["gu"] = "which_key_ignore"
	presets.operators["gU"] = "which_key_ignore"
	presets.operators["!"] = "which_key_ignore"
	presets.operators["v"] = "which_key_ignore"

	presets.motions["h"] = "which_key_ignore"
	presets.motions["j"] = "which_key_ignore"
	presets.motions["k"] = "which_key_ignore"
	presets.motions["l"] = "which_key_ignore"
	presets.motions["w"] = "which_key_ignore"
	presets.motions["0"] = "which_key_ignore"
	presets.motions["$"] = "which_key_ignore"
	presets.motions["gg"] = "which_key_ignore"
	presets.motions["G"] = "which_key_ignore"

	-- presets.objects["a'"] = "which_key_ignore"
	presets.text_objects["a'"] = "which_key_ignore"
	presets.text_objects["a("] = "which_key_ignore"
	presets.text_objects["a)"] = "which_key_ignore"
	presets.text_objects["aW"] = "which_key_ignore"
	presets.text_objects["a["] = "which_key_ignore"
	presets.text_objects["a]"] = "which_key_ignore"
	presets.text_objects["a`"] = "which_key_ignore"
	presets.text_objects["aw"] = "which_key_ignore"
	presets.text_objects["a{"] = "which_key_ignore"
	presets.text_objects["a}"] = "which_key_ignore"
	presets.text_objects['i"'] = "which_key_ignore"
	presets.text_objects["i'"] = "which_key_ignore"
	presets.text_objects["i("] = "which_key_ignore"
	presets.text_objects["i)"] = "which_key_ignore"
	presets.text_objects["iW"] = "which_key_ignore"
	presets.text_objects["i["] = "which_key_ignore"
	presets.text_objects["i]"] = "which_key_ignore"
	presets.text_objects["i`"] = "which_key_ignore"
	presets.text_objects["iw"] = "which_key_ignore"
	presets.text_objects["i{"] = "which_key_ignore"
	presets.text_objects["i}"] = "which_key_ignore"

	require("which-key").setup()
	require("which-key").register(keymaps)
	vim.keymap.set("n", "<leader>p", ":WhichKey<cr>", { desc = "[P]ossible Keys" })
	vim.keymap.set("n", "<leader>pv", ":WhichKey '' v<cr>", { desc = "[P]ossible [V]isual Mode Keys" })
end

return plugin

-- [";"] = { desc = "Repeat f, t, F or T N times" },
-- [","] = { desc = "Repeat f, t, F or T N times backwards" },
