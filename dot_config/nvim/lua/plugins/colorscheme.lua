return {
	{
		"LazyVim/LazyVim",
		opts = {
			colorscheme = "catppuccin",
		},
	},
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
		config = function()
			require("catppuccin").setup({
				flavour = "latte",
				background = {
					light = "latte",
					dark = "frappe",
				},
			})
			vim.cmd.colorscheme("catppuccin")
		end,
	},
	{
		"luukvbaal/statuscol.nvim",
		config = function()
			require("statuscol").setup({})
		end,
	},
}
