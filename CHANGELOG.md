# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [1.0.0] — 2026-04-30

### Added

- **`/enhance` skill** — Augment-style prompt enhancer. Takes a rough developer
  intent and produces a structured, codebase-aware prompt with goal, scope,
  constraints (cross-referenced against the lessons library), success criteria,
  surfaced ambiguities, suggested approach, and risk classification. User
  reviews and approves before execution.
- **`consult-scars` skill** — Auto-firing lesson loader. Triggered by
  architectural verbs in user prompts (design, refactor, migrate, etc.).
  Loads relevant domain files from `~/.claude/lessons/` before producing
  any architectural plan.
- **`/refresh-codemap` skill** — Regenerates `hotfiles.md` and `recent.md`
  from git history. Recommended weekly run.
- **SessionStart hooks** — `inject-global-memory.sh` and
  `inject-project-codemap.sh` for loading universal preferences and
  per-project codemap on session start.
- **Bootstrap script** — `scripts/bootstrap.sh` for idempotent install
  of skills and optional infrastructure.
- **Examples** — Generic lesson library (auth, api-design, data-modeling)
  and codemap templates (overview, hotfiles, recent).
- **Plugin manifest** — `.claude-plugin/plugin.json` for Claude Code
  marketplace distribution.
- **Documentation** — README with comparison table vs Augment Code and
  claude-mem; per-skill READMEs; format specs for lessons and codemap.

### Three-tier graceful degradation

- **Tier A (full):** codemap + lessons + CLAUDE.md + Serena MCP →
  fully codebase-aware enhanced prompts
- **Tier B (partial):** lessons + CLAUDE.md only → structurally
  improved prompts with applicable lessons
- **Tier C (minimal):** no project context → prompts improved using
  prompt engineering principles only

[Unreleased]: https://github.com/pilotparpikhodjaev/claude-code-enhance/compare/v1.0.0...HEAD
[1.0.0]: https://github.com/pilotparpikhodjaev/claude-code-enhance/releases/tag/v1.0.0
