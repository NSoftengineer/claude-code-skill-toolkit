# Frontend E2E Test Plan — <WAVE-ID>

> TEMPLATE. Discover routes and interaction rules from the actual router, components, issue text and backend calls.

## Frontend route inventory and traceability
| FE Case ID | Wave | GitHub Issue / Criterion | Frontend Route | Page/Component Source | Access Role | User Journey / Action | Expected UI State | Linked API Endpoint(s) | Browser / Viewport | Proposed Test File | Priority | Coverage State |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| FE-W1-001 | W1 | #? / AC? | TBD | TBD | TBD | TBD | TBD | TBD | TBD | TBD | TBD | PROPOSED |

## User-flow integration inventory
| Flow ID | Start Route | User Action | Method + API Path | Expected API / Persisted State | Expected UI Outcome | Verified Browser Assertion | Source/Acceptance Criterion | Status |
|---|---|---|---|---|---|---|---|---|
| FLOW-W1-001 | TBD | TBD | TBD | TBD | TBD | TBD | TBD | PROPOSED |

## Include when required by Issue acceptance criteria
- Navigation, forms, validation errors, loading/empty/error/success states
- Auth & authorization redirects or restricted UI states
- Mobile/responsive layout and browser matrix
- Accessibility interactions (focus, labels, keyboard navigation) with recorded scope
- Browser request/response handling and correct user feedback when API fails

## Preconditions
- Approved local/staging frontend URL and any required API environment
- Safe test identity, fixtures, navigation state and cleanup plan
- Browser binaries installed separately and reachable applications

## Exit / evidence
- Route and integration-flow coverage mapped to real Issues
- Passed Playwright browser assertions and screenshots/traces only when actually produced
- No PASS when API-side state is asserted only from visual change with no evidence
