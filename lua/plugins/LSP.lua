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

	local servers = {}
	servers.pyright = {}
	servers.cssls = {}
	servers.bashls = {}

	servers.dockerls = {}
	servers.html = {}
	servers.jsonls = {
		filetypes = { "json", "jsonc", "pep8" },
	}
	servers.jdtls = {} --java lsp
	-- servers.tsserver = {} -- javascript & typscript
	-- Enable tsserver with specific diagnostics settings
	-- servers.tsserver = {
	--     settings = {
	--         typescript = {
	--             inlayHints = {
	--                 includeInlayParameterNameHints = "all",
	--                 includeInlayParameterNameHintsWhenArgumentMatchesName = false,
	--                 includeInlayFunctionParameterTypeHints = true,
	--                 includeInlayVariableTypeHints = true,
	--                 includeInlayPropertyDeclarationTypeHints = true,
	--                 includeInlayFunctionLikeReturnTypeHints = true,
	--                 includeInlayEnumMemberValueHints = true,
	--             },
	--             suggest = {
	--                 includeCompletionsForModuleExports = true,
	--             },
	--             diagnostics = {
	--                 -- Enable all diagnostics
	--                 enable = true,
	--                 -- Specifically enable unused variable and import diagnostics
	--                 unusedSymbols = true,
	--             },
	--         },
	--         javascript = {
	--             inlayHints = {
	--                 includeInlayParameterNameHints = "all",
	--                 includeInlayParameterNameHintsWhenArgumentMatchesName = false,
	--                 includeInlayFunctionParameterTypeHints = true,
	--                 includeInlayVariableTypeHints = true,
	--                 includeInlayPropertyDeclarationTypeHints = true,
	--                 includeInlayFunctionLikeReturnTypeHints = true,
	--                 includeInlayEnumMemberValueHints = true,
	--             },
	--             suggest = {
	--                 includeCompletionsForModuleExports = true,
	--             },
	--             diagnostics = {
	--                 -- Enable all diagnostics
	--                 enable = true,
	--                 -- Specifically enable unused variable and import diagnostics
	--                 unusedSymbols = true,
	--             },
	--         },
	--     },
	-- }

	servers.ltex = {} -- Latex
	servers.marksman = {} -- Markdown
	servers.sqlls = {}
	servers.yamlls = {}
	servers.tailwindcss = {}
	servers.stylelint = {}
	servers.prettier = {}
	servers.jinja_lsp = {}

	-- Vue.js configuration
	servers.volar = {
		takeOverMode = { enabled = true },
		filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue", "json" },
		init_options = {
			preferences = {
				importModuleSpecifierPreference = "relative",
			},
			documentFeatures = {
				selectionRange = true,
				foldingRange = true,
				linkedEditingRange = true,
				documentSymbol = true,
				documentColor = true,
				documentFormatting = {
					defaultPrintWidth = 100,
				},
			},
			typescript = {
				tsdk = vim.fn.expand(
					"$HOME/.local/share/nvim/mason/packages/typescript-language-server/node_modules/typescript/lib"
				),
			},
			languageFeatures = {
				implementation = true, -- new
				references = true, -- new
				definition = true, -- new
				typeDefinition = true, -- new
				callHierarchy = true, -- new
				hover = true, -- new
				rename = true, -- new
				renameFileRefactoring = true, -- new
				signatureHelp = true, -- new
				codeAction = true, -- new
				completion = {
					defaultTagNameCase = "kebabCase",
					defaultAttrNameCase = "kebabCase",
				},
				diagnostics = true, -- new
				semanticTokens = true, -- new
				directories = true, -- new
				workspaceSymbol = true,
				codeLens = true,
			},
		},
		settings = {
			vue = {
				complete = {
					casing = {
						tags = "kebab",
					},
				},
			},
		},
	}
	servers.lua_ls = {}
	servers.lua_ls.settings = {}
	servers.lua_ls.settings.Lua = {}
	servers.lua_ls.settings.Lua.completion = {}
	servers.lua_ls.settings.Lua.completion.callSnippet = "Replace"

	-- servers.vuels = {
	--  config = {
	--      css = {},
	--      emmet = {},
	--      html = {
	--          suggest = {},
	--      },
	--      javascript = {
	--          format = {},
	--      },
	--      stylusSupremacy = {},
	--      typescript = {
	--          format = {},
	--      },
	--      vetur = {
	--          completion = {
	--              autoImport = true,
	--              tagCasing = "kebab",
	--              useScaffoldSnippets = false,
	--          },
	--          format = {
	--              defaultFormatter = {
	--                  js = "none",
	--                  ts = "none",
	--              },
	--              defaultFormatterOptions = {},
	--              scriptInitialIndent = true,
	--              styleInitialIndent = true,
	--          },
	--          useWorkspaceDependencies = true,
	--          validation = {
	--              script = true,
	--              style = true,
	--              template = true,
	--          },
	--      },
	--  },
	-- }

	vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
		pattern = { "*.pep8", "setup.cfg" },
		callback = function()
			vim.bo.filetype = "ini" -- Use INI syntax highlighting which is more appropriate for .pep8 files
			vim.bo.syntax = "ini" -- Ensure both traditional and treesitter highlighting work
		end,
	})
	require("mason").setup()

	local ensure_installed = vim.tbl_keys(servers or {})
	vim.list_extend(ensure_installed, {
		"stylua",
		"autopep8",
		"isort",
		"prettierd",
		"prettier",
		"vue-language-server",
		"typescript-language-server",
		"eslint-lsp",
	}) --ruff, black
	require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

	local function setup_handler(server_name)
		local server = servers[server_name] or {}
		server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})

		if server_name == "pyright" then
			venv_path = os.getenv("CONDA_PREFIX")
			print("Active venv: " .. tostring(venv_path))

			-- Create autocmd to reload pyright on Python file changes
			vim.api.nvim_create_autocmd({ "BufWritePost", "BufEnter" }, {
				pattern = "*.py",
				callback = function()
					local clients = vim.lsp.get_active_clients({ name = "pyright" })
					local client = clients and clients[1]
					if client then
						-- Trigger a full workspace analysis
						client.notify("workspace/didChangeConfiguration", {
							settings = server.settings,
						})
					end
				end,
			})

			-- Additional pyright configuration
			server.settings = {
				python = {
					analysis = {
						autoSearchPaths = true,
						useLibraryCodeForTypes = true,
						diagnosticMode = "workspace",
					},
				},
			}
		end

		require("lspconfig")[server_name].setup(server)
	end

	require("mason-lspconfig").setup({ handlers = { setup_handler } })
end

return plugin
