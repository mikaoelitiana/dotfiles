return {
	{
		"nvim-telescope/telescope.nvim",
		dependencies = {
			{ "polirritmico/telescope-lazy-plugins.nvim" },
		},
	},
	{
		"xvzc/chezmoi.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			require("chezmoi").setup({
				-- your configurations
			})
		end,
	},
}
