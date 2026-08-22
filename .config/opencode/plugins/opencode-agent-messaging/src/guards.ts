/**
 * Two sessions that can message each other can also talk each other in circles.
 * These are the limits that make a loop die out on its own: identical repeats
 * are dropped, and a burst to one target is capped.
 */
export class Throttle {
  private readonly windowMs: number
  private readonly max: number
  private readonly dedupeMs: number
  private readonly now: () => number
  private sent: { target: string; text: string; ts: number }[] = []

  constructor(opts: { windowMs?: number; max?: number; dedupeMs?: number; now?: () => number } = {}) {
    this.windowMs = opts.windowMs ?? 60_000
    this.max = opts.max ?? 10
    this.dedupeMs = opts.dedupeMs ?? 30_000
    this.now = opts.now ?? Date.now
  }

  /** Returns a refusal reason, or null when the message may be sent. */
  check(target: string, text: string): string | null {
    const now = this.now()
    this.sent = this.sent.filter((s) => now - s.ts <= Math.max(this.windowMs, this.dedupeMs))

    const duplicate = this.sent.find(
      (s) => s.target === target && s.text === text && now - s.ts <= this.dedupeMs,
    )
    if (duplicate) {
      return `an identical message was just sent to ${target}; not sending it again`
    }

    const recent = this.sent.filter((s) => s.target === target && now - s.ts <= this.windowMs)
    if (recent.length >= this.max) {
      return `too many messages to ${target} in the last minute; slow down or ask the user to intervene`
    }

    this.sent.push({ target, text, ts: now })
    return null
  }
}
