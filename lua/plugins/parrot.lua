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
				name = "anthropic",
				endpoint = "https://api.anthropic.com/v1/messages",
				model_endpoint = "https://api.anthropic.com/v1/models",
				api_key = os.getenv("ANTHROPIC_API_KEY"),
				params = {
					chat = { max_tokens = 4096 },
					command = { max_tokens = 4096 },
				},
				topic = {
					model = "claude-3-5-haiku-latest",
					params = { max_tokens = 32 },
				},
				headers = function(self)
					return {
						["Content-Type"] = "application/json",
						["x-api-key"] = self.api_key,
						["anthropic-version"] = "2023-06-01",
					}
				end,
				models = {
					"claude-sonnet-4-20250514",
					"claude-3-7-sonnet-20250219",
					"claude-3-5-sonnet-20241022",
					"claude-3-5-haiku-20241022",
				},
				preprocess_payload = function(payload)
					for _, message in ipairs(payload.messages) do
						message.content = message.content:gsub("^%s*(.-)%s*$", "%1")
					end
					if payload.messages[1] and payload.messages[1].role == "system" then
						-- remove the first message that serves as the system prompt as anthropic
						-- expects the system prompt to be part of the API call body and not the messages
						payload.system = payload.messages[1].content
						table.remove(payload.messages, 1)
					end
					return payload
				end,
			},

			gemini = {
				name = "gemini",
				endpoint = function(self)
					return "https://generativelanguage.googleapis.com/v1beta/models/"
						.. self._model
						.. ":streamGenerateContent?alt=sse"
				end,
				model_endpoint = function(self)
					return { "https://generativelanguage.googleapis.com/v1beta/models?key=" .. self.api_key }
				end,
				api_key = os.getenv("GEMINI_API_KEY"),
				params = {
					chat = { temperature = 1.1, topP = 1, topK = 10, maxOutputTokens = 8192 },
					command = { temperature = 0.8, topP = 1, topK = 10, maxOutputTokens = 8192 },
				},
				topic = {
					model = "gemini-1.5-flash",
					params = { maxOutputTokens = 64 },
				},
				headers = function(self)
					return {
						["Content-Type"] = "application/json",
						["x-goog-api-key"] = self.api_key,
					}
				end,
				models = {
					"gemini-2.5-flash-preview-05-20",
					"gemini-2.5-pro-preview-05-06",
					"gemini-1.5-pro-latest",
					"gemini-1.5-flash-latest",
					"gemini-2.5-pro-exp-03-25",
					"gemini-2.0-flash-lite",
					"gemini-2.0-flash-thinking-exp",
					"gemma-3-27b-it",
				},
				preprocess_payload = function(payload)
					local contents = {}
					local system_instruction = nil
					for _, message in ipairs(payload.messages) do
						if message.role == "system" then
							system_instruction = { parts = { { text = message.content } } }
						else
							local role = message.role == "assistant" and "model" or "user"
							table.insert(
								contents,
								{ role = role, parts = { { text = message.content:gsub("^%s*(.-)%s*$", "%1") } } }
							)
						end
					end
					local gemini_payload = {
						contents = contents,
						generationConfig = {
							temperature = payload.temperature,
							topP = payload.topP or payload.top_p,
							maxOutputTokens = payload.max_tokens or payload.maxOutputTokens,
						},
					}
					if system_instruction then
						gemini_payload.systemInstruction = system_instruction
					end
					return gemini_payload
				end,
				process_stdout = function(response)
					if not response or response == "" then
						return nil
					end
					local success, decoded = pcall(vim.json.decode, response)
					if
						success
						and decoded.candidates
						and decoded.candidates[1]
						and decoded.candidates[1].content
						and decoded.candidates[1].content.parts
						and decoded.candidates[1].content.parts[1]
					then
						return decoded.candidates[1].content.parts[1].text
					end
					return nil
				end,
			},

			openai = {
				name = "openai",
				endpoint = "https://api.openai.com/v1/chat/completions",
				-- endpoint to query the available models online
				model_endpoint = "https://api.openai.com/v1/models",
				api_key = os.getenv("OPENAI_API_KEY"),
				-- OPTIONAL: Alternative methods to retrieve API key
				-- Using GPG for decryption:
				-- api_key = { "gpg", "--decrypt", vim.fn.expand("$HOME") .. "/my_api_key.txt.gpg" },
				-- Using macOS Keychain:
				-- api_key = { "/usr/bin/security", "find-generic-password", "-s my-api-key", "-w" },
				--- default model parameters used for chat and interactive commands
				params = {
					chat = { temperature = 1.1, top_p = 1 },
					command = { temperature = 1.1, top_p = 1 },
				},
				-- topic model parameters to summarize chats
				topic = {
					model = "gpt-4.1-nano",
					params = { max_completion_tokens = 64 },
				},
				--  a selection of models that parrot can remember across sessions
				--  NOTE: This will be handled more intelligently in a future version
				models = {
					"gpt-4.1",
					"o4-mini",
					"gpt-4.1-mini",
					"gpt-4.1-nano",
				},
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
