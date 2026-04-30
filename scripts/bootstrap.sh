#!/usr/bin/env bash
# Bootstrap claude-code-enhance — installs the three skills and optionally
# sets up the companion infrastructure (lessons library, SessionStart hooks).
#
# Idempotent: safe to re-run. Existing files are not overwritten unless
# --force is passed.
#
# Usage:
#   bash scripts/bootstrap.sh                # interactive
#   bash scripts/bootstrap.sh --force        # overwrite existing skill files
#   bash scripts/bootstrap.sh --skills-only  # just the three skills, no infrastructure

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CLAUDE_DIR="${HOME}/.claude"

FORCE=false
SKILLS_ONLY=false
for arg in "$@"; do
  case "$arg" in
    --force) FORCE=true ;;
    --skills-only) SKILLS_ONLY=true ;;
    -h|--help)
      sed -n '2,15p' "$0" | sed 's/^# \?//'
      exit 0
      ;;
  esac
done

echo "claude-code-enhance bootstrap"
echo "  source: $REPO_ROOT"
echo "  target: $CLAUDE_DIR"
echo ""

# ---------- Step 1: install the three skills ----------
mkdir -p "$CLAUDE_DIR/skills"

for skill in enhance consult-scars refresh-codemap; do
  src="$REPO_ROOT/skills/$skill/SKILL.md"
  dst_dir="$CLAUDE_DIR/skills/$skill"
  dst="$dst_dir/SKILL.md"

  if [[ -f "$dst" && "$FORCE" != "true" ]]; then
    echo "  ✓ $skill — already installed (use --force to overwrite)"
    continue
  fi

  mkdir -p "$dst_dir"
  cp "$src" "$dst"
  echo "  ✓ $skill — installed at $dst"
done

if [[ "$SKILLS_ONLY" == "true" ]]; then
  echo ""
  echo "Skills installed. Restart Claude Code to pick them up."
  exit 0
fi

# ---------- Step 2: bootstrap optional infrastructure ----------
echo ""
echo "Bootstrapping optional infrastructure..."

# Lessons library
if [[ ! -d "$CLAUDE_DIR/lessons" ]]; then
  mkdir -p "$CLAUDE_DIR/lessons"
  cp "$REPO_ROOT/examples/lessons/README.md" "$CLAUDE_DIR/lessons/README.md"
  for example in api-design auth data-modeling; do
    src="$REPO_ROOT/examples/lessons/${example}.md"
    if [[ -f "$src" ]]; then
      cp "$src" "$CLAUDE_DIR/lessons/${example}.md"
    fi
  done
  echo "  ✓ lessons library — seeded at $CLAUDE_DIR/lessons/"
else
  echo "  ✓ lessons library — already exists at $CLAUDE_DIR/lessons/ (skipping)"
fi

# Hooks (only if user opts in)
mkdir -p "$CLAUDE_DIR/hooks"
for hook in inject-global-memory inject-project-codemap; do
  src="$REPO_ROOT/hooks/${hook}.sh"
  dst="$CLAUDE_DIR/hooks/${hook}.sh"

  if [[ -f "$dst" && "$FORCE" != "true" ]]; then
    echo "  ✓ $hook — already installed at $dst"
    continue
  fi

  cp "$src" "$dst"
  chmod +x "$dst"
  echo "  ✓ $hook — installed at $dst"
done

# Global memory directory (if not present)
if [[ ! -d "$CLAUDE_DIR/memory/_global" ]]; then
  mkdir -p "$CLAUDE_DIR/memory/_global"
  cat > "$CLAUDE_DIR/memory/_global/MEMORY.md" <<'EOF'
# Universal Memory — Loaded on Every Session

This file is read into every conversation regardless of project. Edit it
to capture YOUR universal preferences, stack defaults, and engineering
principles. Keep it small (under ~5KB) — every line earns its place.

## About me
[Describe your role, stack, working style. E.g.: "Senior solo dev. Builds
B2B SaaS. Stack: Next.js + NestJS + Postgres + Flutter. Multilingual."]

## Communication preferences
[Your preferences for how the agent communicates with you. E.g.:
"Lead with action. Skip teaching tone. Push back when wrong. End-of-turn
1-2 lines max."]

## Stack defaults
[Your defaults when starting a new project. E.g.:
"Package manager: pnpm. Web: Next.js 16 App Router + Tailwind + shadcn/ui.
Backend: NestJS. ORM: Prisma 7 with @prisma/adapter-pg."]

## Engineering principles I value
[Universal principles. E.g.:
"Surgical changes only. No premature abstraction. Root causes, not patches.
Verify with command + outcome, not 'tests pass' hand-waving."]
EOF
  echo "  ✓ global memory — template seeded at $CLAUDE_DIR/memory/_global/MEMORY.md"
  echo "    EDIT this file to capture your universal preferences."
fi

echo ""
echo "Bootstrap complete."
echo ""
echo "Next steps:"
echo "  1. Restart Claude Code so skills register"
echo "  2. Edit ~/.claude/memory/_global/MEMORY.md with your universal preferences"
echo "  3. Try: /enhance <some rough idea>"
echo ""
echo "Optional:"
echo "  - Wire SessionStart hooks in ~/.claude/settings.json (see hooks/README.md)"
echo "  - For each project, create .codemap/overview.md and run /refresh-codemap"
echo "  - Install Serena MCP for semantic codebase queries:"
echo "      uv tool install -p 3.13 serena-agent@latest --prerelease=allow"
echo "      serena init && serena setup claude-code"
