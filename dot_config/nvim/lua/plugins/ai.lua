return {
	-- {
	-- 	"sudo-tee/opencode.nvim",
	-- 	config = function()
	-- 		require("opencode").setup({
	-- 			keymap_prefix = "<leader>a",
	-- 			ui = {
	-- 				input = {
	-- 					text = {
	-- 						wrap = true, -- Wraps text inside input window
	-- 					},
	-- 				},
	-- 			},
	-- 			hooks = {
	-- 				-- Automatically open files edited by opencode in Neovim buffers for real-time viewing
	-- 				on_file_edited = function(file_path, edit_type)
	-- 					if not file_path then
	-- 						return
	-- 					end
	--
	-- 					local abs_path = vim.fn.fnamemodify(file_path, ":p")
	--
	-- 					if vim.fn.filereadable(abs_path) ~= 1 then
	-- 						return
	-- 					end
	--
	-- 					local bufnr = vim.fn.bufnr(abs_path)
	-- 					if bufnr ~= -1 and vim.fn.bufloaded(bufnr) == 1 then
	-- 						vim.cmd("buffer " .. bufnr)
	-- 					else
	-- 						vim.cmd("edit " .. vim.fn.fnameescape(abs_path))
	-- 					end
	-- 				end,
	-- 			},
	-- 		})
	-- 	end,
	-- 	dependencies = {
	-- 		"nvim-lua/plenary.nvim",
	-- 		{
	-- 			"MeanderingProgrammer/render-markdown.nvim",
	-- 			opts = {
	-- 				anti_conceal = { enabled = false },
	-- 				file_types = { "markdown", "opencode_output" },
	-- 			},
	-- 			ft = { "markdown", "Avante", "copilot-chat", "opencode_output" },
	-- 		},
	-- 		-- Optional, for file mentions and commands completion, pick only one
	-- 		"saghen/blink.cmp",
	-- 		"folke/snacks.nvim",
	-- 	},
	-- },
	{
		"folke/sidekick.nvim",
		opts = {
			cli = {
				mux = {
					enabled = true,
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
