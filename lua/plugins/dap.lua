return {
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			"leoluz/nvim-dap-go",
			"mfussenegger/nvim-dap-python",
			"rcarriga/nvim-dap-ui",
			"theHamsta/nvim-dap-virtual-text",
			"nvim-neotest/nvim-nio",
			"williamboman/mason.nvim",
		},
		config = function()
			local dap = require("dap")
			local ui = require("dapui")

			require("dapui").setup()
			require("dap-go").setup()

			-- Get Python path with Conda support
			local function get_python_path()
				local conda_prefix = os.getenv("CONDA_PREFIX")
				return conda_prefix and (conda_prefix .. "/bin/python") or "python"
			end

			require("dap-python").setup(get_python_path())

			-- Configure Python debugging with proper path handling
			dap.configurations.python = {
				{
					type = "python",
					request = "launch",
					name = "Launch file with module support",
					program = "${file}",
					pythonPath = get_python_path(),
					cwd = "${workspaceFolder}",
					justMyCode = false,
					env = {
						PYTHONPATH = function()
							-- Get the workspace directory
							local workspace = vim.fn.getcwd()
							-- Get existing PYTHONPATH
							local pythonpath = os.getenv("PYTHONPATH") or ""
							-- Add workspace and parent directory to PYTHONPATH
							local paths = {
								workspace,
								workspace .. "/src", -- Common source directory
								vim.fn.fnamemodify(workspace, ":h"), -- Parent directory
							}
							-- Combine with existing PYTHONPATH
							if pythonpath ~= "" then
								table.insert(paths, pythonpath)
							end
							return table.concat(paths, ":")
						end,
					},
				},
				{
					type = "python",
					request = "launch",
					name = "Launch Module",
					module = "${input:module}",
					pythonPath = get_python_path(),
					cwd = "${workspaceFolder}",
					justMyCode = false,
					env = {
						PYTHONPATH = "${workspaceFolder}:${env:PYTHONPATH}",
					},
				},
			}

			-- Add command for expression evaluation
			vim.api.nvim_create_user_command("DebugEval", function(opts)
				if opts.args ~= "" then
					require("dapui").eval(opts.args)
				else
					require("dapui").eval()
				end
			end, {
				nargs = "?",
				desc = "Evaluate expression or word under cursor",
			})

			-- Add debug configuration info command
			vim.api.nvim_create_user_command("DebugPyInfo", function()
				local workspace = vim.fn.getcwd()
				print("Current workspace: " .. workspace)
				print("Python Path: " .. get_python_path())
				print("Parent directory: " .. vim.fn.fnamemodify(workspace, ":h"))
				print("PYTHONPATH: " .. (os.getenv("PYTHONPATH") or "Not set"))
				-- Try to find setup.py or pyproject.toml
				local setup_py = vim.fn.findfile("setup.py", workspace .. ";")
				local pyproject_toml = vim.fn.findfile("pyproject.toml", workspace .. ";")
				if setup_py ~= "" then
					print("Found setup.py at: " .. setup_py)
				end
				if pyproject_toml ~= "" then
					print("Found pyproject.toml at: " .. pyproject_toml)
				end
			end, {})

			-- Handled by nvim-dap-go
			-- dap.adapters.go = {
			--   type = "server",
			--   port = "${port}",
			--   executable = {
			--     command = "dlv",
			--     args = { "dap", "-l", "127.0.0.1:${port}" },
			--   },
			-- }

			local elixir_ls_debugger = vim.fn.exepath("elixir-ls-debugger")
			if elixir_ls_debugger ~= "" then
				dap.adapters.mix_task = {
					type = "executable",
					command = elixir_ls_debugger,
				}

				dap.configurations.elixir = {
					{
						type = "mix_task",
						name = "phoenix server",
						task = "phx.server",
						request = "launch",
						projectDir = "${workspaceFolder}",
						exitAfterTaskReturns = false,
						debugAutoInterpretAllModules = false,
					},
				}
			end

			vim.keymap.set("n", "<space>db", dap.toggle_breakpoint, { desc = "[D]ebugger [B]reak point" })
			vim.keymap.set("n", "<space>dg", dap.run_to_cursor, { desc = "[D]ebugger [G]o to Cursor" })
			vim.keymap.set("n", "<space>du", ui.open, { desc = "[D]ebugger [U]I toggle" })

			-- Eval in UI window (normal mode)
			vim.keymap.set("n", "<space>de", function()
				require("dapui").eval(nil, { enter = true })
			end, { desc = "[D]ebugger [E]val under cursor" })

			-- Eval in UI window (visual mode)
			vim.keymap.set("v", "<space>de", function()
				require("dapui").eval(nil, { enter = true })
			end, { desc = "[D]ebugger [E]val selection" })

			-- Quick eval in floating window (visual mode)
			vim.keymap.set("v", "<space>dr", function()
				require("dapui").eval(nil, { enter = false, context = "repl" })
			end, { desc = "Debug quick eval selection in float" })

			vim.keymap.set("n", "<F1>", dap.step_into, { desc = "Debugger Step Into" })
			vim.keymap.set("n", "<F2>", dap.step_over, { desc = "Debugger Step Over" })
			vim.keymap.set("n", "<F3>", dap.continue, { desc = "Debugger Continue to cursor" })

			vim.keymap.set("n", "<F4>", dap.step_out, { desc = "Debugger Step Out" })
			vim.keymap.set("n", "<F5>", dap.step_back, { desc = "Debugger Step Back" })
			vim.keymap.set("n", "<F11>", dap.restart, { desc = "Debugger Restart" })

			dap.listeners.before.attach.dapui_config = function()
				ui.open()
			end
			dap.listeners.before.launch.dapui_config = function()
				ui.open()
			end
			dap.listeners.before.event_terminated.dapui_config = function()
				ui.close()
			end
			dap.listeners.before.event_exited.dapui_config = function()
				ui.close()
			end
		end,
	},
}
