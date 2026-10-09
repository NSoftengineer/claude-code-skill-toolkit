$ErrorActionPreference = 'Stop'
$source = Split-Path -Parent $MyInvocation.MyCommand.Path
$target = Join-Path $HOME '.claude'
foreach ($section in @('agents','skills')) {
 $sourceSection = Join-Path $source $section
 Get-ChildItem -Path $sourceSection -Recurse -File | ForEach-Object {
  $relative = $_.FullName.Substring($sourceSection.Length).TrimStart('\','/')
  $destination = Join-Path (Join-Path $target $section) $relative
  if (Test-Path -LiteralPath $destination) {
    $actual = (Get-FileHash -LiteralPath $destination -Algorithm SHA256).Hash
    $bundled = (Get-FileHash -LiteralPath $_.FullName -Algorithm SHA256).Hash
    if ($actual -eq $bundled) { Remove-Item -LiteralPath $destination -Force; Write-Host "REMOVED: $destination" }
    else { Write-Host "SKIP modified file: $destination" -ForegroundColor Yellow }
  }
 }
}
Write-Host 'Done. No backups or project files removed.'
