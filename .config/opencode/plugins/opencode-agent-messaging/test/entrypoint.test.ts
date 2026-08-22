import { describe, expect, test } from "bun:test"
import * as entry from "../src/index.js"

/**
 * Regression guard for a real packaging bug.
 *
 * opencode calls every exported function of a plugin package as a plugin
 * factory. Version 0.2.0 also re-exported Registry, Inbox, Throttle, deliver and
 * friends from the entry point; those throw or return a string when called that
 * way, and the whole package silently failed to load from npm. It worked in
 * local development only because the dev loader re-exported the single plugin
 * function.
 *
 * The entry point must therefore export the plugin and nothing else.
 */
describe("entry point", () => {
  test("exports only the plugin factory and its default alias", () => {
    expect(Object.keys(entry).sort()).toEqual(["CrossSessionMessaging", "default"])
  })

  test("default is the same function, not a second plugin", () => {
    expect(entry.default).toBe(entry.CrossSessionMessaging)
  })

  test("every exported function is safe to call as a plugin factory", async () => {
    for (const [name, value] of Object.entries(entry)) {
      if (typeof value !== "function") continue
      const hooks = await (value as any)({
        directory: "/tmp/entrypoint-check",
        worktree: "/tmp/entrypoint-check",
        serverUrl: new URL("http://localhost:1/"),
      })
      expect(hooks, `${name} must return a hooks object`).toBeObject()
      if (hooks.dispose) await hooks.dispose()
    }
  })
})
