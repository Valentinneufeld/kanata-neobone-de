#Requires -Version 5.1
<#
.SYNOPSIS
  Installiert und startet Kanata mit neobone.kbd. Alles liegt relativ zu diesem Skript.
.PARAMETER Action
  install: Kanata laden, Startmenü-Eintrag anlegen, Kanata starten.
  run:     Kanata mit Konsole starten (zum Debuggen).
.PARAMETER Version
  Kanata-Release-Tag.
#>
[CmdletBinding()]
param(
    [ValidateSet('install', 'run')]
    [string]$Action = 'run',
    [string]$Version = 'v1.13.0-prerelease-1'
)

$ErrorActionPreference = 'Stop'

$Root = $PSScriptRoot
$Bin = Join-Path $Root 'bin'
$Config = Join-Path $Root 'neobone.kbd'
$TtyExe = Join-Path $Bin 'kanata_windows_tty_winIOv2_x64.exe'
$GuiExe = Join-Path $Bin 'kanata_windows_gui_winIOv2_x64.exe'
$VersionFile = Join-Path $Bin 'version.txt'

function Stop-Kanata {
    Get-Process | Where-Object { $_.Path -and $_.Path -like "$Bin\*" } | Stop-Process -Force
    Start-Sleep -Milliseconds 500
}

function Install-KanataBinaries {
    $installed = if (Test-Path $VersionFile) { (Get-Content $VersionFile -Raw).Trim() }
    if ((Test-Path $TtyExe) -and ($installed -eq $Version)) { return }

    Write-Host "Lade Kanata $Version ..."
    $zip = Join-Path $env:TEMP 'kanata.zip'
    $url = "https://github.com/jtroo/kanata/releases/download/$Version/windows-binaries-x64.zip"
    Invoke-WebRequest -UseBasicParsing -Uri $url -OutFile $zip
    New-Item -ItemType Directory -Force -Path $Bin | Out-Null
    Expand-Archive $zip -DestinationPath $Bin -Force
    Remove-Item $zip
    Set-Content $VersionFile $Version
}

function New-StartMenuShortcut {
    $lnk = Join-Path ([Environment]::GetFolderPath('Programs')) 'Kanata.lnk'
    $shortcut = (New-Object -ComObject WScript.Shell).CreateShortcut($lnk)
    $shortcut.TargetPath = $GuiExe
    $shortcut.Arguments = "--cfg `"$Config`""
    $shortcut.WorkingDirectory = $Root
    $shortcut.IconLocation = "$GuiExe,0"
    $shortcut.Description = 'Kanata Neo-Bone'
    $shortcut.Save()
    Write-Host "Startmenü-Eintrag: $lnk"
}

if (-not (Test-Path $Config)) { throw "Config nicht gefunden: $Config" }

switch ($Action) {
    'install' {
        Stop-Kanata
        Install-KanataBinaries
        New-StartMenuShortcut
        Start-Process $GuiExe -ArgumentList "--cfg `"$Config`"" -WorkingDirectory $Root
        Write-Host 'Kanata läuft (Tray-Icon). Beenden: linke Strg + Leertaste + Esc.'
    }
    'run' {
        if (-not (Test-Path $TtyExe)) { throw 'Kanata fehlt. Zuerst install-kanata.bat ausführen.' }
        Stop-Kanata
        & $TtyExe --cfg $Config
    }
}
