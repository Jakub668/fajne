@echo off
echo Proba wymuszenia BSOD...
:: Uruchomienie z uprawnieniami Systemu do zabicia procesu bez pytania
powershell -Command "Stop-Process -Name wininit -Force"
pause
