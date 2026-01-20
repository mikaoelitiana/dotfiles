-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- load .nvimrc files in projects root
vim.o.exrc = true
-- https://www.lazyvim.org/extras/formatting/biome#options
-- Enable this option to avoid Biome conflicts with Prettier.
vim.g.lazyvim_prettier_needs_config = true
