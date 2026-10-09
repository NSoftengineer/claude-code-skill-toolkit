---
name: ps-e2e-verify
description: Verify Wave or Issue acceptance criteria against actual executed E2E test evidence and identify coverage gaps.
argument-hint: "WAVE-ID [--run RUN-ID]"
---
# E2E Acceptance Criteria Verification
1. Read approved Wave table and real issue text with read-only `gh issue view`; missing issue access -> BLOCKED for criteria not otherwise supplied.
2. Read actual test sources and most recent EXPLICITLY SELECTED run artifacts. Distinguish existing coverage from executed and passed coverage.
3. Build traceability matrix: Issue → Criterion → Test ID → File → Execution result → Evidence → Verdict.
4. Mark each criterion PASS/FAIL/BLOCKED/NOT COVERED. A test existence without an executed passing result cannot yield PASS.
5. Report unverified cross-browser/accessibility/integration expectations explicitly. No source edits or GitHub writes. STOP.
