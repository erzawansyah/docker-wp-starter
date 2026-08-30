# WordPress Docker Starter Kit (Fully Automated & Reproducible)

Starter kit Docker Compose yang **100% otomatis**: cukup isi `.env` dan jalankan `docker compose up -d`. Sistem di dalam container Docker akan otomatis mengurus pengecekan database, inisialisasi file, dan instalasi WordPress via WP-CLI!

---

## 🚀 Cara Penggunaan

### 1. Salin Folder Template
Salin folder `wp-starter` ke direktori proyek baru Anda:
```bash
cp -r wp-starter my-new-project
cd my-new-project
```

### 2. Atur Konfigurasi di `.env`
Salin `.env.example` ke `.env` (jika belum ada), lalu sesuaikan variabel:
```dotenv
COMPOSE_PROJECT_NAME=my-new-project
HTTP_PORT=8080
PMA_PORT=8081
WP_TITLE="Website Keren Saya"
WP_URL=http://localhost:8080
WP_ADMIN_USER=admin
WP_ADMIN_PASSWORD=PasswordRahasia123!
WP_ADMIN_EMAIL=admin@example.com
```

### 3. Jalankan Docker Compose
Cukup ketik satu perintah ini di terminal:
```bash
docker compose up -d
```

🎉 **Selesai!**
Container `wp-auto-install` di dalam Docker akan otomatis:
1. Menunggu database MariaDB sehat (*healthy*).
2. Menunggu core file WordPress dan `wp-config.php` dibuat.
3. Menjalankan `wp core install` secara otomatis.
4. Berhenti dengan rapi setelah selesai tanpa membebani resource RAM/CPU.

---

## 🌐 Akses Layanan

- **WordPress Site**: `http://localhost:<HTTP_PORT>` (contoh: `http://localhost:8080`)
- **WordPress Admin**: `http://localhost:<HTTP_PORT>/wp-admin`
- **phpMyAdmin**: `http://localhost:<PMA_PORT>` (contoh: `http://localhost:8081`)

---

## 🛠️ Perintah Berguna

- **Melihat status container**: `docker compose ps`
- **Melihat log instalasi otomatis**: `docker logs <COMPOSE_PROJECT_NAME>-auto-install`
- **Menghentikan container**: `docker compose stop`
- **Menghapus container (data database & web tetap aman)**: `docker compose down`
- **Menjalankan perintah WP-CLI manual**:
  ```bash
  docker compose run --rm wp-auto-install wp plugin list
  docker compose run --rm wp-auto-install wp plugin install elementor --activate
  ```
