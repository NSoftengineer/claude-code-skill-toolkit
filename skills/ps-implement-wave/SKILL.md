---
name: ps-implement-wave
description: Execute one approved implementation wave by role, one GitHub Issue at a time, with dependency checks, tests, independent reviews, report and STOP.
argument-hint: "WAVE-ID --role backend|frontend|database|qa|devops"
---
# Implement a Wave (controlled orchestration)
1. Require one exact WAVE-ID, exactly one of the five roles, approved milestone/wave table, and explicit scope approval. Missing role means STOP and ask for a role.
2. Verify actual issue IDs, acceptance criteria, repository instructions, dependencies, already-changed files and the selected wave's exit criteria. Never infer issue state.
3. Reject out-of-role work and block on missing prerequisites, conflicting changes, unresolved architecture decisions or other waves' unverified gates.
4. Show the ordered list of eligible issues for this role in this wave and request approval for this execution batch; respect any user-approved limit on issues per run.
5. Invoke `/ps-implement-issue NUMBER --role ROLE` separately for each approved issue; maintain the existing per-issue planning, testing, review, reporting and STOP gates. A single approval MUST NOT override any required per-issue checkpoint. Do not auto-continue when an issue reports FAIL/PARTIAL/BLOCKED.
6. After each issue, store results in the in-session wave table, not in GitHub, unless separately authorized to edit tracker files. Validate wave exit criteria with actual evidence; do not claim PASS based on agent assertions alone.
7. Report completed/blocked/unstarted Issues, test results, review findings, changes and remaining prerequisites.
8. STOP. Do not start another wave, create commits, push, close issues or deploy automatically.

## Optional third-party workflow (never bypass gates)
- Before execution check installed skills with `/ps-check-integrations`; use only skills actually available in this session.
- When `/tdd` is present and relevant, follow a Red → Green → Refactor loop within the approved issue+role scope; report exact tests executed. If explicitly required and unavailable, BLOCKED; otherwise use repository-native tests and disclose fallback.
- For approved frontend/browser QA, when gstack `/browse` exists, use it to inspect an authorized local/staging environment. Do not browse production or change production data without explicit approval. If browser testing is required but `/browse` is unavailable, report BLOCKED rather than claiming it passed.
- Superpowers planning/debugging aids are optional and never supersede this toolkit's approval gates, read-only review constraints, or STOP behavior.
- Never invoke third-party skills that push, merge, deploy, or publish as a side effect without separate explicit user approval.

## Optional Impeccable frontend design workflow (role-gated)
- Apply **only when `--role frontend`**, never for backend, database, qa or devops by default. Check availability before execution; the toolkit does not install Impeccable automatically.
- Impeccable official install from the project root: `npx impeccable install --providers=claude --scope=global` (run only after user chooses to install it). A per-project `impeccable init` may write PRODUCT.md and DESIGN.md; do not perform this write without user approval. Check actual command availability in the active Claude Code session after restart.
- If Impeccable is AVAILABLE: inspect PRODUCT.md/DESIGN.md if present; propose `/impeccable shape <issue UI target>` during planning; obtain approval before any UI or design context writes. Implement only the approved frontend issue. Perform `/impeccable audit <target>` and `/impeccable critique <target>` as review steps when suitable; use `/impeccable polish <target>` or `/impeccable harden <target>` only inside the approved scope with explicit permission for resulting changes. Re-run tests/reviews after changes.
- Never assume nested external slash commands execute automatically across subagent contexts. The main Claude Code session should invoke the available skill explicitly, or follow its installed instructions; log exactly what ran.
- Do not require Impeccable for unrelated roles. If explicitly required for this frontend wave but unavailable, return BLOCKED with installation instructions; otherwise report a native frontend review fallback as PARTIAL where design validation was requested.
- Do not run `impeccable init`, external CLI installers, browser tooling, migrations, commits, pushes or deployments implicitly.

## E2E quality gate before Wave completion (v6)
- After authorized issue implementation and normal unit/integration/security reviews, identify approved E2E scenarios for this wave using `/ps-e2e-plan`. Test planning itself must not modify files.
- When the wave exit criteria require E2E, use `/ps-e2e-test <WAVE-ID> --env local|staging` only after environment access and test execution are authorized. Generate the evidence-based `/ps-e2e-report`, then `/ps-e2e-verify`, then `/ps-e2e-gate`.
- If tests/tooling/environment are missing, record BLOCKED; never count unrun tests as passing or advance to the next wave. Playwright MCP or gstack `/browse` may assist investigation but do not substitute for test runner evidence.
- STOP after reporting the gate verdict. Never automatically close issues, launch another wave or deploy.
