#!/usr/bin/env bash
set -euo pipefail


LOG_PREFIX="[debian-ubuntu.sh]"
# Colors
RED=$'\033[1;31m'
GREEN=$'\033[1;32m'
YELLOW=$'\033[1;33m'
BLUE=$'\033[1;34m'
RESET=$'\033[0m'

export RED
export GREEN
export YELLOW
export BLUE
export RESET

log() {
    printf "%s %b\n" "$LOG_PREFIX" "$*"
}

error() {
    printf "%s ${RED}ERROR:${RESET} %b\n" "$LOG_PREFIX" "$*" >&2
}




log "${BLUE}Bootstrapping dev environment...${RESET}"

# Make sure apt is available on the system.
if ! command -v apt-get >/dev/null 2>&1; then
  error "apt-get is not available on this system" >&2
  exit 1
fi

LOG_PREFIX="[Core-Prerequisites]"
# --- 0. Core prerequisites (curl, usermod) ---
if ! command -v curl >/dev/null 2>&1; then
  log "Installing curl..."
  sudo apt-get update
  sudo apt-get install -y curl
  log "${GREEN}curl installed.${RESET}"
fi
if ! command -v usermod >/dev/null 2>&1; then
  log "Installing usermod (passwd package)..."
  sudo apt-get update
  sudo apt-get install -y passwd
  log "${GREEN}usermod installed.${RESET}"
fi


LOG_PREFIX="[Docker Daemon]"
# --- 1. Docker daemon ---
if ! command -v docker >/dev/null 2>&1; then
  log "Docker not found, installing..."

  # Determine install method: env var override > interactive prompt > default
  if [ -n "${DOCKER_INSTALL_METHOD:-}" ]; then
    docker_choice="$DOCKER_INSTALL_METHOD"
    log "${BLUE}DOCKER_INSTALL_METHOD set to '$docker_choice', skipping prompt.${RESET}"
  elif [ -t 0 ]; then
    log "${BLUE}How would you like to install Docker?${RESET}"
    echo "  1) Official Docker repository (recommended — latest stable release, full feature set)"
    echo "  2) Ubuntu apt repository (docker.io — simpler, but often an older version)"
    read -rp "Choose [1/2] (default: 1): " input_choice
    docker_choice="${input_choice:-1}"
  else
    log "${BLUE}Non-interactive shell detected, defaulting to official Docker repository.${RESET}"
    docker_choice="1"
  fi

  if [ "$docker_choice" = "2" ] || [ "$docker_choice" = "apt" ]; then
    log "Installing Docker via apt (docker.io)..."
    sudo apt-get update
    sudo apt-get install -y docker.io
  else
    log "Installing Docker via official Docker repository..."
    sudo apt-get update
    sudo apt-get install -y ca-certificates
    sudo install -m 0755 -d /etc/apt/keyrings
    sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
    sudo chmod a+r /etc/apt/keyrings/docker.asc

    echo \
      "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
      $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
      sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

    sudo apt-get update
    sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
  fi

  sudo systemctl enable --now docker
  sudo usermod -aG docker "$USER"
  log "${YELLOW}You were added to the 'docker' group. Log out/in (or run 'newgrp docker') for it to take effect.${RESET}"
  log "${GREEN}Docker installation completed.${RESET}"
else
  log "${YELLOW}Docker already installed, skipping.${RESET}"
fi

LOG_PREFIX="[DBeaver]"
# --- 1.5. DBeaver (optional) ---

if ! command -v dbeaver >/dev/null 2>&1; then
	read -r -p "${BLUE}DBeaver is a Database management tool. Installation is optional. Do you wish to install it? [Y/n]${RESET} " response
	case "$response" in
	[nN][oO]|[nN])
		log "${YELLOW}Skipping DBeaver installation.${RESET}"
		exit 0
		;;
	*)
	esac

	wget -qO - https://dbeaver.io/debs/dbeaver.gpg.key | sudo gpg --dearmor -o /usr/share/keyrings/dbeaver.gpg
	echo "deb [signed-by=/usr/share/keyrings/dbeaver.gpg] https://dbeaver.io/debs/dbeaver-ce /" | sudo tee /etc/apt/sources.list.d/dbeaver.list
	sudo apt update
	sudo apt install -y dbeaver-ce
	log "${GREEN}DBeaver installation completed.${RESET}"
else
	log "${YELLOW}DBeaver already installed, skipping.${RESET}"
fi

LOG_PREFIX="[Nix]"
# --- 2. Nix (multi-user install) ---
if ! command -v nix >/dev/null 2>&1; then
  log "Installing Nix..."
  curl --proto '=https' --tlsv1.2 -L https://nixos.org/nix/install | sh -s -- --daemon
  log  "${GREEN}Nix installation completed.${RESET}"
else
  log "${YELLOW}Nix already installed, skipping.${RESET}"
fi

LOG_PREFIX="[direnv]"
# --- 3. direnv ---
if ! command -v direnv >/dev/null 2>&1; then
  log "Installing direnv..."
  sudo apt-get update
  sudo apt-get install -y direnv
  log "${GREEN}direnv installation completed.${RESET}"
else
  log "${YELLOW}direnv already installed, skipping.${RESET}"
fi

LOG_PREFIX="[direnv-hook]"
# --- 4. Hook direnv into shell (bash example) ---
SHELL_RC="$HOME/.bashrc"
if ! grep -q "direnv hook bash" "$SHELL_RC" 2>/dev/null; then
  log "Adding direnv hook to $SHELL_RC"
  echo 'eval "$(direnv hook bash)"' >> "$SHELL_RC"
else 
  log "${YELLOW}direnv hook already present in $SHELL_RC, skipping.${RESET}"
fi

LOG_PREFIX="[direnv-allow]"
# --- 5. Allow direnv in this project ---
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
log "Running direnv allow..."
direnv allow "$SCRIPT_DIR/.."

LOG_PREFIX="[debian-ubuntu.sh]"
log "${GREEN}Done. Restart your shell (or 'source ~/.bashrc') then cd into the project.${RESET}"