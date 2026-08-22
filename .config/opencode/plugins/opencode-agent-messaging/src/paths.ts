import path from "node:path"
import os from "node:os"

/**
 * Root for everything sessions publish about themselves.
 * Overridable so tests never touch a live registry.
 */
export const baseDir = () =>
  process.env["OPENCODE_CROSS_SESSION_HOME"] ||
  path.join(os.homedir(), ".cache", "opencode", "cross-session")

export const registryDir = () => path.join(baseDir(), "agents")
export const inboxDir = () => path.join(baseDir(), "inbox")
