local plugin = {
	"yetone/avante.nvim",
	dependencies = {
		"stevearc/dressing.nvim",
		"nvim-lua/plenary.nvim",
		"MunifTanjim/nui.nvim",
		--- The below dependencies are optional,
		"nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
		"zbirenbaum/copilot.lua", -- for providers='copilot'
		{
			-- support for image pasting
			"HakonHarnes/img-clip.nvim",
			event = "VeryLazy",
			opts = {
				-- recommended settings
				default = {
					embed_image_as_base64 = false,
					prompt_for_file_name = false,
					drag_and_drop = {
						insert_mode = true,
					},
					-- required for Windows users
					use_absolute_path = true,
				},
			},
		},
		{
			-- Make sure to set this up properly if you have lazy=true
			"MeanderingProgrammer/render-markdown.nvim",
			opts = {
				file_types = { "markdown", "Avante" },
			},
			ft = { "markdown", "Avante" },
		},
	},
	event = "VeryLazy",
	-- lazy = false,
	-- version = true, -- set this if you want to always pull the latest change

	opts = {
		-- provider options
		provider = "claude", -- Recommend using Claude
		cursor_applying_provider = "groq", -- In this example, use Groq for applying, but you can also use any provider you want.
		auto_suggestions_provider = "copilot", -- Since auto-suggestions are a high-frequency operation and therefore expensive, it is recommended to specify an inexpensive provider or even a free provider: copilot

		-- NEW: Moved provider configurations under 'providers' table
		providers = {
			claude = {
				endpoint = "https://api.anthropic.com",
				model = "claude-4-sonnet-20250514",
				api_key_name = "ANTHROPIC_API_KEY",
				disable_tools = true,
				extra_request_body = {
					temperature = 0,
					max_tokens = 4096,
				},
				-- endpoint = "bedrock", -- Use "bedrock" to indicate AWS Bedrock
				-- model = "anthropic.claude-3-sonnet-20240229-v1:0", -- Bedrock model ID for Claude 3 Sonnet
				-- api_key_name = "AWS_ACCESS_KEY_ID", -- AWS access key
				-- api_secret_name = "AWS_SECRET_ACCESS_KEY", -- AWS secret key
				-- region = "us-east-1", -- Your AWS region (change if needed)
			},
			groq = { -- define groq provider
				__inherited_from = "openai",
				api_key_name = "GROQ_API_KEY",
				endpoint = "https://api.groq.com/openai/v1/",
				model = "llama-3.3-70b-versatile",
				extra_request_body = {
					max_tokens = 32768, -- remember to increase this value, otherwise it will stop generating halfway
				},
			},
		},

		rag_service = {
			enabled = false, -- Enables the rag service, requires OPENAI_API_KEY to be set
			host_mount = "/home/anil/projects/", -- Host mount path for the rag service (docker will mount this path)
			runner = "docker", -- The runner for the rag service, (can use docker, or nix)
			provider = "openai", -- The provider to use for RAG service. eg: openai or ollama
			llm_model = "", -- The LLM model to use for RAG service
			embed_model = "", -- The embedding model to use for RAG service
			endpoint = "https://api.openai.com/v1", -- The API endpoint for RAG service
			docker_extra_args = "", -- Extra arguments to pass to the docker command
		},
		web_search_engine = {
			provider = "tavily",
			providers = {
				tavily = {
					api_key_name = "TAVILY_API_KEY",
					extra_request_body = {
						include_answer = "basic",
					},
					---@type WebSearchEngineProviderResponseBodyFormatter
					format_response_body = function(body)
						return body.answer, nil
					end,
				},
			},
		},
		---Specify the special dual_boost mode
		---1. enabled: Whether to enable dual_boost mode. Default to false.
		---2. first_provider: The first provider to generate response. Default to "openai".
		---3. second_provider: The second provider to generate response. Default to "claude".
		---4. prompt: The prompt to generate response based on the two reference outputs.
		---5. timeout: Timeout in milliseconds. Default to 60000.
		---How it works:
		--- When dual_boost is enabled, avante will generate two responses from the first_provider and second_provider respectively. Then use the response from the first_provider as provider1_output and the response from the second_provider as provider2_output. Finally, avante will generate a response based on the prompt and the two reference outputs, with the default Provider as normal.
		---Note: This is an experimental feature and may not work as expected.
		dual_boost = {
			enabled = false,
			first_provider = "claude",
			second_provider = "openai",
			prompt = "Based on the two reference outputs below, generate a response that incorporates elements from both but reflects your own judgment and unique perspective. Do not provide any explanation, just give the response directly. Reference Output 1: [{{provider1_output}}], Reference Output 2: [{{provider2_output}}]",
			timeout = 60000, -- Timeout in milliseconds
		},
		behaviour = {
			auto_suggestions = false, -- Experimental stage
			auto_set_highlight_group = false,
			auto_set_keymaps = true,
			auto_apply_diff_after_generation = false,
			support_paste_from_clipboard = true,
			minimize_diff = true, -- Whether to remove unchanged lines when applying a code block
			enable_token_counting = true,
			enable_cursor_planning_mode = false,
			enable_claude_text_editor_tool_mode = false,
			use_cwd_as_project_root = false,
		},

		mappings = {
			--- @class AvanteConflictMappings
			diff = {
				ours = "co",
				theirs = "ct",
				all_theirs = "ca",
				both = "cb",
				cursor = "cc",
				next = "]x",
				prev = "[x",
			},
			-- suggestion = {
			--  accept = "<C-k>",
			--  next = "<C-l>",
			--  prev = "<C-H>",
			--  dismiss = "<C-]>",
			-- },
			cancel = {
				normal = { "<C-c>", "<Esc>", "q" },
				insert = { "<C-c>" },
			},
			jump = {
				next = "]]",
				prev = "[[",
			},
			submit = {
				normal = "<CR>",
				insert = "<C-s>",
			},
			sidebar = {
				apply_all = "A",
				apply_cursor = "a",
				switch_windows = "<Tab>",
				reverse_switch_windows = "<S-Tab>",
			},
		},
		hints = { enabled = true },
		windows = {
			---@type "right" | "left" | "top" | "bottom"
			position = "right", -- the position of the sidebar
			wrap = true, -- similar to vim.o.wrap
			width = 40, -- default % based on available width
			sidebar_header = {
				enabled = true, -- true, false to enable/disable the header
				align = "center", -- left, center, right for title
				rounded = true,
			},
			input = {
				prefix = "> ",
				height = 8, -- Height of the input window in vertical layout
			},
			edit = {
				border = "rounded",
				start_insert = true, -- Start insert mode when opening the edit window
			},
			ask = {
				floating = false, -- Open the 'AvanteAsk' prompt in a floating window
				start_insert = false, -- Start insert mode when opening the ask window
				border = "rounded",
				---@type "ours" | "theirs"
				focus_on_apply = "ours", -- which diff to focus after applying
			},
		},
		highlights = {
			---@type AvanteConflictHighlights
			diff = {
				current = "DiffText",
				incoming = "DiffAdd",
			},
		},
		--- @class AvanteConflictUserConfig
		diff = {
			autojump = true,
			---@type string | fun(): any
			list_opener = "copen",
			--- Override the 'timeoutlen' setting while hovering over a diff (see :help timeoutlen).
			--- Helps to avoid entering operator-pending mode with diff mappings starting with `c`.
			--- Disable by setting to -1.
			override_timeoutlen = 500,
		},
	},

	-- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
	build = "make",
}

return plugin
