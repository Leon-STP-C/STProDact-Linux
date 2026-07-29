#!/usr/bin/env bash
set -euo pipefail

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