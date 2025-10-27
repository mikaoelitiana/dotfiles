return {
	-- add js to treesitter
	{
		"nvim-treesitter/nvim-treesitter",
		opts = function(_, opts)
			vim.list_extend(opts.ensure_installed, { "css", "html", "javascript", "jsdoc", "scss" })
		end,
	},

	-- correctly setup mason lsp / dap extensions
	{
		"williamboman/mason.nvim",
		opts = function(_, opts)
			vim.list_extend(opts.ensure_installed, {
				"eslint-lsp",
				"html-lsp",
				"js-debug-adapter",
				"typescript-language-server",
				"tailwindcss-language-server",
			})
		end,
	},
}
