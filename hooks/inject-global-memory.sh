#!/usr/bin/env bash
# SessionStart hook — injects three layers of universal context as
# additionalContext at session start, regardless of project:
#
#   1. ~/.claude/memory/_global/MEMORY.md — curated universal preferences
#   2. ~/.claude/memory/_global/journal.md — DEPRECATED, kept for reference
#      until fully migrated to lessons/. Loaded if present.
#   3. ~/.claude/lessons/_index — auto-generated index of scar-tissue domain
#      files so the agent knows what's available even if `consult-scars`
#      skill doesn't auto-fire.
#
# Output: JSON with hookSpecificOutput.additionalContext (string).
# Failures are silent — never block session startup on a hook issue.

set -euo pipefail

GLOBAL_DIR="${HOME}/.claude/memory/_global"
MEMORY_FILE="${GLOBAL_DIR}/MEMORY.md"
JOURNAL_FILE="${GLOBAL_DIR}/journal.md"
LESSONS_DIR="${HOME}/.claude/lessons"

# Bail silently if the global memory file is missing.
if [[ ! -f "$MEMORY_FILE" ]]; then
  exit 0
fi

memory=$(cat "$MEMORY_FILE")

journal=""
if [[ -f "$JOURNAL_FILE" ]]; then
  journal=$(cat "$JOURNAL_FILE")
fi

# Build a compact lessons index. For each domain file, count the number of
# `## L-` entries (active + archived) and pull tags from the first lesson.
# This stays small (~500 tokens) so it can always load.
lessons_index=""
if [[ -d "$LESSONS_DIR" ]]; then
  lessons_index="## Scar tissue available (run \`consult-scars\` skill before designing/refactoring)"$'\n\n'
  lessons_index+="| Domain file | Lessons | Tags (sample) |"$'\n'
  lessons_index+="|---|---|---|"$'\n'

  for f in "${LESSONS_DIR}"/*.md; do
    name=$(basename "$f" .md)
    [[ "$name" == "README" ]] && continue
    [[ "$name" == _index* ]] && continue

    count=$(grep -c '^## L-' "$f" 2>/dev/null || echo 0)
    [[ "$count" == "0" ]] && continue

    # Pull the first Tags: line (sample)
    tags=$(grep -m1 '^\*\*Tags:\*\*' "$f" 2>/dev/null | sed -e 's/^\*\*Tags:\*\* *//' -e 's/[*_]//g' | head -c 80)
    [[ -z "$tags" ]] && tags="(no tags)"

    lessons_index+="| \`${name}\` | ${count} | ${tags} |"$'\n'
  done

  lessons_index+=$'\n'"To load a specific domain's lessons: read \`~/.claude/lessons/<domain>.md\`."$'\n'
  lessons_index+="To see the format/protocol: read \`~/.claude/lessons/README.md\`."$'\n'
fi

# Compose the full additionalContext block.
combined=$(printf "## Global memory (universal — loaded on every session, every project)\n\n%s" "$memory")

if [[ -n "$lessons_index" ]]; then
  combined+=$'\n\n---\n\n'
  combined+="$lessons_index"
fi

if [[ -n "$journal" ]]; then
  combined+=$'\n\n---\n\n'
  combined+="$journal"
fi

# Emit the JSON envelope. Use jq for safe escaping.
jq -n --arg ctx "$combined" '{
  hookSpecificOutput: {
    hookEventName: "SessionStart",
    additionalContext: $ctx
  }
}'

exit 0
