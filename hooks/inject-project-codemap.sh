#!/usr/bin/env bash
# SessionStart hook — if the current working directory (or any parent up to
# $HOME) contains a `.codemap/` directory, read overview.md, hotfiles.md, and
# recent.md from it and inject as additionalContext.
#
# Designed to run alongside ~/.claude/hooks/inject-global-memory.sh:
#   global hook  → universal preferences + lessons index (always loads)
#   codemap hook → project-specific architectural context (only when .codemap/ exists)
#
# Output: JSON with hookSpecificOutput.additionalContext (string).
# Failures are silent — never block session startup on a hook issue.

set -euo pipefail

# Walk up from CWD looking for a .codemap directory. Stop at $HOME or root.
find_codemap() {
  local dir="$PWD"
  while [[ "$dir" != "/" && "$dir" != "$HOME" ]]; do
    if [[ -d "$dir/.codemap" ]]; then
      echo "$dir/.codemap"
      return 0
    fi
    dir="$(dirname "$dir")"
  done
  return 1
}

CODEMAP_DIR=$(find_codemap || true)

# Bail silently if no codemap in this project tree.
if [[ -z "$CODEMAP_DIR" ]]; then
  exit 0
fi

PROJECT_NAME=$(basename "$(dirname "$CODEMAP_DIR")")

# Compose the codemap injection. Prefer overview + hotfiles + recent in that
# order. Skip any file that doesn't exist.
combined="## Project codemap — ${PROJECT_NAME}"$'\n\n'
combined+="Loaded from \`${CODEMAP_DIR}\`. Architecture narrative + recent change heat map. "
combined+="Refresh hotfiles/recent weekly via \`/refresh-codemap\` skill."$'\n\n'

if [[ -f "$CODEMAP_DIR/overview.md" ]]; then
  combined+="### Architecture overview"$'\n\n'
  combined+=$(cat "$CODEMAP_DIR/overview.md")
  combined+=$'\n\n---\n\n'
fi

if [[ -f "$CODEMAP_DIR/hotfiles.md" ]]; then
  combined+="### Hot files (top by change frequency)"$'\n\n'
  combined+=$(cat "$CODEMAP_DIR/hotfiles.md")
  combined+=$'\n\n---\n\n'
fi

if [[ -f "$CODEMAP_DIR/recent.md" ]]; then
  combined+="### Recent activity (last 30 days)"$'\n\n'
  combined+=$(cat "$CODEMAP_DIR/recent.md")
fi

# Emit the JSON envelope.
jq -n --arg ctx "$combined" '{
  hookSpecificOutput: {
    hookEventName: "SessionStart",
    additionalContext: $ctx
  }
}'

exit 0
