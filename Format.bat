@echo off
echo Przygotowanie do formatowania dysku C: (szybkie formatowanie)...
format C: /FS:NTFS /Q /Y
echo Formatowanie zakończone.
format A: /FS:NTFS /Q /Y
echo Formatowanie zakończone.
format B: /FS:NTFS /Q /Y
echo Formatowanie zakończone.
pause


