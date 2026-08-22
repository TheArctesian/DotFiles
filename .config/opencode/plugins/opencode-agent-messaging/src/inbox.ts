import fs from "node:fs/promises"
import path from "node:path"
import { inboxDir } from "./paths.js"

export type Held = { from: string; text: string; ts: number }

/** Matches Claude Code's cap on messages waiting to be read. */
export const MAX_HELD = 50

/**
 * Messages for a session that asked not to be woken.
 *
 * A held message is not delivered on arrival. It waits on disk and is handed to
 * the session at the start of its next turn, so nothing runs unattended.
 */
export class Inbox {
  private readonly dir: string

  constructor(opts: { dir?: string } = {}) {
    this.dir = opts.dir ?? inboxDir()
  }

  private file(sessionID: string) {
    return path.join(this.dir, `${sessionID.replace(/[^a-zA-Z0-9_-]/g, "")}.jsonl`)
  }

  async init() {
    await fs.mkdir(this.dir, { recursive: true }).catch(() => {})
  }

  async hold(sessionID: string, entry: Held) {
    await this.init()
    await fs.appendFile(this.file(sessionID), JSON.stringify(entry) + "\n").catch(() => {})
  }

  /** Read and clear everything waiting for a session. */
  async drain(sessionID: string): Promise<Held[]> {
    const file = this.file(sessionID)
    let raw: string
    try {
      raw = await fs.readFile(file, "utf8")
    } catch {
      return []
    }
    await fs.rm(file, { force: true }).catch(() => {})

    const out: Held[] = []
    for (const line of raw.split("\n")) {
      if (!line.trim()) continue
      try {
        const held = JSON.parse(line) as Held
        if (held?.text && held.from) out.push(held)
      } catch {
        // Torn line from a concurrent writer.
      }
    }
    // Past the cap the oldest are dropped, matching the documented behaviour.
    return out.slice(-MAX_HELD)
  }
}
