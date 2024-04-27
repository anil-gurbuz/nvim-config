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
	python = { "ruff_format", "black", "isort" },
	javascript = { { "prettierd", "prettier" } },
}

return plugin
