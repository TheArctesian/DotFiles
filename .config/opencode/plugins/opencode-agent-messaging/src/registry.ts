import fs from "node:fs/promises"
import path from "node:path"
import { registryDir } from "./paths.js"

export type Inbound = "accept" | "hold" | "refuse"
export type Status = "idle" | "working"

/** What a session publishes about itself so other sessions can reach it. */
export type AgentRecord = {
  sessionID: string
  name: string
  directory: string
  worktree: string
  /** Base URL of the opencode server hosting this session. */
  serverUrl: string
  pid: number
  status: Status
  inbound: Inbound
  updated: number
}

/** A record is only reachable if it was refreshed within this window. */
export const TTL_MS = 90_000

/**
 * Derive the name a session answers to, from its working directory.
 * A `my-app` directory yields `my-app-3f`, so same-named sessions in different
 * directories stay distinguishable without any configuration.
 */
export function deriveName(directory: string, sessionID: string) {
  const base =
    path
      .basename(directory || "session")
      .toLowerCase()
      .replace(/[^a-z0-9-]+/g, "-")
      .replace(/^-+|-+$/g, "")
      .slice(0, 32) || "session"
  const suffix = sessionID.replace(/[^a-z0-9]/gi, "").slice(-2).toLowerCase() || "00"
  return `${base}-${suffix}`
}

/** A process is gone if signal 0 throws anything other than "not permitted". */
const defaultAlive = (pid: number) => {
  try {
    process.kill(pid, 0)
    return true
  } catch (err: any) {
    return err?.code === "EPERM"
  }
}

export type Resolution =
  | { kind: "found"; agent: AgentRecord }
  | { kind: "missing"; available: AgentRecord[] }
  | { kind: "ambiguous"; candidates: AgentRecord[] }

export class Registry {
  private readonly dir: string
  private readonly ttlMs: number
  private readonly now: () => number
  private readonly alive: (pid: number) => boolean

  constructor(
    opts: { dir?: string; ttlMs?: number; now?: () => number; alive?: (pid: number) => boolean } = {},
  ) {
    this.dir = opts.dir ?? registryDir()
    this.ttlMs = opts.ttlMs ?? TTL_MS
    this.now = opts.now ?? Date.now
    this.alive = opts.alive ?? defaultAlive
  }

  private file(sessionID: string) {
    return path.join(this.dir, `${sessionID.replace(/[^a-zA-Z0-9_-]/g, "")}.json`)
  }

  async init() {
    await fs.mkdir(this.dir, { recursive: true }).catch(() => {})
  }

  /** Publish or refresh this session's record. Written atomically via rename. */
  async publish(record: AgentRecord) {
    const target = this.file(record.sessionID)
    const tmp = `${target}.${process.pid}.tmp`
    try {
      await fs.writeFile(tmp, JSON.stringify(record))
      await fs.rename(tmp, target)
    } catch {
      await fs.rm(tmp, { force: true }).catch(() => {})
    }
  }

  async withdraw(sessionID: string) {
    await fs.rm(this.file(sessionID), { force: true }).catch(() => {})
  }

  /** Every reachable session. Records of dead or stale sessions are pruned. */
  async list(): Promise<AgentRecord[]> {
    let names: string[]
    try {
      names = await fs.readdir(this.dir)
    } catch {
      return []
    }

    const cutoff = this.now() - this.ttlMs
    const out: AgentRecord[] = []

    for (const name of names) {
      if (!name.endsWith(".json")) continue
      const full = path.join(this.dir, name)
      let record: AgentRecord
      try {
        record = JSON.parse(await fs.readFile(full, "utf8"))
      } catch {
        continue
      }
      if (!record?.sessionID || !record.serverUrl) continue

      if (record.updated < cutoff || !this.alive(record.pid)) {
        await fs.rm(full, { force: true }).catch(() => {})
        continue
      }
      out.push(record)
    }

    return out.sort((a, b) => a.name.localeCompare(b.name))
  }

  /** Everything reachable except the caller. */
  async peers(selfSessionID: string) {
    return (await this.list()).filter((a) => a.sessionID !== selfSessionID)
  }

  /**
   * Find the single agent a name refers to. A name may be shared by sessions in
   * different directories, so an exact session id is also accepted as an
   * unambiguous address.
   */
  async resolve(name: string, selfSessionID: string): Promise<Resolution> {
    const peers = await this.peers(selfSessionID)
    const wanted = name.trim().toLowerCase()

    const byId = peers.find((a) => a.sessionID.toLowerCase() === wanted)
    if (byId) return { kind: "found", agent: byId }

    const matches = peers.filter((a) => a.name.toLowerCase() === wanted)
    if (matches.length === 1) return { kind: "found", agent: matches[0]! }
    if (matches.length > 1) return { kind: "ambiguous", candidates: matches }
    return { kind: "missing", available: peers }
  }
}
