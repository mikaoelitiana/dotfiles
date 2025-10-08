return {
	{
		"ravitemer/mcphub.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		build = "bundled_build.lua", -- Bundles `mcp-hub` binary along with the neovim plugin
		config = function()
			require("mcphub").setup({
				use_bundled_binary = true, -- Use local `mcp-hub` binary
				extensions = {
					avante = {
						make_slash_commands = true, -- make /slash commands from MCP server prompts
					},
				},
			})
		end,
	},
	{
		"yetone/avante.nvim",
		-- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
		build = "make", -- ⚠️ must add this line! ! !
		-- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
		event = "VeryLazy",
		version = false, -- Never set this value to "*"! Never!
		---@module 'avante'
		---@type avante.Config
		opts = {
			-- mode = "agentic",
			provider = "lmstudio",
			auto_suggestions_provider = "ollama",
			cursor_applying_provider = "ollama",
			providers = {
				ollama = {
					endpoint = "http://127.0.0.1:11434",
					-- model = "qwen3-coder:30b",
					-- model = "devstral:24b",
					model = "cogito:14b",
					disable_tools = false,
					extra_request_body = {
						stream = true,
					},
				},
				-- mistral = {
				-- 	__inherited_from = "openai",
				-- 	api_key_name = "AVANTE_MISTRAL_API_KEY",
				-- 	endpoint = "https://api.mistral.ai/v1/",
				-- 	model = "devstral-medium-2507",
				-- 	extra_request_body = {
				-- 		max_tokens = 4096, -- to avoid using max_completion_tokens
				-- 	},
				-- },
				lmstudio = {
					__inherited_from = "openai",
					endpoint = "http://127.0.0.1:1234/v1",
					api_key_name = "",
					model = "qwen/qwen3-30b-a3b-2507",
					extra_request_body = {
						max_tokens = 4096, -- to avoid using max_completion_tokens
						stream = true,
					},
				},
			},
			behaviour = {
				enable_cursor_planning_mode = false,
				auto_focus_sidebar = true,
				auto_suggestions = true,
				auto_suggestions_respect_ignore = false,
				auto_set_highlight_group = true,
				auto_set_keymaps = true,
				auto_apply_diff_after_generation = true,
				jump_result_buffer_on_finish = false,
				support_paste_from_clipboard = false,
				minimize_diff = true,
				enable_token_counting = true,
				use_cwd_as_project_root = false,
				auto_focus_on_diff_view = false,
			},
		},
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",
			--- The below dependencies are optional,
			"echasnovski/mini.pick", -- for file_selector provider mini.pick
			"nvim-telescope/telescope.nvim", -- for file_selector provider telescope
			"hrsh7th/nvim-cmp", -- autocompletion for avante commands and mentions
			"ibhagwan/fzf-lua", -- for file_selector provider fzf
			"stevearc/dressing.nvim", -- for input provider dressing
			"folke/snacks.nvim", -- for input provider snacks
			"nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
			"zbirenbaum/copilot.lua", -- for providers='copilot'
			{
				-- support for image pasting
				"HakonHarnes/img-clip.nvim",
				event = "VeryLazy",
				opts = {
					-- recommended settings
					default = {
						embed_image_as_base64 = false,
						prompt_for_file_name = false,
						drag_and_drop = {
							insert_mode = true,
						},
						-- required for Windows users
						use_absolute_path = true,
					},
				},
			},
			{
				-- Make sure to set this up properly if you have lazy=true
				"MeanderingProgrammer/render-markdown.nvim",
				opts = {
					file_types = { "markdown", "Avante" },
				},
				ft = { "markdown", "Avante" },
			},
		},
		config = {
			-- system_prompt as function ensures LLM always has latest MCP server state
			-- This is evaluated for every message, even in existing chats
			system_prompt = function()
				local hub = require("mcphub").get_hub_instance()
				return hub and hub:get_active_servers_prompt() or ""
			end,
			-- Using function prevents requiring mcphub before it's loaded
			custom_tools = function()
				return {
					require("mcphub.extensions.avante").mcp_tool(),
				}
			end,
		},
	},
}
