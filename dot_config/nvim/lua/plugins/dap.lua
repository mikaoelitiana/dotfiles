-- try to execute JS/TS files with ts-node
for _, language in ipairs({ "javascript", "typescript" }) do
	require("dap").configurations[language] = {
		{
			type = "node",
			request = "launch",
			name = "Run file with tsx",
			cwd = "${workspaceFolder}",
			runtimeArgs = { "tsx" },
			runtimeExecutable = "npx",
			args = { "--inspect", "${file}" },
			skipFiles = { "node_modules/**" },
			console = "integratedTerminal",
		},
		{
			type = "node",
			request = "launch",
			name = "Run file with ts-node",
			cwd = "${workspaceFolder}",
			runtimeArgs = { "ts-node", "-r tsconfig-paths/register" },
			runtimeExecutable = "npx",
			args = { "--inspect", "${file}" },
			skipFiles = { "node_modules/**" },
			console = "integratedTerminal",
			env = { NODE_ENV = "local" },
		},
		{
			type = "node",
			request = "launch",
			name = "Run file with bun",
			cwd = "${workspaceFolder}",
			runtimeArgs = { "run" },
			runtimeExecutable = "bun",
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

return {
	{
		"jay-babu/mason-nvim-dap.nvim",
		config = function()
			require("mason-nvim-dap").setup({
				ensure_installed = { "js", "node2" },
				automatic_installation = false,
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
		"mfussenegger/nvim-dap",
		opts = function()
			local dap = require("dap")
			if dap.adapters["pwa-node"] then
				dap.adapters["pwa-node"].host = "::1"
			end

			-- Elixir
			dap.adapters.mix_task = {
				type = "executable",
				command = vim.fn.stdpath("data") .. "/mason/bin/elixir-ls-debugger",
				args = {},
			}
		end,
	},
}
