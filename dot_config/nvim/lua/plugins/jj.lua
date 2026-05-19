return {
	{
		"swaits/lazyjj.nvim",
		dependencies = "nvim-lua/plenary.nvim",
		opts = {
			mapping = "<leader>jj",
		},
	},
	{
		"yannvanhalewyn/jujutsu.nvim",
		dependencies = "sindrets/diffview.nvim",
		opts = {
			diff_preset = "diffview",
		},
		keys = {
			{ "<leader>gj", function() require("jujutsu-nvim").log() end, desc = "Jujutsu log" },
		},
	},
}
