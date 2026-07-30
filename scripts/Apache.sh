#!/usr/bin/env bash
set -eou pipefail

# Disable Autostart of Apache2 service to avoid conflicts with Caddy
sudo systemctl disable apache2 2>/dev/null