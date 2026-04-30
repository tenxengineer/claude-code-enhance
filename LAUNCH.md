# Launch Playbook

Drafts of all launch content + checklist. Fill in your GitHub username,
Twitter handle, and the actual repo URL before posting. Reorder the
sequence to suit your timezone and bandwidth.

---

## Pre-launch checklist (do these BEFORE Day 0)

- [ ] Push the repo to GitHub: `gh repo create claude-code-enhance --public --source=. --push`
- [ ] Replace `<REPLACE-WITH-YOUR-GITHUB>` placeholders in `plugin.json`,
      `CHANGELOG.md`, `README.md`
- [ ] Add GitHub topics: `gh repo edit --add-topic claude-code,prompt-engineering,augment-code,coding-agent,llm-tools,developer-tools,ai-coding,plugin`
- [ ] Record a real demo GIF — see `docs/recording-demo.md` for steps
- [ ] Test bootstrap.sh on a fresh machine (or VM) to verify it works
      end-to-end without errors
- [ ] Star your own repo (sounds silly; signals to algorithms it's not abandoned)
- [ ] Write one issue yourself with a concrete use case — gives visitors
      a sense the project is alive

---

## Day 0 — Show HN post

**When:** Tuesday or Wednesday, 8–10am EST (peak HN traffic)

**Title (under 80 chars):**

```
Show HN: Claude-Code-Enhance – Free, local prompt enhancer for Claude Code
```

**URL field:** `https://github.com/tenxengineer/claude-code-enhance`

**First comment (post immediately after submitting):**

```
Hey HN, author here.

I've been using Claude Code daily for several months across 5+ projects. The
biggest quality lever I found wasn't a better model or more skills — it was
the structure of my prompts. A vague "fix the bug" produces guessing; a
structured prompt with goal/scope/constraints/success-criteria produces
aligned execution.

Augment Code has a great prompt enhancer (Ctrl+P in their CLI) but it's
proprietary, costs credits per query, and may send code to their cloud.
This is a free, local, MIT-licensed equivalent for Claude Code:

  /enhance fix the bug where field area is computed wrong

Loads project context (architecture, hot files, recent git activity,
lessons library, codebase structure via Serena MCP if installed), applies
prompt-engineering principles, and shows you a structured enhanced prompt
you review/edit/submit before execution.

Three skills total:
- /enhance — the prompt enhancer (the headline feature)
- consult-scars — auto-firing lesson loader on architectural verbs
- /refresh-codemap — git-derived heat map regenerator

Plus an optional companion: a "scar tissue" lesson library (~/.claude/lessons/)
that compounds across projects. The /enhance skill cross-references against
it. Comes with default lessons for auth, API design, and data modeling — add
your own as you encounter pain.

Cost: $0. Uses your existing Claude Code session, no separate API call.
Privacy: stays local. License: MIT.

Honest about limitations:
- It can't replicate Augment's exact Ctrl+P UX (Claude Code's keybindings
  can only trigger built-in actions; you can't add custom ones). The
  closest equivalent is the slash command.
- Output quality is bounded by the underlying Claude Code session model.
- Without companion infrastructure (lessons + codemap), it operates in
  "Tier C" — still useful but less codebase-aware.

Open to feedback, especially:
- Default lesson domains worth adding
- Per-stack codemap generators (currently bash + git, agnostic)
- Whether the slash command UX is good enough or whether the external-
  editor approach (Ctrl+G in Claude Code) is worth building

Repo: https://github.com/tenxengineer/claude-code-enhance
```

**Engagement plan for first 4 hours:**

- Refresh HN every 5 min, respond to every comment
- Don't be defensive when criticized — acknowledge the point and explain
  the design decision OR commit to changing it
- If someone misunderstands the project, that's a documentation bug —
  fix the README and link to the new section
- Avoid feeding trolls; ignore obvious bait

---

## Day 0 — Twitter/X thread

**Tweet 1 (lead with GIF):**

```
I built a free, local, MIT-licensed alternative to Augment Code's prompt
enhancer for Claude Code.

Lifts vague developer thoughts into structured, codebase-aware prompts
with goal, scope, constraints, and success criteria — before any code is
written.

[GIF: 30-second demo of /enhance in action]

🧵
```

**Tweet 2:**

```
The problem: a vague "/enhance fix the bug" produces guessing. The fix:
load real codebase context (architecture, hot files, recent commits,
lessons library) and apply prompt-engineering principles to produce a
structured prompt you review before execution.

[Screenshot of the structured output]
```

**Tweet 3:**

```
Three skills:
1. /enhance — the prompt enhancer (headline)
2. consult-scars — auto-firing lesson loader (triggers on "design",
   "refactor", "migrate", etc.)
3. /refresh-codemap — git-derived hot-files map generator

Plus an optional companion: a "scar tissue" lesson library that
compounds across all your projects.
```

**Tweet 4:**

```
How it differs from Augment Code:

✓ Free (uses your existing Claude Code session, no per-query credits)
✓ Local (your code never leaves your machine)
✓ MIT (no AGPL viral copyleft like claude-mem)
✓ Lessons cross-reference (not just structural enhancement)
✓ No lock-in — fork freely

Honest limit: can't replicate Augment's exact Ctrl+P UX in Claude Code's
keybinding system. Slash command is the closest equivalent.
```

**Tweet 5:**

```
Install:

  /plugin marketplace add tenxengineer/claude-code-enhance
  /plugin install claude-code-enhance

Or manually clone + run bootstrap.sh.

Try it: /enhance <some rough idea>

Repo + docs: https://github.com/tenxengineer/claude-code-enhance
```

**Tweet 6 (call for feedback):**

```
This is v1.0.0. Looking for:
- Default lesson domains worth adding
- Real-world feedback on the slash-command UX
- Stories of where structured prompts changed your output quality

Open issues, file PRs, or reply here.

@AnthropicAI @AugmentCode

#ClaudeCode #BuildInPublic #OSS
```

**Posting plan:**

- Post the thread early morning (8–9am your timezone)
- Pin it to your profile for 24 hours
- Quote-tweet your own thread later in the day with a follow-up insight
  to keep it visible
- DM 5-10 power users in the AI dev community asking for feedback
  (don't spam; only people you've genuinely interacted with)

---

## Week 1 — Dev.to article

**Title:**

```
Building a free alternative to Augment Code's prompt enhancer in 200 lines
```

**Subtitle:**

```
How structured prompts produce 5x better output, and why the lessons
library matters more than the enhancer itself.
```

**Tags:** `claudecode`, `ai`, `tutorial`, `opensource`

**Body (markdown — paste into dev.to as-is, edit if needed):**

````markdown
> TL;DR: I built a free, local, MIT-licensed prompt enhancer for Claude
> Code. It does 80% of what Augment Code's Ctrl+P feature does without
> the credits, the cloud, or the lock-in. The unexpected discovery: the
> enhancer matters less than the lessons library that backs it.
>
> Repo: https://github.com/tenxengineer/claude-code-enhance

## The problem nobody talks about

When you use Claude Code daily, you discover that prompt quality is the
single biggest lever for output quality. A vague "fix the bug" produces
guessing; a structured prompt with goal/scope/constraints/success-criteria
produces aligned execution.

Augment Code figured this out. Their interactive CLI has a Ctrl+P shortcut
that takes your rough prompt, runs it through their LLM service with
codebase context, and replaces the input with a structured version.

It's good. It's also proprietary, costs credits per query, and may send
your code to their cloud.

I wanted the same UX in Claude Code, free and local.

## The first attempt — and why it was wrong

I built a `UserPromptSubmit` hook that auto-enhanced every non-trivial
prompt by calling Haiku 4.5 in the background. It worked but was wrong:

1. **It fired automatically.** Augment is user-controlled (Ctrl+P).
   Auto-firing means I pay for every prompt, even when I don't want
   enhancement.
2. **It was invisible.** The "enhancement" was injected as
   additionalContext — I never saw it, couldn't edit it, couldn't reject it.
3. **It cost real money.** ~$0.30-1.50/month at typical usage. Small but
   constant tax on every keystroke.

The right design — what Augment actually does — is:

> User-triggered. Visible. Editable. Reversible.

Tool, not automation.

## The fix — slash command + project context

```
/enhance fix the bug where field area is computed wrong
```

Triggers a skill that:

1. Walks up to find `.codemap/` (architecture overview, hot files,
   recent activity)
2. Greps `~/.claude/lessons/` for matching scar-tissue entries
3. Reads project `CLAUDE.md` for conventions
4. Calls Serena MCP for semantic codebase queries (if installed)
5. Produces a structured prompt using prompt-engineering principles
6. Shows you the enhanced version
7. Asks: submit / edit / scrap

Cost: $0. Uses your existing Claude Code session, no separate API call.
Privacy: stays local.

## The unexpected finding — lessons matter more

Here's what surprised me: the enhancer is the headline feature, but the
**lessons library** is what actually changes output quality.

A naive enhancer says "implement comprehensive error handling." A real
one says: "Note L-AUTH-001 — tenant context comes from JWT, not
localStorage. Last time we did this differently, it shipped a security
bug to production."

That cross-reference only exists because there's a curated, durable,
human-written lesson file at `~/.claude/lessons/auth.md` with stable IDs.

The auto-capture-everything alternatives (claude-mem etc.) don't do this
because compressed AI summaries can't be trusted as authoritative. A
lesson that confidently lies is worse than no lesson.

The philosophy:

> **Curated > captured. Quality > quantity.**

## What's in the repo

- `skills/enhance/` — the prompt enhancer
- `skills/consult-scars/` — auto-firing lesson loader on architectural verbs
- `skills/refresh-codemap/` — git-derived hot-files map regenerator
- `hooks/` — SessionStart hooks for global memory and project codemap
- `examples/lessons/` — generic lesson templates (auth, api-design,
  data-modeling) to bootstrap your own library
- `examples/codemap/` — codemap structure templates
- `scripts/bootstrap.sh` — idempotent installer

## Comparison

|                   | claude-code-enhance | Augment Code      | claude-mem                 |
| ----------------- | ------------------- | ----------------- | -------------------------- |
| License           | MIT                 | Proprietary       | AGPL-3.0                   |
| Cost              | $0                  | Credits per query | API tokens for compression |
| Privacy           | Local               | Optional cloud    | Local SQLite + Chroma      |
| Lessons cross-ref | Yes                 | No                | No                         |
| Lock-in           | None                | Augment infra     | AGPL viral                 |

## Honest limits

- Can't replicate Augment's exact Ctrl+P UX. Claude Code's keybindings
  can only trigger built-in actions, not custom ones. Slash command is
  the closest equivalent.
- Output quality is bounded by your Claude Code session's model.
- Without companion infrastructure (lessons + codemap), the skill
  operates in "Tier C" — still useful but less codebase-aware.

## How to install

```bash
git clone https://github.com/tenxengineer/claude-code-enhance.git
cd claude-code-enhance
bash scripts/bootstrap.sh
```

Restart Claude Code. Try: `/enhance <some rough idea>`.

## What's next

Looking for:

- Default lesson domains worth adding to the library
- Per-stack codemap generators (Python-specific, Go-specific, etc.)
- Real-world feedback from people using it daily

Open issues, file PRs, or reach me on Twitter.

Repo: https://github.com/tenxengineer/claude-code-enhance
````

**Post-publish plan:**

- Cross-post to your personal blog if you have one
- Submit to:
  - r/programming (only if it does well on HN)
  - r/ClaudeAI
  - r/LocalLLaMA (for the local + free angle)
  - Hashnode AI tag
- Tweet the article link with a different angle than the launch tweet
  thread (e.g., "the unexpected finding: lessons matter more than the
  enhancer")

---

## Week 2 — Awesome list submissions

**Awesome lists worth submitting to:**

- `awesome-claude-code` (search GitHub for the most-starred one)
- `awesome-llm-tools`
- `awesome-developer-tools`
- `awesome-ai-coding`

**Submission template (PR description):**

```
Adds [claude-code-enhance](https://github.com/tenxengineer/claude-code-enhance)
— Free, local, MIT-licensed prompt enhancer for Claude Code with a
companion scar-tissue lesson library. Inspired by Augment Code's
prompt enhancer; works fully offline of any cloud service.
```

Match the existing list's format. Some prefer alphabetical order, some
prefer chronological by add-date, some have category sections.

---

## Week 2-4 — Discord communities

**Communities to engage in (don't spam — engage genuinely first):**

- Anthropic's official Discord (Claude Code channels if any)
- AI Engineer Discord
- LocalLLaMA Discord
- Cursor's Discord (yes, Cursor — they're not direct competitors and
  there's overlap in tooling interest)

**Engagement strategy:**

- Lurk for 1-2 days first to understand the culture
- Answer questions you have expertise in (without mentioning your repo)
- When someone asks a problem your repo solves, share it naturally
- Don't drop the link cold-turkey in #general — that's spam

---

## Month 1+ — Sustained growth

**Weekly cadence:**

- Tuesday: ship one visible improvement, write a 1-tweet build-in-public update
- Friday: review issues, respond to PRs, update CHANGELOG

**Monthly cadence:**

- Write one Dev.to article on a learning, lesson, or new feature
- Update the demo GIF if the UX has changed materially
- Review GitHub Insights to see traffic sources, optimize accordingly

**Quarterly cadence:**

- Cut a new release (v1.1, v1.2, etc.) with notable changes
- Reach out to 3 power users for testimonials or interviews
- Audit the README — is the value prop still clear? Is the GIF still current?

---

## Realistic expectations

- **Month 1:** 50-150 stars if the launch goes reasonably; 20-50 if it
  doesn't get HN traction
- **Month 3:** 200-500 stars with consistent shipping + responsive issue
  triage
- **Month 6:** 500-1000 stars if a tweet goes viral or someone notable
  uses it; 200-400 stars on pure organic growth
- **Year 1:** 1000+ stars only if (a) Anthropic features it officially,
  (b) you write a blog post that goes viral, or (c) you've built a
  genuine community of contributors

The win condition isn't star count. It's: **5+ developers tell you this
changed how they use Claude Code.** That's the real signal.

---

## Stuff to AVOID

- ❌ Don't trash competitors. Position as "different choice for different
  needs," not "better than X."
- ❌ Don't do star-spam (asking friends to star). It's transparent and
  hurts long-term credibility.
- ❌ Don't make promises in the README you can't keep. Better to under-
  promise and over-deliver.
- ❌ Don't ignore criticism. Even bad criticism contains signal.
- ❌ Don't burn out. This is a 12-month minimum game. Pace yourself.

---

## You've got this

The plugin is real, the value prop is clear, and you've done the work
most OSS projects skip (CHANGELOG, CONTRIBUTING, examples, bootstrap
script, docs).

Now ship it.
