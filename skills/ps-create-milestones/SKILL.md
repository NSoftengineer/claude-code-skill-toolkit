---
name: ps-create-milestones
description: Publish an explicitly approved milestone plan to the named GitHub repository and optionally assign approved Issues to milestones; always dry-run and verify actual results.
argument-hint: "OWNER/REPO [approved milestone manifest]"
---
# Publish GitHub Milestones
1. Require explicit OWNER/REPO and an existing milestone manifest with exact titles/descriptions and issue-to-milestone mappings.
2. Verify the named repository, `gh auth status`, relevant issue permissions, existing milestone inventory via `gh api`, and referenced issue numbers. Never fabricate IDs or due dates.
3. Show a DRY-RUN manifest of create/reuse actions and any issue assignment edits. Stop for specific approval of exact GitHub writes (do not infer from general planning approval).
4. Delegate verified writes to `milestone-publisher` only after approval. Reuse existing milestones where appropriate; avoid duplicate creation.
5. Verify returned milestone numbers, URLs and issue assignments from GitHub; on partial failure STOP with an exact change log and no blind retries.
6. Report success/partial/blocked and STOP. Do not begin coding, close milestones/issues, push or deploy.
GitHub milestone APIs: `gh api repos/OWNER/REPO/milestones` (GET) and `gh api --method POST repos/OWNER/REPO/milestones` (create), issue assignment via authenticated REST PATCH only after explicit approval.
