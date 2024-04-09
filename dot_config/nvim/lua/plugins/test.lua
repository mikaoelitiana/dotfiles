local wk = require("which-key")

local function get_var(my_var_name, default_value)
  s, v = pcall(function()
    return vim.api.nvim_get_var(my_var_name)
  end)
  if s then
    return v
  else
    return default_value
  end
end

wk.register({
  ["<leader>"] = {
    t = {
      name = "+test",
    },
  },
})

local M = {}

function M.create_test_file_extensions_matcher(intermediate_extensions, end_extensions)
  return function(file_path)
    if file_path == nil then
      return false
    end

    for _, iext in ipairs(intermediate_extensions) do
      for _, eext in ipairs(end_extensions) do
        if string.match(file_path, iext .. "%." .. eext .. "$") then
          return true
        end
      end
    end

    return false
  end
end

return {
  { "nvim-lua/plenary.nvim" },
  { "antoinemadec/FixCursorHold.nvim" },
  { "adrigzr/neotest-mocha" },
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-treesitter/nvim-treesitter", -- should fix https://github.com/nvim-neotest/neotest-jest/issues/85
      "nvim-neotest/neotest-jest",
      "marilari88/neotest-vitest",
      {
        "mrcjkb/rustaceanvim",
        version = "^4", -- Recommended
        ft = { "rust" },
      },
    },
    opts = function(_, opts)
      local is_mocha_test_file = M.create_test_file_extensions_matcher({ "-test" }, { "js", "jsx", "ts", "tsx" })

      opts.adapters = {
        ["neotest-jest"] = {
          jestCommand = Neotest_jest_command ~= nil and Neotest_jest_command or "npx jest --",
          env = Neotest_jest_env ~= nil and Neotest_jest_env or { CI = true },
        },
        ["neotest-mocha"] = {
          command = get_var("neotest_mocha_command", "npm test --"),
          env = neotest_mocha_env ~= nil and neotest_mocha_env or { CI = true },
          cwd = function(path)
            return vim.fn.getcwd()
          end,
          is_test_file = neotest_mocha_is_test_file ~= nil and neotest_mocha_is_test_file or is_mocha_test_file,
        },
        ["neotest-vitest"] = {},
        ["rustaceanvim.neotest"] = {},
      }

      opts.status = {
        enabled = true,
        signs = true,
        virtual_text = false,
      }

      opts.consumers = {
        overseer = require("neotest.consumers.overseer"),
      }
    end,
    keys = {
      --   {
      --     "<leader>tf",
      --     function()
      --       require("neotest").run.run(vim.fn.expand("%"))
      --     end,
      --     desc = "Run current test file",
      --   },
      --   {
      --     "<leader>tn",
      --     function()
      --       require("neotest").run.run()
      --     end,
      --     desc = "Run nearest test",
      --   },
      {
        "<leader>tl",
        function()
          require("neotest").run.run_last()
        end,
        desc = "Run last test",
      },
      --   {
      --     "<leader>td",
      --     function()
      --       require("neotest").run.run({ strategy = "dap" })
      --     end,
      --     desc = "Debug nearest test",
      --   },
      --   {
      --     "<leader>ts",
      --     function()
      --       require("neotest").summary.toggle()
      --     end,
      --     desc = "Toggle summary view",
      --   },
      --   {
      --     "<leader>to",
      --     function()
      --       require("neotest").output.open({ enter = true })
      --     end,
      --     desc = "View output",
      --   },
    },
  },
}
