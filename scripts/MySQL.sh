#!/usr/bin/env bash
set -euo pipefail

DB_NAME="opcua"
LOG_PREFIX="[mysql.sh]"

echo "${LOG_PREFIX} Starte und aktiviere MySQL-Dienst..."
sudo systemctl enable --now mysql

echo "${LOG_PREFIX} Warte, bis der Dienst bereit ist..."
for i in {1..10}; do
    if mysqladmin ping -h localhost --silent 2>/dev/null; then
        echo "${LOG_PREFIX} MySQL ist bereit."
        break
    fi
    if [ "$i" -eq 10 ]; then
        echo "${LOG_PREFIX} FEHLER: MySQL antwortet nach 10 Versuchen nicht." >&2
        exit 1
    fi
    sleep 1
done

echo "${LOG_PREFIX} Lege Datenbank '${DB_NAME}' an (falls nicht vorhanden)..."
sudo mysql -u root -e "CREATE DATABASE IF NOT EXISTS ${DB_NAME} CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"

echo "${LOG_PREFIX} Prüfe, ob Datenbank existiert..."
if sudo mysql -u root -e "SHOW DATABASES;" | grep -qw "${DB_NAME}"; then
    echo "${LOG_PREFIX} Erfolg: Datenbank '${DB_NAME}' vorhanden."
else
    echo "${LOG_PREFIX} FEHLER: Datenbank '${DB_NAME}' konnte nicht angelegt werden." >&2
    exit 1
fi

echo "${LOG_PREFIX} Fertig."