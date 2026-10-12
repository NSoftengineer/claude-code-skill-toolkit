---
name: ps-full-flow
description: One-command, approval-gated discovery-to-GitHub planning flow. Orchestrate project discovery, issue/milestone/wave planning, automatic validation, a single explicit human approval of GitHub writes, GitHub publishing, and an implementation queue. Does not implement code.
argument-hint: '[--repo OWNER/REPO] [project goal]'
disable-model-invocation: true
---

# PS Full Flow — One Command to Implementation Queue

User invocation: `/ps-full-flow` or `/ps-full-flow --repo OWNER/REPO <project objective>`.

This is an *orchestrator*, not a shell script. Coordinate the existing toolkit's agents and reuse the procedures/checks from `ps-plan-project`, `ps-plan-waves`, `ps-create-milestones`, `ps-create-issues`, and `ps-implementation-table`. **Do not rely on printing slash commands to execute them, and do not rely on a subagent being able to invoke another user-facing skill.** Delegate subtasks through the available subagent mechanism, read and apply existing SKILL.md instructions when useful, and retain the approval requirements below. Standalone skills remain independent and preserve their STOP gates; under this orchestrator their outputs are intermediate stages, not separate user commands.

## Exact promise

- One user command starts discovery, planning, validation and publication preparation.
- The **automatic approval gate** is an automatic **pause/prompt**, *not automatic user approval*. No GitHub or project-file writes before the user approves a specific manifest.
- One approval may cover the exact GitHub create/reuse/assignment operations *and* the local queue files listed in that manifest. If any material scope or target changes after approval, stop and get new approval.
- On approval, continue publication and queue-building without asking the user to manually run the individual `ps-*` skills.
- Finish after an evidence-based implementation queue. **Do not implement code, commit, push source code, close issues, deploy, or begin a wave** automatically.

## Phase 0 — Resolve target (READ-ONLY)

1. Read the user's complete request `$ARGUMENTS`. If `--repo OWNER/REPO` is supplied, validate its exact value; explicit target overrides defaults.
2. Otherwise infer default `OWNER/REPO` as follows:
   - Run `gh auth status` and `gh api user --jq .login` to determine the **authenticated user's login**. Never infer the user from Git author name or email.
   - Get project folder name from `git rev-parse --show-toplevel` (when inside a Git checkout), otherwise the current working directory. Use the final folder name **as-is** when it is a valid GitHub repo name; do not silently sanitize or rename invalid folder names.
   - Default `OWNER/REPO` is `<authenticated-gh-login>/<project-root-folder-name>`.
   - Inspect `git remote -v` and `gh repo view --json nameWithOwner,url,viewerPermission,hasIssuesEnabled` when available. If any existing Git remote points at a *different* GitHub repository, or several plausible targets exist, STOP and ask which target to use. Do not publish to the wrong repo.
3. If unauthenticated (`gh` missing, no token, or API access denied), STOP with `BLOCKED` and show the login/setup command. Do not guess a target or fabricate GitHub data.
4. Check repo existence using a read-only lookup of the resolved target. If the repo does not exist, include **CREATE PRIVATE REPO** as an explicitly listed action for approval; never create it silently. If it exists, verify accessible permission and that Issues are enabled. Do not overwrite anything.
5. Read applicable `CLAUDE.md`, README, architecture specs, package/config files and `git status --short`. No local modifications or installations yet.
6. If the project objective cannot be derived from the user's request or existing requirements without invention, return `BLOCKED` and ask for the missing product requirements. Do not synthesize a large speculative backlog.

## Phase 1 — Discovery and issue planning (READ-ONLY)

1. Delegate repository discovery to `project-discovery` (Haiku) and planning to `planner` (Opus).
2. Build a proposed project roadmap and issue list from actual requirements. For each issue include stable `PS-ID` (for example `PS-001`), title, scoped deliverable, primary role `backend|frontend|database|qa|devops`, testable acceptance criteria, dependency PS-IDs, priority, risk and verification.
3. Where requirements include APIs or browser UI, include traceable proposed QA scope for API method/path, frontend routes and mandatory cross-layer user journeys. Record test dependencies and required E2E Gate outcomes in the appropriate Milestones/Waves; do not invent endpoints or assume tests exist. The executable E2E plan is prepared after selecting a Wave with `/ps-e2e-plan W1 --target both`.
4. Review existing open/closed Issues and Milestones in the resolved target when it exists. Identify likely duplicates; map reusable existing Issues, but never assume exact duplicates without verifying their content.
4. Draft the master issue plan and expose uncertain facts separately from confirmed repository facts. No GitHub issue numbers for unpublished items.

## Phase 2 — Milestone & Wave planning (READ-ONLY)

1. Delegate milestone and dependency-aware wave design to `wave-planner`; validate with `plan-validator` (Opus).
2. Produce milestones based on verifiable deliverables, **not calendar guesses**. Each has identifier (M1, M2...), name, objective, exit criteria and issue PS-IDs. Due dates only if provided.
3. For each milestone create numbered Waves W1, W2... with a dependency-respecting topological order; state roles, issue PS-IDs, inputs, exit gates and safe parallelism. All rows must belong to exactly one milestone and have one primary role.
4. Validate no missing/duplicate tasks, conflicting roles, circular dependencies, unapproved architecture decisions or broken milestone/wave grouping. Treat unresolved high-risk assumptions as `BLOCKED`, not as a reason to publish.
5. When a shared Issue spans roles, plan separate queue rows and explicit handoffs; create subissues only if explicitly included in the reviewed publishing manifest.

## Phase 3 — AUTO-GATE (REQUIRES HUMAN APPROVAL)

