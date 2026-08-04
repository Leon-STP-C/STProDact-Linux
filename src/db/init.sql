-- ST-PRO DACT database provisioning.
-- Equivalent of the SQL executed by the Windows installer (STProDact.iss):
--   mysql.exe -u root -h 127.0.0.1 -P 3306 -e "CREATE DATABASE IF NOT EXISTS opcua
--     CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;
--     CREATE USER IF NOT EXISTS 'opcua'@'localhost' IDENTIFIED BY 'opcua';
--     GRANT ALL PRIVILEGES ON opcua.* TO 'opcua'@'localhost';"
--
-- The Windows setup only created 'opcua'@'localhost' (everything runs on the same
-- host). Inside Docker the app runs in its own container, so the 'opcua' user is
-- also granted for '%' (connections from any container on the compose network).
-- These statements are only executed on the first initialization of the data
-- directory; on a reinstall with an existing volume they are skipped, matching
-- the "reuse existing data" behaviour of the installer.

CREATE DATABASE IF NOT EXISTS opcua CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;

CREATE USER IF NOT EXISTS 'opcua'@'localhost' IDENTIFIED BY 'opcua';
CREATE USER IF NOT EXISTS 'opcua'@'%' IDENTIFIED BY 'opcua';

GRANT ALL PRIVILEGES ON opcua.* TO 'opcua'@'localhost';
GRANT ALL PRIVILEGES ON opcua.* TO 'opcua'@'%';

FLUSH PRIVILEGES;
