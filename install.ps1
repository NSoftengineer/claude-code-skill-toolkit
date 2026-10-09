param([switch]$Force)
$ErrorActionPreference = 'Stop'
$source = Split-Path -Parent $MyInvocation.MyCommand.Path
$target = Join-Path $HOME '.claude'
$backupRoot = Join-Path $target ('full-flow-v6-backups\' + (Get-Date -Format 'yyyyMMdd-HHmmss'))
foreach ($section in @('agents','skills')) {
 $sourceSection = Join-Path $source $section
 Get-ChildItem -Path $sourceSection -Recurse -File | ForEach-Object {
  $relative = $_.FullName.Substring($sourceSection.Length).TrimStart('\','/')
  $destination = Join-Path (Join-Path $target $section) $relative
  New-Item -ItemType Directory -Force -Path (Split-Path -Parent $destination) | Out-Null
  if (Test-Path -LiteralPath $destination) {
   if (-not $Force) { Write-Host "SKIP: $destination (use -Force to back up and replace)" -ForegroundColor Yellow; return }
   $backup = Join-Path (Join-Path $backupRoot $section) $relative
   New-Item -ItemType Directory -Force -Path (Split-Path -Parent $backup) | Out-Null
   Copy-Item -LiteralPath $destination -Destination $backup -Force
  }
  Copy-Item -LiteralPath $_.FullName -Destination $destination -Force
  Write-Host "INSTALLED: $destination" -ForegroundColor Green
 }
}
Write-Host 'Done. Restart Claude Code; available skills: /ps-plan-project /ps-create-issues /ps-implementation-table /ps-implement-issue /ps-verify-issue /ps-review-code /ps-plan-waves /ps-create-milestones /ps-implement-wave /ps-e2e-plan /ps-e2e-test /ps-e2e-report /ps-e2e-verify /ps-e2e-gate' -ForegroundColor Cyan

Write-Host 'Optional third-party integrations are NOT auto-installed. Read THIRD-PARTY-INTEGRATIONS.md and run /ps-check-integrations.' -ForegroundColor Yellow
