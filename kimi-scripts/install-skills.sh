#!/usr/bin/env bash
# Install dotnet-claude-kit skills globally so they're available in every project.
# Creates symlinks in ~/.kimi/skills/ and ~/.claude/skills/
# Reads: {} (no input needed)
# Writes: { "installed": [...], "errors": [...] }

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PLUGIN_ROOT="${SCRIPT_DIR}/.."
SKILLS_DIR="${PLUGIN_ROOT}/skills"

KIMI_SKILLS_DIR="${HOME}/.kimi/skills"
CLAUDE_SKILLS_DIR="${HOME}/.claude/skills"

installed=()
errors=()

install_to() {
    local target_dir="$1"
    mkdir -p "${target_dir}"

    for skill_dir in "${SKILLS_DIR}"/*; do
        [ -d "${skill_dir}" ] || continue
        skill_name="$(basename "${skill_dir}")"
        dest="${target_dir}/${skill_name}"

        if [ -L "${dest}" ]; then
            # Remove existing symlink
            rm "${dest}"
        elif [ -e "${dest}" ]; then
            errors+=("${target_dir#$HOME/}: ${skill_name} exists and is not a symlink, skipping")
            continue
        fi

        ln -s "${skill_dir}" "${dest}"
        installed+=("${target_dir#$HOME/}/${skill_name}")
    done
}

install_to "${KIMI_SKILLS_DIR}"
install_to "${CLAUDE_SKILLS_DIR}"

# Build JSON output
json_installed=""
first=true
for item in "${installed[@]}"; do
    if [ "$first" = true ]; then
        first=false
    else
        json_installed+=","
    fi
    json_installed+="\"${item}\""
done

json_errors=""
first=true
for item in "${errors[@]}"; do
    if [ "$first" = true ]; then
        first=false
    else
        json_errors+=","
    fi
    json_errors+="\"${item}\""
done

printf '{"installed":[%s],"errors":[%s]}\n' "$json_installed" "$json_errors"
