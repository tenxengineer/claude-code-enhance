# Lessons Library — Format and Conventions

Append-only library of lessons learned from broken systems. Read by the
`consult-scars` skill before any architectural design, refactor, or
migration. The forcing function is the skill's auto-invocation by the
agent — not human or model self-discipline.

## Structure

One file per domain. Domain = the thing you're working on, not the layer:

```
~/.claude/lessons/
  README.md
  agent-architecture.md   # AI agent design, memory, context
  agent-tuning.md         # Claude Code config, output styles
  api-design.md           # API contracts, response wrappers, naming
  auth.md                 # JWT, OAuth, sessions, RBAC, multi-tenancy
  caching.md              # cache layers, TTLs, invalidation
  data-modeling.md        # schemas, seeds, soft-delete, time-series
  external-apis.md        # rate limits, headers, auth, retries, pricing
  migrations.md           # schema changes, downtime, rollback
  nestjs.md               # NestJS-specific gotchas
  nextjs.md               # Next.js / React-specific gotchas
  prisma.md               # Prisma ORM specifics
```

Add domains as you encounter pain in new areas. A single lesson can apply
to multiple domains — pick the most-canonical and use the `Tags:` field
in the entry to surface it from related domains.

## Lesson format

Every entry is a self-contained scar. Read once, internalize forever.

```markdown
## L-<DOMAIN>-<NNN> — <YYYY-MM-DD> — <Short title>

**Tags:** comma-separated keywords for cross-domain matching
**Project:** project name where it bit, or "universal"
**Severity:** low / medium / high (cost of repeating the mistake)

**What broke:** One sentence on the failure mode.

**Why:** Root cause in 1–3 sentences.

**Never do again:** The actionable rule. Imperative voice.

**Fix:** Commit SHA, PR #, or short diff. If discovered before merge, note that.

---
```

## Stable IDs

`L-<DOMAIN>-<NNN>` is the canonical reference. Use this in:

- CodeRabbit `path_instructions` configs
- Slack/Telegram pings ("hit L-CACHING-003 again, same root cause")
- PR descriptions when fixing similar regressions

**Never reuse an ID even after archiving a lesson.** Increment NNN
permanently per domain. Renaming a lesson's title is fine; renaming its
ID is not.

## When to write a lesson

The moment something burns. Not "when I have time later." After-the-fact
lessons lose 60% of their specificity — the diff link is fresh, the root
cause is fresh, the emotional sting that makes it stick is fresh.

If you discover a near-miss before merge, write it anyway. Near-misses
become real misses on the next person.

## When NOT to write a lesson

- Project-specific gotchas that don't generalize → put in
  `<project>/memory/feedback_*.md` instead
- Personal preferences without an underlying failure mode → put in
  `~/.claude/memory/_global/MEMORY.md` instead
- General principles you'd find in any architecture book → leave them out

The library should grow because of pain, not because of theory.

## Archiving stale lessons

When a lesson becomes obsolete (stack changed, bug class removed, library
upgraded past the issue):

1. Mark the entry `## L-<ID> — ARCHIVED <YYYY-MM-DD> — <title>` (don't delete)
2. Add a one-line note explaining why it's archived
3. Keep the body — future lookups need to know why this was once a
   problem and isn't anymore

## Quarterly review ritual

Schedule a review every 3 months. Checklist:

- For each lesson: is this still true? archive if not.
- For each domain file: is it growing too large? split if >2KB.
- Are there 5+ lessons that should generalize into a new principle?
- Are there CodeRabbit references pointing to archived/renamed lesson IDs?

## CodeRabbit integration (snippet for project `.coderabbit.yaml`)

Append to your project's `.coderabbit.yaml`:

```yaml
reviews:
  path_instructions:
    - path: "**/*.ts"
      instructions: |
        Apply lessons from ~/.claude/lessons/. Specifically check for:
        - L-NESTJS-001: ESM/CJS conflict when importing shared packages
        - L-API-001: API responses must be wrapped { success, data }
        - L-API-002: Frontend types must mirror exact API field casing
        - L-AUTH-001: Tenant context from JWT, not localStorage
        Reference any flagged lesson by stable ID in your comment.
```

CodeRabbit references should always use stable IDs (`L-NESTJS-001`), not
slug-based anchors (`#nestjs-shared-package`) — slugs break when titles
are edited; IDs do not.
