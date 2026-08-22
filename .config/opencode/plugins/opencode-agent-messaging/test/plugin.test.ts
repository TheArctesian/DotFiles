import { describe, expect, test, beforeEach, afterEach } from "bun:test"
import fs from "node:fs/promises"
import path from "node:path"
import os from "node:os"
import { CrossSessionMessaging } from "../src/index.js"
import { Registry, type AgentRecord } from "../src/registry.js"

/**
 * Two plugin instances stand in for two opencode processes. They share a
 * registry directory the way two real sessions share ~/.cache/opencode.
 */

let home: string
let sent: any[]
let realFetch: typeof fetch
const disposers: (() => Promise<void>)[] = []

const SES_A = "ses_aaaa11"
const SES_B = "ses_bbbb22"

const load = async (directory: string, serverUrl: string) => {
  const plugin = (await CrossSessionMessaging({
    directory,
    worktree: directory,
    serverUrl: serverUrl ? new URL(serverUrl) : undefined,
  } as any)) as any
  if (plugin.dispose) disposers.push(plugin.dispose)
  return plugin
}

/** Drive chat.message the way opencode does, returning any injected text. */
const turn = async (plugin: any, sessionID: string) => {
  const output = { message: { id: "msg_1" }, parts: [] as any[] }
  await plugin["chat.message"]({ sessionID, agent: "build" }, output)
  return output.parts.map((p: any) => p.text).join("\n")
}

const peer = (over: Partial<AgentRecord>): AgentRecord => ({
  sessionID: "ses_peer",
  name: "peer-01",
  directory: "/repo/peer",
  worktree: "/repo/peer",
  serverUrl: "http://localhost:4999/",
  pid: process.pid,
  status: "idle",
  inbound: "accept",
  updated: Date.now(),
  ...over,
})

beforeEach(async () => {
  home = await fs.mkdtemp(path.join(os.tmpdir(), "xs-plugin-"))
  process.env["OPENCODE_CROSS_SESSION_HOME"] = home
  delete process.env["OPENCODE_CROSS_SESSION_INBOUND"]
  delete process.env["OPENCODE_AGENT_NAME"]

  sent = []
  realFetch = globalThis.fetch
  globalThis.fetch = (async (url: any, init: any) => {
    sent.push({ url, body: JSON.parse(init.body) })
    return { ok: true, status: 204 } as any
  }) as any
})

afterEach(async () => {
  globalThis.fetch = realFetch
  while (disposers.length) await disposers.pop()!()
  await fs.rm(home, { recursive: true, force: true })
  delete process.env["OPENCODE_CROSS_SESSION_HOME"]
})

describe("discovery", () => {
  test("a session registers itself on its first turn", async () => {
    const a = await load("/repo/api", "http://localhost:4401/")
    await turn(a, SES_A)

    const found = await new Registry().list()
    expect(found).toHaveLength(1)
    expect(found[0]!.name).toBe("api-11")
    expect(found[0]!.serverUrl).toBe("http://localhost:4401/")
  })

  test("list_agents shows the other session but not itself", async () => {
    const a = await load("/repo/api", "http://localhost:4401/")
    const b = await load("/repo/web", "http://localhost:4402/")
    await turn(a, SES_A)
    await turn(b, SES_B)

    const out = await b.tool.list_agents.execute({}, { sessionID: SES_B, agent: "build" })
    expect(out).toContain("api-11")
    expect(out).toContain("/repo/api")
    expect(out).toContain('You are "web-22"')
    expect(out.match(/^- /gm)).toHaveLength(1)
  })

  test("says so plainly when nothing else is running", async () => {
    const a = await load("/repo/api", "http://localhost:4401/")
    await turn(a, SES_A)
    const out = await a.tool.list_agents.execute({}, { sessionID: SES_A, agent: "build" })
    expect(out).toContain("only one running")
  })

  test("an explicit name overrides the derived one", async () => {
    process.env["OPENCODE_AGENT_NAME"] = "migrator"
    const a = await load("/repo/api", "http://localhost:4401/")
    await turn(a, SES_A)
    expect((await new Registry().list())[0]!.name).toBe("migrator")
  })

  test("a session with no reachable server stays unlisted", async () => {
    const a = await load("/repo/api", "")
    await turn(a, SES_A)
    expect(await new Registry().list()).toEqual([])
  })
})

