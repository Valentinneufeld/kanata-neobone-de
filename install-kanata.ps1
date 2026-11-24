# Installiert/aktualisiert Kanata, kopiert neobone.kbd aus diesem Ordner und startet Kanata.
$ErrorActionPreference = 'Stop'
$ver = 'v1.13.0-prerelease-1'
$dir = 'C:\kanata\kanata-pre'
$exe = Join-Path $dir 'kanata_windows_tty_winIOv2_x64.exe'
$marker = Join-Path $dir 'version.txt'

Get-Process -Name 'kanata*' -ErrorAction SilentlyContinue | Stop-Process -Force
Start-Sleep -Milliseconds 500

New-Item -ItemType Directory -Force -Path $dir | Out-Null

if (-not (Test-Path $exe) -or -not (Test-Path $marker) -or (Get-Content $marker) -ne $ver) {
    Write-Host "Lade Kanata $ver ..."
    $zip = Join-Path $env:TEMP 'kanata-pre.zip'
    Invoke-WebRequest -UseBasicParsing -Uri "https://github.com/jtroo/kanata/releases/download/$ver/windows-binaries-x64.zip" -OutFile $zip
    Expand-Archive $zip -DestinationPath $dir -Force
    Remove-Item $zip
    Set-Content $marker $ver
}

Copy-Item (Join-Path $PSScriptRoot 'neobone.kbd') (Join-Path $dir 'neobone.kbd') -Force
Write-Host 'Config kopiert. Starte Kanata (Beenden: Strg+Leertaste+Esc) ...'
& $exe --cfg (Join-Path $dir 'neobone.kbd')
Read-Host 'Kanata beendet. Enter zum Schliessen'
