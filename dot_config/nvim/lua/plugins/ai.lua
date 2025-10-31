return {
	{
		"sudo-tee/opencode.nvim",
		config = function()
			require("opencode").setup({
				keymap_prefix = "<leader>a",
				keymap = {
					editor = {
						["<leader>ag"] = { "toggle", desc = "Toggle opencode" },
						["<leader>ai"] = { "open_input", desc = "Open input" },
						["<leader>aI"] = {
							"open_input_new_session",
							desc = "Open input with new session",
						},
						["<leader>ao"] = { "open_output", desc = "Open output" },
						["<leader>at"] = { "toggle_focus", desc = "Toggle focus" },
						["<leader>aq"] = { "close", desc = "Close UI windows" },
						["<leader>as"] = { "select_session", desc = "Select session" },
						["<leader>ap"] = {
							"configure_provider",
							desc = "Configure provider",
						},
						["<leader>ad"] = {
							"diff_open",
							desc = "Opens diff",
						},
						["<leader>a]"] = { "diff_next", desc = "Navigate to next file diff" },
						["<leader>a["] = { "diff_prev", desc = "Navigate to previous file diff" },
						["<leader>ac"] = { "diff_close", desc = "Cl`ose diff view tab and return to normal editing" },
						["<leader>ara"] = {
							"diff_revert_all_last_prompt",
							desc = "Revert all file changes since the last opencode prompt",
						},
						["<leader>art"] = {
							"diff_revert_this_last_prompt",
							desc = "Revert current file changes since the last opencode prompt",
						},
						["<leader>arA"] = {
							"diff_revert_all",
							desc = "Revert all file changes since the last opencode session",
						},
						["<leader>arT"] = {
							"diff_revert_this",
							desc = "Revert current file changes since the last opencode session",
						},
						["<leader>arr"] = { "diff_restore_snapshot_file", desc = "Restore a file to a restore point" },
						["<leader>arR"] = { "diff_restore_snapshot_all", desc = "Restore all files to a restore point" },
						["<leader>ax"] = { "swap_position", desc = "Swap Opencode pane left/right" },
						["<leader>apa"] = { "permission_accept", desc = "Accept permission request once" },
						["<leader>apA"] = { "permission_accept_all", desc = "Accept all (for current tool)" },
						["<leader>apd"] = { "permission_deny", desc = "Deny permission request once" },
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
