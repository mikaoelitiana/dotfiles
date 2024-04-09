return {
  {
    "ruifm/gitlinker.nvim",
    depedencies = { "nvim-lua/plenary.nvim" },
    keys = {
      {
        "<leader>gy",
        function()
          require("gitlinker").get_buf_range_url("n")
        end,
        desc = "Yank remote host permalink",
        mode = "n",
      },
      {
        "<leader>gy",
        function()
          require("gitlinker").get_buf_range_url("v")
        end,
        desc = "Yank remote host permalink",
        mode = "v",
      },
    },
  },
  {
    "f-person/git-blame.nvim",
    keys = { { "<leader>gb", "<cmd>GitBlameToggle<cr>", desc = "Toggle GitBlame" } },
  },
}
