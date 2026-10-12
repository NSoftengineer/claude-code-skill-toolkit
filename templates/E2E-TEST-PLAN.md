# E2E Test Plan — <WAVE-ID> (API + Frontend + Integration)

> TEMPLATE — plan only. No real endpoints, GitHub Issue IDs or pass results are implied.

- Repository / Milestone / Wave: `<OWNER/REPO>` / `<MILESTONE>` / `<WAVE>`
- Approved target: `both` (or `api` / `frontend`)
- Authorized environment: `<LOCAL_OR_STAGING>`; never production by default
- API base URL: `<APPROVED_API_BASE_URL>`
- Frontend base URL: `<APPROVED_FRONTEND_BASE_URL>`
- Auth / test data / cleanup: `<SAFE_TEST_ACCOUNTS_AND_DATA_STRATEGY>`
- Browser projects and responsive requirements: `<PROJECT_SPECIFIC>`

## 1. API endpoint inventory
| Case ID | Issue/AC | HTTP Method | API Path Template | Auth / Input | Expected Status + Contract | Failure Cases | Source Evidence | Test Source/Status | Priority |
|---|---|---|---|---|---|---|---|---|---|
| API-W1-001 | TBD | TBD | TBD | TBD | TBD | TBD | TBD | PROPOSED / NOT RUN | TBD |

## 2. Frontend route inventory
| Case ID | Issue/AC | Frontend Route | Page / Component | User Action | Expected UI State | API Dependency | Browser / Viewport | Source Evidence | Test Source/Status |
|---|---|---|---|---|---|---|---|---|---|
| FE-W1-001 | TBD | TBD | TBD | TBD | TBD | TBD | TBD | TBD | PROPOSED / NOT RUN |

## 3. Cross-layer user journeys
| Case ID | Issue/AC | Start Route | UI Action | Method + API Path | Expected API/State | Expected UI Result | Verification Method | Status |
|---|---|---|---|---|---|---|---|---|
| FLOW-W1-001 | TBD | TBD | TBD | TBD | TBD | TBD | TBD | PROPOSED / NOT RUN |

## Coverage and exit gates
- Mandatory API: `<COUNT_OR_NOT_APPLICABLE_REASON>`
- Mandatory Frontend: `<COUNT_OR_NOT_APPLICABLE_REASON>`
- Mandatory Integration: `<COUNT_OR_NOT_APPLICABLE_REASON>`
- No PASS without executed test-run artifacts; missing mandatory coverage → BLOCKED.
- Approval required before creating tests, accounts, test data or starting services.

Also see `API-E2E-TEST-PLAN.md`, `FRONTEND-E2E-TEST-PLAN.md`, and `E2E-PATH-COVERAGE-MATRIX.md`.
