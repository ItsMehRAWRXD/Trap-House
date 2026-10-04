$allLines = Get-Content 'f:\~dev\rawrxd\CMakeLists.txt'
$refs = @()
$inBlock = $false
for ($i = 0; $i -lt $allLines.Count; $i++) {
    $line = $allLines[$i]
    if ($line -match 'set\s*\(\s*WIN32IDE_SOURCES') { $inBlock = $true; continue }
    if ($inBlock -and $line -match '^\s*\)\s*$') { break }
    if ($inBlock) {
        $t = $line.Trim()
        if ($t -match '^#') { continue }
        if ($t -match '([\w/._-]+\.(?:cpp|c|hpp|h|asm|rc))') {
            $refs += $matches[1]
        }
    }
}
$refs = $refs | Select-Object -Unique | Sort-Object
$missing = @(); $present = @()
foreach ($r in $refs) {
    $fp = Join-Path 'f:\~dev\rawrxd' $r
    if (Test-Path $fp) { $present += $r } else { $missing += $r }
}
Write-Output "TOTAL=$($refs.Count)"
Write-Output "PRESENT=$($present.Count)"
Write-Output "MISSING=$($missing.Count)"
foreach ($m in $missing) { Write-Output "MISSING: $m" }
