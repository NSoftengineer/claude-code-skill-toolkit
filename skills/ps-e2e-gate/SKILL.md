---
name: ps-e2e-gate
description: Apply an evidence-based E2E release gate for a Wave; block on missing critical coverage, test failures, or unapproved risk.
argument-hint: "WAVE-ID [--run RUN-ID]"
---
# E2E Quality Gate
1. Require the approved Wave exit criteria, authoritative Issue acceptance criteria, current explicit E2E execution evidence, and `/ps-e2e-verify` mapping.
2. PASS only when all mandatory wave acceptance criteria have actual passing evidence, no critical/high unresolved defects for the scoped release, required browsers/environments completed, and run status is successful. User may define stricter thresholds before testing.
3. FAIL when required tests executed and failed or confirmed critical/high defects remain. BLOCKED when evidence, environment, access, approval, or required coverage is missing. PARTIAL is a report-only state and is NOT permission to advance.
4. No approval bypass: a user risk acceptance is a separately documented decision, not an automatic PASS. Never close issues, promote releases, deploy, or start next wave.
5. Produce gate record: Wave, milestone, source issue set, chosen run, counts, mandatory criteria mapping, findings, reviewer, timestamp, status, release blockers, next actions. STOP.
