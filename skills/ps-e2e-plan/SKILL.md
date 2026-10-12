---
name: ps-e2e-plan
description: Build read-only, issue-traceable E2E coverage plans for backend API endpoints, frontend routes, and cross-layer user journeys in an approved Wave or Issue.
argument-hint: 'WAVE-ID [--target api|frontend|both] [--role backend|frontend|database|qa|devops] [--repo OWNER/REPO]'
---
# E2E Test Planning — API Paths + Frontend Routes

Default `--target both` unless the user explicitly chooses `api` or `frontend`. These are natural-language skill arguments, not a standalone shell CLI. For `both`, include three coverage groups: `API`, `FRONTEND` and `INTEGRATION` (browser → HTTP API → observable state). For `api` or `frontend`, include integration dependencies relevant to that surface but do not represent untested cross-layer behavior as passed.

## Required inputs and safe discovery (READ-ONLY)
1. Require an exact Wave ID or Issue number, an approved Wave/Issue plan and a resolved repository. Missing authoritative inputs → BLOCKED. Never invent GitHub Issue numbers, endpoints, routes, environments, or business rules.
2. Read `CLAUDE.md`, real Issue acceptance criteria, existing tests, server route registration, controllers, middleware, OpenAPI/Swagger documents, API client calls, frontend route definitions, link/navigation configuration and permissions. If GitHub access is unavailable, use user-provided Issue text or report BLOCKED for missing criteria.
3. Delegate read-only mapping to `e2e-test-planner`. Classify discovered routes as VERIFIED (code/spec evidence), DOCUMENTED ONLY, or UNVERIFIED; mark examples as placeholders.
4. Build a complete API path inventory for scoped features, each with **HTTP method + path template**, path/query/header/body requirements, authentication/roles, source file or OpenAPI `operationId`, expected success status/response contract, important failures, dependencies, test data, risk, and issue/criterion reference. Use stable `API-W1-001` style IDs.
5. Build a frontend route inventory for scoped features, each with **route URL/path pattern**, page/component source, role/auth, states and validations, accessibility and viewport expectations, underlying API calls, browser test target and issue/criterion reference. Use `FE-W1-001` IDs.
6. Build cross-layer journey inventory `FLOW-W1-001`: starting frontend route, user action, HTTP method + endpoint called, contract/state result, destination UI/feedback, authorization concerns, cleanup, and criterion. Include at least one integration scenario for each required browser-to-API acceptance criterion, or explicitly mark it BLOCKED / NOT APPLICABLE with grounded justification.
7. For API, cover happy-path, input validation and status codes, authentication/authorization, object-level access where relevant, pagination/filter/sort where present, error contracts, idempotency/replay for payment/state-changing endpoints when relevant, and backward compatibility when specified. **Do not invent these features when absent.**
8. For frontend, cover navigation, form/errors/loading/empty states, role-based UI, accessibility expectations, responsive/browser matrix **when required by criteria**, and failures of dependent APIs.
9. Map every plan row to GitHub Issue, Acceptance Criterion, Wave, Milestone, primary role, test type, priority, prerequisites, environment, data plan, expected evidence, test file/tag and implementation state `EXISTING|PROPOSED|BLOCKED|NOT APPLICABLE`.
10. Summarize API endpoint coverage, frontend route coverage, and cross-layer flow coverage separately; record uncovered requirements and `NOT APPLICABLE` rationale. Do **not** calculate execution pass rates in the plan.

## Output
Return draft plan using `templates/E2E-TEST-PLAN.md` and the route-specific templates `templates/API-E2E-TEST-PLAN.md`, `templates/FRONTEND-E2E-TEST-PLAN.md` and `templates/E2E-PATH-COVERAGE-MATRIX.md` as guides. In the application repository, suggest (but do not create without approval):
- `docs/ps-flow/e2e/W1/API-E2E-TEST-PLAN.md`
- `docs/ps-flow/e2e/W1/FRONTEND-E2E-TEST-PLAN.md`
- `docs/ps-flow/e2e/W1/E2E-PATH-COVERAGE-MATRIX.md`

STOP for approval before writing tests/plans, installing dependencies, starting services, provisioning data, or altering GitHub. Treat all unrun tests as NOT RUN.
