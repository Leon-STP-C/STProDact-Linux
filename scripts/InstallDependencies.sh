#!/usr/bin/env bash
set -euo pipefail


# shellcheck disable=SC2034
LOG_PREFIX="[InstallDependencies.sh]"
# shellcheck disable=SC1091
source "$(dirname "${BASH_SOURCE[0]}")/../common.sh"


# Add or remove packages here to change what gets installed.
packages=(
    nodejs
    npm
    caddy
    curl
	unzip
	wget
	gnupg
    apache2
    default-mysql-server
)


# Check if sudo is available, if not, set sudo_cmd to an empty string
if command -v sudo >/dev/null 2>&1; then
  sudo_cmd="sudo"
else
  sudo_cmd=""
fi

if command -v apt-get >/dev/null 2>&1; then
  log "Updating package lists..."
  $sudo_cmd apt-get update
  log "Installing packages: ${packages[*]}"
  $sudo_cmd apt-get install -y "${packages[@]}"

  #installing with yum if apt-get is not available
elif command -v yum >/dev/null 2>&1; then
  log "Installing packages with yum: ${packages[*]}"
  $sudo_cmd yum install -y "${packages[@]}"
else
  error "No supported package manager found (supported: apt-get, yum)." >&2
  exit 1
fi

#npm install adm-zip

log "${GREEN}Dependency installation complete.${RESET}"