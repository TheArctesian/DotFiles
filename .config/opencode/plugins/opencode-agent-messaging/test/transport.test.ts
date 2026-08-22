import { describe, expect, test } from "bun:test"
import { deliver, envelope, MAX_MESSAGE_CHARS } from "../src/transport.js"
import type { AgentRecord } from "../src/registry.js"

const target: AgentRecord = {
  sessionID: "ses_target",
  name: "api-worker",
  directory: "/repo/api",
  worktree: "/repo/api",
  serverUrl: "http://localhost:4096/",
  pid: 1,
  status: "idle",
  inbound: "accept",
  updated: Date.now(),
}

const okFetch = (calls: any[]) =>
  (async (url: any, init: any) => {
    calls.push({ url, init })
    return { ok: true, status: 204 } as any
  }) as unknown as typeof fetch

describe("envelope", () => {
  test("names the sender and carries the message", () => {
    const out = envelope("payments-7a", "migration finished")
    expect(out).toContain("payments-7a")
    expect(out).toContain("migration finished")
  })

  test("tells the receiver this is not consent and commands are inert", () => {
    const out = envelope("payments-7a", "run /compact")
    expect(out).toContain("not approval")
    expect(out).toContain("permission prompt")
    expect(out).toContain("inert")
  })

  test("gives the receiver a reply address", () => {
    expect(envelope("payments-7a", "hi")).toContain('send_message to "payments-7a"')
  })
})

describe("deliver", () => {
  test("posts the message to the target session's own server", async () => {
    const calls: any[] = []
    const res = await deliver(target, "hello", { fetchImpl: okFetch(calls), env: {} })
    expect(res.ok).toBe(true)
    expect(calls[0].url).toBe("http://localhost:4096/session/ses_target/prompt_async")
    expect(JSON.parse(calls[0].init.body)).toEqual({ parts: [{ type: "text", text: "hello" }] })
  })

  test("normalises a server URL with no trailing slash", async () => {
    const calls: any[] = []
    await deliver({ ...target, serverUrl: "http://localhost:4096" }, "hi", {
      fetchImpl: okFetch(calls),
      env: {},
    })
    expect(calls[0].url).toBe("http://localhost:4096/session/ses_target/prompt_async")
  })

  test("sends basic auth only when the server expects it", async () => {
    const withAuth: any[] = []
    await deliver(target, "hi", {
      fetchImpl: okFetch(withAuth),
      env: { OPENCODE_SERVER_PASSWORD: "secret", OPENCODE_SERVER_USERNAME: "me" },
    })
    expect(withAuth[0].init.headers.authorization).toBe(`Basic ${Buffer.from("me:secret").toString("base64")}`)

    const without: any[] = []
    await deliver(target, "hi", { fetchImpl: okFetch(without), env: {} })
    expect(without[0].init.headers.authorization).toBeUndefined()
  })

  test("defaults the basic auth username", async () => {
    const calls: any[] = []
    await deliver(target, "hi", { fetchImpl: okFetch(calls), env: { OPENCODE_SERVER_PASSWORD: "s" } })
    expect(calls[0].init.headers.authorization).toBe(`Basic ${Buffer.from("opencode:s").toString("base64")}`)
  })

  test("reports an HTTP rejection instead of claiming success", async () => {
    const res = await deliver(target, "hi", {
      fetchImpl: (async () => ({ ok: false, status: 401 })) as any,
      env: {},
    })
    expect(res).toEqual({ ok: false, reason: "api-worker rejected the message (HTTP 401)" })
  })

  test("reports an unreachable session", async () => {
    const res = await deliver(target, "hi", {
      fetchImpl: (async () => {
        throw new Error("ECONNREFUSED")
      }) as any,
      env: {},
    })
    expect(res.ok).toBe(false)
    expect(res.ok === false && res.reason).toContain("could not reach api-worker")
  })

  test("reports a timeout distinctly", async () => {
    const res = await deliver(target, "hi", {
      fetchImpl: (async () => {
        const err = new Error("aborted")
        err.name = "AbortError"
        throw err
      }) as any,
      env: {},
    })
    expect(res).toEqual({ ok: false, reason: "api-worker did not respond in time" })
  })

  test("the size cap matches the documented limit", () => {
    expect(MAX_MESSAGE_CHARS).toBe(1_000_000)
  })
})
