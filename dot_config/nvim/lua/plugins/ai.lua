return {
	{
		"sudo-tee/opencode.nvim",
		config = function()
			require("opencode").setup({
				keymap_prefix = "<leader>a",
				ui = {
					input = {
						text = {
							wrap = true, -- Wraps text inside input window
						},
					},
				},
			})
		end,
		dependencies = {
			"nvim-lua/plenary.nvim",
			{
				"MeanderingProgrammer/render-markdown.nvim",
				opts = {
					anti_conceal = { enabled = false },
					file_types = { "markdown", "opencode_output" },
				},
				ft = { "markdown", "Avante", "copilot-chat", "opencode_output" },
			},
			-- Optional, for file mentions and commands completion, pick only one
			"saghen/blink.cmp",
			"folke/snacks.nvim",
		},
	},
}
