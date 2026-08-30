#!/bin/sh
set -eu

WP_PATH="/var/www/html"

# Wait for WordPress core files to be extracted and wp-config.php to be generated
echo "[Auto-Installer] Waiting for WordPress core and wp-config.php..."

until [ -f "${WP_PATH}/wp-config.php" ] && \
      [ -f "${WP_PATH}/wp-includes/version.php" ]; do
  sleep 2
done

echo "[Auto-Installer] WordPress files are ready."

# Check if WordPress is already installed to prevent re-installation
if wp core is-installed --path="${WP_PATH}" 2>/dev/null; then
  echo "[Auto-Installer] WordPress is already installed."
  exit 0
fi

echo "[Auto-Installer] Starting automatic WordPress installation..."

# Run the WordPress installation command and retry if it fails
until wp core install \
  --path="${WP_PATH}" \
  --url="${WP_URL}" \
  --title="${WP_TITLE}" \
  --admin_user="${WP_ADMIN_USER}" \
  --admin_password="${WP_ADMIN_PASSWORD}" \
  --admin_email="${WP_ADMIN_EMAIL}" \
  --locale="${WP_LOCALE:-en_US}" \
  --skip-email; do

  echo "[Auto-Installer] Installation has not succeeded yet; retrying in 3 seconds..."
  sleep 3
done

echo "[Auto-Installer] WordPress has been installed automatically."
