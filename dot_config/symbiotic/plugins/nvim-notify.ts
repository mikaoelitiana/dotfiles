import type { Plugin } from "@symbioticsec/plugin";
import { spawn } from "child_process";

/**
 * nvim-notify plugin for Symbiotic Code
 *
 * Listens to `file.edited` events and opens the edited file in the running
 * Neovim instance via the $NVIM socket (automatically set when running
 * Symbiotic Code inside a Neovim :terminal).
 */

function openFileInNvim(socket: string, filePath: string): Promise<void> {
  return new Promise((resolve, reject) => {
    // Open the file in the first non-terminal window to avoid hijacking
    // the terminal running Symbiotic Code.
    // Fallback: open a vsplit if all windows are terminals.
    const escaped = filePath.replace(/\\/g, "\\\\").replace(/'/g, "\\'");
    // Load the buffer in the first non-terminal window without switching focus.
    // Save/restore the current window so the terminal stays active.
    const lua = `lua local cur=vim.api.nvim_get_current_win() for _,w in ipairs(vim.api.nvim_list_wins()) do if vim.bo[vim.api.nvim_win_get_buf(w)].buftype ~= 'terminal' then vim.api.nvim_win_set_buf(w,vim.fn.bufadd('${escaped}')) vim.bo[vim.fn.bufadd('${escaped}')].buflisted=true return end end vim.cmd('vsplit '..vim.fn.fnameescape('${escaped}')) vim.api.nvim_set_current_win(cur)`;

    const proc = spawn(
      "nvim",
      ["--server", socket, "--remote-send", `<C-\\><C-n>:${lua}<CR>`],
      {
        stdio: "ignore",
        detached: true,
      },
    );
    proc.unref();
    proc.on("error", reject);
    proc.on("close", (code) => {
      if (code === 0) {
        resolve();
      } else {
        reject(new Error(`nvim --remote-send exited with code ${code}`));
      }
    });
  });
}

export const NvimNotifyPlugin: Plugin = async ({ client }) => {
  return {
    event: async ({ event }) => {
      if (event.type !== "file.edited") {
        return;
      }

      const socket = process.env.NVIM;
      if (!socket) {
        return;
      }

      const filePath = event.properties.file;

      try {
        await openFileInNvim(socket, filePath);
      } catch (err: unknown) {
        const message = err instanceof Error ? err.message : String(err);
        await client.app.log({
          body: {
            service: "nvim-notify",
            level: "warn",
            message: `Failed to open ${filePath} in Neovim: ${message}`,
          },
        });
      }
    },
  };
};
