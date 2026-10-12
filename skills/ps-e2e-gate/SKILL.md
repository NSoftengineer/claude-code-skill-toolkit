---
name: ps-e2e-gate
description: Apply strict per-Wave E2E quality gates across mandatory API endpoint, frontend browser, and cross-layer integration coverage.
argument-hint: 'WAVE-ID [--run RUN-ID] [--target api|frontend|both]'
---
# E2E Quality Gate — API + Frontend + Integration

1. Require approved Wave criteria, authoritative GitHub acceptance criteria, required targets, current exact test run evidence and verification matrix. Default planned target is `both`, but only source-grounded required surfaces can be marked mandatory or NOT APPLICABLE.
2. Evaluate three gates separately:
   - `API GATE`: every mandatory API method+path criterion is exercised, required success/negative/auth/contract cases pass, no High/Critical API defects remain.
   - `FRONTEND GATE`: mandatory page routes and browser flows pass in required browsers/viewports, required frontend defects resolved.
   - `INTEGRATION GATE`: mandatory UI→API→observable-state scenarios execute and pass; independent API/Frontend PASS alone cannot satisfy a required integrated journey.
3. Each gate is PASS / FAIL / BLOCKED / NOT APPLICABLE. Fail for an executed mandatory failure or confirmed High/Critical defect; block for missing environment, missing test, absent or incomplete evidence, unavailable authorization, or uncovered mandatory acceptance criterion. NOT APPLICABLE requires an explicit evidence-based reason.
4. OVERALL PASS only if every applicable mandatory gate is PASS and the current approved run completed successfully. A report-only `PARTIAL` is never permission to advance. Non-mandatory exploratory checks may be tracked separately and cannot conceal mandatory gaps.
5. Report Wave, Milestone, Issues, explicit run ID, API/Frontend/Integration counts, unmatched routes/endpoints, requirements-to-tests mapping, open defects, risks, timestamps, and final PASS/FAIL/BLOCKED with next actions.
6. Do not automatically close Issues, deploy, start another Wave, overwrite reports or bypass human approval. STOP.
