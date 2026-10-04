# Sync stickers from the deployed site into local webapp/QQimgs (incremental backup).
# Usage:
#   .\tools\sync-stickers.ps1 -Base "https://overkold.dpdns.org"
#   .\tools\sync-stickers.ps1 -Base "https://overkold.dpdns.org" -Cat "JiMiDou"
#   .\tools\sync-stickers.ps1 -Base "https://overkold.dpdns.org" -All
param(
  [Parameter(Mandatory = $true)][string]$Base,
  [string]$Cat = "",
  [switch]$All
)

$ErrorActionPreference = "Stop"
$Base = $Base.TrimEnd('/')

# Local target: webapp/QQimgs in the source tree
$localRoot = (Resolve-Path (Join-Path $PSScriptRoot "..\src\main\webapp\QQimgs")).Path

Write-Host "Remote : $Base"
Write-Host "Local  : $localRoot"
if ($Cat) { Write-Host "Filter : only category = $Cat" }
Write-Host "Fetching sticker catalog from cloud ..."

# /chat?stickers=1 returns { "category": [ { "n": "filename", "a": isAnimated } ] }
$catalog = Invoke-RestMethod -Uri "$Base/chat?stickers=1" -Method Get

$downloaded = 0; $skipped = 0; $failed = 0
foreach ($prop in $catalog.PSObject.Properties) {
  $cat = $prop.Name
  if ($Cat -and $cat -ne $Cat) { continue }
  $destDir = Join-Path $localRoot $cat
  if (-not (Test-Path $destDir)) { New-Item -ItemType Directory -Path $destDir | Out-Null }

  foreach ($f in $prop.Value) {
    $name = $f.n
    $dest = Join-Path $destDir $name
    if ((Test-Path $dest) -and -not $All) { $skipped++; continue }

    # Category and filename may contain non-ASCII; percent-encode each path segment
    $url = "$Base/QQimgs/" + [uri]::EscapeDataString($cat) + "/" + [uri]::EscapeDataString($name)
    try {
      Invoke-WebRequest -Uri $url -OutFile $dest -UseBasicParsing
      $downloaded++
      Write-Host "  [OK]   [$cat] $name"
    }
    catch {
      $failed++
      Write-Host "  [FAIL] [$cat] $name  -> $($_.Exception.Message)" -ForegroundColor Red
    }
  }
}

Write-Host ""
Write-Host "Done: new=$downloaded  skipped=$skipped  failed=$failed"
Write-Host "Note: files land in src only. To let local Tomcat see them, Build/Update resources or restart, then Ctrl+F5."