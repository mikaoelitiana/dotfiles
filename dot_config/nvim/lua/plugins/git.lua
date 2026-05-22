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
  {
    "afonsofrancof/worktrees.nvim",
    event = "VeryLazy",
    opts = {
      mappings = {
        create = "<leader>wtc",
        delete = "<leader>wtd",
        switch = "<leader>wts",
      },
      on_create = function(path)
        local source_dir = vim.fn.getcwd()

        -- Copy .env and .env.local to the new worktree
        local env_files = { ".env", ".env.local" }
        for _, file in ipairs(env_files) do
          local src = source_dir .. "/" .. file
          if vim.fn.filereadable(src) == 1 then
            vim.fn.system({ "cp", src, path .. "/" .. file })
            vim.notify("Copied " .. file .. " to new worktree", vim.log.levels.INFO)
          end
        end

        -- Run mise trust if a mise config is present
        local mise_files = { ".mise.toml", ".mise.local.toml", "mise.toml", ".tool-versions" }
        for _, file in ipairs(mise_files) do
          if vim.fn.filereadable(path .. "/" .. file) == 1 then
            vim.fn.jobstart({ "mise", "trust", "--all" }, {
              cwd = path,
              on_exit = function(_, code)
                if code == 0 then
                  vim.schedule(function()
                    vim.notify("Ran mise trust in new worktree", vim.log.levels.INFO)
                  end)
                end
              end,
            })
            break
          end
        end

        -- Detect package manager and run install
        local install_cmd = nil
        if vim.fn.filereadable(path .. "/bun.lockb") == 1 or vim.fn.filereadable(path .. "/bun.lock") == 1 then
          install_cmd = "bun install"
        elseif vim.fn.filereadable(path .. "/pnpm-lock.yaml") == 1 then
          install_cmd = "pnpm install"
        elseif vim.fn.filereadable(path .. "/yarn.lock") == 1 then
          install_cmd = "yarn install"
        elseif vim.fn.filereadable(path .. "/package-lock.json") == 1 then
          install_cmd = "npm install"
        elseif
          vim.fn.filereadable(path .. "/requirements.txt") == 1
          or vim.fn.filereadable(path .. "/pyproject.toml") == 1
        then
          install_cmd = "pip install -r requirements.txt"
        end

        if install_cmd then
          vim.notify("Running: " .. install_cmd .. " in new worktree...", vim.log.levels.INFO)
          vim.fn.jobstart(install_cmd, {
            cwd = path,
            on_exit = function(_, code)
              if code == 0 then
                vim.schedule(function()
                  vim.notify("Dependencies installed in worktree", vim.log.levels.INFO)
                end)
              else
                vim.schedule(function()
                  vim.notify("Failed to install dependencies (exit code: " .. code .. ")", vim.log.levels.ERROR)
                end)
              end
            end,
          })
        end
      end,
    },
  },
}
