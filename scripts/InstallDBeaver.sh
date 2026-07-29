#!/usr/bin/env bash
set -euo pipefail


# shellcheck disable=SC2034
LOG_PREFIX="[InstallDBeaver.sh]"
# shellcheck disable=SC1091
source "$(dirname "${BASH_SOURCE[0]}")/../common.sh"


if ! command -v apt-get >/dev/null 2>&1; then
  error "apt-get is not available on this system" >&2
  exit 1
fi

read -r -p "${YELLOW}DBeaver is a Database management tool. Installation is optional. Do you want to install it? [Y/n]${RESET} " response
case "$response" in
  [nN][oO]|[nN])
    log "Skipping DBeaver installation."
    exit 0
    ;;
  *)
    ;;
esac

wget -qO - https://dbeaver.io/debs/dbeaver.gpg.key | sudo gpg --dearmor -o /usr/share/keyrings/dbeaver.gpg
echo "deb [signed-by=/usr/share/keyrings/dbeaver.gpg] https://dbeaver.io/debs/dbeaver-ce /" | sudo tee /etc/apt/sources.list.d/dbeaver.list
sudo apt update
sudo apt install -y dbeaver-ce
log "${GREEN}DBeaver installation completed.${RESET}"
sleep 1