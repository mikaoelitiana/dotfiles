local actions = require("fzf-lua.actions")

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
	-- {
	-- 	"nvim-treesitter/nvim-treesitter-context",
	-- 	dependencies = { "nvim-treesitter/nvim-treesitter" },
	-- 	event = "VeryLazy",
	-- 	opts = {
	-- 		enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
	-- 		max_lines = 0, -- How many lines the window should span. Values <= 0 mean no limit.
	-- 		min_window_height = 0, -- Minimum editor window height to enable context. Values <= 0 mean no limit.
	-- 		line_numbers = true,
	-- 		multiline_threshold = 20, -- Maximum number of lines to collapse for a single context line
	-- 		trim_scope = "outer", -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
	-- 		mode = "cursor", -- Line used to calculate context. Choices: 'cursor', 'topline'
	-- 		-- Separator between context and content. Should be a single character string, like '-'.
	-- 		-- When separator is set, the context will only show up when there are at least 2 lines above cursorline.
	-- 		separator = nil,
	-- 		zindex = 20, -- The Z-index of the context window
	-- 	},
	-- 	keys = {
	-- 		{
	-- 			"<leader>cc",
	-- 			"<cmd>TSContextToggle<cr>",
	-- 			desc = "Toggle context",
	-- 		},
	-- 		{
	-- 			"<leader>cg",
	-- 			function()
	-- 				require("treesitter-context").go_to_context()
	-- 			end,
	-- 			desc = "Go to context",
	-- 		},
	-- 		{
	-- 			"gC",
	-- 			function()
	-- 				require("treesitter-context").go_to_context()
	-- 			end,
	-- 			desc = "Go to context",
	-- 		},
	-- 	},
	-- },
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
		"kylechui/nvim-surround",
		version = "*",
		event = "VeryLazy",
		config = function()
			require("nvim-surround").setup({
				keymaps = {
					normal = "ys",
					delete = "ds",
					visual = "z",
					visual_line = "gS",
					change = "cs",
					change_line = "cS",
				},
				-- Configuration here, or leave empty to use defaults
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
			{ "<leader>o", "<cmd>Portal jumplist backward<cr>", desc = "Jump backward" },
			{ "<leader>i", "<cmd>Portal jumplist forward<cr>", desc = "Jump forward" },
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
		"tpope/vim-abolish",
		init = function()
			-- https://github.com/gregorias/coerce.nvim
			-- Disable coercion mappings. I use coerce.nvim for that.
			-- vim.g.abolish_no_mappings = true
		end,
	},
	{
		"ibhagwan/fzf-lua",
		opts = {
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
		},
	},
}
