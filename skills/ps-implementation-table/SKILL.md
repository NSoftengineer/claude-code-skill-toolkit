---
name: ps-implementation-table
description: Make an ordered role-based implementation table from existing GitHub Issues and stop for user approval before any implementation.
argument-hint: "[OWNER/REPO or issue range]"
disable-model-invocation: true
---
# Prepare execution table from actual GitHub Issues
Input: $ARGUMENTS
1. Read CLAUDE.md and current git state. Confirm repo and retrieve actual issues using read-only `gh issue list` and `gh issue view`. If inaccessible, ask for issue text and mark verification blocked; never invent issues.
2. Delegate to issue-table-planner, supported by planner and plan-validator.
3. For each issue or distinct role deliverable, output a Markdown table with: Seq, Issue #/URL, Epic, Title, Role [backend/frontend/database/qa/devops], Work item/deliverable, Depends on, Priority, Owner, Status, Acceptance/verification, Blockers.
4. Multiple roles in one GitHub Issue: separate table rows or recommend subissues for approval; only one role at a time may be implemented; never silently write across roles.
5. Order by real prerequisites (schema before dependent API, API contracts before integrated UI, tests before completion, CI after build requirements when relevant), but prioritize actual issue dependencies over heuristic order.
6. Mark current progress based on evidence, not guesses; status values: NOT STARTED, READY, BLOCKED, IN PROGRESS, TESTING, REVIEW, DONE (verified). If no evidence, use NOT STARTED.
7. Explain proposed batch and role handoffs; show the approval checkpoint. **STOP**. Do not edit code or GitHub issues.
8. After user approval, invoke `/ps-implement-issue <number> --role <role>` for exactly one issue and role.

## Wave grouping
When an approved Milestone-Wave plan is available, include Milestone ID, Wave ID, cross-wave prerequisites and exit gate per row. If no such plan exists, recommend `/ps-plan-waves` instead of inventing milestone assignments.
