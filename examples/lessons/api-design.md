# API Design

Lessons learned about API contracts, response wrappers, field naming, and
client-server type discipline.

---

## L-API-001 — Frontend types must match the response wrapper, not the inner data

**Tags:** api, typescript, frontend, response-format, types
**Project:** universal
**Severity:** medium

**What broke:** Backend returned `{ success: true, data: { items: [...] } }`. Frontend `apiFetch<Item[]>('/api/items')` typed the return as `Item[]` directly. At runtime, calls to `result.map(...)` failed because `result` was actually the wrapper object, not the array. TypeScript happily compiled because the type lie wasn't checked at the boundary.

**Why:** Standardized API response wrapper (`{ success, data }` or `{ success, error }`) is great for consistent error handling, but only if the client types match the wrapper, not the inner data. Convenience helpers like `apiFetch<T>` need to type their return as `Wrapper<T>`, with `T` being the inner shape — and consumers must read `.data` explicitly.

**Never do again:** When building API client helpers, type the wrapper. Force consumers through `result.data` access. Never type-cast away the wrapper to "make it convenient" — that's how silent runtime failures happen.

**Fix:**

```typescript
type ApiResponse<T> =
  | { success: true; data: T }
  | { success: false; error: { code: string; message: string } };

async function apiFetch<T>(path: string): Promise<ApiResponse<T>> {
  /* ... */
}

// Consumer:
const result = await apiFetch<Item[]>("/api/items");
if (!result.success) throw new Error(result.error.message);
const items = result.data; // Item[]
```

---

## L-API-002 — Frontend interfaces must mirror exact API field casing

**Tags:** api, typescript, frontend, contracts, naming
**Project:** universal
**Severity:** medium

**What broke:** Backend returned `{ organizationId: "..." }`. Frontend interface declared `{ orgId: string }`. TypeScript compiled. At runtime, `record.orgId` was always `undefined` because the actual key was `organizationId`. Bug shipped to production.

**Why:** TypeScript types are erased at runtime. There's no validation that the network response matches the declared interface. If the frontend interface says `orgId` but the API returns `organizationId`, no error is thrown — the access just silently returns `undefined`.

**Never do again:** Frontend interfaces must MIRROR exact backend field names character-for-character, including casing. If backend says `organizationId`, frontend interface says `organizationId`. Don't rename for "convenience" or "consistency" with frontend conventions. If you genuinely need a different shape, build a typed adapter at the boundary.

**Fix:** Audit frontend interfaces against backend Prisma schema or OpenAPI spec. Add runtime validation at API boundary (zod schema or similar) that fails loudly on mismatch instead of silently returning `undefined`.

---
