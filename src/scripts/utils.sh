#!/bin/bash

# Add shared utility functions here if needed
log() {
    sleep 0.1
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

# Replace spaces in a string with underscores
to_underscore() {
    echo "$1" | sed 's/ /_/g'
}

# verify folders
verify_folder() {
    if [[ ! -z "$1" && ! -d "$1" ]]; then
        log "installing folder $1"
        mkdir -p "$1"
    fi
}