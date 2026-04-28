#!/usr/bin/env bash
# Get the full content of a skill by name.
# Reads: { "name": "skill-name" }
# Writes: { "name": "...", "content": "..." }

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILLS_DIR="${SCRIPT_DIR}/../skills"

# Read JSON from stdin and extract name
input=$(cat)
name=$(printf '%s' "$input" | sed -n 's/.*"name"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p')

if [ -z "$name" ]; then
  echo '{"error":"Missing name parameter"}' >&2
  exit 1
fi

skill_file="${SKILLS_DIR}/${name}/SKILL.md"
if [ ! -f "${skill_file}" ]; then
  echo "{\"error\":\"Skill not found: ${name}\"}" >&2
  exit 1
fi

content=$(cat "${skill_file}")

# Escape for JSON
content_escaped="${content//\\/\\\\}"
content_escaped="${content_escaped//\"/\\\"}"
content_escaped="${content_escaped//$'\n'/\\n}"
content_escaped="${content_escaped//$'\r'/}"
content_escaped="${content_escaped//$'\t'/\\t}"

printf '{"name":"%s","content":"%s"}\n' "$name" "$content_escaped"
