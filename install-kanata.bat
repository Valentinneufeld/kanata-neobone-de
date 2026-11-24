@echo off
rem Installiert/aktualisiert Kanata und kopiert die Config. Liegt neben install-kanata.ps1.
pushd "%~dp0"
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0install-kanata.ps1"
popd
if errorlevel 1 pause
