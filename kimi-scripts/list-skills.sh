#!/usr/bin/env bash
# List all available skills with name and description from frontmatter.
# Reads: {} (no input needed)
# Writes: [{ "name": "...", "description": "..." }, ...]

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILLS_DIR="${SCRIPT_DIR}/../skills"

python3 - "${SKILLS_DIR}" << 'PYEOF'
import os, sys, json, re

skills_dir = sys.argv[1]
skills = []

for entry in sorted(os.listdir(skills_dir)):
    skill_path = os.path.join(skills_dir, entry, "SKILL.md")
    if not os.path.isfile(skill_path):
        continue

    with open(skill_path, "r", encoding="utf-8") as f:
        content = f.read()

    name = entry
    description = "No description provided."

    # Extract YAML frontmatter
    match = re.search(r'^---\s*\n(.*?)\n---\s*\n', content, re.DOTALL)
    if match:
        frontmatter = match.group(1)
        # Extract name
        nm = re.search(r'^name:\s*(.+?)$', frontmatter, re.MULTILINE)
        if nm:
            name = nm.group(1).strip()
        # Extract description (handle > folded scalars)
        desc_match = re.search(r'^description:\s*(?:>\s*\n)?((?:\n?[ \t]+[^\n]*)+)', frontmatter, re.MULTILINE)
        if desc_match:
            desc_lines = desc_match.group(1).strip().splitlines()
            description = " ".join(line.strip() for line in desc_lines if line.strip())
        else:
            desc_match = re.search(r'^description:\s*(.+?)$', frontmatter, re.MULTILINE)
            if desc_match:
                description = desc_match.group(1).strip()

    skills.append({"name": name, "description": description})

print(json.dumps(skills, indent=2))
PYEOF
