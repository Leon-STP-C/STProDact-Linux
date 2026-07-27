#!/usr/bin/env bash
set -euo pipefail

# Add or remove packages here to change what gets installed.
packages=(
    nodejs
    npm
    caddy
    python3
    curl
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
  echo "Updating package lists..."
  $sudo_cmd apt-get update
  echo "Installing packages: ${packages[*]}"
  $sudo_cmd apt-get install -y "${packages[@]}"

  #installing with yum if apt-get is not available
elif command -v yum >/dev/null 2>&1; then
  echo "Installing packages with yum: ${packages[*]}"
  $sudo_cmd yum install -y "${packages[@]}"
else
  echo "No supported package manager found (supported: apt-get, yum)." >&2
  exit 1
fi

npm install adm-zip

echo "Dependency installation complete."
echo "Please note that DBeaver for Database Management has to be installed manually. You can download it from https://dbeaver.io/download/."