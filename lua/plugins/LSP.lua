function _G.dump(...)
	local objects = vim.tbl_map(vim.inspect, { ... })
	print(unpack(objects))
end

local plugin = { "neovim/nvim-lspconfig" }

plugin.dependencies = {
	{ "williamboman/mason.nvim", config = true }, -- NOTE: Must be loaded before dependants
	"williamboman/mason-lspconfig.nvim",
	"WhoIsSethDaniel/mason-tool-installer.nvim",
	{ "j-hui/fidget.nvim", opts = {} }, -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
	{ "folke/neodev.nvim", opts = {} },
	"hrsh7th/cmp-nvim-lsp",
}

function attachment_callback(event)
	-- Everytime LspAttach event occurs, this function will be executed --- So everythime a new buffer opened and there is a LSP for the file type.
	-- Event will be LspAttach

	-- helper function
	local map = function(keys, func, desc)
		vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
	end

	map("gD", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")
	map("gR", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")

	map("<leader>cs", require("telescope.builtin").lsp_document_symbols, "[C]ode [S]ymbols")
	map("<leader>cws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[C]ode [W]orkspace [S]ymbols")
	map("<leader>cr", vim.lsp.buf.rename, "[C]ode [R]ename")
	map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")
	map("<leader>cd", vim.lsp.buf.hover, "[C]ode [D]ocumentation")
	vim.keymap.set("i", "<C-d>", vim.lsp.buf.hover, { buffer = event.buf, desc = "LSP: " .. "[C]ode [D]ocumentation" })

	local client = vim.lsp.get_client_by_id(event.data.client_id)
	if client and client.server_capabilities.documentHighlightProvider then
		vim.api.nvim_create_autocmd(
			{ "CursorHold", "CursorHoldI" },
			{ buffer = event.buf, callback = vim.lsp.buf.document_highlight }
		)
		vim.api.nvim_create_autocmd(
			{ "CursorMoved", "CursorMovedI" },
			{ buffer = event.buf, callback = vim.lsp.buf.clear_references }
		)
	end

	if client and client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
		local function inlayhint_enable()
			vim.lsp.inlay_hint.enable(0, not vim.lsp.inlay_hint.is_enabled())
		end
		map("<leader>ch", inlayhint_enable, "[C]ode Inlay [H]ints")
	end
end

function plugin.config()
	-- Register .mdc files as markdown filetype
	vim.filetype.add({
		extension = {
			mdc = "markdown",
		},
	})

	-- Add file type detection for Jinja2 files
	vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
		pattern = { "*.jinja", "*.jinja2", "*.j2" },
		callback = function()
			vim.bo.filetype = "jinja"
		end,
	})

	-- Create global ToggleDiagnostics command
	vim.api.nvim_create_user_command("ToggleDiagnostics", function()
		local diagnostics_enabled = vim.diagnostic.is_disabled()
		if diagnostics_enabled then
			vim.diagnostic.enable()
		else
			vim.diagnostic.disable()
		end
	end, { desc = "Toggle diagnostics" })

	-- Check for NVIM_DISABLE_DIAGNOSTICS environment variable
	local disable_patterns = os.getenv("NVIM_DISABLE_DIAGNOSTICS")
	if disable_patterns then
		-- Split the patterns by comma
		for pattern in disable_patterns:gmatch("[^,]+") do
			vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
				pattern = vim.fn.trim(pattern),
				callback = function()
					vim.diagnostic.disable(0)
				end,
			})
		end
	end

	vim.api.nvim_create_autocmd("LspAttach", {
		group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
		callback = attachment_callback,
	})

	local capabilities = vim.lsp.protocol.make_client_capabilities()
	capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

	-- Define servers
	local servers = {
		pyright = {},
		cssls = {},
		bashls = {},
		dockerls = {},
		html = {},
		jsonls = {
			filetypes = { "json", "jsonc", "pep8" },
		},
		jdtls = {},
		ltex = {},
		marksman = {},
		sqlls = {},
		yamlls = {},
		tailwindcss = {},
		eslint = {},
		jinja_lsp = { filetypes = { "jinja", "jinja2", "j2" } },
		ts_ls = {
			filetypes = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
			settings = {
				typescript = {
					preferences = {
						disableSuggestions = false,
					},
				},
			},
		},

		lua_ls = {
			settings = {
				Lua = {
					completion = {
						callSnippet = "Replace",
					},
				},
			},
		},
	}

	-- Setup Mason
	require("mason").setup({
		ui = {
			border = "rounded",
		},
	})

	-- Setup Mason-LSPConfig
	local mason_lspconfig = require("mason-lspconfig")
	mason_lspconfig.setup({
		ensure_installed = vim.tbl_keys(servers),
		automatic_enable = false,
	})

	-- Setup LSP servers
	local lspconfig = require("lspconfig")
	for server_name, server_config in pairs(servers) do
		local config = vim.tbl_deep_extend("force", {
			capabilities = capabilities,
		}, server_config)
		lspconfig[server_name].setup(config)
	end

	-- Setup Mason Tool Installer
	require("mason-tool-installer").setup({
		ensure_installed = {
			"prettier",
			"stylua",
			"eslint_d",
			"typescript-language-server",
			"stylelint",
		},
		auto_update = true,
		run_on_start = true,
	})
end

return plugin
