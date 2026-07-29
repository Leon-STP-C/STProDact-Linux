#!/usr/bin/env bash
set -euo pipefail


# shellcheck disable=SC2034
LOG_PREFIX="[Caddy.sh]"
# shellcheck disable=SC1091
source "$(dirname "${BASH_SOURCE[0]}")/../common.sh"


SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
CONFIG_FILE="$REPO_ROOT/release/config/Caddyfile"

if [[ ! -f "$CONFIG_FILE" ]]; then
  error "Caddy config not found at $CONFIG_FILE" >&2
  exit 1
fi

if ! command -v caddy >/dev/null 2>&1; then
  error "caddy is not installed or not on PATH" >&2
  exit 1
fi

# Allows Caddy to bind to privileged ports (like 80) without running as root
sudo setcap cap_net_bind_service=+ep "$(which caddy)"

# Check if Caddy is already running and stop it if necessary
if pgrep -x caddy >/dev/null 2>&1; then
  log "${YELLOW}Existing Caddy process found. Stopping the already running instance...${RESET}" >&2
  sudo pkill -x caddy || true

  # make sure caddy has stopped before continuing
  while pgrep -x caddy >/dev/null 2>&1; do
    sleep 0.5
  done
fi

log "Starting Caddy with config: $CONFIG_FILE"
nohup caddy run --config "$CONFIG_FILE" --adapter caddyfile > /tmp/stprodact-caddy.log 2>&1 &
log "${GREEN}Caddy started in the background (PID $!)${RESET}"
sleep 1