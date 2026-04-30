# I've Used Claude Code Daily for 6 Months. The Same Bug Cost Me 3 Times Before I Built This.

> On scar tissue, agent memory, and why curation beats capture every time.

**Suggested Medium tags:** AI, Programming, Software Engineering, Anthropic, Open Source, Developer Tools, Claude

**Estimated read time:** ~9 min

---

## The third time

It was 11 PM on a Tuesday. I was deep into project number three, building a multi-tenant marketplace, and Claude Code had just suggested I read the user's organization ID from `localStorage`.

For the third time.

The first time was eight months ago. I was building [FarmScope](https://github.com/tenxengineer), a precision-agriculture platform for cotton clusters in Uzbekistan. The agent suggested `localStorage.getItem('orgId')` for tenant scope. I shipped it. Two weeks later, a user in the cluster admin role switched orgs in the UI — but the API kept returning the old org's data. The localStorage value was updated. The JWT wasn't refreshed. The frontend was asking for "Org B" while the backend authorized as "Org A."

It took me two hours to find the bug. Another hour to write the fix. The lesson seared itself into my brain: **tenant context is a security claim. It belongs in the JWT, not in localStorage.**

Four months later, on a Solomiata e-commerce backend, the agent made the same suggestion. I caught it before it shipped — but only because I happened to remember.

Now, eight months after the original bug, on a brand new project, the agent was confidently suggesting the same broken pattern.

That's when I realized: **I'm paying for the same lessons over and over because the agent never learns.**

---

## The pattern I'd been ignoring

I sat with that thought for a few days.

I'd been using Claude Code daily for six months. Across five active projects. By my count, that's somewhere around 500+ sessions. And the more I worked with it, the more I noticed a specific class of repeated failure that wasn't about the model being stupid:

- It was about the **agent starting cold every time I switched projects.**

Some examples from my own scar tissue:

- **`localStorage` for tenant scope** — caught three times, fixed three times
- **Importing types from `@workspace/shared` into a NestJS API** — broke production builds twice with cryptic ESM/CJS interop errors before I learned to inline types
- **Prisma 7 client setup with `datasourceUrl`** — wasted an afternoon before realizing v7 deprecated it in favor of explicit Driver Adapters
- **Frontend types declaring `orgId` when the API returns `organizationId`** — silent runtime undefined, twice
- **Seeding fake field polygons for dev** — masked real PostGIS edge cases that only surfaced when actual users uploaded actual GeoJSON

Each of these cost me hours when I first hit them. None of them transferred between projects. The agent forgot. I forgot. The fix lived in one project's git history, invisible to the next.

This is the pattern I want to talk about.

---

## Why agents are amnesiac across projects

Claude Code, by default, has three layers of context awareness:

1. **The current conversation.** Everything in this chat session.
2. **The current project's `CLAUDE.md`.** A file at the project root that gets injected into every session in that directory.
3. **Your personal `~/.claude/CLAUDE.md`.** A global file that loads on every session.

That's it. There is no built-in mechanism for **"things I learned the hard way in project A that should apply when I work on project B."**

You can put rules in `~/.claude/CLAUDE.md`, but it gets loaded on every session, regardless of what you're doing. After 50 lessons, that file becomes a 30 KB blob of mostly-irrelevant rules clogging the context window. After 200 lessons, it's unusable.

What I needed was: **per-domain memory, loaded conditionally, based on what I'm prompting about right now.**

---

## What I tried first (and why each failed)

I went through the obvious options.

### Option 1: Better `CLAUDE.md` files

I started writing extensive project-specific gotchas into each project's `CLAUDE.md`. This worked locally but didn't compound. Every new project started a new file. Lessons stayed trapped.

### Option 2: claude-mem (auto-capture-everything memory)

There's an [open-source tool called claude-mem](https://github.com/thedotmack/claude-mem) that auto-captures every tool call and uses an AI to compress observations into summaries. I read the docs carefully. Two problems killed it for me:

1. **AGPL-3.0 license.** That's a viral copyleft. If I touch their code in a commercial project, my code becomes AGPL too. Many companies block AGPL outright. For a tool meant to compound across all my work, including paid client work, that was a deal-breaker.

2. **The compressed summaries can't be trusted.** When the agent reads "we decided X for reason Y," is that authoritative or an AI hallucination from the compression pass? The README never addresses how you audit a compressed summary. A memory that confidently lies is worse than no memory.

### Option 3: A flat global memory file

I tried hand-curating one big `MEMORY.md` with all my universal lessons. Works for ~20 lessons. After that, it's a flat unsearchable blob the agent can't selectively load.

---

## The pattern that finally worked

Here's the design I landed on:

**Per-domain markdown files. Stable lesson IDs. Conditionally loaded based on what I'm prompting about.**

```
~/.claude/lessons/
  README.md
  agent-architecture.md   ← AI agent memory, context engineering
  agent-tuning.md         ← Claude Code config, output styles
  api-design.md           ← API contracts, response wrappers, naming
  auth.md                 ← JWT, OAuth, sessions, RBAC, multi-tenancy
  caching.md              ← cache layers, TTLs, invalidation
  data-modeling.md        ← schemas, seeds, soft-delete, time-series
  migrations.md           ← schema changes, downtime, rollback
  nestjs.md               ← NestJS-specific gotchas
  nextjs.md               ← Next.js / React-specific gotchas
  prisma.md               ← Prisma ORM specifics
```

Each lesson is a self-contained scar:

```markdown
## L-AUTH-001 — Tenant context comes from JWT, not localStorage

**Tags:** auth, jwt, multi-tenant, frontend, security
**Severity:** high

**What broke:** Dashboard read `localStorage.getItem('orgId')` to scope
queries. On org switch, localStorage updated but JWT didn't refresh —
backend kept returning the old org's data while the frontend asked for
the new one. Worse: localStorage is forgeable client-side, so a malicious
user could change the value to access another org's data.

**Why:** Tenant scope is a security claim, not a UI preference.
localStorage is unauthenticated client state. JWT is signed by the
backend and cryptographically tied to the session.

**Never do again:** Tenant scope from JWT only.

**Fix:** Replace all `localStorage.getItem('orgId')` with
`getCurrentOrgId()` (decodes JWT). Org switch endpoint re-issues JWT.
See commit abc123.
```

The IDs (`L-AUTH-001`) are the durable thing. They survive heading
renames, file splits, even maintainer changes. You can cite them from:

- **CodeRabbit `path_instructions`** — "flag patterns matching L-AUTH-001"
- **PR descriptions** — "fixes regression of L-AUTH-001"
- **Slack/Telegram pings to teammates** — "you hit L-AUTH-001 again, same root cause"

---

## How the agent reaches them

I built a Claude Code skill called `consult-scars`. Its description in the skill file matches architectural verbs in user prompts:

```
description: |
  Loads relevant lessons from ~/.claude/lessons/ before producing any
  architectural plan. Use when the user's prompt contains design,
  refactor, migrate, introduce, implement, build, fix, debug, optimize,
  add caching, add auth, schema change, or similar verbs combined with
  topics like authentication, JWT, OAuth, sessions, RBAC, caching, TTLs,
  invalidation, migrations, schema changes, ORM upgrades, distributed
  locking, payment flows, webhook handling, queue processing, retry
  logic, error recovery, rate limiting, deploys, infrastructure changes,
  API contract design, response wrappers, NestJS modules, NestJS DI,
  Prisma client setup, Next.js layouts, Server Components, seed data,
  fake data generation.
```

When my prompt includes any of those triggers, Claude Code's skill matcher auto-fires `consult-scars`. The skill body walks the lessons directory, greps tag fields against the prompt, loads matching domain files in full, and cross-checks my proposed approach against each lesson before outputting a plan.

The agent now sees my scar tissue from project A when working on project C. Same fix, but loaded **before** the bad suggestion is made — not after I catch it in code review.

This isn't fancy AI. It's mechanical pattern matching with human-curated content. That's the point.

---

## The `/enhance` skill — built on top

Once the lessons library exists, a slash command called `/enhance` becomes obvious.

```
/enhance refactor the auth middleware to use JWT instead of sessions
```

Triggers a skill that:

1. Loads project context — `.codemap/` if present (architecture, hot files, recent git activity)
2. Greps lessons for matching tags (auth, refactor → loads `auth.md`)
3. Reads project `CLAUDE.md` for conventions
4. Calls [Serena MCP](https://github.com/oraios/serena) for semantic codebase queries (if installed)
5. Applies prompt-engineering principles (intent classification, scope detection, success criteria, surfaced ambiguities)
6. Produces a structured prompt
7. Asks: **submit / edit / scrap**

The output looks like this:

```markdown
# Enhanced Prompt

## Goal

Replace session-based authentication in the NestJS API with JWT-based
auth, while preserving the existing org-switching flow.

## Scope

**In:**

- apps/api/src/auth/auth.module.ts
- apps/api/src/auth/auth.service.ts (currently issues sessions)
- apps/api/src/auth/jwt.strategy.ts (already exists, needs to become primary)

**Out:**

- Org switcher (already uses JWT re-issue)

## Constraints

**Lessons that apply:**

- **L-AUTH-001** — Tenant context from JWT, not localStorage
- **L-NESTJS-001** — Don't import shared workspace package in NestJS API

## Success criteria

1. All authenticated endpoints accept JWT in Authorization header
2. No reliance on session cookies anywhere in the codebase
3. `pnpm --filter api test` passes
4. No `localStorage.getItem('orgId')` calls remain in apps/web

## Implicit assumptions to confirm

- [ ] Existing user sessions can be invalidated, OR you need a migration
- [ ] Refresh tokens stored in httpOnly cookie or response body?
- [ ] CSRF protection — needed if cookies, not needed if headers

## Risk: HIGH

Touches authentication. Don't ship without spec-architect lock-in
and codex review pass.
```

Notice what just happened. The vague request "refactor the auth middleware" became a structured prompt with **two specific lessons cited by ID**. The agent knew about my localStorage scar tissue from project A. It surfaced the migration-path question I would otherwise have realized two days into the work.

That's the difference compounding scar tissue makes.

---

## What changed in my workflow

Concrete numbers from six months of using this system:

- **12 lessons captured** so far, across eight domain files
- **~500 Claude Code sessions** over 6 months
- **5 active projects** that all share the same lessons library
- **Estimated time saved:** if I assume each repeated lesson costs ~2 hours of debugging + fix, and I've avoided maybe 6 repetitions across these projects, that's 12 hours of senior-engineer time. At ~$100/hour reasonable solo-dev rate, that's $1,200 saved over 6 months.
- **API cost:** $0. The skill uses my existing Claude Code session — no separate Anthropic API call, no per-prompt tax.
- **Storage:** ~80 KB of markdown across all lesson files. Fits in a Git repo with room to spare.

The numbers aren't viral-startup numbers. But the trajectory is what matters: every new lesson I add today will save time across **every future project I work on**, indefinitely.

That's compounding.

---

## What I learned building this

Three insights that surprised me.

### 1. Curated > captured. Always.

The temptation when designing memory systems is to capture everything and let the AI sort it out later. claude-mem's design philosophy.

But quality of memory matters infinitely more than quantity. **A senior engineer's notebook is thin and authoritative. A junior's is overflowing and unreliable.** Auto-capture-everything systems build the junior's notebook with extra steps.

### 2. Stable IDs are the protocol.

Without `L-AUTH-001`-style IDs, lessons stay trapped in markdown. With them, lessons travel into:

- CodeRabbit configurations (`path_instructions` referencing IDs)
- PR descriptions (`fixes regression of L-AUTH-001`)
- Slack and Telegram pings between teammates
- Issue tracker tags

The IDs are what make the library more than "another markdown folder." They're the API for cross-tool, cross-time communication about specific lessons.

### 3. The skill description is the forcing function.

I tried writing the lessons library as a passive reference. I never read it. Even with my own self-discipline, I'd skip checking it under deadline pressure.

Once the lessons were behind a skill that **auto-fires on architectural verbs**, the agent loaded them mechanically — no discipline required from me. The harness became the enforcement layer.

This generalizes: **for any "you should remember to do X" pattern in your workflow, find a way to make the system enforce it instead of relying on yourself.**

---

## Try it

I open-sourced everything. Free, local, MIT-licensed.

```bash
git clone https://github.com/tenxengineer/claude-code-enhance.git
cd claude-code-enhance
bash scripts/bootstrap.sh
```

Then restart Claude Code. Try:

```
/enhance <some rough idea you've been putting off>
```

The skill ships with default lessons for auth, API design, and data modeling. You add your own as you encounter pain.

**Repo:** [github.com/tenxengineer/claude-code-enhance](https://github.com/tenxengineer/claude-code-enhance)

---

## What I'm looking for

If you've been using Claude Code (or Cursor, or Cody, or any agent harness) at scale across multiple projects, I'd love to hear from you:

- **Default lesson domains worth shipping.** I have eight; what other domains have given you repeated pain? Mobile? Payments? Observability? Distributed systems?
- **Stories of where compounding scar tissue changed your agent's output.** Real examples beat synthetic ones.
- **Per-stack codemap generators for non-TypeScript projects.** Python, Go, Rust — the shape is similar but the heuristics differ.

Open issues, file PRs, or reach me on [Twitter](https://twitter.com/tenxengineer).

---

## One last thought

The biggest pain in agentic coding isn't the model. It's the gap between what you've already learned and what the agent can reach.

Close that gap, and the agent stops being a smart consultant who walked in this morning. It becomes a colleague with all your scar tissue, ready to apply it before you make the same mistake the fourth time.

That's the asymmetry I want to keep building toward.

If you're a senior engineer running multiple projects through Claude Code, this might be worth twenty minutes of your evening.

Thanks for reading.

---

> If you enjoyed this, consider giving it a clap on Medium and starring the [GitHub repo](https://github.com/tenxengineer/claude-code-enhance). Both help the project find the next reader who's been paying for the same bug three times.

---

## For the author (notes before publishing)

**Before posting on Medium:**

1. **Cover image.** Medium articles with cover images get ~2x the engagement. Use the `assets/demo.svg` from the repo as the cover, or generate a simple text+icon image with the title.
2. **Curate vs captured pull-quote.** Highlight that line in Medium's pull-quote feature; it's the most shareable insight in the article.
3. **Member-only or public?** Member-only earns money but reaches fewer readers initially. **Recommendation:** publish as member-only after you've already built launch traction (HN + Twitter). For Day 0, public reach beats earnings.
4. **Cross-post to Dev.to.** Use Medium's canonical URL feature so SEO doesn't get split.
5. **Tags to test:** `AI`, `Programming`, `Software Engineering`, `Anthropic`, `Open Source`, `Developer Tools`, `Claude`. Pick 5 (Medium's max).
6. **Submission to publications.** Worth pitching to:
   - **Better Programming** (the dev tooling angle)
   - **Towards AI** (AI/agent design angle)
   - **Level Up Coding** (general developer audience)
     Each has different review timelines (1-7 days). Pitch one; if accepted, more reach.
7. **Schedule for Tuesday/Thursday morning EST** for best Medium algorithm pickup.
