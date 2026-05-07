---
name: github-admin-ops
description: Use when the GitHub MCP server lacks the needed mutation — org teams, branch protection / rulesets, or Projects v2 boards/fields/items/workflows — and you must fall back to `gh api` / `gh project`.
---

# github-admin-ops

The GitHub MCP exposes issues, PRs, files, releases, and read-only org/team data. Everything below is **not** in the MCP and requires the `gh` CLI.

## Required token scopes

`gh auth status` to verify. Refresh interactively when missing — non-interactive refresh fails:

| Operation | Scope |
|---|---|
| Org teams (create, attach, member ops) | `admin:org` |
| Projects v2 (create, fields, items) | `project` |
| Repo workflows | `workflow` (usually default) |

```
gh auth refresh -s admin:org,project
```

## Org teams

```bash
# Create
gh api -X POST /orgs/{org}/teams -f name=maintainers -f description='...' -f privacy=closed

# Attach to repo with permission (pull|triage|push|maintain|admin)
gh api -X PUT /orgs/{org}/teams/{slug}/repos/{org}/{repo} -f permission=push

# Remove auto-added creator from a sentinel "no-one" team
gh api -X DELETE /orgs/{org}/teams/{slug}/memberships/{user}
```

GitHub auto-adds the creator to new teams. For sentinel "block" teams used in CODEOWNERS, delete the membership immediately.

## Branch protection / rulesets

**Paywall:** classic branch protection AND repo-level rulesets return `403 Upgrade to GitHub Pro` on private repos under the free plan. Public repos and Pro/Team plans work. Surface this to the user instead of retrying.

```bash
# Classic branch protection
gh api -X PUT /repos/{owner}/{repo}/branches/{branch}/protection \
  -H "Accept: application/vnd.github+json" --input protection.json

# Repo ruleset (newer, more flexible — same paywall)
gh api -X POST /repos/{owner}/{repo}/rulesets \
  -H "Accept: application/vnd.github+json" --input ruleset.json
```

Required status checks list will silently accept names that have never reported — do not rely on them. Land the workflow first, let it run once, then add to the contexts list.

## Projects v2

Projects v2 is GraphQL only, but `gh project` wraps the common mutations.

```bash
# Create board (returns project id PVT_... and number)
gh project create --owner {org} --title "..." --format json

# Add single-select field
gh project field-create {number} --owner {org} \
  --name "Stage" --data-type SINGLE_SELECT \
  --single-select-options "stage-0,stage-1,stage-2"

# Add issue / PR by URL (idempotent per item)
gh project item-add {number} --owner {org} --url <issue-or-pr-url>

# Set a field value on an item
gh project item-edit --id {item-id} --project-id {pid} \
  --field-id {field-id} --single-select-option-id {opt-id}

# Link project to a repo (so it appears under repo Projects tab)
gh project link {number} --owner {org} --repo {org}/{repo}

# List projects / fields / items
gh project list --owner {org}
gh project field-list {number} --owner {org} --format json
gh project item-list {number} --owner {org} --format json --limit 200
```

**Bulk-add issues:** loop `gh issue list ... -q '.[].url'` into `gh project item-add`. Count successes/failures explicitly — the CLI exits 0 even on per-item duplicates.

**Cannot do via CLI** (still UI-only): grouped views, "Auto-add to project" workflows, custom layouts. Comment on the tracking issue with direct UI links instead of pretending it's done.

## Issue lifecycle

State changes ARE in the MCP (`issue_write` with `state_reason: completed | not_planned | duplicate`). Use the MCP for those. This skill is for the gaps above.