1. Present a single reviewable publication manifest using `templates/FULL-FLOW-PUBLISH-MANIFEST.md` with:
   - exact `OWNER/REPO`, whether REUSE or CREATE PRIVATE REPO, and URL when known;
   - existing items reused; milestone names/description; NEW issue PS-ID/title/body/acceptance criteria; labels or assignments if and only if explicitly proposed;
   - issue→milestone map; wave→issue map; exact expected created counts; dependencies and blocked assumptions;
   - local output files to write after approval (`docs/ps-flow/IMPLEMENTATION-QUEUE.md` and `docs/ps-flow/IMPLEMENTATION-QUEUE.json`);
   - note that **source code will NOT be pushed** by this flow.
2. Run `plan-validator` on the *final manifest*. STOP as `BLOCKED` if invalid.
3. **Ask the user to explicitly approve or reject this exact GitHub-write manifest and queue-file creation.** Allow approval in the same conversation (the orchestrator resumes after approval); do not require another skill invocation. Any material change to target, issue bodies, milestone assignment, or count requires a fresh approval.
4. If the user rejects, report `NOT PUBLISHED` and STOP. If the user requests revisions, change the proposal read-only, revalidate, and ask again. Never treat `--yes`, user silence, or general intent as permission to create Issues/Milestones.

## Phase 4 — GitHub publishing (ONLY AFTER APPROVAL)

Preconditions: user approved exact manifest, GitHub authenticated, target resolved, permissions verified, no unresolved blocking assumptions.

1. Rerun target and duplicate checks immediately before writing. If new conflicts or duplicate matches appear, STOP and show a revised manifest for approval. Do not blindly retry.
2. If creation of `<login>/<folder>` is approved and repo absent, create a **private** repo using `gh repo create OWNER/REPO --private` (no `--push` or `--source` flag). Confirm its real URL. Do not create a public repo by default or alter existing Git remotes.
3. Create/reuse GitHub Milestones for the **approved** titles/descriptions using the authenticated GitHub API via `gh api`. Resolve actual milestone numbers and verify them; avoid duplicate titles. Do not create issue/milestone due dates unless approved.
4. Create/reuse approved Issues with `gh issue create --repo OWNER/REPO --title ... --body-file ...` (and `--milestone` when a verified approved milestone applies). Include a stable non-sensitive `<!-- ps-plan-id: PS-001 -->` marker in each approved issue body to make retry detection possible. Avoid command-injection; quote inputs safely, and use approved body files. Do not create labels silently.
5. Resolve real GitHub Issue numbers/URLs and verify each using `gh issue view`. Use verified mapping to annotate dependencies in the local queue; do not claim native GitHub blocking links were created unless they actually were and separately approved.
6. If issue→milestone assignment requires editing *existing* Issues, do so **only when the manifest separately lists that exact mutation**; otherwise flag for approval. Do not silently modify existing Issues.
7. On partial failure, STOP immediately, enumerate successful GitHub changes and pending PS-IDs, and provide safe recovery guidance. Never automatically recreate the same batch, overwrite, close or delete Issues, or continue to the next phase while identifiers are unresolved.

## Phase 5 — Implementation Queue (AFTER VERIFIED PUBLISH)

1. Delegate issue-to-role scheduling to `issue-table-planner`. Create queue from **actual verified** GitHub issue IDs/URLs, milestone numbers, approved W IDs, dependency PS-ID→issue mappings and the five roles.
2. For each row include: Seq, Milestone, Wave, Issue number & URL, role, scope/deliverable, dependencies (verified IDs), priority, acceptance criteria summary, owner if known, state and `ps-implement` command. No fabricated issue numbers or owners.
3. Order by dependencies. Use `READY` only when prerequisites are truly satisfied; otherwise `BLOCKED` or `NOT STARTED`. Newly created Issues are **NOT STARTED** by default, even when unblocked; distinguish `Ready to schedule` from `Done`.
4. After approval of local artifact creation in Phase 3, write:
   - `docs/ps-flow/IMPLEMENTATION-QUEUE.md` (use `templates/IMPLEMENTATION-QUEUE.md`)
   - `docs/ps-flow/IMPLEMENTATION-QUEUE.json` (machine-readable array with target, verified issue ids/URLs, milestone, wave, role, `depends_on`, priority, status and last verification timestamp)
   Do not overwrite preexisting queue files if the content has changed without an explicit reviewed diff/approval.
5. Queue examples: `/ps-implement-wave W1 --role database` and `/ps-implement-issue 123 --role backend`. These are **next-step commands only**, not automatically executed.
6. Inspect written files, ensure parseable JSON and all linked IDs are real GitHub issue references, report exact file paths and GitHub URLs.

## Phase 6 — Report and STOP

Return `PASS`, `PARTIAL`, `FAIL` or `BLOCKED`. Show resolved repository, milestone/issue counts created vs reused, plan-ID→actual-ID mapping, number of waves, implementation queue location, blocked dependencies, next recommended Wave/Role command, and unresolved risks. **STOP**. No automatic coding, issue closure, source push, commits, deployment, new batch, or production activity.

## Safety and reliability

- No unattended external writes, no bypass of the approval gate, and no synthetic results.
- Do not leak secrets or publish private documentation in Issue bodies. Redact risky context from approval preview; if content is sensitive, ask before publication.
- Respect git status and project instructions. Existing agent permissions and per-issue implementation gates still apply to later commands.
- If a full project exceeds context, API access, or execution limits, report `PARTIAL/BLOCKED`, summarize durable verified progress, and stop. Never claim an entire backlog published unless verified.
