local wk = require("which-key")

wk.add({
	{ "<leader>a", group = "+ai" },
})

return {
	{
		"carlos-algms/agentic.nvim",
		lazy = true,
		opts = {
			provider = "opencode-acp",
		},
		init = function()
			-- Map agentic.nvim highlight groups to the active catppuccin flavour.
			-- Agentic only creates a highlight if it doesn't already exist, so
			-- defining them here (and re-applying on ColorScheme) is enough.
			local function apply_highlights()
				local ok, palettes = pcall(require, "catppuccin.palettes")
				if not ok then
					return
				end
				local p = palettes.get_palette()
				if not p then
					return
				end

				local function blend(fg, bg, alpha)
					local function hex2rgb(hex)
						hex = hex:gsub("#", "")
						return tonumber(hex:sub(1, 2), 16), tonumber(hex:sub(3, 4), 16), tonumber(hex:sub(5, 6), 16)
					end
					local fr, fg_, fb = hex2rgb(fg)
					local br, bg_, bb = hex2rgb(bg)
					local r = math.floor(fr * alpha + br * (1 - alpha))
					local g = math.floor(fg_ * alpha + bg_ * (1 - alpha))
					local b = math.floor(fb * alpha + bb * (1 - alpha))
					return string.format("#%02x%02x%02x", r, g, b)
				end

				local hl = vim.api.nvim_set_hl
				-- Diff word-level (use stronger blend over base background)
				hl(0, "AgenticDiffDeleteWord", { bg = blend(p.red, p.base, 0.35), bold = true })
				hl(0, "AgenticDiffAddWord", { bg = blend(p.green, p.base, 0.35), bold = true })

				-- Tool-call status indicators
				hl(0, "AgenticStatusPending", { bg = blend(p.mauve, p.base, 0.35) })
				hl(0, "AgenticStatusCompleted", { bg = blend(p.green, p.base, 0.30) })
				hl(0, "AgenticStatusFailed", { bg = blend(p.red, p.base, 0.30) })

				-- Permission buttons
				hl(0, "AgenticPermissionButtonAllow", {
					bg = blend(p.green, p.base, 0.35),
					fg = p.text,
					bold = true,
				})
				hl(0, "AgenticPermissionButtonReject", {
					bg = blend(p.red, p.base, 0.35),
					fg = p.text,
					bold = true,
				})
				hl(0, "AgenticPermissionButtonInactive", { bg = p.surface1, fg = p.subtext0 })

				-- Window titles in sidebar
				hl(0, "AgenticTitle", { bg = p.blue, fg = p.base, bold = true })

				-- Linked groups: explicitly point at catppuccin-aware groups
				hl(0, "AgenticDiffDelete", { link = "DiffDelete" })
				hl(0, "AgenticDiffAdd", { link = "DiffAdd" })
				hl(0, "AgenticCodeBlockFence", { link = "Directory" })
				hl(0, "AgenticThinking", { link = "Comment" })
			end

			vim.api.nvim_create_autocmd("ColorScheme", {
				group = vim.api.nvim_create_augroup("AgenticCatppuccinHighlights", { clear = true }),
				callback = apply_highlights,
			})

			-- Apply now in case the colorscheme is already loaded.
			apply_highlights()
		end,
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
