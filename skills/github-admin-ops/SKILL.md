---
name: github-admin-ops
description: Use when the GitHub MCP server lacks the needed mutation — org teams, branch protection / rulesets, or Projects v2 boards/fields/items/workflows — and you must fall back to `gh api` / `gh project`.
---

# github-admin-ops

GitHub MCP covers issues, PRs, files, releases, read-only org/team. Below is what it doesn't, plus the non-obvious gotchas — the rest is standard `gh` usage.

## Not in MCP — use `gh`

- Org teams: create, attach to repo, membership mutations → `gh api /orgs/{org}/teams...`
- Branch protection (`/branches/{b}/protection`) and repo rulesets (`/rulesets`) → `gh api`
- Projects v2 boards / fields / items / repo links → `gh project ...`
- Issue state changes ARE in MCP (`issue_write` + `state_reason`). Don't reach for `gh` for those.

## Gotchas

- **Scope refresh is interactive.** `gh auth refresh -s admin:org,project` requires a TTY; non-interactive call errors with "--hostname required". Ask the user to run it themselves.
- **Branch protection + rulesets are paywalled** on private repos under the free plan (`403 Upgrade to GitHub Pro`). Public repos and Pro/Team work. Surface to the user; don't retry.
- **Required status check `contexts` accept names that have never reported.** Land the workflow first, let it run once, then add. Otherwise the rule silently never blocks.
- **New teams auto-add the creator.** For sentinel "no-one"-style teams used in CODEOWNERS to block paths, immediately `DELETE /orgs/{org}/teams/{slug}/memberships/{user}`.
- **`gh project item-add` exits 0 on duplicates.** Count successes/failures explicitly when bulk-adding.
- **Projects v2 still UI-only:** grouped/board views, "Auto-add to project" workflow, custom layouts. Don't fake-complete the issue — comment with direct UI links instead.
