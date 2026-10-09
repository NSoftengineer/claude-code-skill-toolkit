---
name: ps-plan-project
description: Discover repository, draft Epic and GitHub Issue plan, validate and stop for approval without GitHub writes.
argument-hint: "[project objective]"
disable-model-invocation: true
---
# Project planning (read-only)
Input: $ARGUMENTS
1. Delegate to project-discovery and planner; inspect CLAUDE.md, working tree, repo and known requirements.
2. Produce project overview, architecture assumptions, suggested Epics and proposed atomic issues. For each: stable plan ID, title, description, primary role backend/frontend/database/qa/devops, acceptance criteria, priority, dependency plan IDs, verification, risk.
3. Ask plan-validator to check completeness, duplicate candidates, dependencies and role allocation. Inspect existing GitHub issues with read-only `gh issue list` if possible.
4. Output draft MASTER-ISSUE-PLAN table using template. Clearly distinguish plan IDs (not GitHub numbers).
5. STOP → request explicit approval of exact plan and target OWNER/REPO. **No gh issue create, edits, commits or project file changes.**
6. After approval, tell user to invoke `/ps-create-issues` with the approved plan. Do not automatically execute it.

## Milestone and wave handoff
After building and validating the master plan, recommend `/ps-plan-waves OWNER/REPO` to group proposed/issues into verifiable milestones and dependency-aware waves. Do not publish milestones or issues without separate approval.
