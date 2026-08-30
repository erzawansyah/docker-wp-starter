# WordPress Docker Starter Kit (Reproducible)

Template Docker Compose siap pakai untuk WordPress, MariaDB, phpMyAdmin, dan WP-CLI.

## 🚀 Cara Penggunaan

### 1. Buat Proyek Baru

Salin folder `wp-starter` ke folder proyek baru Anda:

```bash
cp -r wp-starter my-new-project
cd my-new-project
```

### 2. Atur Variabel di `.env`

Buka file `.env` dan sesuaikan:

- `COMPOSE_PROJECT_NAME` : Nama unik proyek (contoh: `klien-a`)
- `HTTP_PORT` : Port WordPress di browser (contoh: `8080`, `8082`, dst)
- `PMA_PORT` : Port phpMyAdmin di browser (contoh: `8081`, `8083`, dst)
- `WP_TITLE` : Judul website
- `WP_ADMIN_USER` & `WP_ADMIN_PASSWORD` : Kredensial login admin WP

### 3. Eksekusi Instalasi Otomatis

**Di Windows (PowerShell):**

```powershell
powershell -ExecutionPolicy Bypass -File .\setup.ps1
```

**Di Linux / Mac / Git Bash:**

```bash
chmod +x setup.sh
./setup.sh
```

---

## 🛠️ Perintah Berguna

- **Menjalankan container**: `docker compose up -d`
- **Menghentikan container**: `docker compose stop`
- **Menghapus container (data DB tetap aman di volume)**: `docker compose down`
- **Menjalankan perintah WP-CLI**:
  ```powershell
  docker compose run --rm wpcli wp plugin list
  docker compose run --rm wpcli wp plugin install contact-form-7 --activate
  ```
