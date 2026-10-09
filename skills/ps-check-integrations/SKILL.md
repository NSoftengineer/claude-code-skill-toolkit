---
name: ps-check-integrations
description: Read-only preflight for optional Superpowers, Matt Pocock TDD gstack browser skills and Impeccable frontend design tooling before a role or wave implementation.
argument-hint: "[optional: tdd|browse|impeccable|all]"
---
# Check integrations before implementing issues

1. Read the project's CLAUDE.md and THIRD-PARTY-INTEGRATIONS.md if present. Identify installed plugins and available skills using Claude Code's skill/plugin discovery where possible.
2. Check that Superpowers is available if the approved plan requires it.
3. Check that Matt Pocock's `/tdd` is available for tasks requiring test-driven development.
4. Check that gstack `/browse` is available and an accessible target application exists for browser validation.
5. Check Impeccable is installed and accessible (`/impeccable`); verify the project has design context or seek approval to create it using `/impeccable init`. Do not install or initialize automatically.
6. On Windows, confirm Git, Bun and Node.js requirements before suggesting gstack setup; never install dependencies automatically.
7. Report AVAILABLE / UNAVAILABLE / NOT REQUIRED for each integration with observed evidence. If a required capability is missing, mark related validation BLOCKED, and provide install instructions from THIRD-PARTY-INTEGRATIONS.md.
8. Do not run any third-party installer, add plugins, modify files, create issues, commit, push, or deploy.
