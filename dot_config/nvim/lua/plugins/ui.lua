return {
	{
		"folke/noice.nvim",
		event = "VeryLazy",
		opts = function(_, opts)
			table.insert(opts.routes, {
				filter = {
					event = "lsp",
					kind = "message",
					find = "Inlay Hints request failed. Requires TypeScript 4.4+.",
				},
				opts = { skip = true },
			})
		end,
	},
	{
		"f-person/auto-dark-mode.nvim",
		opts = {
			update_interval = 1000,
			set_dark_mode = function()
				vim.api.nvim_set_option_value("background", "dark", {})
				vim.cmd("colorscheme catppuccin")
			end,
			set_light_mode = function()
				vim.api.nvim_set_option_value("background", "light", {})
				vim.cmd("colorscheme catppuccin")
			end,
		},
	},
}
