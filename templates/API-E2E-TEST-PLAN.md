# API E2E Test Plan — <WAVE-ID>

> TEMPLATE. Discover registered effective METHOD + PATH from real router mounts/controller code and cross-check with OpenAPI and Issues; do not invent endpoints. `--role backend` without a Wave covers the whole repository. For Wave planning, map the inventory to known criteria; unknown Issue mappings are UNASSIGNED.

## API inventory and traceability
| API Case ID | Wave | Milestone | GitHub Issue / Criterion | HTTP Method | Path Template | Source / operationId | Auth/Roles | Path/Query/Body Inputs | Expected Success Status / Contract | Required Negative / Auth Tests | Test Data / Cleanup | Proposed Playwright Test | Priority | Coverage State |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| API-W1-001 | W1 | M? | #? / AC? | TBD | TBD | TBD | TBD | TBD | TBD | TBD | TBD | TBD | TBD | PROPOSED |

## Required API scenario checks (only when feature/spec requires)
- HTTP status and response contract; request validation and error shape
- Authenticated, unauthenticated, unauthorized and object-level authorization
- Pagination / sorting / filtering; rate limiting when specified
- Idempotency, duplicate submissions, replay, and failure rollback for sensitive mutation paths
- Audit and sensitive-data handling when relevant
- Path and route parameters, required headers, versioning and backwards compatibility when contracted

## Preconditions
- Approved non-production API base URL and test identity
- Known safe fixture setup, deterministic cleanup and no real payments/customer data
- Existing Playwright tests OR approved change to implement the tests

## Exit / evidence
- Traceable executable API tests for each mandatory method+path criterion
- Real HTTP assertion results and machine-readable Playwright artifacts
- `NOT COVERED`, `BLOCKED`, `NOT APPLICABLE` recorded separately from `PASS`


## Router discovery and API scenario matrix (`--scope all-routes`)

Use `templates/API-ROUTE-INVENTORY.md` first. Build these rows **for every confirmed registered METHOD + PATH**, not merely endpoints mentioned in the current Wave. Record ambiguity when static inspection cannot resolve dynamic route registration.

| Scenario ID | API ID | Scenario Class | Precondition / Fixture | HTTP Request / Auth | Expected Status / Body / State (Evidence) | Cleanup | Priority | Proposed Test Path | State |
|---|---|---|---|---|---|---|---|---|---|
| API-001-P01 | API-001 | Success | <fixture> | <method,path,headers/body> | <contract or TBD/BLOCKED> | <cleanup> | P1 | tests/e2e/api/... | PROPOSED |
| API-001-N01 | API-001 | Validation / Authorization / Error | <fixture> | <invalid request or auth case> | <contract or TBD/BLOCKED> | <cleanup> | P1 | tests/e2e/api/... | PROPOSED |

Do not equate proposed scenarios with test files or passed test results. Do not invent expected HTTP statuses, response fields, auth roles or data side effects.
