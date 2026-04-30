# Contributing

Thanks for considering a contribution. This project is small, focused, and
maintained by a solo developer — clear, narrow PRs are easier to review
than broad ones.

## What's in scope

- New default lesson domains in `examples/lessons/` (e.g., `mobile.md`,
  `payments.md`, `observability.md`)
- Improvements to existing lessons (better titles, clearer "never do
  again" rules, real-world examples)
- Per-stack codemap generators (e.g., Python-specific `hotfiles.md`
  generation, Go-specific patterns)
- Improvements to the `/enhance` skill's system prompt or output template
- Localization of skill descriptions (Russian, Spanish, Japanese,
  whatever you can read fluently)
- Bug fixes in `bootstrap.sh`, hooks, or skill behavior
- Documentation improvements

## What's NOT in scope

- Adding LLM-call-based features that would create per-prompt API costs
  (the design intentionally stays free and local)
- Rewriting in Python/Node when bash + jq solves the problem
- Bundling vector databases, search engines, or other heavyweight
  infrastructure
- Adding telemetry or analytics phoning home
- Changing the license away from MIT

## How to contribute

### Filing an issue

Before opening a new issue, search existing ones. When filing:

1. Describe what you tried, what happened, what you expected
2. Include your OS, Claude Code version, and relevant `~/.claude/`
   directory state if applicable
3. Paste the exact command you ran and the exact output (or lack of
   output) you saw

### Submitting a PR

1. **Open an issue first** for non-trivial changes. We can discuss the
   approach before you spend time on code that might not match the
   project's direction.
2. **Keep PRs small.** One concern per PR. Bundle of related changes is
   fine; mixed concerns in one PR isn't.
3. **Update CHANGELOG.md** under `[Unreleased]` with a one-line entry.
4. **Match existing style:**
   - Bash: `set -euo pipefail` at the top, `[[` for tests, comments
     above non-obvious operations
   - Markdown: prose paragraphs, semantic headings, fenced code blocks
     with language tags
   - Skills (SKILL.md): keep descriptions specific (trigger phrases,
     verb lists), not generic
5. **Test the bootstrap path on a fresh machine** if your change touches
   install logic. The whole point of this plugin is friction-free
   adoption — don't break first-run.
6. **One commit per logical change.** Squash WIP commits before opening
   the PR. We squash-merge.

## Adding a new default lesson

The lessons library is the most useful place to contribute durable value.
A new lesson:

1. Goes in `examples/lessons/<domain>.md`
2. Uses the format specified in `examples/lessons/README.md`
3. Has a stable ID `L-<DOMAIN>-NNN` (next available number for that
   domain)
4. Includes: tags, project (use "universal" if generic), severity,
   what broke, why, never-do-again rule, fix
5. References real failures, not theoretical patterns. The library grows
   from pain, not theory.

## Adding a new domain file

If you want to add a new domain (e.g., `mobile.md`, `payments.md`):

1. Open an issue first to confirm the domain is broadly useful (not
   project-specific)
2. Create the file with at least 1-2 lessons populated; an empty domain
   file is worse than no domain file
3. Update `examples/lessons/README.md`'s structure list to include the
   new domain

## Adding a localization

Skill descriptions can be improved with multilingual trigger phrases.
For a new language:

1. Identify the trigger phrases in the language (e.g., for Russian:
   "улучши промпт", "отрефактори", "мигрируй")
2. Add them to the `description:` field of the relevant SKILL.md
3. Test that the harness still recognizes English triggers
4. Submit a PR

## Code of conduct

Be kind. Be specific. Disagree with code, not people. We assume good
faith and grant it freely.

## License

By contributing, you agree your contributions will be licensed under
the project's MIT license.
