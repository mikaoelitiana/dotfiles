-- Auto-install/update bun-dap (https://github.com/ioeldev/bun-dap)
local function ensure_bun_dap()
	local install_path = vim.fn.stdpath("data") .. "/bun-dap"
	local marker = install_path .. "/dist/index.js"
	local is_installed = vim.fn.filereadable(marker) == 1

	-- Skip if installed and checked within the last 24h
	local last_check_file = install_path .. "/.last_update_check"
	if is_installed and vim.fn.filereadable(last_check_file) == 1 then
		local last_check = tonumber(vim.fn.readfile(last_check_file)[1] or "0")
		if os.time() - last_check < 86400 then
			return
		end
	end

	if vim.fn.executable("bun") == 0 then
		if not is_installed then
			vim.notify("bun-dap: 'bun' is not installed. Install bun first: https://bun.sh", vim.log.levels.WARN)
		end
		return
	end

	local cmds
	if is_installed then
		-- Update: pull latest and rebuild only if there are changes
		cmds = string.format(
			"cd %s && git fetch --depth 1 origin main && "
				.. "if [ $(git rev-parse HEAD) != $(git rev-parse origin/main) ]; then "
				.. "git reset --hard origin/main && bun install --frozen-lockfile && bun run build; fi",
			vim.fn.shellescape(install_path)
		)
	else
		-- Fresh install
		cmds = string.format(
			"git clone --depth 1 https://github.com/ioeldev/bun-dap.git %s && cd %s && bun install && bun run build",
			vim.fn.shellescape(install_path),
			vim.fn.shellescape(install_path)
		)
	end

	if not is_installed then
		vim.notify("bun-dap: installing...", vim.log.levels.INFO)
	end

	vim.fn.jobstart(cmds, {
		on_exit = function(_, code)
			if code == 0 then
				-- Record successful check timestamp
				vim.fn.writefile({ tostring(os.time()) }, last_check_file)
				if not is_installed then
					vim.notify("bun-dap: installed successfully", vim.log.levels.INFO)
				end
			else
				if not is_installed then
					-- Clean up failed install so next attempt starts fresh
					vim.fn.delete(install_path, "rf")
					vim.notify(
						"bun-dap: installation failed. Ensure 'bun' and 'git' are available.",
						vim.log.levels.ERROR
					)
				end
			end
		end,
	})
end

-- try to execute JS/TS files with ts-node
for _, language in ipairs({ "javascript", "typescript" }) do
	require("dap").configurations[language] = {
		{
			type = "node",
			request = "launch",
			name = "Run file with tsx",
			cwd = "${workspaceFolder}",
			runtimeArgs = { "tsx" },
			runtimeExecutable = "npx",
			args = { "--inspect", "${file}" },
			skipFiles = { "node_modules/**" },
			console = "integratedTerminal",
		},
		{
			type = "node",
			request = "launch",
			name = "Run file with ts-node",
			cwd = "${workspaceFolder}",
			runtimeArgs = { "ts-node", "-r tsconfig-paths/register" },
			runtimeExecutable = "npx",
			args = { "--inspect", "${file}" },
			skipFiles = { "node_modules/**" },
			console = "integratedTerminal",
			env = { NODE_ENV = "local" },
		},
		{
			type = "bun",
			request = "launch",
			name = "Run file with bun",
			cwd = "${workspaceFolder}",
			program = "${file}",
			stopOnEntry = false,
		},
		{
			type = "bun",
			request = "attach",
			name = "Attach to bun (ws://localhost:6499/)",
			inspectorUrl = "ws://localhost:6499/",
		},
		{
			-- Opens debug.bun.sh in browser for WebKit-based debugging
			type = "node",
			request = "launch",
			name = "Run file with bun (web debugger)",
			cwd = "${workspaceFolder}",
			runtimeExecutable = "bun",
			runtimeArgs = { "--inspect-wait" },
			args = { "${file}" },
			console = "integratedTerminal",
			autoAttachChildProcesses = false,
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

return {
	{
		"jay-babu/mason-nvim-dap.nvim",
		config = function()
			require("mason-nvim-dap").setup({
				ensure_installed = { "js", "node2" },
				automatic_installation = false,
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
		end,
	},
	{
		"mfussenegger/nvim-dap",
		opts = function()
			local dap = require("dap")
			if dap.adapters["pwa-node"] then
				dap.adapters["pwa-node"].host = "::1"
			end

			-- Ensure bun-dap is installed
			ensure_bun_dap()

			-- Bun debugger adapter (https://github.com/ioeldev/bun-dap)
			-- Bridges DAP over stdio to Bun's WebKit Inspector over WebSocket
			dap.adapters.bun = {
				type = "executable",
				command = "node",
				args = { vim.fn.stdpath("data") .. "/bun-dap/dist/index.js" },
			}

			-- Elixir
			dap.adapters.mix_task = {
				type = "executable",
				command = vim.fn.stdpath("data") .. "/mason/bin/elixir-ls-debugger",
				args = {},
			}
		end,
	},
}
