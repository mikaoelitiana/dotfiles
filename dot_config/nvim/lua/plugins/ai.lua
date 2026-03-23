return {
	{
		"sudo-tee/opencode.nvim",
		config = function()
			require("opencode").setup({
				keymap_prefix = "<leader>O",
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
	{
		"editor-code-assistant/eca-nvim",
		dependencies = {
			"MunifTanjim/nui.nvim", -- Required: UI framework
			"nvim-lua/plenary.nvim", -- Optional: Enhanced async operations
			"folke/snacks.nvim", -- Optional: Picker for server messages/tools
		},
		keys = {
			{ "<leader>ec", "<cmd>EcaChat<cr>", desc = "Open ECA chat" },
			{ "<leader>ef", "<cmd>EcaFocus<cr>", desc = "Focus ECA sidebar" },
			{ "<leader>et", "<cmd>EcaToggle<cr>", desc = "Toggle ECA sidebar" },
		},
		opts = {
			debug = false,
			server_path = "",
			behavior = {
				auto_set_keymaps = true,
				auto_focus_sidebar = true,
			},
		},
	},
}
