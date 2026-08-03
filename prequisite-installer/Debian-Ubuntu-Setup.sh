#!/usr/bin/env bash
set -euo pipefail

echo "Bootstrapping dev environment..."

# --- 0. Core prerequisites (curl, usermod) ---
if ! command -v curl >/dev/null 2>&1; then
  echo "Installing curl..."
  sudo apt-get update
  sudo apt-get install -y curl
fi
if ! command -v usermod >/dev/null 2>&1; then
  echo "Installing usermod (passwd package)..."
  sudo apt-get update
  sudo apt-get install -y passwd
fi


# --- 1. Docker daemon ---
if ! command -v docker >/dev/null 2>&1; then
  echo ""

  # Determine install method: env var override > interactive prompt > default
  if [ -n "${DOCKER_INSTALL_METHOD:-}" ]; then
    docker_choice="$DOCKER_INSTALL_METHOD"
    echo "==> DOCKER_INSTALL_METHOD set to '$docker_choice', skipping prompt."
  elif [ -t 0 ]; then
    echo "How would you like to install Docker?"
    echo "  1) Official Docker repository (recommended — latest stable release, full feature set)"
    echo "  2) Ubuntu apt repository (docker.io — simpler, but often an older version)"
    read -rp "Choose [1/2] (default: 1): " input_choice
    docker_choice="${input_choice:-1}"
  else
    echo "==> Non-interactive shell detected, defaulting to official Docker repository."
    docker_choice="1"
  fi

  if [ "$docker_choice" = "2" ] || [ "$docker_choice" = "apt" ]; then
    echo "==> Installing Docker via apt (docker.io)..."
    sudo apt-get update
    sudo apt-get install -y docker.io
  else
    echo "==> Installing Docker via official Docker repository..."
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
  echo "⚠️  You were added to the 'docker' group. Log out/in (or run 'newgrp docker') for it to take effect."
else
  echo "==> Docker already installed, skipping."
fi


# --- 2. Nix (multi-user install) ---
if ! command -v nix >/dev/null 2>&1; then
  echo "Installing Nix..."
	curl --proto '=https' --tlsv1.2 -L https://nixos.org/nix/install | sh -s -- --daemon
else
  echo "Nix already installed, skipping."
fi

# --- 3. direnv ---
if ! command -v direnv >/dev/null 2>&1; then
  echo "Installing direnv..."
  sudo apt-get update
  sudo apt-get install -y direnv
else
  echo "direnv already installed, skipping."
fi

# --- 4. Hook direnv into shell (bash example) ---
SHELL_RC="$HOME/.bashrc"
if ! grep -q "direnv hook bash" "$SHELL_RC" 2>/dev/null; then
  echo 'eval "$(direnv hook bash)"' >> "$SHELL_RC"
  echo "Added direnv hook to $SHELL_RC"
fi

# --- 5. Allow direnv in this project ---
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Running direnv allow..."
direnv allow "$SCRIPT_DIR/.."

echo "Done. Restart your shell (or 'source ~/.bashrc') then cd into the project."