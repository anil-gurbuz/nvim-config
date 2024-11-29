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
	vim.api.nvim_create_autocmd("LspAttach", {
		group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
		callback = attachment_callback,
	})

	local capabilities = vim.lsp.protocol.make_client_capabilities()
	capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

	local servers = {}
	servers.pyright = {}
	servers.cssls = {}
	servers.bashls = {}
	servers.dockerls = {}
	servers.html = {}
	servers.jsonls = {}
	servers.jdtls = {} --java lsp
	-- servers.tsserver = {} -- javascript & typscript
	servers.ltex = {} -- Latex
	servers.marksman = {} -- Markdown
	servers.sqlls = {}
	servers.yamlls = {}
	servers.tailwindcss = {}
	servers.stylelint = {}
	servers.prettier = {}

	servers.lua_ls = {}
	servers.lua_ls.settings = {}
	servers.lua_ls.settings.Lua = {}
	servers.lua_ls.settings.Lua.completion = {}
	servers.lua_ls.settings.Lua.completion.callSnippet = "Replace"

	require("mason").setup()

	local ensure_installed = vim.tbl_keys(servers or {})
	vim.list_extend(ensure_installed, { "stylua", "black", "prettierd", "prettier" }) --ruff
	require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

	local function setup_handler(server_name)
		local server = servers[server_name] or {}
		server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})

		if server_name == "pyright" then
			venv_path = os.getenv("CONDA_PREFIX")

			print("Active venv: " .. tostring(venv_path)) -- Uses the python environment that is active when starting the nvim -- which is great
		end

		require("lspconfig")[server_name].setup(server)
	end

	require("mason-lspconfig").setup({ handlers = { setup_handler } })
end

return plugin
