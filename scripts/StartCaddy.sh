#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_FILE="$SCRIPT_DIR/release/config/Caddyfile"

if [[ ! -f "$CONFIG_FILE" ]]; then
  echo "Caddy config not found at $CONFIG_FILE" >&2
  exit 1
fi

if ! command -v caddy >/dev/null 2>&1; then
  echo "caddy is not installed or not on PATH" >&2
  exit 1
fi

# Allows Caddy to bind to privileged ports (like 80) without running as root
sudo setcap cap_net_bind_service=+ep $(which caddy)

echo "Starting Caddy with config: $CONFIG_FILE"
exec caddy run --config "$CONFIG_FILE" --adapter caddyfile
