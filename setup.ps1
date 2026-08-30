# ==============================================================================
# Script Otomatisasi Setup WordPress (Windows PowerShell)
# ==============================================================================

if ($PSScriptRoot) {
    Set-Location -Path $PSScriptRoot
}

Write-Host ""
Write-Host "========================================================" -ForegroundColor Cyan
Write-Host "   [*] MEMULAI INSTALASI WORDPRESS DOCKER COMPOSE       " -ForegroundColor Cyan
Write-Host "========================================================" -ForegroundColor Cyan
Write-Host ""

# 1. Validasi & Muat .env
if (-not (Test-Path .env)) {
    if (Test-Path .env.example) {
        Write-Host "[*] Menyalin .env.example ke .env..." -ForegroundColor Yellow
        Copy-Item .env.example .env
    } else {
        Write-Host "[!] Error: File .env atau .env.example tidak ditemukan!" -ForegroundColor Red
        exit 1
    }
}

$envLines = Get-Content -Path .env
foreach ($line in $envLines) {
    $trimmed = $line.Trim()
    if ($trimmed -and -not $trimmed.StartsWith("#") -and $trimmed.Contains("=")) {
        $parts = $trimmed.Split("=", 2)
        $key = $parts[0].Trim()
        $val = $parts[1].Trim().Trim('"').Trim("'")
        [System.Environment]::SetEnvironmentVariable($key, $val, "Process")
    }
}

# 2. Jalankan Container Docker
Write-Host "[+] Menjalankan container Docker (WordPress, MariaDB, phpMyAdmin)..." -ForegroundColor Green
docker compose up -d

# 3. Tunggu Database MariaDB siap menerima koneksi
Write-Host ""
Write-Host "[*] Menunggu MariaDB database siap..." -ForegroundColor Yellow
$maxAttempts = 30
$attempt = 0
$dbReady = $false

while (-not $dbReady -and $attempt -lt $maxAttempts) {
    Start-Sleep -Seconds 2
    $attempt++
    try {
        $check = docker compose exec -T db mariadb-admin ping -h localhost -u root "-p$env:DB_ROOT_PASSWORD" 2>&1
        if ($check -match "mysqld is alive") {
            $dbReady = $true
            Write-Host "[OK] Database MariaDB siap!" -ForegroundColor Green
            break
        }
    } catch {
        # ignore stderr during boot
    }
    Write-Host "   (Percobaan $attempt/$maxAttempts) Menunggu database..." -ForegroundColor DarkGray
}

if (-not $dbReady) {
    Write-Host "[!] Database memakan waktu terlalu lama untuk memulai." -ForegroundColor Red
    exit 1
}

# 4. Tunggu file WordPress di-generate oleh container WordPress
Write-Host ""
Write-Host "[*] Menunggu core file WordPress dan wp-config.php diinisialisasi..." -ForegroundColor Yellow
$wpCoreReady = $false
$attempt = 0

while (-not $wpCoreReady -and $attempt -lt 30) {
    Start-Sleep -Seconds 2
    $attempt++
    if (Test-Path ".\wordpress\wp-config.php") {
        $wpCoreReady = $true
        Write-Host "[OK] File WordPress & wp-config.php terdeteksi!" -ForegroundColor Green
        break
    }
    Write-Host "   (Percobaan $attempt/30) Menunggu inisialisasi file WordPress..." -ForegroundColor DarkGray
}

# 5. Jalankan Instalasi WordPress via WP-CLI
Write-Host ""
Write-Host "[*] Memeriksa & Menginstall WordPress via WP-CLI..." -ForegroundColor Cyan

# Cek apakah WP sudah terinstall
$isInstalled = docker compose run --rm wpcli wp core is-installed 2>&1
if ($LASTEXITCODE -eq 0) {
    Write-Host "[*] WordPress sudah terinstall di database ini." -ForegroundColor Green
} else {
    Write-Host "[+] Menjalankan 'wp core install'..." -ForegroundColor Cyan
    docker compose run --rm wpcli wp core install --url="$env:WP_URL" --title="$env:WP_TITLE" --admin_user="$env:WP_ADMIN_USER" --admin_password="$env:WP_ADMIN_PASSWORD" --admin_email="$env:WP_ADMIN_EMAIL" --skip-email
    Write-Host "[OK] WordPress berhasil diinstall!" -ForegroundColor Green
}

Write-Host ""
Write-Host "========================================================" -ForegroundColor Green
Write-Host "   [SUCCESS] SETUP SELESAI & SIAP DIGUNAKAN!            " -ForegroundColor Green
Write-Host "========================================================" -ForegroundColor Green
Write-Host "WordPress  : $env:WP_URL" -ForegroundColor White
Write-Host "  Admin    : $env:WP_ADMIN_USER" -ForegroundColor Gray
Write-Host "  Pass     : $env:WP_ADMIN_PASSWORD" -ForegroundColor Gray
Write-Host ""
Write-Host "phpMyAdmin : http://localhost:$env:PMA_PORT" -ForegroundColor White
Write-Host "  DB User  : root atau $env:DB_USER" -ForegroundColor Gray
Write-Host "  DB Pass  : $env:DB_ROOT_PASSWORD atau $env:DB_PASSWORD" -ForegroundColor Gray
Write-Host "========================================================" -ForegroundColor Green
Write-Host ""

