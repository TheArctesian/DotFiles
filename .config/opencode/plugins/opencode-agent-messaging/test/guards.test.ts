import { describe, expect, test } from "bun:test"
import { Throttle } from "../src/guards.js"
import { Inbox, MAX_HELD } from "../src/inbox.js"
import fs from "node:fs/promises"
import path from "node:path"
import os from "node:os"

describe("Throttle", () => {
  test("allows an ordinary message", () => {
    expect(new Throttle({ now: () => 0 }).check("api", "hello")).toBeNull()
  })

  test("drops an identical repeat inside the dedupe window", () => {
    let t = 0
    const throttle = new Throttle({ now: () => t })
    expect(throttle.check("api", "same")).toBeNull()
    t = 5_000
    expect(throttle.check("api", "same")).toContain("identical")
  })

  test("allows the same text again once the dedupe window passes", () => {
    let t = 0
    const throttle = new Throttle({ dedupeMs: 1_000, now: () => t })
    throttle.check("api", "same")
    t = 2_000
    expect(throttle.check("api", "same")).toBeNull()
  })

  test("does not confuse different targets or different text", () => {
    const throttle = new Throttle({ now: () => 0 })
    expect(throttle.check("api", "same")).toBeNull()
    expect(throttle.check("web", "same")).toBeNull()
    expect(throttle.check("api", "different")).toBeNull()
  })

  test("caps a burst to one target so a loop dies out", () => {
    let t = 0
    const throttle = new Throttle({ max: 3, now: () => t })
    for (let i = 0; i < 3; i++) {
      t += 100
      expect(throttle.check("api", `msg ${i}`)).toBeNull()
    }
    t += 100
    expect(throttle.check("api", "one too many")).toContain("too many messages")
  })

  test("lets the sender resume after the window", () => {
    let t = 0
    const throttle = new Throttle({ max: 2, windowMs: 1_000, dedupeMs: 0, now: () => t })
    throttle.check("api", "a")
    throttle.check("api", "b")
    expect(throttle.check("api", "c")).toContain("too many")
    t = 2_000
    expect(throttle.check("api", "d")).toBeNull()
  })
})

describe("Inbox", () => {
  let dir: string

  const make = async () => {
    dir = await fs.mkdtemp(path.join(os.tmpdir(), "xs-inbox-"))
    return new Inbox({ dir })
  }

  test("holds a message and hands it over once", async () => {
    const inbox = await make()
    await inbox.hold("ses_a", { from: "web-1a", text: "heads up", ts: 1 })
    const first = await inbox.drain("ses_a")
    expect(first).toHaveLength(1)
    expect(first[0]!.text).toBe("heads up")
    expect(await inbox.drain("ses_a")).toEqual([])
  })

  test("keeps each session's messages separate", async () => {
    const inbox = await make()
    await inbox.hold("ses_a", { from: "web-1a", text: "for a", ts: 1 })
    await inbox.hold("ses_b", { from: "web-1a", text: "for b", ts: 1 })
    expect((await inbox.drain("ses_a")).map((h) => h.text)).toEqual(["for a"])
    expect((await inbox.drain("ses_b")).map((h) => h.text)).toEqual(["for b"])
  })

  test("returns nothing for a session with no mail", async () => {
    const inbox = await make()
    expect(await inbox.drain("ses_none")).toEqual([])
  })

  test("skips a torn line from a concurrent writer", async () => {
    const inbox = await make()
    await fs.writeFile(path.join(dir, "ses_a.jsonl"), '{"from":"x","text":"ok","ts":1}\n{"from":"y","te\n')
    expect(await inbox.drain("ses_a")).toHaveLength(1)
  })

  test("drops the oldest past the cap", async () => {
    const inbox = await make()
    for (let i = 0; i < MAX_HELD + 10; i++) {
      await inbox.hold("ses_a", { from: "web-1a", text: `m${i}`, ts: i })
    }
    const held = await inbox.drain("ses_a")
    expect(held).toHaveLength(MAX_HELD)
    expect(held[held.length - 1]!.text).toBe(`m${MAX_HELD + 9}`)
  })
})
