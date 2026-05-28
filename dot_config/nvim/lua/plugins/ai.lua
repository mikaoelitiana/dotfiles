local wk = require("which-key")

wk.add({
	{ "<leader>a", group = "+ai" },
})

return {
	{
		"carlos-algms/agentic.nvim",
		opts = {
			provider = "symbiotic",
			acp_providers = {
				["symbiotic"] = {
					name = "symbiotic",
					command = "symbiotic",
					args = { "acp" },
				},
			},
		},
		keys = {
			{
				"<leader>aa",
				function()
					require("agentic").toggle()
				end,
				desc = "Toggle Agentic",
				mode = { "n", "v" },
			},
			{
				"<leader>ao",
				function()
					require("agentic").open()
				end,
				desc = "Open Agentic",
			},
			{
				"<leader>aq",
				function()
					require("agentic").close()
				end,
				desc = "Close Agentic",
			},
			{
				"<leader>an",
				function()
					require("agentic").new_session()
				end,
				desc = "New session",
			},
			{
				"<leader>ar",
				function()
					require("agentic").restore_session()
				end,
				desc = "Restore session",
			},
			{
				"<leader>as",
				function()
					require("agentic").stop_generation()
				end,
				desc = "Stop generation",
			},
			{
				"<leader>ap",
				function()
					require("agentic").switch_provider()
				end,
				desc = "Switch provider",
			},
			{
				"<leader>aL",
				function()
					require("agentic").rotate_layout()
				end,
				desc = "Rotate layout",
			},
			{
				"<leader>ac",
				function()
					require("agentic").add_selection_or_file_to_context({ focus_prompt = true })
				end,
				desc = "Add file/selection to context",
				mode = { "n", "v" },
			},
			{
				"<leader>af",
				function()
					require("agentic").add_file({ focus_prompt = true })
				end,
				desc = "Add file to context",
			},
			{
				"<leader>ad",
				function()
					require("agentic").add_current_line_diagnostics({ focus_prompt = true })
				end,
				desc = "Add line diagnostic",
			},
			{
				"<leader>aD",
				function()
					require("agentic").add_buffer_diagnostics({ focus_prompt = true })
				end,
				desc = "Add buffer diagnostics",
			},
		},
	},
}
