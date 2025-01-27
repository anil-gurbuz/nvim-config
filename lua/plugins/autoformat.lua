local plugin = { "stevearc/conform.nvim" }

plugin.lazy = false

plugin.keys = {
	{
		"<leader>cf",
		function()
			require("conform").format({ async = true, lsp_fallback = true })
		end,
		mode = "",
		desc = "[C]ode [F]ormat",
	},
}

plugin.opts = {}
plugin.opts.notify_on_error = false
function plugin.opts.format_on_save(bufnr)
	local disable_filetypes = { c = true, cpp = true }
	return { timout_ms = 500, lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype] }
end

plugin.opts.formatters_by_ft = {
	lua = { "stylua" },
	python = { "autopep8", "isort" },
	javascript = { "prettierd", "prettier" },
	vue = { "prettierd", "prettier" },
}

plugin.opts.formatters = {
	autopep8 = {
		inherit = true,
		debug = true, -- This will show the command being run
	},
}

-- Add logging for format events
plugin.init = function()
	-- Create a log buffer if it doesn't exist
	local function get_log_buffer()
		local name = "Conform Format Log"
		for _, buf in ipairs(vim.api.nvim_list_bufs()) do
			if vim.api.nvim_buf_get_name(buf):match(name) then
				return buf
			end
		end

		-- Create new buffer if not found
		local buf = vim.api.nvim_create_buf(false, true)
		vim.api.nvim_buf_set_name(buf, name)
		return buf
	end

	-- Log to buffer function
	local function log_to_buffer(msg)
		local buf = get_log_buffer()
		local lines = vim.split(msg, "\n")
		local timestamp = os.date("%H:%M:%S")
		local formatted_lines = {}
		for _, line in ipairs(lines) do
			table.insert(formatted_lines, string.format("[%s] %s", timestamp, line))
		end
		vim.api.nvim_buf_set_lines(buf, -1, -1, false, formatted_lines)
	end

	-- Create a custom notification function
	local function notify_formatters()
		local conform = require("conform")
		local formatters = conform.list_formatters(0)
		if #formatters > 0 then
			local formatter_names = vim.tbl_map(function(f)
				return f.name
			end, formatters)
			local current_file = vim.fn.expand("%:t")
			local msg =
				string.format("File: %s | Formatting with: %s", current_file, table.concat(formatter_names, ", "))

			-- Log to buffer
			log_to_buffer(msg)

			-- Show notification
			vim.notify(msg, vim.log.levels.INFO, {
				title = "Conform.nvim",
				timeout = 5000, -- Message will stay for 5 seconds
			})
		end
	end

	vim.api.nvim_create_autocmd("BufWritePre", {
		callback = notify_formatters,
	})

	-- Command to show formatters
	vim.api.nvim_create_user_command("ConformInfo", notify_formatters, {
		desc = "Show current formatters",
	})

	-- Command to show log buffer
	vim.api.nvim_create_user_command("ConformLog", function()
		local buf = get_log_buffer()
		-- Open in a split window
		vim.cmd("split")
		vim.api.nvim_win_set_buf(0, buf)
	end, {
		desc = "Show format log",
	})
end

return plugin
