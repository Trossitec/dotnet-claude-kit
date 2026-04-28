#!/usr/bin/env bash
# Remove globally installed dotnet-claude-kit skills.
# Reads: {} (no input needed)
# Writes: { "removed": [...], "notFound": [...] }

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PLUGIN_ROOT="${SCRIPT_DIR}/.."
SKILLS_DIR="${PLUGIN_ROOT}/skills"

KIMI_SKILLS_DIR="${HOME}/.kimi/skills"
CLAUDE_SKILLS_DIR="${HOME}/.claude/skills"

removed=()
not_found=()

remove_from() {
    local target_dir="$1"
    for skill_dir in "${SKILLS_DIR}"/*; do
        [ -d "${skill_dir}" ] || continue
        skill_name="$(basename "${skill_dir}")"
        dest="${target_dir}/${skill_name}"

        if [ -L "${dest}" ]; then
            rm "${dest}"
            removed+=("${target_dir#$HOME/}/${skill_name}")
        else
            not_found+=("${target_dir#$HOME/}/${skill_name}")
        fi
    done
}

remove_from "${KIMI_SKILLS_DIR}"
remove_from "${CLAUDE_SKILLS_DIR}"

json_removed=""
first=true
for item in "${removed[@]}"; do
    if [ "$first" = true ]; then first=false; else json_removed+=","; fi
    json_removed+="\"${item}\""
done

json_notfound=""
first=true
for item in "${not_found[@]}"; do
    if [ "$first" = true ]; then first=false; else json_notfound+=","; fi
    json_notfound+="\"${item}\""
done

printf '{"removed":[%s],"notFound":[%s]}\n' "$json_removed" "$json_notfound"
