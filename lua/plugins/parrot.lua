local plugin = {
	"frankroeder/parrot.nvim",
	dependencies = { "ibhagwan/fzf-lua", "nvim-lua/plenary.nvim", "rcarriga/nvim-notify" },
}

function plugin.config()
	require("parrot").setup({
		-- If false, Dont fix cursor to the last chunk of the stream while streaming
		command_auto_select_response = false,
		-- Providers must be explicitly added to make them available.
		providers = {
			anthropic = {
				api_key = os.getenv("ANTHROPIC_API_KEY"),
			},
			gemini = {
				api_key = os.getenv("GEMINI_API_KEY"),
			},
			groq = {
				api_key = os.getenv("GROQ_API_KEY"),
			},
			mistral = {
				api_key = os.getenv("MISTRAL_API_KEY"),
			},
			pplx = {
				api_key = os.getenv("PERPLEXITY_API_KEY"),
			},
			-- provide an empty list to make provider available (no API key required)
			-- ollama = {},
			openai = {
				api_key = os.getenv("OPENAI_API_KEY"),
			},
		},
		hooks = {
			Complete = function(prt, params)
				local template = [[
					I have the following code from {{filename}}:

					```{{filetype}}
					{{selection}}
					```

					Please finish the code above carefully and logically.
					Respond just with the snippet of code that should be inserted."
					]]
				local model_obj = prt.get_model("command")
				prt.Prompt(params, prt.ui.Target.append, model_obj, nil, template)
			end,
			Explain = function(prt, params)
				local template = [[
						Your task is to take the code snippet from {{filename}} and explain it with gradually increasing complexity.
						Break down the code's functionality, purpose, and key components.
						The goal is to help the reader understand what the code does and how it works.

						```{{filetype}}
						{{selection}}
						```

						Use the markdown format with codeblocks and inline code.
						Explanation of the code above:
						]]
				local model = prt.get_model("command")
				prt.logger.info("Explaining selection with model: " .. model.name)
				prt.Prompt(params, prt.ui.Target.new, model, nil, template)
			end,
		},
	})
end

plugin.keys = {
	{ "<C-s>", "<cmd>PrtChatRespond<cr>", mode = { "i", "v", "n" }, desc = "[S]end Answer" },
	{ "<leader>js", "<cmd>PrtChatNew<cr>", mode = { "n" }, desc = "[J]droid [S]tart" },
	{ "<leader>jq", "<cmd>PrtStop<cr>", mode = { "n" }, desc = "[J]droid [Q]uit" },
	{ "<leader>jf", "<cmd>PrtChatFinder<cr>", mode = { "n" }, desc = "[J]droid [F]ind chats" },

	{ "<leader>jvr", ":<C-u>'<,'>PrtRewrite<cr>", mode = { "v" }, desc = "[J]droid [V]isual [R]ewrite" },
	{ "<leader>jve", "<cmd>PrtChatPaste<cr>", mode = { "v" }, desc = "[J]droid [V]isual[E]xecute" },
	{ "<leader>jva", ":<C-u>'<,'>PrtAppend<cr>", mode = { "v" }, desc = "[J]droid [V]isual [A]ppend" },
	{ "<leader>jvp", ":<C-u>'<,'>PrtPrepend<cr>", mode = { "v" }, desc = "[J]droid [V]isual [P]repend" },
	{ "<leader>jvc", ":<C-u>'<,'>PrtComplete<cr>", mode = { "v" }, desc = "[J]droid [V]isual [C]omplete" },
	{ "<leader>jvn", ":<C-u>'<,'>PrtEnew<cr>", mode = { "v" }, desc = "[J]droid [V]isual [N]ew buffer" },

	-- { "<leader>jo", "<cmd>PrtContext<cr>", mode = { "n" }, desc = "Open context file" },
	{ "<leader>jmm", "<cmd>PrtModel<cr>", mode = { "n" }, desc = "[J]droid [M]odel [M]odel" },
	{ "<leader>jmp", "<cmd>PrtProvider<cr>", mode = { "n" }, desc = "[J]droid [M]odel [P]rovider" },
	{ "<leader>jmi", "<cmd>PrtStatus<cr>", mode = { "n" }, desc = "[J]droid [M]odel [I]nfo" }, -- Prints model info
	{ "<leader>jna", "<cmd>PrtAsk<cr>", mode = { "n" }, desc = "[J]droid [N]ormal [A]sk a question" },
}

return plugin
