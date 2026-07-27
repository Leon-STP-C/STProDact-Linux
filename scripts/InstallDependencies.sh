#!/usr/bin/env bash
set -euo pipefail

# Add or remove packages here to change what gets installed.
packages=(
    nodejs
    npm
    caddy
    python3
    apache2
    default-mysql-server
)

if command -v sudo >/dev/null 2>&1; then
  sudo_cmd="sudo"
else
  sudo_cmd=""
fi

if command -v apt-get >/dev/null 2>&1; then
  echo "Updating package lists..."
  $sudo_cmd apt-get update

  echo "Installing packages: ${packages[*]}"
  $sudo_cmd apt-get install -y "${packages[@]}"
elif command -v yum >/dev/null 2>&1; then
  echo "Installing packages with yum: ${packages[*]}"
  $sudo_cmd yum install -y "${packages[@]}"
else
  echo "No supported package manager found (supported: apt-get, yum)." >&2
  exit 1
fi

echo "Dependency installation complete."
echo Please note that DBeaver for Database Management has to be installed manually. You can download it from https://dbeaver.io/download/.