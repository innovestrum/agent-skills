---
name: mark-deferred-work
description: Activate when narrowing scope mid-task — a fix, hotfix, or design pass surfaces an extension or follow-up that won't ship now.
---

Drop the marker at the spot that made the deferral obvious. A separate "future work" doc nobody reads is the failure mode.

Match the surrounding syntax:

- Markdown / docs → `> TODO: <what> (<pointer>).` blockquote inside the affected section
- Code → `// TODO(<scope>): <what>` adjacent to the line, not at file top
- Workflow / config → inline comment on the deferred line

Include the *why* and a re-visit trigger, not just the gap. `TODO: tighten X when Y workflow lands (#28)` beats `TODO: tighten X` — the next reader needs to judge whether the marker is still load-bearing or has gone stale.

Issue tracking is the author's call. File one when the follow-up needs scheduling or stakeholder visibility; skip ceremonial trackers nobody will action.

Do not scope-creep the current PR to resolve the marker. The marker exists *because* you are deferring.
