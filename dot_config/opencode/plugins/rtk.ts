import { execFile } from "node:child_process"
import { promisify } from "node:util"

// RTK OpenCode plugin — rewrites commands to use rtk for token savings.
// Requires: rtk >= 0.23.0 in PATH.
//
// This is a thin delegating plugin: all rewrite logic lives in `rtk rewrite`,
// which is the single source of truth (src/discover/registry.rs).
// To add or change rewrite rules, edit the Rust registry — not this file.

const run = promisify(execFile)

export default {
  id: "rtk",
  async setup(ctx) {
    try {
      await run("which", ["rtk"])
    } catch {
      console.warn("[rtk] rtk binary not found in PATH — plugin disabled")
      return
    }

    await ctx.tool.hook("execute.before", async (event) => {
      if (event.tool !== "shell") return
      const input = event.input
      if (!input || typeof input !== "object") return

      const command = (input as Record<string, unknown>).command
      if (typeof command !== "string" || !command) return

      // `rtk rewrite` reports through its exit code: 0 and 3 print a rewrite,
      // 1 prints nothing, 2 is a deny whose message is the reason to block.
      const result = await run("rtk", ["rewrite", command]).catch(
        (error) => error,
      )
      const exit = typeof result.code === "number" ? result.code : 0
      const output = String(result.stdout ?? "").trim()

      if (exit === 2) {
        if (output) throw new Error(output)
        return
      }
      if ((exit === 0 || exit === 3) && output && output !== command) {
        event.input = { ...input, command: output }
      }
    })
  },
}
