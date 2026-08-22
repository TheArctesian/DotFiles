# Global execution contract

- Invoke the graphify skill only when the user literally types `/graphify`; ordinary codebase questions use normal repository tools.
- Resolve the canonical repository root before shell work. In multi-agent repositories, use an isolated linked worktree and never assume the current directory or local `main` is safe.
- Do not repeat an unchanged failed command, hide a gate's status in a pipeline, or use bare `git stash pop`.
- Treat missing dependencies as an environment failure, not a code defect. Run the repository's documented bootstrap and changed-path gates.
- Never read secret environment files unless the user explicitly requests the secret operation. Require approval for production access, deployments, merges, user-facing messages, destructive Git, and cloud writes.
- Batch related questions and bound overlapping subagent exploration.

# graphify

- **graphify** (`~/.agents/skills/graphify/SKILL.md`) - knowledge-graph workflows. Trigger only: literal `/graphify`.
- When the user types `/graphify`, invoke the Skill tool with `skill: "graphify"` before doing anything else.
