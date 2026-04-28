#!/usr/bin/env bash
# List all available agents.
# Reads: {} (no input needed)
# Writes: [{ "name": "...", "file": "..." }, ...]

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
AGENTS_DIR="${SCRIPT_DIR}/../agents"

agents=()
for agent_file in "${AGENTS_DIR}"/*.md; do
  [ -f "${agent_file}" ] || continue
  basename_file="$(basename "${agent_file}")"
  name="${basename_file%.md}"

  # Escape for JSON
  name_escaped="${name//\\/\\\\}"
  name_escaped="${name_escaped//\"/\\\"}"
  file_escaped="${basename_file//\\/\\\\}"
  file_escaped="${file_escaped//\"/\\\"}"

  agents+=("{\"name\":\"${name_escaped}\",\"file\":\"${file_escaped}\"}")
done

printf '['
first=true
for item in "${agents[@]}"; do
  if [ "$first" = true ]; then
    first=false
  else
    printf ','
  fi
  printf '%s' "$item"
done
printf ']\n'
