return {
	{
		"LazyVim/LazyVim",
		opts = { colorscheme = "catppuccin-latte" },
	},
	{
		"luukvbaal/statuscol.nvim",
		config = function()
			require("statuscol").setup({})
		end,
	},
}
