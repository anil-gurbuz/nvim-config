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
			-- local venv_path = os.getenv("CONDA_PREFIX")
			require("dap-python").setup("python")

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

			-- Eval var under cursor
			vim.keymap.set("n", "<space>de", function()
				require("dapui").eval(nil, { enter = true })
			end, { desc = "[D]ebugger [E]val under cursor" })

			vim.keymap.set("n", "<F1>", dap.continue, { desc = "Debugger Continue" })
			vim.keymap.set("n", "<F2>", dap.step_into, { desc = "Debugger Step Into" })
			vim.keymap.set("n", "<F3>", dap.step_over, { desc = "Debugger Step Over" })
			vim.keymap.set("n", "<F4>", dap.step_out, { desc = "Debugger Step Out" })
			vim.keymap.set("n", "<F5>", dap.step_back, { desc = "Debugger Step Back" })
			vim.keymap.set("n", "<F13>", dap.restart, { desc = "Debugger Restart" })

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
