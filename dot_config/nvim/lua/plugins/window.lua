return {
  {
    "nvim-zh/colorful-winsep.nvim",
    opts = {
      no_exec_files = { "packer", "TelescopePrompt", "mason", "CompetiTest", "neo-tree" },
    },
    event = { "WinNew" },
  },
  {
    "s1n7ax/nvim-window-picker",
    name = "window-picker",
    event = "VeryLazy",
    version = "2.*",
    config = function()
      require("window-picker").setup()
    end,
  },
  {
    "https://gitlab.com/yorickpeterse/nvim-window.git",
    keys = {
      {
        "<leader>wp",
        function()
          require("nvim-window").pick()
        end,
        desc = "Pick a window",
      },
    },
  },
  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    keys = {
      { "<leader>bp", "<Cmd>BufferLineTogglePin<CR>", desc = "Toggle pin" },
      { "<leader>bP", "<Cmd>BufferLineGroupClose ungrouped<CR>", desc = "Delete non-pinned buffers" },
      {
        "<leader>1",
        function()
          require("bufferline").go_to(1, true)
        end,
        desc = "Jump to buffer 1",
      },
      {
        "<leader>2",
        function()
          require("bufferline").go_to(2, true)
        end,
        desc = "Jump to buffer 2",
      },
      {
        "<leader>3",
        function()
          require("bufferline").go_to(3, true)
        end,
        desc = "Jump to buffer 3",
      },
      {
        "<leader>4",
        function()
          require("bufferline").go_to(4, true)
        end,
        desc = "Jump to buffer 4",
      },
      {
        "<leader>5",
        function()
          require("bufferline").go_to(5, true)
        end,
        desc = "Jump to buffer 5",
      },
      {
        "<leader>6",
        function()
          require("bufferline").go_to(6, true)
        end,
        desc = "Jump to buffer 6",
      },
      {
        "<leader>7",
        function()
          require("bufferline").go_to(7, true)
        end,
        desc = "Jump to buffer 7",
      },
      {
        "<leader>8",
        function()
          require("bufferline").go_to(8, true)
        end,
        desc = "Jump to buffer 8",
      },
      {
        "<leader>9",
        function()
          require("bufferline").go_to(9, true)
        end,
        desc = "Jump to buffer 9",
      },
    },
    opts = {
      options = {
        diagnostics = "nvim_lsp",
        always_show_bufferline = false,
        show_buffer_close_icons = false,
        numbers = "ordinal",
        mappings = true,
        diagnostics_indicator = function(_, _, diag)
          local icons = require("lazyvim.config").icons.diagnostics
          local ret = (diag.error and icons.Error .. diag.error .. " " or "")
            .. (diag.warning and icons.Warn .. diag.warning or "")
          return vim.trim(ret)
        end,
        offsets = {
          {
            filetype = "neo-tree",
            text = "Neo-tree",
            highlight = "Directory",
            text_align = "left",
          },
        },
      },
    },
  },
}
