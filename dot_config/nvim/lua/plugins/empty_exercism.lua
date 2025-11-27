return {
	{
		"2kabhishek/exercism.nvim",
		cmd = { "Exercism" },
		keys = { { "<leader>exa", desc = "Exercism select language" }, "<leader>exl", "<leader>exr" }, -- add your preferred keybindings
		dependencies = {
			"2kabhishek/utils.nvim", -- required, for utility functions
			"2kabhishek/termim.nvim", -- optional, better UX for running tests
		},
		-- Add your custom configs here, keep it blank for default configs (required)
		opts = {
			exercism_workspace = "~/Developer/exercism",
		},
	},
}
