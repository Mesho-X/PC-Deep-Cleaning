@echo off
Title Deep Cleaner & Update Control
echo.

echo ======================================================
echo == Choose Windows Update Service State              ==
echo ======================================================
echo.
echo Press (Y) to DISABLE Windows Update
echo Press (N) to ENABLE Windows Update
echo Press (C) to CONTINUE without changing the service
choice /C YNC /N /M "Select your option:"

IF ERRORLEVEL 3 GOTO START_CLEANING  :: C (Continue)
IF ERRORLEVEL 2 GOTO ENABLE_UPDATE    :: N (Enable)
IF ERRORLEVEL 1 GOTO DISABLE_UPDATE   :: Y (Disable)

:DISABLE_UPDATE
    SC config wuauserv start= disabled
    NET STOP wuauserv
    echo.
    echo [SUCCESS] Windows Update Service Disabled.
    GOTO CLEANUP_SWD

:ENABLE_UPDATE
    SC config wuauserv start= auto
    NET START wuauserv
    echo.
    echo [SUCCESS] Windows Update Service Enabled.
    GOTO CLEANUP_SWD
    
:START_CLEANING
    echo.
    echo [INFO] Skipping Windows Update state change.
    GOTO CLEANUP_SWD

:CLEANUP_SWD
    echo.
    echo Starting Deep System Cleanup...
    
    DEL /F /S /Q "%TEMP%\*.*"
    DEL /F /S /Q "C:\Windows\Temp\*.*"
    DEL /F /S /Q "C:\Windows\Prefetch\*.*"
    DEL /F /S /Q "C:\Windows\Logs\*.*"
    RunDll32.exe InetCpl.cpl,ClearMyTracksByProcess 8

    echo [INFO] Purging old Windows Update cache...
    NET STOP wuauserv
    REN "C:\Windows\SoftwareDistribution" "C:\Windows\SoftwareDistribution.old"
    NET START wuauserv
    
    rd /s /q C:\$Recycle.bin
    md C:\$Recycle.bin
    cleanmgr /sageset:1
    cleanmgr /sagerun:1
    
    echo Cleanup complete. System rebooting in 10 seconds (Ctrl+C to abort).
    shutdown /r /t 10
    pause > nul