describe("send_message", () => {
  test("delivers to the named session's own server", async () => {
    const a = await load("/repo/api", "http://localhost:4401/")
    const b = await load("/repo/web", "http://localhost:4402/")
    await turn(a, SES_A)
    await turn(b, SES_B)

    const out = await b.tool.send_message.execute(
      { agent: "api-11", message: "schema migration finished" },
      { sessionID: SES_B, agent: "build" },
    )

    expect(out).toContain("Delivered to api-11")
    expect(sent).toHaveLength(1)
    expect(sent[0].url).toBe(`http://localhost:4401/session/${SES_A}/prompt_async`)

    const text = sent[0].body.parts[0].text
    expect(text).toContain("schema migration finished")
    expect(text).toContain("web-22")
    expect(text).toContain("not approval")
  })

  test("lists what is reachable when the name is wrong", async () => {
    const a = await load("/repo/api", "http://localhost:4401/")
    const b = await load("/repo/web", "http://localhost:4402/")
    await turn(a, SES_A)
    await turn(b, SES_B)

    const out = await b.tool.send_message.execute(
      { agent: "nope", message: "hi" },
      { sessionID: SES_B, agent: "build" },
    )
    expect(out).toContain('No session named "nope"')
    expect(out).toContain("api-11")
    expect(sent).toHaveLength(0)
  })

  test("asks for a session id when a name is shared", async () => {
    const b = await load("/repo/web", "http://localhost:4402/")
    await turn(b, SES_B)
    const registry = new Registry()
    await registry.init()
    await registry.publish(peer({ sessionID: "ses_p1", name: "api-11", directory: "/repo/one" }))
    await registry.publish(peer({ sessionID: "ses_p2", name: "api-11", directory: "/repo/two" }))

    const out = await b.tool.send_message.execute(
      { agent: "api-11", message: "hi" },
      { sessionID: SES_B, agent: "build" },
    )
    expect(out).toContain("more than one session")
    expect(out).toContain("id=ses_p1")
    expect(sent).toHaveLength(0)
  })

  test("refuses to send an oversized message", async () => {
    const b = await load("/repo/web", "http://localhost:4402/")
    await turn(b, SES_B)
    const out = await b.tool.send_message.execute(
      { agent: "api-11", message: "x".repeat(1_000_001) },
      { sessionID: SES_B, agent: "build" },
    )
    expect(out).toContain("over the")
    expect(sent).toHaveLength(0)
  })

  test("refuses an empty message", async () => {
    const b = await load("/repo/web", "http://localhost:4402/")
    await turn(b, SES_B)
    const out = await b.tool.send_message.execute(
      { agent: "api-11", message: "   " },
      { sessionID: SES_B, agent: "build" },
    )
    expect(out).toContain("empty")
  })

  test("drops an identical repeat so a loop cannot run away", async () => {
    const a = await load("/repo/api", "http://localhost:4401/")
    const b = await load("/repo/web", "http://localhost:4402/")
    await turn(a, SES_A)
    await turn(b, SES_B)

    const args = { agent: "api-11", message: "same thing" }
    await b.tool.send_message.execute(args, { sessionID: SES_B, agent: "build" })
    const second = await b.tool.send_message.execute(args, { sessionID: SES_B, agent: "build" })

    expect(second).toContain("identical")
    expect(sent).toHaveLength(1)
  })

  test("reports a delivery failure instead of claiming success", async () => {
    const a = await load("/repo/api", "http://localhost:4401/")
    const b = await load("/repo/web", "http://localhost:4402/")
    await turn(a, SES_A)
    await turn(b, SES_B)
    globalThis.fetch = (async () => ({ ok: false, status: 500 })) as any

    const out = await b.tool.send_message.execute(
      { agent: "api-11", message: "hi" },
      { sessionID: SES_B, agent: "build" },
    )
    expect(out).toContain("Nothing sent")
    expect(out).toContain("HTTP 500")
  })
})

