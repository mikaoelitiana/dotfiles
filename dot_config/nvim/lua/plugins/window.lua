local wk = require("which-key")

-- Register buffer jump mappings directly (not via expand)
-- so that `hidden = true` is properly respected by tree:fix()
local buffer_mappings = {
	{ "<leader>", group = "buffers" },
}
for buf = 1, 9, 1 do
	buffer_mappings[#buffer_mappings + 1] = {
		"<leader>" .. buf,
		function()
			require("bufferline").go_to(buf, true)
		end,
		desc = "Jump to buffer " .. buf,
		icon = { cat = "file" },
		hidden = true,
	}
end
buffer_mappings[#buffer_mappings + 1] = { "<leader>*", desc = "Jump to buffer [1-9]", icon = { cat = "file" } }

wk.add(buffer_mappings)

return {
	{
		"s1n7ax/nvim-window-picker",
		name = "window-picker",
		event = "VeryLazy",
		version = "2.*",
		config = function()
			require("window-picker").setup({
				hint = "floating-big-letter",
				filter_rules = {
					include_current_win = false,
					autoselect_one = true,
					-- filter using buffer options
					bo = {
						-- if the file type is one of following, the window will be ignored
						filetype = { "neo-tree", "neo-tree-popup", "notify", "noice" },
						-- if the buffer type is one of following, the window will be ignored
						buftype = { "terminal", "quickfix" },
					},
				},
			})
		end,
	},
	{
		"https://github.com/yorickpeterse/nvim-window.git",
		keys = {
			{
				"<leader>wp",
				function()
					require("nvim-window").pick()
				end,
				desc = "Pick a window",
			},
		},
	},
	{
		"akinsho/bufferline.nvim",
		event = "VeryLazy",
		opts = {
			options = {
				diagnostics = "nvim_lsp",
				always_show_bufferline = true,
				show_buffer_close_icons = false,
				numbers = "ordinal",
				mappings = true,
				diagnostics_indicator = function(_, _, diag)
					local icons = require("lazyvim.config").icons.diagnostics
					local ret = (diag.error and icons.Error .. diag.error .. " " or "")
						.. (diag.warning and icons.Warn .. diag.warning or "")
					return vim.trim(ret)
				end,
				offsets = {
					{
						filetype = "neo-tree",
						text = "Neo-tree",
						highlight = "Directory",
						text_align = "left",
					},
					{
						filetype = "dapui_scopes",
						text = "Debugger",
						highlight = "Directory",
						text_align = "left",
					},
					{
						filetype = "dapui_breakpoints",
						text = "Debugger",
						highlight = "Directory",
						text_align = "left",
					},
					{
						filetype = "dapui_stacks",
						text = "Debugger",
						highlight = "Directory",
						text_align = "left",
					},
				},
			},
		},
	},
	{
		"folke/snacks.nvim",
		opts = {
			explorer = { enabled = false },
			lazygit = {
				theme = {},
				win = {
					height = 0,
					width = 0,
				},
			},
		},
	},
}
