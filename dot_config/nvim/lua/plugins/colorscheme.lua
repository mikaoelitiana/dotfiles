return {
	{
		"LazyVim/LazyVim",
		opts = { colorscheme = "catppuccin-frappe" },
	},
	{
		"luukvbaal/statuscol.nvim",
		config = function()
			require("statuscol").setup({})
		end,
	},
}
