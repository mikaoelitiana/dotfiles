return {
	{
		"jay-babu/mason-nvim-dap.nvim",
		depedencies = "mason.nvim",
		config = function()
			require("mason-nvim-dap").setup({
				ensure_installed = { "js", "node2" },
				automatic_installation = true,
				handlers = {
					function(config)
						require("mason-nvim-dap").default_setup(config)
					end,
					node2 = function(config)
						config.configurations = nil
						require("mason-nvim-dap").default_setup(config)
					end,
				},
			})
		end,
	},
	{
		"microsoft/vscode-js-debug",
		build = "git checkout . && npm install --legacy-peer-deps && npx gulp vsDebugServerBundle && mv dist out && git checkout package-lock.json",
	},
	{
		"mxsdev/nvim-dap-vscode-js",
		depedencies = "microsoft/vscode-js-debug",
		event = "VeryLazy",
		config = function()
			local dap = require("dap")

			dap.adapters.node = dap.adapters.node2

			-- cf. https://github.com/mxsdev/nvim-dap-vscode-js/pull/50
			local lazy_avail, lazy_config = pcall(require, "lazy.core.config")

			require("dap-vscode-js").setup({
				debugger_path = lazy_avail and table.concat({ lazy_config.defaults.root, "vscode-js-debug" }, "/")
					or "", -- Path to vscode-js-debug installation.
				adapters = { "pwa-node", "node-terminal" }, -- which adapters to register in nvim-dap
				-- log_file_path = "/Users/mikaoelitiana/tmp/dap_vscode_js.log", -- Path for file logging
				-- log_file_level = vim.log.levels.DEBUG, -- Logging level for output to file. Set to false to disable file logging.
				-- log_console_level = vim.log.levels.DEBUG, -- Logging level for output to console. Set to false to disable console output.
			})

			for _, language in ipairs({ "javascript", "typescript" }) do
				dap.configurations[language] = {
					{
						type = "node",
						request = "launch",
						name = "Run file with ts-node",
						cwd = "${workspaceFolder}",
						runtimeArgs = { "-r", "ts-node/register" },
						runtimeExecutable = "node",
						args = { "--inspect", "${file}" },
						skipFiles = { "node_modules/**" },
						console = "integratedTerminal",
					},
					{
						type = "node",
						request = "attach",
						name = "Attach to process (" .. language .. ")",
						processId = require("dap.utils").pick_process,
						cwd = "${workspaceFolder}",
						sourceMaps = true,
						protocol = "inspector",
						console = "integratedTerminal",
						outputCapture = "std",
					},
				}
			end
		end,
	},
}
