return {
  { "catppuccin/nvim", name = "catppuccin", priority = 1000, lazy = false },
  {
    "LazyVim/LazyVim",
    opts = { colorscheme = "catppuccin-frappe" },
  },
  {
    "luukvbaal/statuscol.nvim",
    config = function()
      require("statuscol").setup({})
    end,
  },
}
