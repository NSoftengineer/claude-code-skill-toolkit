---
name: ps-e2e-plan
description: Prepare evidence-traceable Playwright E2E scenarios for a GitHub Issue or implementation Wave without running tests or modifying files.
argument-hint: "WAVE-ID [--role frontend|backend|database|qa|devops] [--repo OWNER/REPO]"
---
# E2E Test Planning
1. Require explicit Wave ID or Issue number. Resolve repository and approved wave plan; missing inputs -> BLOCKED (do not guess).
2. Read repository CLAUDE.md, real GitHub issues when `gh` is authenticated, acceptance criteria, approvals, dependencies, and current E2E test inventory.
3. Delegate a read-only planning pass to `e2e-test-planner` if available.
4. Produce test traceability table: test ID | issue | user journey | role | priority | prerequisite | expected behavior | proposed test file | evidence type | status.
5. Include positive/negative flows, auth/permission cases, browser matrix where relevant, test-data isolation, known risks, and environment prerequisites.
6. Distinguish EXISTING/PROPOSED/BLOCKED; do not claim tests exist without locating source.
7. STOP for approval before writing test files, provisioning accounts, installing browsers, or modifying project setup. Planning is read-only.
