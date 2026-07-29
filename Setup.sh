#!/usr/bin/env bash
set -euo pipefail

#This script runs all the necessary installation scripts in the "scripts/" directory to set up the environment for the project.

chmod +x scripts/*.sh

./scripts/InstallDependencies.sh
sleep 2
./scripts/InstallDBeaver.sh
sleep 2
./scripts/DisableAutostart.sh
sleep 2
./scripts/Caddy.sh
sleep 2
./scripts/MySQL.sh
sleep 2