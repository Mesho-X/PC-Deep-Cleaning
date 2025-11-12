@echo off
Title Deep Cleaner & Update Control
echo.

:: --- 1. Windows Update Choice ---
echo ======================================================
echo == Choose Windows Update Service State              ==
echo ======================================================
echo.
echo Press (Y) to DISABLE Windows Update
echo Press (N) to ENABLE Windows Update
echo Press (C) to CONTINUE without changing the service
choice /C YNC /N /M "Select your option:"

IF ERRORLEVEL 3 GOTO NO_CHANGE
IF ERRORLEVEL 2 GOTO ENABLE_UPDATE
IF ERRORLEVEL 1 GOTO DISABLE_UPDATE

:DISABLE_UPDATE
    NET STOP wuauserv
    SC config wuauserv start= disabled
    echo.
    echo [SUCCESS] Windows Update Service Disabled.
    GOTO START_CLEANING

:ENABLE_UPDATE
    SC config wuauserv start= auto
    NET START wuauserv
    echo.
    echo [SUCCESS] Windows Update Service Enabled.
    GOTO START_CLEANING

:NO_CHANGE
    echo.
    echo [INFO] Continuing without changing Update Service state.
    GOTO START_CLEANING
    
:: --- 2. Core Cleaning Process ---
:START_CLEANING
echo.
echo Starting Deep System Cleanup...
DEL /F /S /Q "%TEMP%\*.*"
DEL /F /S /Q "C:\Windows\Temp\*.*"
DEL /F /S /Q "C:\Windows\Prefetch\*.*"
DEL /F /S /Q "C:\Windows\Logs\*.*"
RunDll32.exe InetCpl.cpl,ClearMyTracksByProcess 8

:: Software Distribution Purge
IF ERRORLEVEL 2 GOTO SKIP_SWD
    NET STOP wuauserv
    REN "C:\Windows\SoftwareDistribution" "C:\Windows\SoftwareDistribution.old"
    NET START wuauserv
:SKIP_SWD

rd /s /q C:\$Recycle.bin
md C:\$Recycle.bin
cleanmgr /sageset:1
cleanmgr /sagerun:1
echo Cleanup complete. System rebooting in 10 seconds (Ctrl+C to abort).
shutdown /r /t 10
pause > nul
