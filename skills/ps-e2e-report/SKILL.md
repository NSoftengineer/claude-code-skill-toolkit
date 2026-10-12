---
name: ps-e2e-report
description: Generate an evidence-based E2E report broken down by API endpoints, frontend routes, and integration journeys.
argument-hint: 'WAVE-ID [--run RUN-ID] [--target api|frontend|both]'
---
# Evidence-based API + Frontend E2E Report

1. Locate the explicitly selected run and real Playwright JSON/JUnit/HTML artifacts. If multiple runs exist, ask for `--run` or use the run clearly identified in the current conversation; never silently combine unrelated runs. Check file existence and parse machine-readable results.
2. Delegate evidence interpretation to `e2e-report-analyst`. Match test IDs and tags to the approved `API-`, `FE-` and `FLOW-` plan rows and actual Issues. Mark unmapped tests `UNMAPPED`; do not fabricate coverage from names alone.
3. Produce **three separate sections**: API (method + endpoint + response/status/schema/auth/negative scenarios), FRONTEND (route/page + browser + navigation/forms/accessibility relevant to criteria), INTEGRATION (frontend action → API endpoint → expected UI or state). For each, show required/implemented/executed/passed/failed/skipped/not-run counts and evidence. These are distinct measurements; do not mislabel planned count as executed count.
4. Provide run metadata: repository/branch/commit, Wave/Milestone, approved environment without credentials, UTC time, browser projects, exact commands, exit codes, API/frontend base URL identity (redacted if sensitive), source/artifact paths, flaky/retried tests and limitations.
5. Report defects with target, Issue, test ID, severity with evidence, reproduction steps, links/paths to traces/screenshots/responses **after redacting secrets, cookies, tokens and personal/payment data**. Never expose raw authorization headers or sensitive response bodies.
6. Coverage Matrix: Issue → Acceptance Criterion → API endpoint / Frontend route / Flow → Test ID → executed evidence → verdict. Show cross-layer gaps and targets marked `NOT APPLICABLE` with reasons.
7. Only after approval to create report artifacts, write `reports/<wave>/E2E-TEST-REPORT.md`, `reports/<wave>/DEFECT-REPORT.md` (without silent overwrite) using templates. If machine-readable evidence is missing, report BLOCKED / NOT RUN, never invent PASS.
8. No GitHub issue mutation, push, or deployment. STOP.
