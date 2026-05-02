---
name: code-quality
description: Monitor and improve code quality metrics including cyclomatic complexity, cognitive complexity, maintainability index, coupling, and depth of inheritance. Use when reviewing code, refactoring, setting up linters or static analysis, or when the user asks about code health, technical debt, or quality gates.
license: MIT
metadata:
  author: InnoVestrum
  version: "1.0"
  repo: https://github.com/InnoVestrum/agent-skills
---

## Code Quality Standards

### Metric Targets

| Metric | Green | Warning | Critical — Must Refactor |
|---|---|---|---|
| **Cyclomatic complexity** (per function) | ≤5 | 6–10 | >10 |
| **Cognitive complexity** (per function) | ≤7 | 8–15 | >15 |
| **Function length** (lines) | ≤20 | 21–50 | >50 |
| **File length** (lines) | ≤200 | 201–400 | >400 |
| **Parameters per function** | ≤3 | 4–5 | >5 |
| **Depth of nesting** | ≤2 | 3 | >3 |
| **Depth of inheritance** | ≤3 | — | >3 |
| **Afferent coupling** (fan-in) | Low | — | High (god class signal) |
| **Efferent coupling** (fan-out) | ≤7 | 8–12 | >12 |

### Cyclomatic Complexity

- Each `if`, `else if`, `for`, `while`, `case`, `catch`, `&&`, `||`, `?:` adds +1.
- Functions above 10: refactor by extracting helper functions or using strategy/table-driven patterns.
- Use early returns to flatten nested conditions instead of deep `if-else` trees.

### Cognitive Complexity

- Deeply nested structures incur higher cognitive load than equivalent flat structures.
- Reduce by: early returns, guard clauses, extracting inner loops/conditions to named functions.

### Maintainability

- High maintainability = easy to understand, change, and test in isolation.
- Signs of low maintainability: long files, many imports, large classes, no tests, unclear names.
- Before declaring a refactor complete, ask: "Can I understand this without context?"

### Coupling & Cohesion

- **High cohesion** (good): class methods all relate to a single concept.
- **Low coupling** (good): classes depend on interfaces, not concretions; few external imports.
- **God class** (bad): one class that knows/does everything — split it.
- **Feature envy** (bad): a method that uses data from another class more than its own — move it.

### Tooling to Set Up

| Language | Complexity tool | Linter |
|---|---|---|
| TypeScript/JS | `complexity-report`, ESLint `complexity` rule | ESLint + Prettier |
| Python | `radon`, `flake8-cognitive-complexity` | Ruff or Flake8 + Black |
| Go | `gocyclo`, `gocognit` | `golangci-lint` |
| Java/Kotlin | SonarQube / Checkstyle | SpotBugs |

### Refactoring Workflow

1. Run static analysis to identify hotspots (high complexity, long files).
2. Write or verify tests exist for the code to be refactored.
3. Refactor one function/class at a time — do not mix refactoring with feature changes.
4. Re-run analysis to confirm metrics improved.
5. Update tests if behaviour-preserving refactors changed signatures.

### Quality Gate (CI)

Configure CI to fail on:
- Any function with cyclomatic complexity > 10
- Any function with more than 5 parameters
- Test coverage below 80% on changed files

## Gotchas

- High test coverage does not imply high quality — tests must assert meaningful behaviour, not just line coverage.
- Reducing complexity by extracting tiny trivial helpers with meaningless names makes code harder to follow — extract only when the extracted unit has a clear, reusable purpose.
- Linter rules are defaults, not laws — document any suppression with a reason comment.
