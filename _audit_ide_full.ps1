# Comprehensive IDE Source File Audit
$ErrorActionPreference = "Stop"
$repoRoot = "f:\~dev\rawrxd"
$cmakeFile = Join-Path $repoRoot "CMakeLists.txt"

Write-Host "=== RAWRXD IDE SOURCE AUDIT ===" -ForegroundColor Cyan
Write-Host "Repository: $repoRoot"
Write-Host ""

# Parse ALL WIN32IDE_SOURCES references across the entire file
$allLines = Get-Content $cmakeFile
$activeSources = @()
$excludedSources = @()
$inBlock = $false
$blockStart = -1

for ($i = 0; $i -lt $allLines.Count; $i++) {
    $line = $allLines[$i]
    $trim = $line.Trim()
    
    # Detect start of a WIN32IDE_SOURCES block
    if ($trim -match 'set\s*\(\s*WIN32IDE_SOURCES' -or $trim -match 'list\s*\(\s*APPEND\s+WIN32IDE_SOURCES') {
        $inBlock = $true
        $blockStart = $i + 1
        continue
    }
    
    if (-not $inBlock) { continue }
    
    # End block on closing paren at start of line
    if ($trim -match '^\)') {
        $inBlock = $false
        continue
    }
    
    # Skip empty lines
    if ($trim -eq '') { continue }
    
    # Check if comment references a file that was excluded
    if ($trim -match '^#') {
        if ($trim -match '(src/[\w/._-]+\.(?:cpp|c|hpp|h|asm|rc)|Ship/[\w/._-]+\.cpp)') {
            $excludedSources += [PSCustomObject]@{
                File = $matches[1]
                Line = $i + 1
                Reason = $trim
            }
        }
        continue
    }
    
    # Match active source references
    if ($trim -match '^(src/[\w/._-]+\.(?:cpp|c|hpp|h|asm|rc)|Ship/[\w/._-]+\.cpp)$') {
        $activeSources += [PSCustomObject]@{
            File = $matches[1]
            Line = $i + 1
        }
    }
}

Write-Host "--- ACTIVE SOURCES ---" -ForegroundColor Green
$present = 0
$missing = 0
$missingActive = @()
foreach ($src in $activeSources) {
    $fp = Join-Path $repoRoot $src.File
    if (Test-Path $fp) {
        Write-Host "[OK] $($src.File)" -ForegroundColor Green
        $present++
    } else {
        Write-Host "[MISSING] $($src.File) (line $($src.Line))" -ForegroundColor Red
        $missing++
        $missingActive += $src
    }
}

Write-Host ""
Write-Host "--- EXCLUDED SOURCES (in comments) ---" -ForegroundColor Yellow
$excludedMissing = 0
foreach ($src in $excludedSources) {
    $fp = Join-Path $repoRoot $src.File
    $status = if (Test-Path $fp) { "EXISTS" } else { "ALSO MISSING" }
    Write-Host "[$status] $($src.File) (line $($src.Line))"
    if (-not (Test-Path $fp)) {
        $excludedMissing++
    }
}

Write-Host ""
Write-Host "=== SUMMARY ===" -ForegroundColor Cyan
Write-Host "Active sources referenced: $($activeSources.Count)"
Write-Host "  Present: $present"
Write-Host "  Missing: $missing"
Write-Host "Excluded sources (commented out): $($excludedSources.Count)"
Write-Host "  Also missing from disk: $excludedMissing"
Write-Host "Total files referenced: $($activeSources.Count + $excludedSources.Count)"
Write-Host "Total MISSING: $($missing + $excludedMissing)"

if ($missing -gt 0) {
    Write-Host ""
    Write-Host "=== MISSING ACTIVE SOURCES ===" -ForegroundColor Red
    foreach ($src in $missingActive) {
        Write-Host "  $($src.File) (line $($src.Line))"
    }
}
