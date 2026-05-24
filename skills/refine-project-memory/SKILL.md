---
name: refine-project-memory
description: Activate when the user asks to audit, refine, prune, or check the project's auto-memory store. Reconciles memory against current code and canonical docs.
---

Memory drifts. Promote what still bites future-you into the canonical doc / ADR / skill where reviewers find it; delete the rest. The store path is named under "auto memory" in this session's system prompt — use that, don't derive.

Per memory, one grep across `AGENTS.md`, `CLAUDE.md`, `README.md`, `docs/`, ADRs, project + user skills, runbooks. Confirm each hit with a Read; "named in" ≠ "explained in".

**Staleness check before any verdict.** Memory is point-in-time:

- Names a file / function / flag → confirm it still exists at that name.
- Claims *"doc §X is stale"* → re-read §X; the doc may have been fixed since (now the memory itself is stale, not §X).
- Describes tool behaviour → confirm the project still wires that tool. A memory about a replaced tool is dead, not a lesson — don't try to update it.

Classify: unique + load-bearing → promote; partial overlap → extend the home, then delete; redundant or stale → delete.

Promote into the matching home — inline gotcha next to the code it qualifies (not a new sub-section that fragments the parent); ratified decision into a new ADR (skip if an ADR or merged hotfix PR already ratified it — inline the *why* instead); operational procedure into a runbook / `RUNNERS.md`; process rule into `AGENTS.md` or a skill. Cross-link related additions so a reader landing on either side finds the other.

Promotion goes through the project's normal change flow (`frame-the-change` if present) — even for tiny doc edits. One docs-only PR per sweep.

Prune separately from promote. Memory deletes don't belong in the PR body — different surface. Delete already-covered memories immediately; delete promoted ones only after the PR merges. Drop matching lines from `MEMORY.md`; an empty index file is fine.
