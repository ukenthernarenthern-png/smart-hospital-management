@echo off
title SmartCare AI - Hospital Operations Platform
echo ========================================================
echo   SmartCare AI: Intelligent Hospital Operations Platform
echo   Overcrowded Hospitals, Limited Resources: Doing More With What Exists
echo ========================================================
echo.
echo Starting local web server on port 5000...
start /b powershell -ExecutionPolicy Bypass -File "%~dp0server.ps1"
timeout /t 2 >nul
echo.
echo Opening http://127.0.0.1:5000/ in your web browser...
start "" "http://127.0.0.1:5000/"
echo.
echo Server is actively running. Press any key to stop.
pause >nul
