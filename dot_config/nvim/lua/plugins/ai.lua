return {
	{
		"folke/sidekick.nvim",
		opts = {
			cli = {
				mux = {
					enabled = true,
					backend = "zellij",
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
}
