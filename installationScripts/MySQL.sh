#!/usr/bin/env bash
set -euo pipefail

DB_NAME="opcua"
DB_USER="opcua"
DB_PASSWORD="opcua"
DB_COLLATE="utf8mb4_0900_ai_ci"


# shellcheck disable=SC2034
LOG_PREFIX="[MySQL.sh]"
# shellcheck disable=SC1091
source "$(dirname "${BASH_SOURCE[0]}")/../common.sh"


log "Starting and activating MySQL service..."
#sudo systemctl enable --now mysql

log "Waiting for MySQL to be ready..."
for i in {1..10}; do
    if mysqladmin ping -h localhost --silent 2>/dev/null; then
        log "${GREEN}MySQL is ready.${RESET}"
        break
    fi
    if [ "$i" -eq 10 ]; then
        error "MySQL didn't respond after 10 attempts." >&2
        exit 1
    fi
    sleep 1
done

log "Creating database '${DB_NAME}' and user '${DB_USER}'..."
sudo mysql -u root -e "
CREATE DATABASE IF NOT EXISTS ${DB_NAME} CHARACTER SET utf8mb4 COLLATE ${DB_COLLATE};
CREATE USER IF NOT EXISTS '${DB_USER}'@'localhost' IDENTIFIED BY '${DB_PASSWORD}';
GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO '${DB_USER}'@'localhost';
FLUSH PRIVILEGES;
"

log "Checking if database exists..."
if sudo mysql -u root -e "SHOW DATABASES;" | grep -qw "${DB_NAME}"; then
    log "${GREEN}Database '${DB_NAME}' exists.${RESET}"
else
    error "Database '${DB_NAME}' could not be created." >&2
    exit 1
fi

log "Checking if user '${DB_USER}' can access the database..."
if mysql -u "${DB_USER}" -p"${DB_PASSWORD}" -h 127.0.0.1 -e "USE ${DB_NAME};" 2>/dev/null; then
    log  "${GREEN}User '${DB_USER}' can connect.${RESET}"
else
    error "User '${DB_USER}' cannot connect to the database." >&2
    exit 1
fi

log "${GREEN}MySQL setup completed successfully.${RESET}"