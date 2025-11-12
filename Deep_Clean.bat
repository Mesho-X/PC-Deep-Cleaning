@echo off
Title Deep Cleaner & Performance Booster
DEL /F /S /Q "%TEMP%\*.*"
DEL /F /S /Q "C:\Windows\Temp\*.*"
DEL /F /S /Q "C:\Windows\Prefetch\*.*"
DEL /F /S /Q "C:\Windows\Logs\*.*"
RunDll32.exe InetCpl.cpl,ClearMyTracksByProcess 8
NET STOP wuauserv
REN "C:\Windows\SoftwareDistribution" "C:\Windows\SoftwareDistribution.old"
NET START wuauserv
rd /s /q C:\$Recycle.bin
md C:\$Recycle.bin
cleanmgr /sageset:1
cleanmgr /sagerun:1
echo Cleanup complete. Rebooting in 10 seconds (Ctrl+C to abort).
shutdown /r /t 10
pause > nul