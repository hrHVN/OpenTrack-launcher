#!/bin/bash

# Uninstall script for OpenTrack-Launcher
INSTALL_DIR="$HOME/.local/share/OpenTrack-Launcher"
DESKTOP_FILES_DIR="$HOME/.local/share/applications"
#
#   Loading bar
#
_PROGRESS=0
overlay_loading_bar() {
    # Temporary file for holding progress values
    local progress_file="/tmp/OTL_progress.cfg"
    local max=50
    local progress=0
    local bar=""
    local current_line=$(tput lines)

    # Hide cursor
    tput civis
    echo 0 > "$progress_file"
    _PROGRESS=0

    while [ "$progress" -le "$max" ]; do
        # Read progress from file
        progress=$progress_file
        
        # Generate the bar
        bar=$(printf "%-${progress}s" "#" | tr ' ' '#')
        bar=$(printf "%-${max}s" "$bar")
        
        # Display the loading bar two lines from the bottom
        tput cup "$((current_line - 1))" 0
        printf "\r[${bar}] $((progress * 2))%%"

        # Small delay to avoid constant CPU usage
        sleep 0.01
    done

    # Restore cursor visibility
    tput cnorm
    tput cup "$current_line" 0
}
UpdateLoadingBar() {
    _PROGRESS=$(($_PROGRESS + $1))
    echo $_PROGRESS > "/tmp/OTL_progress.cfg"
}
CompleteLoadingBar() {
    local progress="/tmp/OTL_progress.cfg"
    if [ $progress -lt 50 ];then
        echo 50 > "/tmp/OTL_progress.cfg"
    fi
    sleep 1

    kill "$1" 2>/dev/null
    return
}

log() {
    sleep 0.1
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}
# Function to remove files and directories
remove_files() {
    if [ -d "$INSTALL_DIR" ]; then
        log "Removing installation directory: $INSTALL_DIR"
        rm -rf "$INSTALL_DIR"
        UpdateLoadingBar 5
    else
        log "Installation directory not found: $INSTALL_DIR"
    fi

    log "Searching for launcher files..."
    DESKTOP_FILES=$(grep -l "OpenTrack-Launcher" "$DESKTOP_FILES_DIR"/*.desktop 2>/dev/null)
    UpdateLoadingBar 5

    if [ -n "$DESKTOP_FILES" ]; then
        log "Removing launcher files:"
        for file in $DESKTOP_FILES; do
            UpdateLoadingBar 1
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

CompleteLoadingBar $loading_bar_pid
read -p "
    press a key to exit."