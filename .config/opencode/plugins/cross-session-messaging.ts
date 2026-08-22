/**
 * Local dev loader for opencode-agent-messaging.
 *
 * opencode only auto-loads files at the top level of the plugins directory, so
 * this file re-exports the plugin from the checked-out repo beside it. Edit the
 * source in ./opencode-agent-messaging/src and restart opencode.
 */
export { CrossSessionMessaging } from "./opencode-agent-messaging/src/index.js"
