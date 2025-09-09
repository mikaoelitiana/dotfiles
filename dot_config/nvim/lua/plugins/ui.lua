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
	-- temporary fix for catppuccin bufferline integration
	-- https://github.com/LazyVim/LazyVim/issues/6355#issuecomment-3212986215
	{
		"catppuccin/nvim",
		opts = function(_, opts)
			local module = require("catppuccin.groups.integrations.bufferline")
			if module then
				module.get = module.get_theme
			end
			return opts
		end,
	},
}
