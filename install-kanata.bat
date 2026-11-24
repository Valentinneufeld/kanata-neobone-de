@echo off
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0kanata.ps1" -Action install
if errorlevel 1 pause
