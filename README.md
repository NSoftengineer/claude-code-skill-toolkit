# Claude Code Full-Flow Toolkit v8 — Installation and User Guide (Windows)

> A guide to the user-level `ps-*` Toolkit, which can be installed once and reused across multiple repositories. It covers milestones/waves, GitHub Issues, role-based coding, E2E testing, and reporting. **Installing the Toolkit does not install third-party tools.**



## NEW in v8.1 — Backend router scan & API scenario planning (one command)

For a complete **repository-level backend API route inventory** followed by evidence-based scenario planning, open Claude Code at the root of the target project and run:

```text
/ps-e2e-plan --role backend
```

This deliberately **does not require a Wave or GitHub Issue**. It instructs the `e2e-test-planner` subagent to discover the repository's router registration entry points, follow nested router prefixes, list registered HTTP method + effective URL paths, cross-check controllers/OpenAPI/existing tests, and propose API test scenarios per endpoint. It performs **planning only**; tests are not written, executed or marked PASS. Some dynamically registered endpoints may require manual confirmation.

For an explicit full scan and a Wave mapping:

```text
/ps-e2e-plan W1 --role backend --target api --scope all-routes
```

For a known router file or directory:

```text
/ps-e2e-plan --role backend --router-file src/routes/api.ts
/ps-e2e-plan --role backend --router-dir src/routes --scope all-routes
```

Replace the sample router paths with paths that exist in your repository. Use `-role backend` only as an alias; `--role backend` is recommended. Other examples:

```text
/ps-e2e-plan W1 --role backend --target api            # Wave-focused
/ps-e2e-plan W1 --target both                         # API + UI journeys
```

**Workflow:** inspect `CLAUDE.md` → locate router entry points → recursively resolve `METHOD + effective path` → verify source/spec evidence → identify auth and inputs/outputs → produce positive, negative, validation, security and contract scenarios → report route/scenario coverage and gaps → **STOP for human approval**. Repository-wide inventory can still run without `gh` login, but mapping rows to GitHub Issue acceptance criteria requires real Issue data.

**Sample output files after approval:** `docs/ps-flow/e2e/REPOSITORY/API-ROUTE-INVENTORY.md`, `API-E2E-TEST-PLAN.md`, and `E2E-PATH-COVERAGE-MATRIX.md`. The plan separates `EXISTING` tests from `PROPOSED` scenarios and `BLOCKED` cases. Only `/ps-e2e-test` with an approved test scope and safe environment is intended to run actual Playwright API tests. See [`templates/API-ROUTE-INVENTORY.md`](templates/API-ROUTE-INVENTORY.md) for the inventory schema and [`templates/API-E2E-TEST-PLAN.md`](templates/API-E2E-TEST-PLAN.md) for scenario fields.

## NEW in v8 — E2E planning for both API paths and frontend routes

**One E2E plan can cover both surfaces** in a Milestone/Wave: (1) backend HTTP API endpoints, (2) frontend URL routes and browser UI, and (3) cross-layer journeys linking frontend interactions to real API responses and observable application state. Playwright supports API testing using its `request` fixture / `APIRequestContext`, and browser testing using `page` fixtures. These are **proposed coverage plans**, not automatic test results.

### Quick commands (inside Claude Code)

```text
/ps-e2e-plan W1 --target both
/ps-e2e-test W1 --target both --env staging
/ps-e2e-report W1
/ps-e2e-verify W1
/ps-e2e-gate W1
```

Use `--target api` for API-only coverage, `--target frontend` for browser-only coverage, or `--target both` (default) for API + frontend + integrated user journeys. These options are **skill instructions interpreted by Claude**, not shell flags to run in PowerShell. Run only approved test IDs against local/staging. Never invent actual endpoint paths from an example.

### What is mapped into the test plan?

| Coverage group | Discovery sources | What test rows include | Typical assertions |
|---|---|---|---|
| API Paths | OpenAPI/Swagger, backend routes/controllers, existing API tests | HTTP method + endpoint pattern, parameters, auth/roles, expected response, issue/criterion, test source | Status, response schema, validation errors, auth/authorization, error contracts |
| Frontend Routes | Frontend router and page/component files, frontend acceptance criteria | Route path, page, UI actions/states, browser/viewport, linked API calls, issue/criterion | Navigation, forms, loading/errors, permissions, UI changes |
| Cross-layer flows | Mapped user journeys + API client calls | Starting route, user action, HTTP method + API path, state/response, resulting UI | Browser action → request → response/data/state → visible outcome |

**Important:** A green API-only suite does not prove the frontend works. Green but independent API and UI suites do not prove the end-to-end integration journey. Mandatory cross-layer acceptance criteria require their own executed evidence.

### Planning outputs (written only after approval)

```text
project/
  docs/ps-flow/e2e/W1/
    API-E2E-TEST-PLAN.md
    FRONTEND-E2E-TEST-PLAN.md
    E2E-PATH-COVERAGE-MATRIX.md
  reports/W1/runs/<UTC-run-id>/
    ... actual Playwright JSON/JUnit/HTML evidence when tests execute ...
  reports/W1/E2E-TEST-REPORT.md
```

The Toolkit provides `templates/E2E-TEST-PLAN.md`, `templates/API-E2E-TEST-PLAN.md`, `templates/FRONTEND-E2E-TEST-PLAN.md`, `templates/E2E-PATH-COVERAGE-MATRIX.md`, and `templates/E2E-TEST-REPORT.md`. These are templates only. Installing the global Toolkit does **not** add Playwright packages, browser binaries, or tests to a project. Configure/install Playwright separately per repository and obtain authorization before running against non-production APIs that modify data.

