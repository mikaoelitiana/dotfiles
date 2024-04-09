-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local function map(mode, lhs, rhs, opts)
  local keys = require("lazy.core.handler").handlers.keys
  ---@cast keys LazyKeysHandler
  if not keys.active[keys.parse({ lhs, mode = mode }).id] then
    opts = opts or {}
    opts.silent = opts.silent ~= false
    vim.keymap.set(mode, lhs, rhs, opts)
  end
end

map("n", "<leader>fy", "<cmd>let @*=expand('%')<cr>", { desc = "Yank file path to clipboard" })
map("n", "<leader>fY", "<cmd>echo expand('%')<cr>", { desc = "Echo file path" })
map("n", "<leader>ce", "<cmd>EslintFixAll<cr>", { desc = "EslintFixAll" })
