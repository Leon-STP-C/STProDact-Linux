#!/usr/bin/env bash
set -euo pipefail

DB_NAME="opcua"
DB_USER="opcua"
DB_PASSWORD="opcua"


# shellcheck disable=SC2034
LOG_PREFIX="[MySQL.sh]"
# shellcheck disable=SC1091
source "$(dirname "${BASH_SOURCE[0]}")/../common.sh"


log "Starte und aktiviere MySQL-Dienst..."
sudo systemctl enable --now mysql

log "Warte, bis der Dienst bereit ist..."
for i in {1..10}; do
    if mysqladmin ping -h localhost --silent 2>/dev/null; then
        log "${GREEN}MySQL ist bereit.${RESET}"
        break
    fi
    if [ "$i" -eq 10 ]; then
        error " MySQL antwortet nach 10 Versuchen nicht." >&2
        exit 1
    fi
    sleep 1
done

log "Lege Datenbank '${DB_NAME}' und User '${DB_USER}' an..."
sudo mysql -u root -e "
CREATE DATABASE IF NOT EXISTS ${DB_NAME} CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;
CREATE USER IF NOT EXISTS '${DB_USER}'@'localhost' IDENTIFIED BY '${DB_PASSWORD}';
GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO '${DB_USER}'@'localhost';
FLUSH PRIVILEGES;
"

log "Prüfe, ob Datenbank existiert..."
if sudo mysql -u root -e "SHOW DATABASES;" | grep -qw "${DB_NAME}"; then
    log "${GREEN}Erfolg: Datenbank '${DB_NAME}' vorhanden.${RESET}"
else
    error "Datenbank '${DB_NAME}' konnte nicht angelegt werden." >&2
    exit 1
fi

log "Prüfe, ob User '${DB_USER}' zugreifen kann..."
if mysql -u "${DB_USER}" -p"${DB_PASSWORD}" -h 127.0.0.1 -e "USE ${DB_NAME};" 2>/dev/null; then
    log  "${GREEN}Erfolg: User '${DB_USER}' kann sich verbinden.${RESET}"
else
    error "User '${DB_USER}' kann sich nicht verbinden." >&2
    exit 1
fi

log "Fertig."