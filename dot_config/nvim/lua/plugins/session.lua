return {
	{
		"folke/persistence.nvim",
		-- Neo-tree's oversized width after a session restore: :mksession never
		-- actually stores the neo-tree window (its buffer is special/unlisted),
		-- so the bad width comes from a neo-tree window that is already open when
		-- the session is restored. Fix: close neo-tree before save so it isn't
		-- the current window when :mksession runs, and after a session loads
		-- close any neo-tree window and reopen it fresh so its width is reset
		-- (the same thing a manual close + reopen does).
		init = function()
			local group = vim.api.nvim_create_augroup("neotree_session_fix", { clear = true })

			local function close_neotree()
				pcall(function()
					require("neo-tree.command").execute({ action = "close" })
				end)
			end

			vim.api.nvim_create_autocmd("User", {
				group = group,
				pattern = "PersistenceSavePre",
				callback = close_neotree,
			})

			vim.api.nvim_create_autocmd("User", {
				group = group,
				pattern = "PersistenceLoadPost",
				callback = function()
					vim.schedule(function()
						-- Was a neo-tree window present after restore? If so, reset it.
						local had_neotree = false
						for _, win in ipairs(vim.api.nvim_list_wins()) do
							local buf = vim.api.nvim_win_get_buf(win)
							if vim.bo[buf].filetype == "neo-tree" then
								had_neotree = true
								break
							end
						end
						close_neotree()
						if had_neotree then
							pcall(function()
								require("neo-tree.command").execute({
									action = "show",
									source = "filesystem",
									position = "left",
								})
								-- Backstop: force the configured width in case the
								-- reopened window inherited a stale size.
								local width = vim.tbl_get(require("neo-tree").config, "window", "width") or 40
								for _, win in ipairs(vim.api.nvim_list_wins()) do
									local buf = vim.api.nvim_win_get_buf(win)
									if vim.bo[buf].filetype == "neo-tree" then
										vim.api.nvim_win_set_width(win, width)
									end
								end
							end)
						end
					end)
				end,
			})
		end,
	},
}
