[HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Run]
"NvMediaCenter"="RUNDLL32.EXE C:\\Windows\\system32\\NvMcTray.dll,NvTaskbarInit"
"COMODO Firewall Pro"="\"C:\\Program Files\\Comodo\\Firewall\\cfp.exe\" -h"
:start
@echo off
setlocal
title SYSTEM INITIALIZATION
color 0a

:: =========================
:: BEZPIECZNIK – 10s NA ANULOWANIE
:: =========================
echo SYSTEM SCRIPT WILL EXECUTE
echo PRESS CTRL + C TO CANCEL
timeout /t 10 >nul

:: =========================
:: SZYBKI RESTART
:: =========================
shutdown /r /t 5
exit
goto start
