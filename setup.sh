#!/usr/bin/env bash
set -e

# Pindah ke direktori script
cd "$(dirname "$0")"

echo -e "\n========================================================"
echo -e "   🚀 MEMULAI INSTALASI WORDPRESS DOCKER COMPOSE        "
echo -e "========================================================\n"

if [ ! -f .env ]; then
    if [ -f .env.example ]; then
        echo "ℹ️  Menyalin .env.example ke .env..."
        cp .env.example .env
    else
        echo "❌ File .env atau .env.example tidak ditemukan!"
        exit 1
    fi
fi

# Load .env
export $(grep -v '^#' .env | xargs)

# 1. Jalankan container
echo "📦 Menjalankan container Docker..."
docker compose up -d

# 2. Tunggu database siap
echo -e "\n⏳ Menunggu MariaDB database siap..."
until docker compose exec -T db mariadb-admin ping -h localhost -u root -p"${DB_ROOT_PASSWORD}" --silent &>/dev/null; do
    echo "   Menunggu database..."
    sleep 2
done
echo "✅ Database MariaDB siap!"

# 3. Tunggu file WordPress
echo -e "\n⏳ Menunggu core file WordPress diinisialisasi..."
until [ -f "./wordpress/wp-includes/version.php" ]; do
    echo "   Menunggu file WordPress..."
    sleep 2
done
echo "✅ Core file WordPress terdeteksi!"

# 4. Install via WP-CLI
echo -e "\n⚙️  Memeriksa & Menginstall WordPress via WP-CLI..."
if docker compose run --rm wpcli wp core is-installed &>/dev/null; then
    echo "ℹ️  WordPress sudah terinstall sebelumnya di database ini."
else
    echo "📥 Menjalankan 'wp core install'..."
    docker compose run --rm wpcli wp core install \
        --url="${WP_URL}" \
        --title="${WP_TITLE}" \
        --admin_user="${WP_ADMIN_USER}" \
        --admin_password="${WP_ADMIN_PASSWORD}" \
        --admin_email="${WP_ADMIN_EMAIL}" \
        --skip-email
    echo "✅ WordPress berhasil diinstall!"
fi

echo -e "\n========================================================"
echo -e "   🎉 SETUP SELESAI & SIAP DIGUNAKAN!                  "
echo -e "========================================================"
echo -e "🌐 WordPress  : ${WP_URL}"
echo -e "   👤 Admin   : ${WP_ADMIN_USER}"
echo -e "   🔑 Pass    : ${WP_ADMIN_PASSWORD}"
echo -e ""
echo -e "🗄️  phpMyAdmin : http://localhost:${PMA_PORT}"
echo -e "   👤 DB User : root atau ${DB_USER}"
echo -e "   🔑 DB Pass : ${DB_ROOT_PASSWORD} atau ${DB_PASSWORD}"
echo -e "========================================================\n"

