#!/bin/bash

#
#   Dependency check
#
log "Checking dependencies..."

sleep 0.5

DEPENDENCIES=("steam" "protontricks" "wget" "curl" "7z")
MISSING_DEPS=()

for dep in "${DEPENDENCIES[@]}"; do
    log "locating $dep ..."
    sleep 0.1
    if ! command -v $dep &> /dev/null; then
        MISSING_DEPS+=($dep)
    fi
done
#
#   Error handler
#
if [ ${#MISSING_DEPS[@]} -gt 0 ]; then
    log "ERROR: The following dependencies are missing: ${MISSING_DEPS[*]}"
    log "ERROR: Please install them and rerun the script."
    exit 1
fi

log "All dependencies are installed."