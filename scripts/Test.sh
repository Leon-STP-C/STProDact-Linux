#!/usr/bin/env bash
set -euo pipefail

# shellcheck disable=SC2034
LOG_PREFIX="[Test.sh]"
# shellcheck disable=SC1091
source "$(dirname "${BASH_SOURCE[0]}")/../common.sh"

log "Test"
log "${GREEN}Test erfolgreich!${RESET}"

error "Red text"

log "${BLUE}Blue text${RESET}"
log "${YELLOW}Yellow text${RESET}"