#!/usr/bin/env bash
# Run a quality guard hook by name.
# Reads: { "name": "hook-name" }
# Writes: { "name": "...", "output": "...", "exitCode": N }

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HOOKS_DIR="${SCRIPT_DIR}/../hooks"

# Read JSON from stdin and extract name
input=$(cat)
name=$(printf '%s' "$input" | sed -n 's/.*"name"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p')

if [ -z "$name" ]; then
  echo '{"error":"Missing name parameter"}' >&2
  exit 1
fi

hook_file="${HOOKS_DIR}/${name}.sh"
if [ ! -f "${hook_file}" ]; then
  echo "{\"error\":\"Hook not found: ${name}\"}" >&2
  exit 1
fi

# Run the hook and capture output
output=""
exit_code=0
if ! output=$(bash "${hook_file}" 2>&1); then
  exit_code=$?
fi

# Escape for JSON
output_escaped="${output//\\/\\\\}"
output_escaped="${output_escaped//\"/\\\"}"
output_escaped="${output_escaped//$'\n'/\\n}"
output_escaped="${output_escaped//$'\r'/}"
output_escaped="${output_escaped//$'\t'/\\t}"

printf '{"name":"%s","output":"%s","exitCode":%d}\n' "$name" "$output_escaped" "$exit_code"
