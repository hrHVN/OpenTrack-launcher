#!/bin/bash

# Uninstall script for OpenTrack-Launcher
INSTALL_DIR="$HOME/.local/share/OpenTrack-Launcher"
DESKTOP_FILES_DIR="$HOME/.local/share/applications"

log() {
    sleep 0.1
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}
# Function to remove files and directories
remove_files() {
    if [ -d "$INSTALL_DIR" ]; then
        log "Removing installation directory: $INSTALL_DIR"
        rm -rf "$INSTALL_DIR"
    else
        log "Installation directory not found: $INSTALL_DIR"
    fi

    log "Searching for launcher files..."
    DESKTOP_FILES=$(grep -l "OpenTrack-Launcher" "$DESKTOP_FILES_DIR"/*.desktop 2>/dev/null)

    if [ -n "$DESKTOP_FILES" ]; then
        log "Removing launcher files:"
        for file in $DESKTOP_FILES; do
            log " - $file"
            rm -f "$file"
        done
    else
        log "No launcher files found."
    fi

    log "Uninstallation complete."
}

# Confirmation prompt
read -p "
    Are you sure you want to uninstall OpenTrack-Launcher? [y/N]: " CONFIRM
case $CONFIRM in
    [yY])
        remove_files
        overlay_loading_bar &
        loading_bar_pid=$!
        ;;
    *)
        log "Uninstallation canceled."
        ;;
esac

read -p "
    press a key to exit."