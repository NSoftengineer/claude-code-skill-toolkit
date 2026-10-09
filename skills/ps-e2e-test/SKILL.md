---
name: ps-e2e-test
description: Run existing Playwright E2E tests for an approved Wave or Issue with real JSON, JUnit and HTML evidence in an authorized environment.
argument-hint: "WAVE-ID [--role qa|frontend|backend|database|devops] [--env local|staging]"
---
# E2E Test Execution
1. Require Wave ID (or Issue number), approved E2E plan, explicit target environment and authorization, known test credentials, and a non-production endpoint. Block on missing prerequisites. Never assume localhost/staging is running.
2. Read CLAUDE.md; inspect `package.json`, Playwright config and tests. Check `node`, local Playwright installation, browser availability and test command. Do not install or auto-configure dependencies. If tests do not exist, BLOCKED and suggest creating them under a separate, approved change.
3. Restrict to the selected wave's test IDs/files/tags when traceable; do not run entire suite silently if scope not mapped. State selected projects/browsers. Prefer project-defined npm scripts/config; do not overwrite existing settings without approval.
4. Obtain explicit approval for starting services, seeding test data, or writing to a staging system; never run against production or with real payment credentials.
5. Configure Playwright reporter outputs in a unique run directory, e.g. `reports/W1/runs/<UTC-run-id>/`, using supported environment variables `PLAYWRIGHT_JSON_OUTPUT_FILE`, `PLAYWRIGHT_JUNIT_OUTPUT_FILE`, `PLAYWRIGHT_HTML_OUTPUT_DIR`, `PLAYWRIGHT_HTML_OPEN=never` and `--reporter=line,json,junit,html`, provided this does not conflict with repository-specific setup. Paths and exact command must be shown before run. In PowerShell set env vars with `$env:`; in Bash use `export`.
6. Execute approved Playwright tests; preserve non-zero exit codes. Check that output files actually exist. Capture git commit, timestamp, command, browser and environment. Do not overwrite previous reports.
7. Never treat an arbitrary Playwright MCP browsing session as a reproducible test-suite execution; require test runner evidence for E2E PASS.
8. Report PASS/FAIL/PARTIAL/BLOCKED/NOT RUN with counts and evidence paths; redact secrets. Then STOP. No issue mutations, deploy, push or auto-retry.
