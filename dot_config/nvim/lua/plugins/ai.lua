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
				hooks = {
					-- Automatically open files edited by opencode in Neovim buffers for real-time viewing
					on_file_edited = function(file_path, edit_type)
						local bufnr = vim.fn.bufnr(file_path)
						if bufnr ~= -1 and vim.fn.bufloaded(bufnr) == 1 then
							vim.cmd("buffer " .. bufnr)
						else
							vim.cmd("edit " .. vim.fn.fnameescape(file_path))
						end
					end,
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
