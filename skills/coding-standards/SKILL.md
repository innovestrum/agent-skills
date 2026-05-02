---
name: coding-standards
description: Apply clean-code, DRY, KISS, and YAGNI principles during coding, refactoring, code review, or when writing new modules. Use when creating functions, classes, or modules and when the user asks to improve or review code quality, reduce duplication, or simplify logic.
license: MIT
metadata:
  author: InnoVestrum
  version: "1.0"
  repo: https://github.com/InnoVestrum/agent-skills
---

## Coding Standards

Apply the following principles consistently across all code produced or reviewed.

### Clean Code

- Use intention-revealing names for variables, functions, and classes.
- Functions do one thing only. If a function needs a comment to explain what it does, rename it.
- Keep functions short (aim for ≤20 lines; hard limit 50).
- Avoid deeply nested control flow (max depth 3). Extract early-return guards or helper functions.
- No magic numbers or strings — extract to named constants.
- Comments explain *why*, never *what*. Delete commented-out code.

### DRY (Don't Repeat Yourself)

- Every piece of knowledge has a single, authoritative representation.
- Before writing new code, search for existing utilities/helpers that already solve the problem.
- Extract repeated logic into shared functions, base classes, or modules — not copy-paste.
- Configuration lives in one place (env vars, config files) — never scattered inline.

### KISS (Keep It Simple, Stupid)

- Choose the simplest solution that correctly solves the problem.
- Prefer flat over nested, explicit over implicit, synchronous over asynchronous where complexity is not justified.
- Avoid clever one-liners that sacrifice readability for brevity.

### YAGNI (You Aren't Gonna Need It)

- Do not implement features or abstractions that are not required right now.
- Do not add parameters, config flags, or extension points "just in case".
- Delete dead code — version control remembers it.

### Workflow

1. Before writing code: identify existing patterns in the codebase and follow them.
2. Write the simplest passing implementation first.
3. Refactor for clarity, removing duplication.
4. Review: would a new team member understand this in 30 seconds?

## Gotchas

- DRY applies to knowledge/logic, not necessarily every string — some duplication in tests or config is acceptable if it aids clarity.
- YAGNI does not mean skip error handling or logging — those are always needed.
- Do not add comments to explain obvious code; only explain non-obvious decisions.
