# Data Modeling

Lessons learned about schemas, seeds, soft-deletes, time-series storage,
and data hygiene.

---

## L-DATA-001 — No fake seed data, ever

**Tags:** seeds, dev-data, integration-bugs, demo-data, postgres
**Project:** universal
**Severity:** high

**What broke:** Seed script generated synthetic records with random/placeholder values to make the dashboard "look populated" in dev. Resulted in:

1. Integration bugs hidden behind fake data — code that assumed valid input shape broke on real user uploads but worked on seeds.
2. Frontend filters tested only against seed shapes; real-world data had edge cases (special characters, edge-of-range values, unusual relationships) that were never exercised.
3. Demo decisions made assuming the fake data was representative — wasn't.
4. Maintenance tax: every schema change required updating the seed too.

**Why:** Fake seed data is a maintenance liability that masks real integration problems. Development should run against either: (a) empty DB (forces testing the empty state, which is real production for new users/tenants), or (b) a small set of REAL data carefully captured from production with sensitive fields scrubbed. Synthetic data is uniform in ways real data isn't, hiding the long-tail bugs you most need to find.

**Never do again:** Don't write seed scripts that fabricate fake records. If the empty state isn't useful for development, capture a sanitized snapshot from production (dump → scrub PII → restore locally). Treat the dev DB the same way you treat production: real-shape data only, or empty.

**Fix:** Delete seed scripts that fabricate. Document "to populate dev DB, import a real record via the standard import flow with sanitized sample data." Empty DB becomes the default — if a feature needs data to develop against, you import real data first.

---
