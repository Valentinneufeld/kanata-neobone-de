# Startet nur Kanata aus C:\kanata\kanata-pre mit der dort liegenden neobone.kbd.
$dir = 'C:\kanata\kanata-pre'
Set-Location $dir
& (Join-Path $dir 'kanata_windows_tty_winIOv2_x64.exe') --cfg (Join-Path $dir 'neobone.kbd')
Read-Host 'Kanata beendet. Enter zum Schliessen'
