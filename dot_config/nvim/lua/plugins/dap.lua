return {
  {
    "jay-babu/mason-nvim-dap.nvim",
    config = function()
      require("mason-nvim-dap").setup({
        ensure_installed = { "js", "node2" },
        handlers = {
          function(config)
            require("mason-nvim-dap").default_setup(config)
          end,
          node2 = function(config)
            config.configurations = nil
            require("mason-nvim-dap").default_setup(config)
          end,
        },
      })

      local dap = require("dap")
      dap.adapters["pwa-node"] = dap.adapters.node2
    end,
  },
  {
    "mxsdev/nvim-dap-vscode-js",
    event = "VeryLazy",
    config = function()
      local dap = require("dap")

      dap.adapters.node = dap.adapters.node2

      for _, language in ipairs({ "javascript", "typescript" }) do
        dap.configurations[language] = {
          {
            type = "node",
            request = "launch",
            name = "Launch file (" .. language .. ")",
            program = "${file}",
            cwd = "${workspaceFolder}",
          },
          {
            type = "node",
            request = "attach",
            name = "Attach to process (" .. language .. ")",
            processId = require("dap.utils").pick_process,
            cwd = "${workspaceFolder}",
            sourceMaps = true,
            protocol = "inspector",
            console = "integratedTerminal",
            outputCapture = "std",
          },
        }
      end

      -- read .vscode/launch.json
      require("dap.ext.vscode").load_launchjs(nil, {
        node = { "javascript", "javascriptreact", "typescriptreact", "typescript" },
        node2 = {},
        ["pwa-node"] = { "javascript", "javascriptreact", "typescriptreact", "typescript" },
      })
    end,
  },
}
