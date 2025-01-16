-- https://github.com/mxsdev/nvim-dap-vscode-js/issues/58#issuecomment-2582575821
--- Gets a path to a package in the Mason registry.
--- Prefer this to `get_package`, since the package might not always be
--- available yet and trigger errors.
---@param pkg string
---@param path? string
local function get_pkg_path(pkg, path)
	pcall(require, "mason")
	local root = vim.env.MASON or (vim.fn.stdpath("data") .. "/mason")
	path = path or ""
	local ret = root .. "/packages/" .. pkg .. "/" .. path
	return ret
end

require("dap").adapters["pwa-node"] = {
	type = "server",
	host = "localhost",
	port = "${port}",
	executable = {
		command = "node",
		args = {
			get_pkg_path("js-debug-adapter", "/js-debug/src/dapDebugServer.js"),
			"${port}",
		},
	},
}

for _, language in ipairs({ "javascript", "typescript" }) do
	require("dap").configurations[language] = {
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
}
