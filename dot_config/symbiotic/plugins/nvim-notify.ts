import type { Plugin } from "@symbioticsec/plugin";
import { execFile, spawn } from "child_process";
import { dirname } from "path";

/**
 * nvim-notify plugin for Symbiotic Code
 *
 * Listens to `file.edited` events and opens the edited file in the running
 * Neovim instance via the $NVIM socket (automatically set when running
 * Symbiotic Code inside a Neovim :terminal).
 */

/**
 * Determines the first edited line in a file by parsing `git diff` output.
 * Returns null for binary files (skip opening), or line 1 as fallback for
 * untracked files / empty diffs.
 */
function getFirstEditedLine(filePath: string): Promise<number | null> {
  return new Promise((resolve) => {
    execFile(
      "git",
      ["diff", "--unified=0", "--no-color", "--", filePath],
      { cwd: dirname(filePath) },
      (err, stdout) => {
        if (err || !stdout) {
          resolve(1);
          return;
        }
        // git diff reports "Binary files ... differ" for binary content
        if (/^Binary files .* differ$/m.test(stdout)) {
          resolve(null);
          return;
        }
        // Parse the first @@ hunk header: @@ -old[,count] +new[,count] @@
        const match = stdout.match(/@@ -\d+(?:,\d+)? \+(\d+)/);
        if (match) {
          resolve(Math.max(1, parseInt(match[1], 10)));
        } else {
          resolve(1);
        }
      },
    );
  });
}

function openFileInNvim(socket: string, filePath: string, line: number = 1): Promise<void> {
  return new Promise((resolve, reject) => {
    // Open the file in the first non-terminal window to avoid hijacking
    // the terminal running Symbiotic Code.
    // Fallback: open a vsplit if all windows are terminals.
    const escaped = filePath.replace(/\\/g, "\\\\").replace(/'/g, "\\'");
    // Load the buffer in the first non-terminal window without switching focus.
    // Save/restore the current window so the terminal stays active.
    // Position the cursor on the first edited line.
    const lua = `lua local cur=vim.api.nvim_get_current_win() local line=${line} for _,w in ipairs(vim.api.nvim_list_wins()) do if vim.bo[vim.api.nvim_win_get_buf(w)].buftype ~= 'terminal' then local buf=vim.fn.bufadd('${escaped}') vim.api.nvim_win_set_buf(w,buf) vim.bo[buf].buflisted=true vim.api.nvim_win_set_cursor(w,{math.min(line,math.max(1,vim.api.nvim_buf_line_count(buf))),0}) return end end vim.cmd('vsplit '..vim.fn.fnameescape('${escaped}')) local w=vim.api.nvim_get_current_win() local buf=vim.api.nvim_win_get_buf(w) vim.api.nvim_win_set_cursor(w,{math.min(line,math.max(1,vim.api.nvim_buf_line_count(buf))),0}) vim.api.nvim_set_current_win(cur)`;

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
        const line = await getFirstEditedLine(filePath);
        if (line === null) {
          // Binary file – skip opening in Neovim
          return;
        }
        await openFileInNvim(socket, filePath, line);
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
