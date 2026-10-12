# Implementation Queue

> Generated from verified GitHub Issue numbers after an approved publication. This table is a **plan**, not proof of code implementation or test completion.

- Repository: `OWNER/REPO`
- Generated (UTC): `YYYY-MM-DDTHH:MM:SSZ`
- Milestones created/reused:
- Issues created/reused:
- Validation status: `PASS / PARTIAL / BLOCKED`

| Seq | Milestone | Wave | GitHub Issue | Role | Deliverable | Depends on | Priority | State | Owner | Exit evidence | Next command |
|---:|---|---|---|---|---|---|---|---|---|---|---|
| 1 | M1 | W1 | [#123](https://github.com/OWNER/REPO/issues/123) | database | Example only | — | High | NOT STARTED | Unassigned | Migration + tests | `/ps-implement-issue 123 --role database` |

## Wave execution order

| Wave | Milestone | Roles and issue IDs | Verified prerequisites | Quality gate | Suggested next command |
|---|---|---|---|---|---|
| W1 | M1 | database: #123 | None | Tests + review | `/ps-implement-wave W1 --role database` |

## Execution rules

- Requires a human-approved execution scope per wave/role as defined by the implementation Skills.
- `NOT STARTED` is the default after publishing; a ready prerequisite is not evidence of code completion.
- Do not auto-implement, auto-close Issues, push source, or deploy.
- Cross-role Issues require separate rows; never silently combine scopes.
- Mark dependency or evidence gaps `BLOCKED` and give the reason.
