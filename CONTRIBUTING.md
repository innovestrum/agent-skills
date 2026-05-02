# Contributing

## Adding a New Skill

1. Create a directory under `skills/` with a lowercase, hyphenated name matching the skill name:
   ```
   skills/<skill-name>/
   ```

2. Add a `SKILL.md` with valid YAML frontmatter:
   ```yaml
   ---
   name: <skill-name>
   description: <what it does and when to use it — include trigger keywords>
   license: MIT
   metadata:
     author: InnoVestrum
     version: "1.0"
     repo: https://github.com/InnoVestrum/agent-skills
   ---
   ```

3. Write the body as clear, step-by-step Markdown instructions the agent follows.

4. Optionally add `references/` or `assets/` subdirectories for supporting material.

5. Add the skill to the table in `README.md`.

## Skill Quality Checklist

- [ ] `name` matches the directory name exactly
- [ ] `description` includes keywords that clearly trigger the skill and define its scope
- [ ] Instructions are step-by-step, not vague declarations
- [ ] Includes a `## Gotchas` section for common mistakes
- [ ] Does not duplicate content already covered by another skill
- [ ] Tested in at least one compatible agent (Claude Code or Windsurf)

## Updating an Existing Skill

- Bump `metadata.version` in the frontmatter.
- Keep changes focused — one PR per concern.

## Naming Conventions

- Skill directory and `name` field: lowercase, hyphens only (e.g. `code-quality`, not `CodeQuality`).
- No consecutive hyphens, no leading/trailing hyphens.
