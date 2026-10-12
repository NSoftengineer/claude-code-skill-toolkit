---
name: ps-e2e-verify
description: Verify GitHub Wave acceptance criteria against real API-path, frontend-route, and cross-layer Playwright test evidence.
argument-hint: 'WAVE-ID [--run RUN-ID] [--target api|frontend|both]'
---
# E2E Acceptance Criteria Verification (API + Frontend)

1. Read actual Issues, approved Wave exit criteria and test plan; use real `gh issue view` when available. Missing authoritative criteria → BLOCKED for affected rows.
2. Read current test source and explicit selected run evidence. An existing test is not proof that it ran or passed.
3. Build a matrix: Issue → criterion → target API/FRONTEND/INTEGRATION → HTTP method/path or UI route → test ID → source → run evidence → PASS/FAIL/BLOCKED/NOT COVERED.
4. For API criteria verify status code and response contract, required auth and negative outcomes as explicitly required. For frontend verify browser route, UI behavior and relevant viewport/browser coverage. For end-to-end user journeys verify evidence that the UI triggered the expected API/state behavior; separate green API+UI tests do not automatically establish linked cross-layer coverage.
5. Distinguish `NOT APPLICABLE` (with source-supported explanation) from `NOT COVERED` and `NOT RUN`. Produce an API coverage summary, frontend route coverage summary, cross-layer coverage summary, and missing paths.
6. Report actual executed outcome and current environment; never edit files or GitHub state. STOP.
