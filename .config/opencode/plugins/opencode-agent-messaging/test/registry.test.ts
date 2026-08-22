import { describe, expect, test, beforeEach, afterEach } from "bun:test"
import fs from "node:fs/promises"
import path from "node:path"
import os from "node:os"
import { Registry, deriveName, type AgentRecord } from "../src/registry.js"

let dir: string

const rec = (over: Partial<AgentRecord> = {}): AgentRecord => ({
  sessionID: "ses_aaa",
  name: "my-app-aa",
  directory: "/repo/my-app",
  worktree: "/repo/my-app",
  serverUrl: "http://localhost:4096/",
  pid: process.pid,
  status: "idle",
  inbound: "accept",
  updated: 1_000_000,
  ...over,
})

const make = (over: Partial<ConstructorParameters<typeof Registry>[0]> = {}) =>
  new Registry({ dir, now: () => 1_000_000, alive: () => true, ...over })

beforeEach(async () => {
  dir = await fs.mkdtemp(path.join(os.tmpdir(), "xs-reg-"))
})

afterEach(async () => {
  await fs.rm(dir, { recursive: true, force: true })
})

describe("deriveName", () => {
  test("uses the working directory's folder name with a short suffix", () => {
    expect(deriveName("/repo/my-app", "ses_00000000000000003f")).toBe("my-app-3f")
  })

  test("gives sessions in the same directory different names", () => {
    expect(deriveName("/repo/my-app", "ses_aaaa11")).not.toBe(deriveName("/repo/my-app", "ses_aaaa22"))
  })

  test("sanitises awkward directory names", () => {
    expect(deriveName("/repo/My App (v2)", "ses_xx")).toMatch(/^my-app-v2-[a-z0-9]{2}$/)
  })

  test("falls back when there is no usable directory", () => {
    expect(deriveName("", "ses_zz")).toBe("session-zz")
    expect(deriveName("/", "ses_zz")).toBe("session-zz")
  })
})

describe("publish and list", () => {
  test("round-trips a record", async () => {
    const registry = make()
    await registry.init()
    await registry.publish(rec())
    const all = await registry.list()
    expect(all).toHaveLength(1)
    expect(all[0]!.name).toBe("my-app-aa")
  })

  test("returns nothing when no registry directory exists", async () => {
    expect(await make({ dir: "/tmp/xs-does-not-exist-here" }).list()).toEqual([])
  })

  test("republishing updates rather than duplicates", async () => {
    const registry = make()
    await registry.init()
    await registry.publish(rec({ status: "idle" }))
    await registry.publish(rec({ status: "working" }))
    const all = await registry.list()
    expect(all).toHaveLength(1)
    expect(all[0]!.status).toBe("working")
  })

  test("ignores unparseable files", async () => {
    const registry = make()
    await registry.init()
    await fs.writeFile(path.join(dir, "junk.json"), "{not json")
    expect(await registry.list()).toEqual([])
  })
})

describe("liveness", () => {
  test("prunes a record that stopped heartbeating", async () => {
    const registry = make()
    await registry.init()
    await registry.publish(rec({ updated: 1_000_000 - 200_000 }))
    expect(await registry.list()).toEqual([])
    expect(await fs.readdir(dir)).toEqual([])
  })

  test("prunes a record whose process is gone", async () => {
    const registry = make({ alive: () => false })
    await registry.init()
    await registry.publish(rec())
    expect(await registry.list()).toEqual([])
  })

  test("keeps a record owned by another user's live process", async () => {
    // process.kill throwing EPERM means the process exists but is not ours.
    const registry = make({
      alive: (pid) => {
        try {
          process.kill(pid, 0)
          return true
        } catch (e: any) {
          return e?.code === "EPERM"
        }
      },
    })
    await registry.init()
    await registry.publish(rec())
    expect(await registry.list()).toHaveLength(1)
  })
})

describe("peers and resolve", () => {
  const setup = async () => {
    const registry = make()
    await registry.init()
    await registry.publish(rec({ sessionID: "ses_self", name: "self-aa" }))
    await registry.publish(rec({ sessionID: "ses_api", name: "api-worker", directory: "/repo/api" }))
    return registry
  }

  test("peers excludes the caller", async () => {
    const registry = await setup()
    const peers = await registry.peers("ses_self")
    expect(peers.map((p) => p.name)).toEqual(["api-worker"])
  })

  test("resolves an unambiguous name", async () => {
    const registry = await setup()
    const r = await registry.resolve("api-worker", "ses_self")
    expect(r.kind).toBe("found")
    expect(r.kind === "found" && r.agent.sessionID).toBe("ses_api")
  })

  test("resolves case-insensitively and ignores surrounding space", async () => {
    const registry = await setup()
    expect((await registry.resolve("  API-Worker ", "ses_self")).kind).toBe("found")
  })

  test("never resolves to the caller itself", async () => {
    const registry = await setup()
    expect((await registry.resolve("self-aa", "ses_self")).kind).toBe("missing")
  })

  test("reports the reachable list when the name is unknown", async () => {
    const registry = await setup()
    const r = await registry.resolve("nope", "ses_self")
    expect(r.kind).toBe("missing")
    expect(r.kind === "missing" && r.available.map((a) => a.name)).toEqual(["api-worker"])
  })

  test("reports every candidate when a name is shared", async () => {
    const registry = await setup()
    await registry.publish(rec({ sessionID: "ses_api2", name: "api-worker", directory: "/repo/api-2" }))
    const r = await registry.resolve("api-worker", "ses_self")
    expect(r.kind).toBe("ambiguous")
    expect(r.kind === "ambiguous" && r.candidates).toHaveLength(2)
  })

  test("accepts an exact session id as an unambiguous address", async () => {
    const registry = await setup()
    await registry.publish(rec({ sessionID: "ses_api2", name: "api-worker", directory: "/repo/api-2" }))
    const r = await registry.resolve("ses_api2", "ses_self")
    expect(r.kind).toBe("found")
    expect(r.kind === "found" && r.agent.directory).toBe("/repo/api-2")
  })
})

describe("withdraw", () => {
  test("removes the record so the session stops being listed", async () => {
    const registry = make()
    await registry.init()
    await registry.publish(rec())
    await registry.withdraw("ses_aaa")
    expect(await registry.list()).toEqual([])
  })

  test("is safe to call for a session that was never published", async () => {
    const registry = make()
    await registry.init()
    await registry.withdraw("ses_never")
    expect(await registry.list()).toEqual([])
  })
})
