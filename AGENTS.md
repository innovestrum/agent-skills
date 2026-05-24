# InnoVestrum Engineering Standards

## Code Quality
- Follow clean-code, DRY, SOLID, KISS, YAGNI, and GRASP practices
- Keep cyclomatic complexity, cognitive complexity, coupling, and depth of inheritance low
- Use code comments only to explain something non-obvious or tricky

## Architecture
- Prefer OOP with inheritance, composition, and polymorphism
- Apply dependency injection and inversion of control
- Design a project structure that is extensible but not overengineered
- Prefer modern libraries and frameworks

## Process
- Always ask before hardcoding a value to fix a bug or issue
- Keep README.md updated as the project evolves
- Tag every temporary doc passage or code workaround with `TODO(ref):` and its removal trigger — the TODO and what it guards must be removable in one cut when the trigger fires

## Cloud & Infrastructure
- Follow 12-factor app and cloud-native principles
- Prefer Alpine-based images for containers

## Documentation & Authoring
- Applies to skills, slash commands, AGENTS.md, READMEs, ADRs, project briefings
- Write only **gaps** (what's missing where the agent would expect it), **gotchas** (silent failures, paywalls, exit-code lies, auto-behaviors), and **pointers** (use X here, not Y)
- Cut anything a competent agent already knows: generic CLI/API syntax, flag enums, obvious patterns, restated rules from this file
- Read like a senior engineer's terse handover note, not a tutorial; aim short and re-cut after drafting

## Diagrams in Markdown
- **Default to Mermaid** in fenced ` ```mermaid ` blocks — renders natively on GitHub and adapts to dark themes.
- Use **PlantUML only for UML class / abstraction-layer views** Mermaid can't represent.
- **Never `skinparam backgroundColor transparent`** — invisible on dark themes. Use an explicit light fill + dark text colour.
- Hardcode fills only when colour carries meaning; pick values that survive both themes.
- **Style for readability, not decoration.** Apply a consistent palette across a doc set, give related diagrams the same look, and reserve colour for semantic groups (clusters, stages, terminals, decisions) — not every node.
