return {
	{
		"folke/sidekick.nvim",
		opts = {
			cli = {
				mux = {
					enabled = true,
					backend = "zellij",
				},
				win = {
					keys = {
						prompt = { "<c-y>", "prompt", mode = "t", desc = "insert prompt or context" },
					},
				},
				tools = {
					symbiotic = {
						cmd = { "symbiotic" },
						continue = { "--continue" },
						native_scroll = true,
						env = {
							-- HACK: https://github.com/sst/opencode/issues/445
							OPENCODE_THEME = "system",
						},
					},
				},
			},
		},
	},
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
	},
}
