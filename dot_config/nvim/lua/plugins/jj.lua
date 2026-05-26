local wk = require("which-key")

wk.add({
	{ "<leader>J", group = "+jujutsu" },
})

return {
	{
		"swaits/lazyjj.nvim",
		dependencies = "nvim-lua/plenary.nvim",
		opts = {
			mapping = "<leader>JJ",
		},
	},
	{
		"yannvanhalewyn/jujutsu.nvim",
		dependencies = "sindrets/diffview.nvim",
		opts = {
			diff_preset = "diffview",
		},
		keys = {
			{
				"<leader>gj",
				function()
					require("jujutsu-nvim").log()
				end,
				desc = "Jujutsu log",
			},
		},
	},
	{
		"Cretezy/neo-tree-jj.nvim",
		dependencies = {
			{
				"nvim-neo-tree/neo-tree.nvim",
				opts = function(_, opts)
					-- Register the source
					table.insert(opts.sources, "jj")

					-- Optional: Replace git tab in neo-tree when in jj repo
					if
						opts.source_selector
						and opts.source_selector.sources
						and require("neo-tree.sources.jj.utils").get_repository_root()
					then
						-- Remove git tab
						for i, source in ipairs(opts.source_selector.sources) do
							if source.source == "git_status" then
								table.remove(opts.source_selector.sources, i)
								break
							end
						end

						-- Add jj tab
						table.insert(opts.source_selector.sources, {
							display_name = "󰊢 JJ",
							source = "jj",
						})
					end
				end,
			},
		},
	},
}
