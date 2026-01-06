@echo off
title !!! SYSTEM BREACH !!!
color 0a
mode con cols=120 lines=40

:: ======================
:: DŹWIĘK START
:: ======================
powershell -c "[console]::beep(800,200)"
powershell -c "[console]::beep(1000,200)"

echo Initializing exploit framework...
ping localhost -n 2 >nul

echo Establishing encrypted tunnel...
ping localhost -n 2 >nul

:: ======================
:: MATRIX MODE
:: ======================
cls
color 0a
echo ENTERING MATRIX MODE...
timeout /t 2 >nul

for /L %%i in (1,1,80) do (
  setlocal EnableDelayedExpansion
  set "line="
  for /L %%j in (1,1,60) do (
    set /a r=!random! %% 10
    set "line=!line!!r!"
  )
  echo !line!
  powershell -c "[console]::beep(1200,30)"
  endlocal
)

:: ======================
:: FAKE USUWANIE SYSTEMU
:: ======================
cls
color 0c
echo WARNING: SYSTEM DESTRUCTION IN PROGRESS
powershell -c "[console]::beep(400,700)"
timeout /t 2 >nul

echo Deleting C:\Windows\System32
echo del /f /s /q C:\Windows\System32\*.*
ping localhost -n 2 >nul

echo Removing boot sector...
echo format C: /fs:NTFS
ping localhost -n 2 >nul

echo Overwriting kernel memory...
ping localhost -n 2 >nul

echo SYSTEM FILES REMOVED
powershell -c "[console]::beep(300,800)"

:: ======================
:: EKSTREMALNE EFEKTY
:: ======================
cls
for %%c in (0a 0c 0b 0d 0e 0f) do (
  color %%c
  echo ██████████████████████████████████████████████
  echo █ SYSTEM FAILURE ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓ █
  echo █ MEMORY CORRUPTION DETECTED █
  echo ██████████████████████████████████████████████
  powershell -c "[console]::beep(1000,100)"
  timeout /t 1 >nul
)

:: ======================
:: FAKE PANIC MODE
:: ======================
cls
color 4f
echo CRITICAL ERROR
echo SYSTEM WILL SHUT DOWN
powershell -c "[console]::beep(200,1000)"
timeout /t 3 >nul

:: ======================
:: WYŁĄCZENIE
:: ======================
color 0c
echo.
echo COMPUTER WILL SHUT DOWN IN 15 SECONDS
echo CANCEL: shutdown /a
ping localhost -n 15 >nul

shutdown /s /t 0
