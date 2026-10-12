# API E2E Test Plan — <WAVE-ID>

> TEMPLATE. Discover endpoints from code/OpenAPI and real Issues; do not fill with invented routes.

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