describe("inbound controls", () => {
  test("a refusing session receives nothing", async () => {
    const b = await load("/repo/web", "http://localhost:4402/")
    await turn(b, SES_B)
    const registry = new Registry()
    await registry.init()
    await registry.publish(peer({ sessionID: "ses_ref", name: "locked-01", inbound: "refuse" }))

    const out = await b.tool.send_message.execute(
      { agent: "locked-01", message: "hi" },
      { sessionID: SES_B, agent: "build" },
    )
    expect(out).toContain("not accepting messages")
    expect(sent).toHaveLength(0)
  })

  test("a holding session is not woken, and gets the message on its next turn", async () => {
    const a = await load("/repo/api", "http://localhost:4401/")
    const b = await load("/repo/web", "http://localhost:4402/")
    await turn(b, SES_B)

    const registry = new Registry()
    await registry.init()
    await registry.publish(peer({ sessionID: SES_A, name: "api-11", inbound: "hold" }))

    const out = await b.tool.send_message.execute(
      { agent: "api-11", message: "queued for later" },
      { sessionID: SES_B, agent: "build" },
    )
    expect(out).toContain("queued")
    expect(sent).toHaveLength(0)

    const injected = await turn(a, SES_A)
    expect(injected).toContain("queued for later")
    expect(injected).toContain("web-22")
    expect(injected).toContain("not approval")
  })

  test("held messages are delivered once, not on every later turn", async () => {
    const a = await load("/repo/api", "http://localhost:4401/")
    const registry = new Registry()
    await registry.init()
    await registry.publish(peer({ sessionID: SES_A, name: "api-11", inbound: "hold" }))
    const b = await load("/repo/web", "http://localhost:4402/")
    await turn(b, SES_B)
    await b.tool.send_message.execute(
      { agent: "api-11", message: "once only" },
      { sessionID: SES_B, agent: "build" },
    )

    expect(await turn(a, SES_A)).toContain("once only")
    expect(await turn(a, SES_A)).toBe("")
  })

  test("a session publishes its own inbound setting", async () => {
    process.env["OPENCODE_CROSS_SESSION_INBOUND"] = "refuse"
    const a = await load("/repo/api", "http://localhost:4401/")
    await turn(a, SES_A)
    expect((await new Registry().list())[0]!.inbound).toBe("refuse")
  })
})

describe("lifecycle", () => {
  test("status follows the session between working and idle", async () => {
    const a = await load("/repo/api", "http://localhost:4401/")
    await turn(a, SES_A)
    expect((await new Registry().list())[0]!.status).toBe("working")

    await a.event({ event: { type: "session.idle", properties: { sessionID: SES_A } } })
    expect((await new Registry().list())[0]!.status).toBe("idle")
  })

  test("ignores events for sessions this process does not host", async () => {
    const a = await load("/repo/api", "http://localhost:4401/")
    await turn(a, SES_A)
    await a.event({ event: { type: "session.idle", properties: { sessionID: "ses_elsewhere" } } })
    expect(await new Registry().list()).toHaveLength(1)
  })

  test("a deleted session stops being reachable", async () => {
    const a = await load("/repo/api", "http://localhost:4401/")
    await turn(a, SES_A)
    await a.event({ event: { type: "session.deleted", properties: { sessionID: SES_A } } })
    expect(await new Registry().list()).toEqual([])
  })

  test("dispose unregisters the session", async () => {
    const a = await load("/repo/api", "http://localhost:4401/")
    await turn(a, SES_A)
    await a.dispose()
    expect(await new Registry().list()).toEqual([])
  })

  test("OPENCODE_CROSS_SESSION=0 removes the tools entirely", async () => {
    process.env["OPENCODE_CROSS_SESSION"] = "0"
    try {
      const a = (await CrossSessionMessaging({ directory: "/repo/api", serverUrl: new URL("http://x/") } as any)) as any
      expect(a.tool).toBeUndefined()
      expect(a["chat.message"]).toBeUndefined()
    } finally {
      delete process.env["OPENCODE_CROSS_SESSION"]
    }
  })
})
