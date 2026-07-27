#!/usr/bin/env bash
set -euo pipefail

#This script runs all the necessary installation scripts in the "scripts/" directory to set up the environment for the project.

chmod +x scripts/*.sh

./scripts/InstallDependencies.sh
./scripts/DisableAutostart.sh
./scripts/StartCaddy.shw