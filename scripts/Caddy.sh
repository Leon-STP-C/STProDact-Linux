#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
CONFIG_FILE="$REPO_ROOT/release/config/Caddyfile"

if [[ ! -f "$CONFIG_FILE" ]]; then
  echo "Caddy config not found at $CONFIG_FILE" >&2
  exit 1
fi

if ! command -v caddy >/dev/null 2>&1; then
  echo "caddy is not installed or not on PATH" >&2
  exit 1
fi

# Allows Caddy to bind to privileged ports (like 80) without running as root
sudo setcap cap_net_bind_service=+ep "$(which caddy)"

# Check if Caddy is already running and stop it if necessary
if pgrep -x caddy >/dev/null 2>&1; then
  echo "Stopping existing Caddy process..."
  sudo pkill -x caddy || true
fi

echo "Starting Caddy with config: $CONFIG_FILE"
nohup caddy run --config "$CONFIG_FILE" --adapter caddyfile > /tmp/stprodact-caddy.log 2>&1 &
echo -e "\033[1;32mCaddy started in the background (PID $!)\033[0m"