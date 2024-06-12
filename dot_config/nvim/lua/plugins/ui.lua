return {
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = function(_, opts)
      table.insert(opts.routes, {
        filter = {
          event = "lsp",
          kind = "message",
          find = "Inlay Hints request failed. Requires TypeScript 4.4+.",
        },
        opts = { skip = true },
      })
    end,
  },
}
