return {
	{
		"catppuccin/nvim",
		name = "catppuccin",
		lazy = false,
		priority = 1000,
		opts = {
			flavour = "auto",
			background = {
				light = "latte",
				dark = "frappe",
			},
		},
	},
	{
		"LazyVim/LazyVim",
		opts = {
			colorscheme = "catppuccin-nvim",
		},
	},
	{
		"luukvbaal/statuscol.nvim",
		config = function()
			require("statuscol").setup({})
		end,
	},
}
