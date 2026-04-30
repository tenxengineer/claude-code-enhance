# Authentication & Multi-Tenancy

Lessons learned about JWT, session management, RBAC, and multi-tenant
context handling. Generic patterns from real production incidents.

---

## L-AUTH-001 — Tenant context comes from JWT, not localStorage

**Tags:** auth, jwt, multi-tenant, frontend, security
**Project:** universal
**Severity:** high

**What broke:** Dashboard pages read `localStorage.getItem('orgId')` to scope queries. Bug: when a user switched orgs via the org switcher, localStorage updated but JWT didn't refresh — backend kept returning the old org's data, frontend kept asking for the new org. Worse: localStorage is forgeable client-side, so a malicious user could change the value to access another org's data.

**Why:** Tenant context is a security claim, not a UI preference. localStorage is unauthenticated client-side state — fine for UI prefs (theme, language), unsafe for anything the backend authorizes against. JWT is signed by the backend and cryptographically tied to the user's session; the org claim inside it is authoritative.

**Never do again:** Never read tenant/org/scope context from localStorage in any code path that talks to the backend. Always decode it from the JWT (`getCurrentOrgId()` or equivalent). On org switch, the backend must re-issue a JWT with the new org claim — frontend swaps tokens, then refetches.

**Fix:** Replace `localStorage.getItem('orgId')` reads with `getCurrentOrgId()` (decodes from auth context). Org switch endpoint returns a new JWT; frontend stores it and re-renders. Backend tenant guard reads only from JWT.

---
