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
		"mfussenegger/nvim-dap",
		opts = function()
			local dap = require("dap")
			dap.adapters["pwa-node"].host = "::1"
		end,
	},
}
