---
name: ps-implement-issue
description: Implement exactly one GitHub Issue for a mandatory explicit role (backend/frontend/database/qa/devops); test, review, report and stop.
argument-hint: "<issue-number> --role backend|frontend|database|qa|devops"
disable-model-invocation: true
---
# Role-gated implementation
Input: $ARGUMENTS
**Hard stop:** Require exactly one issue number/URL AND an explicit `--role` with one of: `backend`, `frontend`, `database`, `qa`, `devops`. If absent/invalid/multiple, request correction and DO NOT edit.
1. Read CLAUDE.md, `git status`, actual issue and acceptance criteria through read-only `gh issue view` (or explicit provided text when gh unavailable). Locate the approved implementation-table row if available. If unavailable, generate a scoped mini-plan and ask for user approval before editing.
2. Check issue state, approval, dependencies and architecture decisions. If prereqs incomplete, scope inconsistent, or another role owns the requested change, STOP with BLOCKED/handoff. The role is a strict scope boundary, not merely an agent name.
3. Present exact file/module scope and tests. Obtain approval of scope if not already approved for this issue+role.
4. Delegate to developer for ONLY this issue and role. No other issue or role edits. Database role may author migration code but **not apply migration in shared/production DB** without separate approval. Devops role may update CI/Docker/IaC but **not deploy**.
5. Delegate to tester, code-reviewer and security-reviewer; use github-issue-verifier for acceptance criteria. If failures need edits outside approved scope, report BLOCKED. Retest within approved scope as needed.
6. Report `PASS|FAIL|PARTIAL|BLOCKED`, issue number and role, files changed, commands and actual results, reviewer findings, unfulfilled cross-role work, next recommended issue and blockers. **STOP**: no automatic next issue, gh issue close/comment/edit, commits, push, merge or deploy.

## Wave safeguards
If invoked from `/ps-implement-wave`, verify the selected issue is in the approved wave and matches the requested role. Do not override existing per-issue gates or automatically continue to the next issue/wave. Report progress for the calling wave table.

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

## E2E handoff (v6)
- For issues requiring browser/user-journey verification, add test-case and evidence handoff to QA; use `/ps-e2e-plan` for the relevant wave and do not claim E2E PASS from unit tests alone.
- `/ps-e2e-test` must target authorized local/staging only, with actual artifacts; Wave-level release decision belongs to `/ps-e2e-gate`.
