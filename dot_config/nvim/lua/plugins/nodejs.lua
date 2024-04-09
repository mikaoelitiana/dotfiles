local wk = require("which-key")

wk.register({
  ["<leader>"] = {
    c = {
      o = {
        name = "+overseer",
      },
    },
  },
})

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
      vim.list_extend(
        opts.ensure_installed,
        { "eslint-lsp", "html-lsp", "js-debug-adapter", "node-debug2-adapter", "typescript-language-server" }
      )
    end,
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = { eslint = {} },
      setup = {
        eslint = function()
          require("lazyvim.util").lsp.on_attach(function(client)
            if client.name == "eslint" then
              client.server_capabilities.documentFormattingProvider = true
            elseif client.name == "tsserver" then
              client.server_capabilities.documentFormattingProvider = false
            end
          end)
        end,
      },
    },
  },
  {
    "stevearc/overseer.nvim",
    config = function()
      local overseer = require("overseer")
      overseer.setup({
        sections = {
          lualine_x = { "overseer" },
        },
      })
      overseer.register_template({
        name = "tsc --watch",
        builder = function()
          return {
            cmd = { "yarn", "tsc", "--watch", "--noEmit" }, -- or however you're running tsc --watch
            components = {
              {
                "on_output_parse",
                problem_matcher = "$tsc-watch",
              },
              "default",
              "on_result_notify",
              "on_result_diagnostics",
              "on_complete_restart",
            },
          }
        end,
      })
    end,
    keys = {
      { "<leader>cot", "<cmd>OverseerToggle<cr>", desc = "Overseer Toggle" },
      { "<leader>cor", "<cmd>OverseerRun<cr>", desc = "Overseer Run" },
    },
  },
}
