#!/usr/bin/env bash
set -euo pipefail

if ! command -v apt-get >/dev/null 2>&1; then
  echo "apt-get is not available on this system" >&2
  exit 1
fi

read -r -p $'\033[1;33mDBeaver is a Database management tool. Installation is optional. Do you want to install it? [Y/n]\033[0m ' response
case "$response" in
  [nN][oO]|[nN])
    echo -e "\033[1;33mSkipping DBeaver installation.\033[0m"
    exit 0
    ;;
  *)
    ;;
esac

wget -O - https://dbeaver.io/debs/dbeaver.gpg.key | sudo gpg --dearmor -o /usr/share/keyrings/dbeaver.gpg
echo "deb [signed-by=/usr/share/keyrings/dbeaver.gpg] https://dbeaver.io/debs/dbeaver-ce /" | sudo tee /etc/apt/sources.list.d/dbeaver.list
sudo apt update
sudo apt install -y dbeaver-ce