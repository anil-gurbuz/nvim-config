local plugin = { "rmagatti/auto-session" }

function plugin.config()
	require("auto-session").setup({
		log_level = "error",
		auto_session_enabled = true, -- auto save and restore
		auto_session_create_enabled = true, --Main func -- autosave the session
		auto_save_enabled = nil, --can be true, false, nil
		auto_restore_enabled = nil, --can be true, false, nil
		auto_session_use_git_branch = nil, --can be true, false, nil
		-- auto_session_suppress_dirs = { "~/", "~/Downloads", "/"},
		session_lens = {
			buftypes_to_ignore = {},
			load_on_setup = true,
			theme_conf = { border = true },
			previewer = false,
		},
	})
	vim.keymap.set(
		"n",
		"<leader><C-s>",
		require("auto-session.session-lens").search_session,
		{ noremap = true, desc = "Serch Saved Sessions" }
	)
end

return plugin
