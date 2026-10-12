# Full Flow: Proposed GitHub Publication Manifest

> **DRAFT — NO WRITES AUTHORIZED**. Approval must cover the exact version below.

## Target repository

- Authenticated GitHub login: `<read from gh api user>`
- Project root folder: `<read from git root or cwd>`
- Resolved target: `OWNER/REPO`
- Repository disposition: `REUSE EXISTING` / `CREATE PRIVATE REPO`
- Git remote consistency: `MATCH` / `NO REMOTE` / `CONFLICT — BLOCKED`
- Source code push: **NO**

## Project baseline

- Requirements source:
- Architecture decisions:
- Unresolved questions:

## Milestones (proposed)

| Milestone ID | GitHub milestone title | Deliverable | Exit criteria | Create/reuse | Issue PS-IDs |
|---|---|---|---|---|---|
| M1 | | | | | |

## Waves (proposed)

| Wave | Milestone | PS-IDs | Roles | Prerequisites | Wave exit gate |
|---|---|---|---|---|---|
| W1 | M1 | | | | |

## GitHub issue publication

| PS-ID | Issue title | Primary role | Wave | Milestone | Dependency PS-IDs | New/reuse | Priority |
|---|---|---|---|---|---|---|---|
| PS-001 | | backend | W1 | M1 | | NEW | High |

Each NEW issue also requires an **exact issue body** with scope, acceptance criteria, tests, dependencies, and the stable HTML marker `<!-- ps-plan-id: PS-001 -->`; attach the proposed bodies before approval.

## Exact authorized operations

- [ ] Create private repository `OWNER/REPO` (only if absent)
- [ ] Create the enumerated milestones (count: __)
- [ ] Create the enumerated issues (count: __)
- [ ] Make the listed assignments to existing issues (if any: list exact # IDs)
- [ ] Create local `docs/ps-flow/IMPLEMENTATION-QUEUE.md` and `.json` after verification
- [ ] No Git push, source commits, deploy, issue close/delete, new labels or due dates

## Approval gate

- Proposed manifest version/hash: `<identifier>`
- Plan-validator result: `PASS / FAIL / BLOCKED`
- User's exact approval: `<pending>`
- Publish: **ONLY AFTER EXPLICIT APPROVAL OF THIS MANIFEST**
