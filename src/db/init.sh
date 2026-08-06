#!/usr/bin/env bash
# ST-PRO DACT database provisioning.
# Equivalent of the SQL executed by the Windows installer (STProDact.iss):
#   mysql.exe -u root -h 127.0.0.1 -P 3306 -e "CREATE DATABASE IF NOT EXISTS opcua
#     CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;
#     CREATE USER IF NOT EXISTS 'opcua'@'localhost' IDENTIFIED BY 'opcua';
#     GRANT ALL PRIVILEGES ON opcua.* TO 'opcua'@'localhost';"
#
# The database and user are created from the DB_NAME/DB_USER/DB_PASSWORD values
# in src/.env, which compose.yaml maps onto MYSQL_DATABASE/MYSQL_USER/MYSQL_PASSWORD.
# As a .sh file, this script is sourced by the MySQL entrypoint with those
# environment variables available (plain .sql files would be hard-coded).
#
# The Windows setup only created 'opcua'@'localhost' (everything runs on the same
# host). Inside Docker the app runs in its own container, so the user is also
# granted for '%' (connections from any container on the compose network).
# These statements are only executed on the first initialization of the data
# directory; on a reinstall with an existing volume they are skipped, matching
# the "reuse existing data" behaviour of the installer.

mysql --protocol=socket -uroot -hlocalhost -p"${MYSQL_ROOT_PASSWORD}" <<EOSQL
CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\` CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;

CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'localhost' IDENTIFIED BY '${MYSQL_PASSWORD}';
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';

GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'localhost';
GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';

FLUSH PRIVILEGES;
EOSQL
