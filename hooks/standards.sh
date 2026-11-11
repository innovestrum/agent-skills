#!/bin/sh
# Prints AGENTS.md as context for the hook event named in $1.
# JSON, not plain stdout: Claude Code drops plain stdout on SubagentStart,
# and a raw tab or CR would make the JSON unparseable, which drops it silently.
export LC_ALL=C
root=${CLAUDE_PLUGIN_ROOT:-$(dirname "$0")/..}

printf '{"hookSpecificOutput":{"hookEventName":"%s","additionalContext":"' "$1"
tr -d '\r' <"$root/AGENTS.md" | tr '\t' ' ' |
  sed -e 's/\\/\\\\/g' -e 's/"/\\"/g' |
  awk '{ printf "%s\\n", $0 }'
printf '"}}\n'
