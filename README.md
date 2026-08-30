# WordPress Docker Starter Kit (Fully Automated & Reproducible)

A **100% automated** Docker Compose starter kit: simply fill in `.env` and run `docker compose up -d`. The system inside the Docker container will automatically handle database checks, file initialization, and WordPress installation via WP-CLI!

---

## 🚀 How to Use

### 1. Copy the Template Folder
Copy the `wp-starter` folder to your new project directory:
```bash
cp -r wp-starter my-new-project
cd my-new-project
```

### 2. Configure `.env`
Copy `.env.example` to `.env` (if it doesn't exist yet), then adjust the variables:
```dotenv
COMPOSE_PROJECT_NAME=my-new-project
HTTP_PORT=8080
PMA_PORT=8081
WP_TITLE="My Awesome Website"
WP_URL=http://localhost:8080
WP_ADMIN_USER=admin
WP_ADMIN_PASSWORD=SecretPassword123!
WP_ADMIN_EMAIL=admin@example.com
```

### 3. Run Docker Compose
Just type this single command in the terminal:
```bash
docker compose up -d
```

🎉 **Done!**
The `wp-auto-install` container inside Docker will automatically:
1. Wait for the MariaDB database to be healthy.
2. Wait for the WordPress core files and `wp-config.php` to be created.
3. Run `wp core install` automatically.
4. Stop gracefully after completion without burdening RAM/CPU resources.

---

## 🌐 Accessing the Services

- **WordPress Site**: `http://localhost:<HTTP_PORT>` (example: `http://localhost:8080`)
- **WordPress Admin**: `http://localhost:<HTTP_PORT>/wp-admin`
- **phpMyAdmin**: `http://localhost:<PMA_PORT>` (example: `http://localhost:8081`)

---

## 🛠️ Useful Commands

- **Check container status**: `docker compose ps`
- **View auto-installation logs**: `docker logs <COMPOSE_PROJECT_NAME>-auto-install`
- **Stop containers**: `docker compose stop`
- **Remove containers (database data & web files remain safe)**: `docker compose down`
- **Run manual WP-CLI commands**:
  ```bash
  docker compose run --rm --entrypoint wp wp-auto-install plugin list
  docker compose run --rm --entrypoint wp wp-auto-install theme install generatepress --activate
  ```
- **Backup WordPress (`wp-content` + Database SQL)**:
  ```bash
  ./scripts/wp-backup.sh
  ```
- **Reset Environment (Delete local database & WordPress files)**:
  ```bash
  # Standard reset (wordpress/ & db_data/)
  ./scripts/wp-reset.sh

  # Full reset (including backups/ & .env)
  ./scripts/wp-reset.sh --all
  ```
