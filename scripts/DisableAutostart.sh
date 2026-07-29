#!/usr/bin/env bash
set -euo pipefail

# This script disables the autostart of certain services on system boot.

sudo systemctl disable apache2
sudo systemctl disable caddy