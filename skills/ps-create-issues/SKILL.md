---
name: ps-create-issues
description: Publish a human-approved set of planned issues to a specified GitHub repository and verify creation.
argument-hint: "[approved plan and OWNER/REPO]"
disable-model-invocation: true
---
# Explicit approval-gated GitHub issue publication
Input: $ARGUMENTS
1. Retrieve exact approved plan; validate target `OWNER/REPO`, authentication (`gh auth status`) and pre-existing issues using read-only gh commands. If plan or explicit authorization is missing, STOP.
2. Present final publication table and exact titles/bodies, count, repository, anticipated labels and dependency references. Ask for explicit confirmation **before any GitHub writes** if previous approval did not cover this exact set.
3. Delegate to github-issue-creator only after confirmation. Create issues one by one; store verified returned URLs. Dependencies between new issue numbers can be recorded as text if applicable and specifically approved; do not assume GitHub-native linked blocking relations.
4. Verify each created Issue using read-only `gh issue view`, map plan IDs to real issue numbers, compare titles/requirements, and report any partial failures. Never blindly retry a failed create.
5. Return mapping PLAN-ID → #ISSUE → URL and remaining problems, then **STOP**. Don't close issues, commit, push, start implementation or begin another batch.

## Milestone coordination
Use only approved milestone names and wave identifiers in issue bodies when supplied. Do not create or assign GitHub milestones as a side effect of creating issues; use `/ps-create-milestones` with separate authorization. Verify actual created issue IDs before producing a wave execution table.
