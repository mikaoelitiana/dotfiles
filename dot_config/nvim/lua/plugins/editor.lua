local wk = require("which-key")

wk.add({
	{ "<leader>j", group = "+jumplist" },
	{ "<leader>a", group = "+ai" },
})

return {
	{
		"nvim-treesitter/nvim-treesitter",
		dependencies = {
			{ "windwp/nvim-ts-autotag" },
		},
		event = { "BufReadPre" },
		opts = function(_, opts)
			vim.list_extend(opts.ensure_installed, {
				"typescript",
				"javascript",
				"hcl",
			})
			return vim.tbl_deep_extend("force", opts, {
				autotag = {
					enable = true,
				},
			})
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter-context",
		keys = {
			{
				"[k",
				function()
					require("treesitter-context").go_to_context(vim.v.count1)
				end,
				desc = "Go to context",
			},
		},
	},
	{
		"nvim-neo-tree/neo-tree.nvim",
		--  https://github.com/nvim-neo-tree/neo-tree.nvim#configuration-for-nerd-fonts-v3-users
		cmd = "Neotree",
		deactivate = function()
			vim.cmd([[Neotree close]])
		end,
		init = function()
			vim.g.neo_tree_remove_legacy_commands = 1
			if vim.fn.argc() == 1 then
				local stat = vim.loop.fs_stat(vim.fn.argv(0))
				if stat and stat.type == "directory" then
					require("neo-tree")
				end
			end
		end,
		opts = {
			sources = { "filesystem", "buffers", "git_status", "document_symbols" },
			source_selector = {
				winbar = true,
				sources = {
					{ source = "filesystem", display_name = " Files" },
					{ source = "buffers", display_name = "󰈚 Buffers" },
					{ source = "git_status", display_name = "󰊢 Git" },
					{ source = "document_symbols", display_name = " Symbols" },
				},
			},
			open_files_do_not_replace_types = { "terminal", "Trouble", "qf", "Outline" },
			filesystem = {
				bind_to_cwd = false,
				follow_current_file = true,
				use_libuv_file_watcher = true,
			},
			window = {
				mappings = {
					["<space>"] = "none",
				},
			},
			default_component_configs = {
				indent = {
					with_expanders = true, -- if nil and file nesting is enabled, will enable expanders
					expander_collapsed = "",
					expander_expanded = "",
					expander_highlight = "NeoTreeExpander",
				},
				icon = {
					folder_empty = "󰜌",
					folder_empty_open = "󰜌",
				},
				git_status = {
					symbols = {
						renamed = "󰁕",
						unstaged = "󰄱",
					},
				},
			},
			document_symbols = {
				kinds = {
					File = { icon = "󰈙", hl = "Tag" },
					Namespace = { icon = "󰌗", hl = "Include" },
					Package = { icon = "󰏖", hl = "Label" },
					Class = { icon = "󰌗", hl = "Include" },
					Property = { icon = "󰆧", hl = "@property" },
					Enum = { icon = "󰒻", hl = "@number" },
					Function = { icon = "󰊕", hl = "Function" },
					String = { icon = "󰀬", hl = "String" },
					Number = { icon = "󰎠", hl = "Number" },
					Array = { icon = "󰅪", hl = "Type" },
					Object = { icon = "󰅩", hl = "Type" },
					Key = { icon = "󰌋", hl = "" },
					Struct = { icon = "󰌗", hl = "Type" },
					Operator = { icon = "󰆕", hl = "Operator" },
					TypeParameter = { icon = "󰊄", hl = "Type" },
					StaticMethod = { icon = "󰠄 ", hl = "Function" },
				},
			},
		},
		config = function(_, opts)
			require("neo-tree").setup(opts)
			vim.api.nvim_create_autocmd("TermClose", {
				pattern = "*lazygit",
				callback = function()
					if package.loaded["neo-tree.sources.git_status"] then
						require("neo-tree.sources.git_status").refresh()
					end
				end,
			})
		end,
	},
	{
		"cbochs/portal.nvim",
		-- Optional dependencies
		dependencies = {
			"cbochs/grapple.nvim",
			"ThePrimeagen/harpoon",
		},
		keys = {
			{ "<leader>jo", "<cmd>Portal jumplist backward<cr>", desc = "Jump backward" },
			{ "<leader>ji", "<cmd>Portal jumplist forward<cr>", desc = "Jump forward" },
		},
	},
	{
		"AckslD/nvim-neoclip.lua",
		dependencies = {
			{ "kkharji/sqlite.lua", module = "sqlite" },
		},
		config = function()
			require("neoclip").setup()
		end,
	},
	{
		"gregorias/coerce.nvim",
		tag = "v4.1.0",
		config = true,
	},
	{
		"ibhagwan/fzf-lua",
		opts = function(_, opts)
			local actions = require("fzf-lua.actions")
			return {
				actions = {
					files = {
						["enter"] = actions.file_edit,
						["alt-q"] = actions.file_sel_to_qf,
					},
				},
				keymap = {
					fzf = {
						["tab"] = "down",
						["shift-tab"] = "up",
						["ctrl-a"] = "toggle-all",
						["ctrl-space"] = "toggle",
					},
				},
			}
		end,
	},
	{
		"folke/snacks.nvim",
		opts = {
			picker = {
				win = {
					input = {
						keys = {
							["<c-Space>"] = { "select_and_next", mode = { "i", "n" } },
							["<S-Tab>"] = { "list_up", mode = { "i", "n" } },
							["<Tab>"] = { "list_down", mode = { "i", "n" } },
							["<c-d>"] = { "preview_scroll_down", mode = { "i", "n" } },
							["<c-u>"] = { "preview_scroll_up", mode = { "i", "n" } },
							["<c-f>"] = { "list_scroll_down", mode = { "i", "n" } },
							["<c-b>"] = { "list_scroll_up", mode = { "i", "n" } },
						},
					},
				},
			},
		},
	},
}
