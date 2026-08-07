#!/bin/sh
# ST-PRO DACT app entry point.
# Docker equivalent of the installer steps that configure the Windows service
# user (STProDactSvc):
#   - create the ProgramData directories (config, logs, appdata, profile, tmp)
#   - grant that user write access (the installer used icacls ... /grant)
# Here the 'node' user of the image plays the role of the service user: we
# create the data directories, make them writable by 'node' and then run the
# app with dropped privileges.
set -e

DATA_DIR="${STPRO_DATA_DIR:-/srv/app}"

mkdir -p \
	"$DATA_DIR/config" \
	"$DATA_DIR/logs" \
	"$DATA_DIR/appdata/Roaming" \
	"$DATA_DIR/appdata/Local" \
	"$DATA_DIR/profile" \
	"$DATA_DIR/tmp"

chown -R node:node "$DATA_DIR"

if [ "$(id -u)" = "0" ]; then
	exec su -s /bin/sh node -c 'exec "$@"' _ "$@"
fi

exec "$@"
