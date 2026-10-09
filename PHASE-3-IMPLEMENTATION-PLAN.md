# Phase 3 — Role-Based GitHub Issue Implementation Plan

> **Template / example only.** Issues #123–#127 below are illustrative, not verified or created. Replace the issue numbers, titles, acceptance criteria, owners, and dependencies with facts read from your GitHub repository.

**Repository:** `OWNER/REPO` (replace)  
**Approval:** `PENDING`  
**Execution policy:** Exactly **one issue + one role** per invocation. Do not silently modify another role's scope.  
**Roles allowed:** `backend`, `frontend`, `database`, `qa`, `devops`.

## Prerequisites and gates

1. Complete Phase 1 (`/ps-plan-project`) and approve the proposed Issue Plan.
2. Publish approved Issues through `/ps-create-issues`, then verify the actual created issue links and acceptance criteria.
3. Run `/ps-implementation-table OWNER/REPO` to read **real** GitHub Issues and build the dependency-ordered table.
4. Review the table for ownership, dependencies, scope, architecture decisions, tests and priority. **STOP for explicit approval** before any edits.
5. Run **one** `/ps-implement-issue <number> --role <role>` command; inspect the report and verify status before continuing. The next command is not automatic.

## Example implementation execution table

| Seq | Example issue | Role | Expected deliverable (illustrative) | Prerequisites | Validation | Gate / state |
|---|---|---|---|---|---|---|
| 1 | #125 | `database` | Schema and migration scripts | Approved schema decision | Migration validation, rollback review | PENDING |
| 2 | #123 | `backend` | API/service implementation | #125, approved API contract | Unit/integration tests and code review | PENDING |
| 3 | #124 | `frontend` | UI and API integration | #123, approved UI contract | UI tests, build, accessibility review | PENDING |
| 4 | #126 | `qa` | Test scenarios and regression automation | #123 and #124 | Test execution and recorded results | PENDING |
| 5 | #127 | `devops` | CI/CD pipeline and config as code | #126 and release policy | Pipeline/config validation; NO deployment | PENDING |

**Dependency order is only an example.** Actual Issue relationships determine the real order, even if they differ from this table. Do not claim issue numbers or links exist without reading GitHub.

## Exact Phase 3 commands

Run the following **only when the matching actual issue exists, its dependencies are satisfied, and the user has approved its scope**. The order shown here follows the example table (database → backend → frontend → qa → devops), not issue-number order.

```text
/ps-implement-issue 125 --role database
/ps-implement-issue 123 --role backend
/ps-implement-issue 124 --role frontend
/ps-implement-issue 126 --role qa
/ps-implement-issue 127 --role devops
```

If your repository's actual dependencies permit a different order, follow the approved implementation table. Every command runs independently and must **STOP → REPORT** before the next one.

## Role scope and handoffs

| Role | Allowed implementation scope | Not allowed without separate approval | Evidence required |
|---|---|---|---|
| `database` | Migration files, indexes, query/data integrity changes | Applying migrations to production/shared DB; deleting data; editing backend/UI | Migration validation and compatibility assessment |
| `backend` | APIs, service logic, auth rules, error handling | Schema or UI redesign; production configuration changes | Tests, API contract and review results |
| `frontend` | Components, routes, forms, client integration, accessibility | API or DB changes | Build, UI/component tests, review results |
| `qa` | Test cases, automated tests, fixtures within scope, defect evidence | Unapproved application fixes or weakening assertions | Test execution log and results |
| `devops` | CI, Docker, infrastructure-as-code, configuration | Actual deployments, production secret changes, destructive operations | Config/pipeline validation and risk assessment |

If a single Issue contains work for multiple Roles, record separate Role rows or propose approved subissues. **Never** cross-edit roles as a side effect of one command.

## Per-Issue checklist

- [ ] Actual GitHub Issue content retrieved (`gh issue view`) or user-provided exact text.
- [ ] Role explicitly supplied and matches approved table.
- [ ] All required decisions and dependencies verified.
- [ ] Relevant `CLAUDE.md` and repository patterns read.
- [ ] Git working tree inspected; user changes protected.
- [ ] Exact file scope and acceptance criteria approved.
- [ ] Implementation limited to **one issue / one role**.
- [ ] Relevant tests run and outcomes recorded (do not claim unrun tests passed).
- [ ] Independent code/security review and issue verification completed as applicable.
- [ ] Report `PASS`, `FAIL`, `BLOCKED`, or `PARTIAL`, including file list, test commands, findings, blockers and handoffs.
- [ ] **STOP**. No automatic next issue, close/comment/edit Issue, commit, push, merge, migrate production data, or deploy.

## Example work session

```text
# In a project repository after GitHub CLI is authenticated:
/ps-implementation-table OWNER/REPO
# Review/approve the actual generated table before any code changes.
/ps-implement-issue 125 --role database
# Read the report, confirm migration files/tests, and approve next scope.
/ps-implement-issue 123 --role backend
# Continue one Issue and one Role at a time, only when dependencies are satisfied.
/ps-verify-issue 123
/ps-review-code
```

## Recommended status vocabulary

`NOT STARTED` → `READY` → `IN PROGRESS` → `TESTING` → `REVIEW` → `DONE (verified)`; use `BLOCKED` if prerequisites or approvals are missing. A PASS review is not permission to close the GitHub Issue automatically.


## E2E Exit Gate (v6)
After an approved Wave implementation: `/ps-e2e-plan W1` → approval for environment/test execution → `/ps-e2e-test W1 --env staging` → `/ps-e2e-report W1` → `/ps-e2e-verify W1` → `/ps-e2e-gate W1` → STOP. Missing tests or evidence yields BLOCKED, not PASS.
