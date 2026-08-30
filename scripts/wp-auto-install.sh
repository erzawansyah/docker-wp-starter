#!/bin/sh
set -eu

WP_PATH="/var/www/html"

echo "[Auto-Installer] Menunggu WordPress core dan wp-config.php..."

until [ -f "${WP_PATH}/wp-config.php" ] && \
      [ -f "${WP_PATH}/wp-includes/version.php" ]; do
  sleep 2
done

echo "[Auto-Installer] WordPress files siap."

if wp core is-installed --path="${WP_PATH}" 2>/dev/null; then
  echo "[Auto-Installer] WordPress sudah terinstall sebelumnya."
  exit 0
fi

echo "[Auto-Installer] Memulai instalasi otomatis WordPress..."

until wp core install \
  --path="${WP_PATH}" \
  --url="${WP_URL}" \
  --title="${WP_TITLE}" \
  --admin_user="${WP_ADMIN_USER}" \
  --admin_password="${WP_ADMIN_PASSWORD}" \
  --admin_email="${WP_ADMIN_EMAIL}" \
  --locale="${WP_LOCALE:-id_ID}" \
  --skip-email; do

  echo "[Auto-Installer] Instalasi belum berhasil; mencoba kembali dalam 3 detik..."
  sleep 3
done

echo "[Auto-Installer] WordPress berhasil diinstall otomatis."