### Example planning rows (ILLUSTRATIVE ONLY — NOT discovered from your repo)

| Test ID | Issue | Target | Method / API path | Frontend route | Scope |
|---|---|---|---|---|---|
| API-W1-001 | #EXAMPLE | API | `POST /api/auth/login` | — | 200/401 contract, invalid input, authorization |
| FE-W1-001 | #EXAMPLE | FRONTEND | — | `/login` | Form errors, login UI, browser navigation |
| FLOW-W1-001 | #EXAMPLE | INTEGRATION | `POST /api/auth/login` | `/login` → `/dashboard` | UI action issues request and leads to authenticated page |

A Wave's E2E Gate reports API, Frontend and Integration verdicts separately. It **blocks** if any mandatory surface lacks executed passing evidence. A target can be marked NOT APPLICABLE only with documented architectural/Issue support. This does not change the existing human approval gate or the STOP-after-Wave policy.

See: [Playwright API testing](https://playwright.dev/docs/api-testing), [Playwright Test projects](https://playwright.dev/docs/test-projects), and [Playwright reporters](https://playwright.dev/docs/test-reporters).

---

## NEW in v7 (retained in v8) — One-command `/ps-full-flow` (Discovery → GitHub → Queue)

**Yes: use a single command for the entire planning and GitHub publishing sequence.** This does **not** automatically write application code. It produces an approved and verified GitHub Milestone/Issue backlog and local implementation queue, so your team can then implement Waves by role.

```text
/ps-full-flow
```

You can specify a particular repository and objective:

```text
/ps-full-flow --repo OWNER/REPO Design the billing feature backlog and rollout waves
```

### How the default OWNER/REPO is selected

When you omit `--repo`, the Skill uses the account returned by `gh api user --jq .login` as `OWNER` and the **current project root folder name** as `REPO` (`git rev-parse --show-toplevel` when in a Git repository; otherwise the working folder). Thus a logged-in user `alice` running Claude Code inside `C:\Work\billing-api` proposes `alice/billing-api`. This is a proposal only until the repository is verified.

It checks any existing Git remote. If the remote points to a different repository, it **stops for a target decision** instead of writing to the wrong destination. If the target repository does not exist, the reviewed publication manifest can include creating a **private** repository. The Skill never silently creates a public repository and does not push application source code.

### End-to-end workflow

```text
/ps-full-flow
    |
    +--> 1. Discover actual repository and requirements [READ-ONLY]
    |
    +--> 2. Plan Epics and atomic GitHub Issues [READ-ONLY]
    |
    +--> 3. Plan Milestones + dependency-aware Waves [READ-ONLY]
    |
    +--> 4. Automatic plan validation [READ-ONLY]
    |
    +--> 5. AUTO APPROVAL GATE  <-- pauses for EXPLICIT HUMAN APPROVAL
    |
    +--> 6. Publish approved private repo (if needed), Milestones, Issues
    |        Check duplicates and verify GitHub numbers/URLs
    |
    +--> 7. Build implementation queue from VERIFIED GitHub Issues
    |        docs/ps-flow/IMPLEMENTATION-QUEUE.md
    |        docs/ps-flow/IMPLEMENTATION-QUEUE.json
    |
    +--> 8. Verify -> Report -> STOP (NO automatic code changes)
```

The **gate is triggered automatically**, but **approval is never automatic**. Claude Code displays the proposed target repository, exact Milestone/Issue operations and queue file changes, and requests your explicit approval **once for that exact manifest**. After approval, the orchestrator continues without requiring you to type `/ps-create-milestones`, `/ps-create-issues`, or `/ps-implementation-table` separately. Significant changes to an approved manifest require renewed approval. If GitHub publishing partially fails, the workflow stops with a verified progress report rather than retrying blindly.

### Output files and commands

The local queue lives in the **application project**, not in the global Toolkit folder:

- `docs/ps-flow/IMPLEMENTATION-QUEUE.md` — human-readable ordered table (Milestone, Wave, Issue, Role, Dependencies, Priority, Status, next command).
- `docs/ps-flow/IMPLEMENTATION-QUEUE.json` — machine-readable issue-to-wave/role mapping.

The Toolkit contains example source templates under `templates/FULL-FLOW-PUBLISH-MANIFEST.md` and `templates/IMPLEMENTATION-QUEUE.md`. The GitHub Issues referenced in the queue must be **verified**, not fabricated.

After reviewing the resulting queue, choose a Wave and Role:

```text
/ps-implement-wave W1 --role database
/ps-implement-wave W1 --role backend
/ps-implement-wave W2 --role frontend
/ps-e2e-gate W2
```

**Important:** These commands are examples, not automatic post-publication steps. Roles are `backend`, `frontend`, `database`, `qa`, `devops`. Implementation has its own per-wave and per-issue approval and quality gates.

### Preconditions and limitations

- Claude Code, Git and authenticated GitHub CLI (`gh auth login` / `gh auth status`). The account must have permission to create Issues, Milestones, and (if necessary) a repository.
- A real product goal/specification must be provided or exist in the project. The orchestrator will not invent requirements when essential details are missing.
- GitHub publishing means GitHub **Milestones and Issues**. It does not mean pushing source code, committing, deploying, enabling Actions or closing Issues.
- The workflow is an **AI-orchestrated Skill**, not a deterministic executable pipeline. An approval prompt requires an additional user reply; execution might stop with `BLOCKED` if requirements, permissions or external services are unavailable.
- External Skills (Superpowers, Matt Pocock `/tdd`, gstack, Impeccable, Playwright) are *not* required to create the planning queue, and are still separately installed.

**Reference:** [Claude Code Skills](https://code.claude.com/docs/en/skills) · [GitHub CLI repo creation](https://cli.github.com/manual/gh_repo_create) · [GitHub CLI current repository](https://cli.github.com/manual/gh_repo_view)

---

## GitHub distribution — Publish / Install / Update / Uninstall

> **Goal:** Publish the entire Toolkit to GitHub **once**, so users can clone it and install global Skills/Subagents for use across projects under their Windows user account. **All commands in this section run in Windows PowerShell**, unless explicitly identified as Claude Code commands. The safer approach is **Clone → Review files → Run installer**, rather than executing unreviewed shell scripts directly from the internet.

### Repository layout to publish on GitHub

```text
claude-code-full-flow-toolkit/
├── README.md
├── install.ps1
├── uninstall.ps1
├── THIRD-PARTY-INTEGRATIONS.md
├── PHASE-3-IMPLEMENTATION-PLAN.md
├── agents/                       # Claude Code global subagents (.md)
├── skills/                       # ps-* skills (each contains a SKILL.md)
└── templates/                    # Markdown planning/reporting templates
```

After extracting the ZIP, make sure you are working **directly inside** the folder containing `install.ps1`, `uninstall.ps1`, `agents/`, and `skills/` before running the commands. Do not publish `.env` files, API keys, credentials, personal `.claude/settings.json` files, test artifacts containing real data, or private files to the repository. Start with a **private repository** until you have completed a thorough review of its code and documentation.

### A. For Toolkit maintainers — Publish to GitHub (first time)

**Prerequisites:** Git, GitHub CLI (`gh`), and a GitHub account with repository creation permissions. Replace `OWNER` with your GitHub username or organization. You may choose another repository name if desired.

1. Extract the ZIP and open PowerShell **inside the Toolkit folder** containing `README.md` and `install.ps1` (not its parent folder).
2. Check installed versions and sign in to GitHub:

   ```powershell
   git --version
   gh --version
   gh auth login
   gh auth status
   ```

3. Review the contents and files to be published before committing, especially secrets, test reports, and internal company information:

   ```powershell
   Get-ChildItem -Name
   git status --short     # If this is not yet a Git repository, Git will report "not a git repository"
   ```

4. **Only if this folder is not already a Git repository**, initialize Git, stage **only the Toolkit files**, and commit:

   ```powershell
   git init -b main
   git config user.name
   git config user.email
   # If your Git name/email are not configured, set them with git config user.name "YOUR_NAME"
   # and git config user.email "YOU@EXAMPLE.COM" (for this repository only)
   git add README.md install.ps1 uninstall.ps1 THIRD-PARTY-INTEGRATIONS.md PHASE-3-IMPLEMENTATION-PLAN.md agents skills templates
   git diff --cached --stat
   git diff --cached --check
   git commit -m "Publish PS Full-Flow Toolkit v8"
   ```

   **Review staged files before committing.** Avoid `git add -A` in folders that might contain personal data. If the folder is already a Git repository, inspect its branch, remote, and changes first; do not reinitialize Git or overwrite an existing remote unintentionally.

5. Create the repository and push to GitHub **only after confirming its name and permissions**:

   ```powershell
   gh repo create OWNER/claude-code-full-flow-toolkit --private --source=. --remote=origin --push
   gh repo view OWNER/claude-code-full-flow-toolkit --web
   ```

   `--private` restricts repository access to authorized users. Switch to `--public` only after confirming the contents are ready for public release. Use `gh repo create` **only to create a new repository**, not for an existing one.

**Alternative if you already created an empty repository on the GitHub website:** Do not run `gh repo create`. Instead, configure the remote and push from your committed local repository (only if an `origin` remote does not already exist):

```powershell
git remote -v
git remote add origin https://github.com/OWNER/claude-code-full-flow-toolkit.git
git push -u origin main
```

Ideally, create the GitHub repository without selecting a README, License, or `.gitignore` template. If the remote repository already has commits, review and reconcile its history before pushing. **Do not use `--force` to bypass conflicts.**

### B. For users — Install from GitHub on a new Windows machine

**Prerequisites:** Claude Code and Git are installed. Cloning a private repository requires GitHub authentication and access permissions. GitHub CLI (`gh`) is not required when cloning a public repository with Git.

1. Open PowerShell in a folder where you want to keep the Toolkit source (for example, `Documents`):

   ```powershell
   Set-Location (Join-Path $HOME 'Documents')
   git clone https://github.com/OWNER/claude-code-full-flow-toolkit.git
   Set-Location .\claude-code-full-flow-toolkit
   ```

   Alternatively, run `gh repo clone OWNER/claude-code-full-flow-toolkit` instead of `git clone` if you have already authenticated GitHub CLI. **Cloning alone does not install the Skills.**

2. Inspect the cloned source before running any script:

   ```powershell
   Get-Content .\install.ps1
   Get-Content .\uninstall.ps1
   Get-ChildItem .\agents
   Get-ChildItem .\skills
   ```

3. Install global Skills/Subagents:

   ```powershell
   Set-ExecutionPolicy -Scope Process Bypass
   .\install.ps1
   ```

   Files are installed into `%USERPROFILE%\.claude\agents\` and `%USERPROFILE%\.claude\skills\`, without changing your project repository files. Existing files with the same names are **SKIPPED** by default. To replace them, back up the existing versions first:

   ```powershell
   .\install.ps1 -Force
   ```

   With `-Force`, files being replaced are backed up to `~/.claude/full-flow-v7-backups/<timestamp>/` before overwrite. This does **not** automatically install Superpowers, Matt Pocock Skills, gstack, Impeccable, Playwright, or other external software. See the Installation Matrix and Step 3 below.

4. Restart Claude Code **from any project repository**:

   ```powershell
   claude
   ```

   Inside Claude Code, type `/` and look for `/ps-full-flow`, `/ps-plan-project`, `/ps-plan-waves`, `/ps-implement-wave`, and `/ps-e2e-plan` to confirm Skill discovery. Use `/ps-check-integrations all` to check any external integrations you chose to install.

### C. Update the Toolkit when a new version is published on GitHub

Open **PowerShell in the cloned Toolkit source folder (not your application project)** and check for local modifications before updating:

```powershell
Set-Location (Join-Path $HOME 'Documents\claude-code-full-flow-toolkit')
git status --short
git pull --ff-only
Set-ExecutionPolicy -Scope Process Bypass
.\install.ps1 -Force
```

`git pull --ff-only` stops if branch histories have diverged and may stop if local edits conflict; investigate and resolve those issues first. **Do not discard changes with `git reset --hard`.** The `-Force` option backs up and replaces installed files with matching names. If the new release **renames or removes a Skill**, the old version may remain installed. Review `~/.claude/skills` and the release migration notes before deleting anything.

After updating, restart Claude Code and check the slash commands again. **Running `git pull` alone does not update previously installed global Skills.**

### D. Uninstall a Toolkit installed from GitHub

1. Open PowerShell in the **cloned source folder** and inspect the uninstall script:

   ```powershell
   Set-Location (Join-Path $HOME 'Documents\claude-code-full-flow-toolkit')
   Get-Content .\uninstall.ps1
   Set-ExecutionPolicy -Scope Process Bypass
   .\uninstall.ps1
   ```

2. Before deleting a global Agent/Skill file, `uninstall.ps1` compares its **SHA-256** checksum against the corresponding file in the source folder. As a result:
   - Only files whose checksums match are deleted, protecting files you have customized.
   - If you see `SKIP modified file`, that file is **not deleted**. Inspect it and manage it manually if needed.
   - If an older version was installed but the source folder has since been updated, changed hashes may cause older installed files to remain. Use the source from the previously installed version or review the affected files individually.
   - The script does **not** delete backups, third-party plugins, GitHub repositories/issues, application project files, or the cloned source folder. Empty directories may remain under `~/.claude/`.

3. Restart Claude Code and confirm the uninstalled `/ps-*` commands no longer appear. If they still do, inspect skipped files, project-level Skill installations, or an older cached session.
4. **Optional:** Once you have checked for local changes or important files, you may manually delete the cloned Toolkit source folder. **Deleting the source folder alone is not an uninstall**, because global Skills/Subagents remain installed.

> Uninstalling the Toolkit does **not** uninstall `superpowers`, `mattpocock-skills`, `gstack`, `Impeccable`, `Playwright Test`, `Playwright MCP`, or security plugins. Uninstall these separately using their own documentation, and review project-level dependencies before removing them.

### E. Command Cheat Sheet

| Goal | Run in | Command |
|---|---|---|
| Publish repository (first time) | PowerShell, Toolkit root | `gh repo create OWNER/claude-code-full-flow-toolkit --private --source=. --remote=origin --push` |
| Clone Repo | PowerShell | `git clone https://github.com/OWNER/claude-code-full-flow-toolkit.git` |
| First installation | PowerShell, Toolkit root | `.\install.ps1` |
| Upgrade / Replace (with backup) | PowerShell, Root Toolkit | `.\install.ps1 -Force` |
| Get latest code | PowerShell, Root Toolkit | `git pull --ff-only` |
| Uninstall Toolkit | PowerShell, Root Toolkit | `.\uninstall.ps1` |
| Verify Skills | Inside Claude Code | Type `/` and search for `/ps-full-flow` |
| One-command project to queue | Inside Claude Code, in app repo | `/ps-full-flow` |

**Official references:** [GitHub CLI — gh repo create](https://cli.github.com/manual/gh_repo_create) · [GitHub Docs — Add locally hosted code](https://docs.github.com/en/migrations/importing-source-code/using-the-command-line-to-import-source-code/adding-locally-hosted-code-to-github) · [GitHub Docs — Clone a repository](https://docs.github.com/en/repositories/creating-and-managing-repositories/cloning-a-repository) · [Claude Code — Skills](https://code.claude.com/docs/en/skills) · [Claude Code — Subagents](https://code.claude.com/docs/en/sub-agents)

---

## Where to start: Installation Matrix

| Skill set / Tool | What we use it for | Included in Toolkit ZIP? | Install separately? | Per-project setup? |
|---|---|---|---|---|
| **PS Full-Flow Toolkit** | `/ps-full-flow`, `/ps-plan-project`, `/ps-plan-waves`, `/ps-implement-wave`, E2E reporting, and all 16 workflow Skills | **Yes** | Run `install.ps1` once | Read the project rules and issue scope for each project |
| **Claude Code** | AI coding CLI that invokes Skills/Subagents | **No** | **Required** | Open it in each repository |
| **Git** | Inspect diffs, branches and checkouts; needed for the gstack installer | **No** | **Required** | The project must be a Git repository |
| **GitHub CLI (`gh`)** | Read and create GitHub Issues and Milestones | **No** | **Required for GitHub workflows** | Verify the target repository and GitHub permissions |
| **superpowers** | Planning, systematic debugging, and implementation discipline | **No** | **Install separately (recommended)** | Enable or invoke according to the task |
| **mattpocock-skills** | `/tdd` to write tests before code (Red → Green → Refactor) | **No** | **Install separately (recommended)** | **Run `/setup-matt-pocock-skills` in each repository** |
| **gstack** | `/browse` for visual browser inspection and `/qa` for browser QA | **No** | **Install separately for browser QA** | Set URLs and credentials per environment |
| **Impeccable** | `/impeccable shape`, `audit`, `critique`, and `polish` for frontend work | **No** | **Install separately for frontend work** | Run `/impeccable init` when project-context changes are approved |
| **Playwright Test** | Repeatable E2E tests with HTML/JSON/JUnit reports | **No** | **Install the dependency and browsers in the repository** | **Requires config, scripts, test accounts, and a test environment** |
| **Playwright MCP** | Interactive browser exploration/debugging only | **No** | Optional installation | Configure MCP and permissions separately |
| **Security plugins** | Optional scanning/advice beyond the bundled Agent review | **No** | Optional installation | Confirm the commands exist before use |

**Important:** All 16 `ps-*` Skills and Toolkit Subagents are available after installation, but external integrations such as `/tdd`, `/browse`, `/impeccable`, and `superpowers` are **not** downloaded or enabled automatically. `ps-e2e-test` does not install packages or browsers.

## Step 0 — Check prerequisites on Windows

Open **PowerShell** (administrator privileges are not required) and check:

```powershell
claude --version
git --version
gh --version
node --version
npm --version
```

If you want **gstack**, also check `bun --version` and `node --version` (Node.js is required on Windows). Install missing tools from their official upstream sources and check your `PATH` before continuing. The `/plugin` commands below must be entered **inside Claude Code**, not PowerShell.

## Step 1 — Install the PS Full-Flow Toolkit (once per Windows user)

Extract the ZIP **or clone from GitHub (see GitHub distribution above)**, then open PowerShell in the folder containing `install.ps1`:

```powershell
Set-ExecutionPolicy -Scope Process Bypass
.\install.ps1
```

To back up existing files and overwrite matching Toolkit files:

```powershell
.\install.ps1 -Force
```

Files are installed into `%USERPROFILE%\.claude\agents\` and `%USERPROFILE%\.claude\skills\`. **Restart Claude Code**, type `/`, and look for `/ps-plan-project` and `/ps-e2e-plan`. **Do not use `-Force` without reviewing your customizations first.** This installer does not install external software or sign you into GitHub.

## Step 2 — Configure GitHub (required for Issues/Milestones)

```powershell
gh auth login
gh auth status
gh repo view OWNER/REPO
```

Confirm you are targeting the correct repository and have sufficient permissions before using `/ps-create-issues` or `/ps-create-milestones`, since these write real data to GitHub. The Toolkit must display the proposed changes and obtain separate user approval.

## Step 3 — Install external Skill sets (separately from the Toolkit)

### A. Superpowers — Recommended for planning & debugging

**Where:** Launch `claude` and enter the following line:

```text
/plugin install superpowers@claude-plugins-official
```

Verify installation from Claude Code’s `/plugin` menu. If the package/channel changes, use its current Marketplace listing. Do not assume it is callable until it appears in your installation.

### B. Matt Pocock Skills — Recommended `/tdd`

**Where:** Inside Claude Code, enter each line separately:

```text
/plugin marketplace add mattpocock/skills
/plugin install mattpocock-skills@mattpocock
```

**Per repository:** Open Claude Code in each repository where you want to use this and run:

```text
/setup-matt-pocock-skills
```

Answer the setup questions according to the project’s issue tracker, labels, and documentation destination. Type `/tdd` to verify availability. Installing the plugin globally does not mean per-repository setup has been completed. See: https://github.com/mattpocock/skills

### C. gstack — Optional `/browse` and Browser QA

**Prerequisites:** Git, **Bun v1+**, and **Node.js on Windows**. Use **Git Bash or WSL** for `./setup`, not PowerShell directly. Review the upstream README before running the setup script, as it downloads/builds binaries and browser components.

```bash
git clone --single-branch --depth 1 https://github.com/garrytan/gstack.git ~/.claude/skills/gstack
cd ~/.claude/skills/gstack
./setup
```

If `~/.claude/skills/gstack` already exists, **do not clone over it**; follow the upstream update instructions instead. gstack provides `/qa` and `/browse`. Do not run `/ship`, deployment commands, or production-changing commands from this workflow without approval. The upstream README describes Windows 11 support through Git Bash/WSL. See: https://github.com/garrytan/gstack

### D. Impeccable — Optional Frontend UX/UI

**Where:** PowerShell; make sure Node/npm/npx are available first:

```powershell
npx impeccable install --providers=claude --scope=global
```

Inspect the upstream installer and permissions before accepting prompts, then restart Claude Code and check for `/impeccable` in the command list. If starting a new project and the creation of context files has been approved, run:

```text
/impeccable init
```

Choose **one installation method** to avoid duplicate Skills. For a frontend Wave, use `shape` during UI planning, `audit`/`critique` during review, and `polish` only for approved code changes. See: https://github.com/pbakaus/impeccable

### E. Playwright Test — Necessary for reproducible E2E runs

**Where:** PowerShell in **the repository you will test**. Use the repository’s existing package manager and inspect `package.json` first; for an npm repository without Playwright Test:

```powershell
npm init playwright@latest
```

This command may create/change project files and install dependencies, so obtain the repository owner’s approval first. If Playwright is already configured, use the existing scripts/config rather than reinitializing it. Verify the web app/backend is running in an approved local/staging environment and safe test accounts are available:

```powershell
npx playwright test
npx playwright test --reporter=html
npx playwright show-report
```

Install missing browser binaries when prompted by Playwright, for example with `npx playwright install`. The Toolkit must not automatically install packages/browsers or run E2E tests against production without confirming the environment. HTML/JSON/JUnit are **Playwright Test reporters**; `gstack /browse` and Playwright MCP do not replace a reproducible test runner. Docs: https://playwright.dev/docs/intro and https://playwright.dev/docs/test-reporters

### F. Optional: Security review tooling

The Toolkit already bundles a read-only `security-reviewer` Subagent, so **no additional plugin is required** for `/ps-review-code`. For more scanners/plugins, verify availability through Claude Code’s `/plugin` menu and current upstream documentation. Names, availability, and install methods may change. Do not assume `/security-review` or `/claude-security` exists without checking, and do not treat a security PASS as proof of complete safety.

## Step 4 — Health checks after installation

Restart Claude Code, then open each repository:

```text
/ps-check-integrations all
```

Type `/` to confirm the commands you actually installed appear, such as `/ps-plan-waves`, `/ps-implement-wave`, `/ps-e2e-test`, `/tdd`, `/browse`, or `/impeccable`. Listing a slash command does not prove its tests or browser integration will run successfully; perform an authorized verification. If a required dependency is missing, report `BLOCKED` with the missing install steps rather than guessing that it passed.

## Step 5 — Full Workflow end-to-end

| Phase | Commands | Expected artifact/decision |
|---|---|---|
| Discovery & Planning | `/ps-plan-project` | Master Plan, assumptions, issue proposals |
| Milestone & Wave Planning | `/ps-plan-waves OWNER/REPO` | milestone/wave table, dependencies, role ownership |
| **Approval Gate** | User reviews exact issue + milestone manifest | STOP until explicit approval |
| GitHub Publishing | `/ps-create-issues`, `/ps-create-milestones OWNER/REPO` | Actual URLs/IDs, verified; STOP |
| Implementation queue | `/ps-implementation-table OWNER/REPO` | Dependency-ordered Issue table; approval |
| Implementation | `/ps-implement-wave W1 --role frontend` or `/ps-implement-issue 123 --role backend` | Role-scoped diffs and evidence |
| Verification | `/ps-verify-issue 123`, `/ps-review-code` | Actual code/tests findings |
| E2E | `/ps-e2e-plan W1 --target both`, `/ps-e2e-test W1 --target both --env staging`, `/ps-e2e-report W1`, `/ps-e2e-verify W1` | Test evidence, report and defects |
| Quality Gate | `/ps-e2e-gate W1` | PASS / FAIL / BLOCKED; STOP |

**Wave vs Milestone:** A Milestone is a GitHub delivery target; a Wave is a dependency-ordered batch of implementation tasks. **Allowed roles:** `backend`, `frontend`, `database`, `qa`, and `devops`. No command should automatically close issues, merge, push, deploy, or start the next Wave.

Example commands (Issue numbers below are hypothetical):

```text
/ps-plan-project
/ps-plan-waves OWNER/REPO
/ps-implementation-table OWNER/REPO
# Approved: Wave W1, frontend scope only
/ps-implement-wave W1 --role frontend
/ps-e2e-plan W1 --target both
/ps-e2e-test W1 --target both --env staging
/ps-e2e-report W1
/ps-e2e-verify W1
/ps-e2e-gate W1
```

## Troubleshooting

| Symptom | What to check |
|---|---|
| `ps-*` missing | Confirm extracted ZIP, `install.ps1` success, `~/.claude/skills` and restart Claude Code |
| `/tdd` missing | Verify Matt Pocock plugin + `/setup-matt-pocock-skills` for this repository |
| `/browse` missing | Verify Bun/Node/Git and gstack `./setup` in Git Bash/WSL; restart |
| `/impeccable` missing | Check install scope/provider, duplicates, then restart Claude Code |
| `gh` unauthorized | `gh auth status`, `gh repo view OWNER/REPO`, permission scope |
| E2E `BLOCKED` | Playwright dependency/browser, config, test data, authorized staging URL, running server |
| Reports empty | Confirm actual executed run/artifact directory and reporter; never fabricate PASS |
| Plugin command fails | Re-check current upstream commands in `/plugin` and official project README |

## Security & maintenance

- Review external plugin permissions, hooks, `npx` installers, and shell scripts before allowing execution. **No third-party installation is automatic**.
- Maintain per-repo `CLAUDE.md` for architecture/roles, environment rules and deployment controls.
- Never store real passwords, API keys, payment details or session cookies in committed E2E reports/screenshots/traces.
- A PASS requires actual execution evidence; BLOCKED/PARTIAL are acceptable and preferable to invented results.
- Use `uninstall.ps1` to remove Toolkit-owned files; plugin uninstall/update follows each upstream tool separately.

---

## Full v6 workflow/reference material (retained from prior version)

# Claude Code Full-Flow Toolkit v8 — PS Waves + Impeccable + E2E Testing

Reusable **global Claude Code Subagents and Skills**, designed for a two-stage GitHub Issues workflow with human approval gates and mandatory role-based implementation.

Documentation references: [Create custom subagents](https://code.claude.com/docs/en/sub-agents), [Skills](https://code.claude.com/docs/en/skills), [GitHub CLI](https://cli.github.com/manual/gh_issue_create).

## Install once; use in multiple projects

**Requirements:** Claude Code, Windows PowerShell 5.1+ or PowerShell 7, Git, and an authenticated GitHub CLI (`gh`) to read or create real GitHub Issues. Each repository needs its own applicable GitHub permissions.

1. Extract the toolkit ZIP.
2. Open PowerShell **inside the extracted folder** containing `install.ps1`.
3. Run:

```powershell
Set-ExecutionPolicy -Scope Process Bypass
.\install.ps1
```

If same-named files already exist, the installer skips them. To back up and replace existing toolkit files:

```powershell
.\install.ps1 -Force
```

Restart Claude Code after installation. Global files are installed to `%USERPROFILE%\.claude\agents\` and `%USERPROFILE%\.claude\skills\`, allowing the same Skills to be invoked inside different projects. Project-specific `CLAUDE.md` and repository rules still apply. No Administrator privileges are needed.

To check GitHub access before working with Issues:

```powershell
gh auth status
gh repo view OWNER/REPO
```

If not authenticated, run `gh auth login` and grant the necessary repository access.

## Full workflow

### Phase 1 — Plan → GitHub Issues

1. Project Discovery — inspect project, architecture, docs, and Git state.
2. Planner Agent — propose epics, tasks, dependencies, acceptance criteria.
3. Plan Validation — flag duplicates, missing architecture decisions, conflicting dependencies.
4. **STOP → User Approval** — no GitHub writes before explicit approval.
5. GitHub Issue Creator — create **only** the approved issues after checking for duplicates.
6. Verify → Report → **STOP** — inspect actually created Issues and give their URLs; do not launch implementation automatically.

```text
/ps-plan-project Analyze this repository and prepare a GitHub Issue plan. Do not publish yet.
# Review and approve the plan explicitly.
/ps-create-issues Create only the GitHub Issues in the approved plan for OWNER/REPO.
```

### Phase 2 — Create the implementation table

Use the real GitHub Issues to define sequencing, ownership, dependencies, priority, acceptance criteria and execution status, split by **backend**, **frontend**, **database**, **qa**, and **devops**.

```text
/ps-implementation-table OWNER/REPO
```

Review the resulting table and **approve it before implementation**. Follow actual dependencies rather than assuming a fixed role order. See [PHASE-3-IMPLEMENTATION-PLAN.md](PHASE-3-IMPLEMENTATION-PLAN.md) for a ready-to-adapt template and detailed gates.

### Phase 3 — Implement exactly one Issue and one Role

`/ps-implement-issue` **requires** one valid Issue and an explicit `--role`. The Skill must stop if either is missing, dependencies or architecture decisions are unresolved, or the scope includes another Role.

The following Issue IDs are **examples, not verified GitHub records**:

```text
/ps-implement-issue 123 --role backend
/ps-implement-issue 124 --role frontend
/ps-implement-issue 125 --role database
/ps-implement-issue 126 --role qa
/ps-implement-issue 127 --role devops
```

**These are examples of Role syntax, not an instruction to run all five sequentially.** Follow your approved dependency-ordered table and run each Issue individually. For example, when #123 depends on #125, implement the database work first:

```text
/ps-implement-issue 125 --role database
# Review reported checks and explicitly approve the next task.
/ps-implement-issue 123 --role backend
```

Each implementation runs project discovery → issue/role validation → scope approval → developer changes → tests → independent code/security reviews → Issue verification → **report and STOP**.

### Phase 4 — Verification (read-only)

```text
/ps-verify-issue 123
/ps-review-code
```

## Skills catalog

| Skill | Purpose | Side effects |
|---|---|---|
| `/ps-plan-project` | Discovery, planning and plan review | Read-only planning |
| `/ps-create-issues` | Create approved Issues from Plan | **GitHub write only after approval** |
| `/ps-implementation-table` | Sequence actual Issues by Role and dependency | Read-only; stops for approval |
| `/ps-implement-issue <number> --role <role>` | Implement one approved Issue and Role | Local code changes in approved scope |
| `/ps-verify-issue <number>` | Verify acceptance criteria against code/tests | Read-only |
| `/ps-review-code` | Code/security review | Read-only |

## Role contract

| Role | Primary scope | Restricted operations |
|---|---|---|
| `backend` | API, services, business rules, auth | No unapproved UI/schema updates |
| `frontend` | UI, pages, client logic, accessibility | No unapproved backend/schema updates |
| `database` | Schema migrations, queries, indexes | No production/shared DB migration execution |
| `qa` | Tests, test data, regression and defects | No silent changes to application code |
| `devops` | CI/CD files, Docker, IaC, monitoring config | No production deployments |

### Safety and STOP conditions

- Do not fabricate Issues; read GitHub with `gh` or ask for exact Issue text.
- Do not begin edits without approved Issue+Role scope and satisfied prerequisites.
- Do not cross-edit other Roles. If an Issue needs multiple Roles, create approved separate work rows or subissues.
- Do not automatically close/change/comment Issues; commit, push, merge, deploy, or execute destructive operations.
- Report exact checks performed and actual results; report `BLOCKED` or `PARTIAL` when appropriate.
- Subagent instructions are **not** a tool-permission sandbox. Configure Claude Code permissions for critical operations.

## Example role-oriented implementation table

| Order | Example Issue | Role | Depends on | Acceptance evidence | Status |
|---|---|---|---|---|---|
| 1 | #125 | database | — | Migration checks | PENDING |
| 2 | #123 | backend | #125 | API tests | PENDING |
| 3 | #124 | frontend | #123 | Build and UI tests | PENDING |
| 4 | #126 | qa | #123, #124 | Regression tests | PENDING |
| 5 | #127 | devops | #126 | CI validation | PENDING |

**Note:** This is a hypothetical example. Do not use these dependencies as facts about any actual repository. See [PHASE-3-IMPLEMENTATION-PLAN.md](PHASE-3-IMPLEMENTATION-PLAN.md) for the full execution checklist.

## Uninstall and migration

See **GitHub distribution → D. Uninstall Toolkit** above for step-by-step instructions. Run `uninstall.ps1` from this extracted package. It removes installed Toolkit files only if they still match the bundled hashes; modified files and backups are preserved. If the previous non-`ps-` version was installed, run its original `uninstall.ps1` first or review its old Skill names manually so commands do not conflict.

## References

- https://code.claude.com/docs/en/sub-agents
- https://code.claude.com/docs/en/skills
- https://cli.github.com/manual/gh_issue_view
- https://cli.github.com/manual/gh_issue_create

## V3: Milestone and Wave workflow

Milestone = outcome/deliverable tracked as a GitHub Milestone. Wave = dependency-aware implementation batch scoped to one milestone. Waves are **not** automatically represented as GitHub Milestones; GitHub milestones are actual remote records, while waves are the local/approved execution plan.

Run in this order:

```text
/ps-plan-project
/ps-plan-waves OWNER/REPO
# Review tables and explicitly approve the plan.
/ps-create-issues
# Review and explicitly approve the exact GitHub write manifest.
/ps-create-milestones OWNER/REPO
/ps-implementation-table OWNER/REPO
/ps-implement-wave W1 --role database
/ps-implement-issue 123 --role backend
/ps-verify-issue 123
/ps-review-code
```

Use `/ps-create-issues` before milestone assignment if planned issues do not yet have real GitHub IDs. `ps-create-milestones` must verify issue IDs before assignments. Publication and execution require distinct human approval gates. Missing dependencies or unverified GitHub access = BLOCKED, not a guessed result.

Wave planning artifact: `templates/MILESTONE-WAVE-PLAN.md`. Extra agents: `wave-planner` (Opus), `milestone-publisher` (Sonnet). Global install uses `install.ps1 -Force` with backups for replacements.

Reference: https://code.claude.com/docs/en/sub-agents and https://code.claude.com/docs/en/skills and https://docs.github.com/en/rest/issues/milestones


## Optional integrations: Superpowers, Matt Pocock, gstack

The toolkit keeps all `ps-*` commands and approval gates. Third-party tools are **not bundled or auto-installed**. See [THIRD-PARTY-INTEGRATIONS.md](THIRD-PARTY-INTEGRATIONS.md) for reviewed installation steps and Windows prerequisites. Run `/ps-check-integrations` before any task where `/tdd` or `/browse` is required. Never assume third-party skills are available before checking inside Claude Code.


## Optional Impeccable frontend integration (v5)

Only `--role frontend` enables the Impeccable integration. Install separately after reviewing upstream sources:

```powershell
npx impeccable install --providers=claude --scope=global
```

Restart Claude Code and check `/impeccable` is available. Per project, use `/impeccable init` with explicit consent since it writes design-context files. Then:

```text
/ps-check-integrations impeccable
/ps-implement-wave W1 --role frontend
```

The wave planner should invoke Impeccable's `shape` (plan), `audit` and `critique` (validate), and optionally `polish`/`harden` (approved changes), without bypassing issue approval, tests, independent reviews or STOP gates. If Impeccable is required but missing, report `BLOCKED`. Full instructions: [THIRD-PARTY-INTEGRATIONS.md](THIRD-PARTY-INTEGRATIONS.md).


## Phase 4 — E2E Testing + Evidence Reports + Gate (v6)

The toolkit now includes **five new global skills** and three E2E-focused subagents. These skills are workflow instructions; they do not install Playwright or configure your project automatically. Use an approved local/staging environment and repository-native Playwright setup.

| Skill | Purpose |
|---|---|
| `/ps-e2e-plan W1 --target both` | Map real GitHub Issue acceptance criteria to cases and a test plan |
| `/ps-e2e-test W1 --target both --env staging` | Execute approved existing Playwright tests and collect machine-readable evidence |
| `/ps-e2e-report W1` | Summarize JSON/JUnit/HTML results and defect findings, no fictional PASS |
| `/ps-e2e-verify W1` | Map criteria to executed tests and actual results |
| `/ps-e2e-gate W1` | PASS / FAIL / BLOCKED and STOP; no automatic issue closure or next wave |

A typical approved flow:

```text
/ps-implement-wave W1 --role frontend
/ps-e2e-plan W1
# Approve test setup and local/staging test execution.
/ps-e2e-test W1 --env staging
/ps-e2e-report W1
/ps-e2e-verify W1
/ps-e2e-gate W1
```

**Dependencies:** Node.js, an already configured Playwright Test dependency, browser binaries, active authorized local/staging environment, and safe test accounts/data. The toolkit installer does not run `npm install`, `npx playwright install`, or tests. If prerequisites are absent, the E2E step returns BLOCKED and explains why. `/browse` and Playwright MCP are optional helpers, not replacements for a reproducible Playwright Test run.

**Report artifacts:** Prefer unique `reports/W1/runs/<UTC-run-id>/` for raw JSON, JUnit and HTML, and `reports/W1/E2E-TEST-REPORT.md` for the summary after explicit permission to write results. Report templates live in `templates/`. Some reports can contain secrets; review before committing or uploading.

Playwright documentation: https://playwright.dev/docs/test-reporters and https://playwright.dev/docs/test-cli.
