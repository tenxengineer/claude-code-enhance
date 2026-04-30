# <Project Name> — Architecture Overview

**Last reviewed:** YYYY-MM-DD — update when architecture changes materially.

> This is a TEMPLATE. Replace the bracketed sections with your project's
> actual content. Delete this note when you've filled it in.

## What this product is

[One paragraph: what the product does, who uses it, what makes it
distinctive. This is the elevator pitch a new hire would read on day one.]

## Top-level layout

```
<project-root>/
  apps/
    api/           [framework] — [what it owns]
    web/           [framework] — [what it owns]
    mobile/        [framework] — [what it owns]
  packages/
    shared/        [what's shared]
  infra/
    [infrastructure files]
  docs/
    [project docs]
```

## Layer boundaries (sacred — don't cross)

- **Controllers** [what they do, what they don't do]
- **Services** [what they do, what they don't do]
- **Repositories** [what they do, what they don't do]
- **Models / DTOs** [validation strategy]
- **Frontend** [what's RSC vs Client, when]
- **Mobile** [feature structure, state management]

## Cross-cutting concerns (touch these and many things break)

### Auth (`<path>`)

[How auth works — token type, claims, storage, refresh strategy. Reference
relevant lesson IDs if applicable: e.g., L-AUTH-001.]

### Tenant scoping

[If multi-tenant: how tenant context propagates from request to query.]

### API response contract

[Response wrapper format. Reference L-API-001 if applicable.]

### Logging & observability

[Logger choice, log format, where logs land.]

## Hot subsystems (highest-risk areas — extra care here)

### [Subsystem 1]

[Description of the most complex/risky/high-traffic subsystem. Key
gotchas. Cross-reference relevant lessons.]

### [Subsystem 2]

[Same — for the next-most-complex area.]

## Tech stack defaults (when adding new code)

- **Backend:** [framework, conventions]
- **Frontend:** [framework, conventions]
- **Mobile:** [framework, conventions]
- **i18n:** [primary/secondary languages, format]
- **Date format:** [API vs UI conventions]

## Boundaries you should know about

- **[Anti-pattern 1]** — [explanation, lesson ID]
- **[Anti-pattern 2]** — [explanation, lesson ID]

## Where current sprint work is

See `recent.md` for last 30-day activity summary. See
`<project>/HANDOFF.md` (or equivalent) for milestone tracking.

## Ground truth references

- Full spec: `docs/SPEC.md`
- Architecture decision records: `docs/adr/`
- API contract: `docs/openapi.yaml` (or equivalent)
- External docs: [links to library/framework docs you reference often]
