local plugin = { "rmagatti/auto-session" }

function plugin.config()
	require("auto-session").setup({
		log_level = "error",
		auto_session_enabled = true, -- auto save and restore
		auto_session_create_enabled = true, --Main func -- autosave the session
		auto_save_enabled = true, --can be true, false, nil
		auto_restore_enabled = true, --can be true, false, nil
		auto_session_use_git_branch = true, --can be true, false, nil
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
		{ noremap = true, desc = "Search Saved Sessions" }
	)

	-- Add command to delete sessions
	vim.api.nvim_create_user_command("SessionDelete", function()
		-- Get the session dir from auto-session config
		local auto_session = require("auto-session")
		local session_dir = auto_session.get_root_dir()

		-- Function to delete a session file directly without confirmation
		local function delete_session(session_file)
			vim.fn.delete(session_file)
			vim.notify("Session deleted: " .. vim.fn.fnamemodify(session_file, ":t"), vim.log.levels.INFO)
		end

		-- Use telescope to select and delete sessions
		require("telescope.builtin").find_files({
			prompt_title = "Select Session to Delete",
			cwd = session_dir,
			attach_mappings = function(prompt_bufnr, map)
				-- Custom action to delete a session file without closing the picker
				local delete_session_action = function()
					local selection = require("telescope.actions.state").get_selected_entry(prompt_bufnr)
					if selection then
						local session_file = selection.path

						-- Delete the file
						delete_session(session_file)

						-- Remove the selection from the picker results
						local actions_state = require("telescope.actions.state")
						local picker = actions_state.get_current_picker(prompt_bufnr)
						picker:delete_selection(function() end)
					end
					return true
				end

				-- Map Enter in insert mode to delete session
				map("i", "<CR>", delete_session_action)

				-- Map dd in normal mode to delete session (consistent with your global telescope config)
				map("n", "dd", delete_session_action)

				-- Open session with Enter in normal mode
				map("n", "<CR>", function()
					local selection = require("telescope.actions.state").get_selected_entry(prompt_bufnr)
					require("telescope.actions").close(prompt_bufnr)

					if selection then
						-- Load the selected session
						require("auto-session").RestoreSession(selection.path)
					end
					return true
				end)

				return true
			end,
		})
	end, {})

	-- Add keybinding for deleting sessions
	vim.keymap.set("n", "<leader><C-d>", function()
		vim.cmd("SessionDelete")
	end, { noremap = true, desc = "Delete Saved Session" })
end

return plugin
