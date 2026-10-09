---
name: ps-e2e-report
description: Generate a Markdown E2E test and defect report from real Playwright outputs for one Wave or Issue, without inventing test results.
argument-hint: "WAVE-ID [--run RUN-ID]"
---
# Evidence-based E2E Report
1. Locate the specified completed run under `reports/<wave>/runs/<run-id>/` or the existing repository's approved report path; do not choose an arbitrary run if multiple exist. Confirm file existence and parse actual Playwright JSON/JUnit results.
2. Delegate analysis to `e2e-report-analyst` where available. Use raw evidence and actual GitHub issue acceptance criteria; report limitations where mapping is missing.
3. Summarize wave/repo/branch/commit/environment/browsers/start time/runner command/exit status, attempted/passed/failed/skipped/flaky/interrupted counts, failed test names and repro steps, attachments with exact relative paths, severity with justification, and coverage gaps.
4. Prepare `reports/<wave>/E2E-TEST-REPORT.md` and `reports/<wave>/DEFECT-REPORT.md` only when the user has approved writing report artifacts. Never overwrite existing reports silently. Use template `templates/E2E-TEST-REPORT.md` as a guide where accessible.
5. If machine-readable evidence is missing, state BLOCKED or NOT RUN; never generate a fabricated PASS, percentages or screenshots. Redact secrets and private test data.
6. Do not create GitHub bug issues or modify existing ones without separate explicit approval. STOP.
