---
description: Triage claude-reflect learnings queue with smart routing — global rules to the agent-skills repo, procedural learnings to skills, project rules to local CLAUDE.md
---

# Reflect Triage

You are helping the user process learnings captured by the **claude-reflect** plugin and route each one to the right destination with explicit human approval.

## Important context

The user installs global rules from a Git repository (`agent-skills`). The file `~/.claude/CLAUDE.md` is a **symlink** to `<agent-skills>/AGENTS.md`. Discover the repo path dynamically — never hardcode it:

```bash
readlink -f ~/.claude/CLAUDE.md
# → /Users/<user>/github/agent-skills/AGENTS.md
# Repo dir = dirname of that path
```

Writes to `~/.claude/CLAUDE.md` therefore land directly inside the agent-skills repo and must be committed and pushed.

The repo also contains skills under `<repo>/skills/` (managed by the existing `manage-skills` skill) and rules in `AGENTS.md` (managed by the existing `manage-rules` skill). Prefer those skills to do the actual writes when they apply — do not duplicate their logic.

## Workflow

### 1. Read the queue

Read `~/.claude/learnings-queue.json`. If empty or missing, tell the user there's nothing to triage and stop.

If non-empty, also do `readlink -f ~/.claude/CLAUDE.md` and report the repo path so the user knows where global writes will land.

### 2. For each learning, present it like this

```
[3/12] Confidence: 0.78 · Source: <project-or-session>

  Captured: "no, always use trpc, not REST for internal APIs"
  Extracted rule: "Use tRPC instead of REST for internal API calls"

  Suggested route: [p]roject  (mentions a specific architecture choice
  that varies between projects — better as project rule)

  [g]lobal · [p]roject · [s]kill · [d]iscard · [?]explain
```

**Rules for the suggestion:**

Suggest **`[g]lobal`** when the learning:
- Doesn't reference any specific file path, library version, or project name
- Expresses preference about communication style, code aesthetics, or general engineering principle
- Mentions a model name, language feature, or universal pattern (e.g. "use TypeScript strict", "prefer pure functions", "Conventional Commits")
- Would still be valid if the user started a brand-new project tomorrow

Suggest **`[p]roject`** when the learning:
- References a specific file, folder, module, or service in the current codebase
- Uses domain-specific terminology
- Mentions a specific library version or framework choice that varies between projects

Suggest **`[s]kill`** when the learning:
- Describes a multi-step workflow ("first do X, then Y, then Z")
- Is triggered by a specific command or task ("when deploying", "for code review")
- Would be better expressed as a procedure than a declaration

Suggest **`[d]iscard`** when the learning:
- Is already covered by an existing rule (check current AGENTS.md and project CLAUDE.md before suggesting)
- Is too vague or contextual to be reusable
- Has confidence score below 0.65

### 3. Wait for user decision

Process **one item at a time**. Never batch decisions. If the user picks `[?]explain`, justify your suggestion in 2-3 sentences then re-ask.

### 4. Execute the routing

- **`[g]lobal`** → use the **`manage-rules`** skill from this repo to add the rule to `<repo>/AGENTS.md`. The skill knows the right section structure. Pass it the rule text and let it choose placement.

- **`[p]roject`** → append to `<current-working-directory>/CLAUDE.md`. Create the file if missing. Add under an appropriate `## ` heading (create one if no heading fits). Show the diff before writing.

- **`[s]kill`** → use the **`manage-skills`** skill. Either create a new skill or extend an existing one — let the skill choose. If creating new, suggest a kebab-case name based on the learning topic.

- **`[d]iscard`** → just remove from queue. No further action.

After each successful write, **immediately remove that item** from `~/.claude/learnings-queue.json` so the queue shrinks as you go. Don't wait until the end — a crash midway shouldn't lose progress.

### 5. Final pass: commit and push

If any `[g]` or `[s]` writes touched the agent-skills repo:

```bash
cd "$(dirname "$(readlink -f ~/.claude/CLAUDE.md)")"
git status --short
git diff
```

Show the user the diff. Suggest a Conventional Commits message based on what changed:
- `rules: add <short-summary>` for AGENTS.md edits
- `skills(<skill-name>): add <short-summary>` for skill edits
- Combine into one commit if both touched (`chore: triage N learnings`)

Ask: `Commit and push? [y/n]`

If yes: `git add -A && git commit -m "<message>" && git push`. If push fails (no remote configured, network error), tell the user — do not retry silently.

### 6. Summary

Print:

```
Triage complete:
  global:   N rules → AGENTS.md
  project:  N rules → ./CLAUDE.md
  skills:   N updates → skills/
  discard:  N
  remaining in queue: N
```

## Style

- Concise, fact-based tone — the user is solo and wants to ship.
- Always **suggest** a route but never override the user's choice.
- Show the actual diff before writing, not a paraphrase.
- Ask one question at a time — never bundle multiple confirmations.
- If the user types `q` or `quit` at any prompt, stop cleanly and leave the rest of the queue intact for next time.
