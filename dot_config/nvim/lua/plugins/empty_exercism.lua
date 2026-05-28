local wk = require("which-key")

wk.add({
	{ "<leader>z", group = "+exercism" },
})

return {
	{
		"2kabhishek/exercism.nvim",
		cmd = { "Exercism" },
		keys = {
			{ "<leader>za", "<cmd>Exercism languages<cr>", desc = "Select language" },
			{ "<leader>zr", "<cmd>Exercism recent<cr>", desc = "Recent exercises" },
			{ "<leader>zt", "<cmd>Exercism test<cr>", desc = "Run tests" },
		}, -- add your preferred keybindings
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
