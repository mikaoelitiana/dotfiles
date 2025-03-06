return {
	{
		"LazyVim/LazyVim",
		opts = { colorscheme = "catppuccin-latte" },
	},
	{
		"f-person/auto-dark-mode.nvim",
	},
	{
		"luukvbaal/statuscol.nvim",
		config = function()
			require("statuscol").setup({})
		end,
	},
}
