-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- load .nvimrc files in projects root
vim.o.exrc = true

-- ensure signcolumn is always enabled
require("lazyvim.util").lsp.on_attach(function()
  vim.opt.signcolumn = "yes"
  vim.opt.conceallevel = 0
end)
