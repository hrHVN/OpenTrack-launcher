#!/bin/bash

#
#   Dependency check
#
log "Checking dependencies..."
sleep 0.2

DEPENDENCIES=("wget" "curl" "7z")
MISSING_DEPS=()

TEST_DEPS() {
    MISSING_DEPS=()

    for dep in "${DEPENDENCIES[@]}"; do
        log "testing installation $dep"
        sleep 0.1
        if ! command -v $dep &> /dev/null; then
            MISSING_DEPS+=($dep)
        fi
    done
}

TEST_DEPS
#
#   Error handler
#
if [ ${#MISSING_DEPS[@]} -gt 0 ]; then
    log "ERROR: The following dependencies are missing: ${MISSING_DEPS[*]}"
    log "ERROR: performing autmoated install"
    
    if $APT_I_CMD -y "${MISSING_DEPS[@]}";then
        log "All dependencies are installed."
        MISSING_DEPS=()
    else
        TEST_DEPS
    fi
fi

if [ ${#MISSING_DEPS[@]} -eq 0 ]; then
    log "All dependencies are installed."
else
    log "ERROR: The following dependencies are missing: ${MISSING_DEPS[*]}"
    log "Please install them before you try again."
    
    read -p "
        Press enter to continue"
fi
