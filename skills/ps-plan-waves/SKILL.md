---
name: ps-plan-waves
description: Create a read-only, dependency-aware milestone and execution-wave plan for a project from actual plans and GitHub Issues, with role assignment and approval gates.
argument-hint: "[OWNER/REPO or planning scope]"
---
# Plan Milestones and Waves
1. Read applicable CLAUDE.md and repository instructions and current master plan and issue table if available.
2. If a repository is given and `gh` is authenticated, read actual open AND relevant closed Issues, milestones and dependencies. Else label everything PROPOSED and report unverified items; never fabricate issue numbers.
3. Delegate dependency-aware wave design to `wave-planner` and validation to `plan-validator`.
4. Every MILESTONE is a deliverable with objective, acceptance criteria, owner if known, issues, due date only if supplied, exit gate and status.
5. Every WAVE is a batch within one milestone with stable W-number, ordered prerequisites, issues, role (one per row), deliverable, validation evidence, execution status and explicit human approval gate.
6. Validate dependency DAG, no cycles, no orphan issues, no milestone-less waves, no overlapping role writes, and no unsupported assumptions about readiness.
7. Present both Milestone and Wave tables using templates/MILESTONE-WAVE-PLAN.md. Present an exact PROPOSED GitHub change manifest, if publication is desired.
8. STOP for human approval. No issue or milestone mutations in this skill. Distinguish plan approval from separate GitHub write authorization.
