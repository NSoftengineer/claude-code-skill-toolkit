# Optional Third-party Skills Integration

This toolkit does **not** bundle or silently install third-party code. Installation is opt-in and performed by the user in Claude Code after reviewing the upstream repositories and requirements.

## Prerequisites
- Claude Code running on your machine, current version.
- Windows PowerShell; Git installed; `gh` authenticated for GitHub workflows.
- For **gstack**: Bun v1+ and, on Windows, Node.js. Its setup is a shell script; on Windows choose a Bash-capable shell (Git Bash/WSL as supported) and check upstream setup requirements. Do not try to execute `./setup` directly in PowerShell without a compatible shell.
- Review extension permissions, hooks, and external scripts before installation.

## Install optional plugins inside Claude Code
Open Claude Code (`claude`), enter **one command at a time** and wait for completion:

```text
/plugin install superpowers@claude-plugins-official
/plugin marketplace add mattpocock/skills
/plugin install mattpocock-skills@mattpocock
```

Plugin marketplace contents and availability can change; if any command fails, use `/plugin` to inspect available plugins and consult current upstream documentation rather than assume success. Then, in each repository where it is needed, use:

```text
/setup-matt-pocock-skills
```

## Install gstack (separate upstream repository)
This is **not** a Claude Code plugin, and is not included in this toolkit. Review https://github.com/garrytan/gstack before executing its installer.

From a Bash-compatible environment, in your home directory:

```bash
git clone --single-branch --depth 1 https://github.com/garrytan/gstack.git ~/.claude/skills/gstack
cd ~/.claude/skills/gstack
./setup
```

Do not overwrite an existing `~/.claude/skills/gstack` clone. See the upstream README for changes to setup and alternative host options.

## Verify before work
1. Restart Claude Code.
2. Type `/` and confirm available skills including `/tdd` and `/browse` (depending on installed versions).
3. If either is missing, report **UNAVAILABLE** and stop workflows that require it. Do not pretend browser or TDD validation happened.
4. Do not run external installers silently from `/ps-implement-issue`, `/ps-implement-wave`, or an agent.

## Role & wave mapping
| Toolkit stage | Optional extension | Intent |
|---|---|---|
| Plan/Debug | Superpowers planning/debugging tools | Support discovery and debugging, without bypassing approvals |
| Backend, Frontend, Database, QA | Matt Pocock `/tdd` | Red → Green → Refactor, subject to issue-specific scope |
| Frontend UI validation, QA | gstack `/browse` | Interactive browser verification for accessible local/staging app |
| DevOps | No automatic browser/deploy dependency | Prefer deterministic CI/infrastructure checks |

No plugin overrides human approval, role scope, issue dependency checks, read-only reviewers, or GitHub write restrictions. Never run `/ship`, deploy, push, auto-merge, or close an issue from an optional plugin unless separately approved.

Source references:
- https://code.claude.com/docs/en/plugins
- https://github.com/mattpocock/skills
- https://github.com/garrytan/gstack

## Impeccable — optional frontend design skill

Official project: https://github.com/pbakaus/impeccable

For Claude Code, from a project folder, after reviewing the upstream installer and approving installation, use:

```powershell
npx impeccable install --providers=claude --scope=global
```

Restart Claude Code. Verify `/impeccable` appears in the skill list. On each target project, run `/impeccable init` only after approving the generation/update of `PRODUCT.md` and potentially `DESIGN.md`.

Alternative plugin-based install: `/plugin marketplace add pbakaus/impeccable` followed by selecting Impeccable inside `/plugin`. Choose one installation method to avoid duplicates.

In a `frontend` wave, use `shape` to plan UI, `audit`/`critique` for inspection, then `polish`/`harden` only for approved UI changes. Never allow these commands to expand GitHub Issue scope; report unapproved recommendations instead.


## Playwright API and frontend E2E planning

The Toolkit v8 `ps-e2e-plan --target both` inventories HTTP API methods/paths and frontend routes, plus integrated browser-to-API scenarios. Playwright Test must be configured separately within each application repository. Its `request` fixture can perform REST API assertions, while browser tests use the `page` fixture. These features do not require installing a second testing product. Configure separate API and frontend base URLs according to your application and never run mutating API tests against production. Use `/ps-e2e-plan W1 --target both` in Claude Code, not PowerShell.

Docs: https://playwright.dev/docs/api-testing and https://playwright.dev/docs/test-projects
