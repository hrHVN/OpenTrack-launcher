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

# Update config values
save_config(){
    local key="$1"
    local value="$2"

    sed -i "s/^${key}=./${key}=${value}/" "config.cfg"
}

# Render a loading bar syncronized with a program
# example: overlay_loading_bar "script.sh" 
overlay_loading_bar() {
    local progress_file=$1
    local max=50
    local progress=0
    local bar=""
    local current_line=$(tput lines)

    # Hide cursor
    tput civis

    # Ensure progress file exists
    echo 0 > "$progress_file"

    while [ "$progress" -le "$max" ]; do
        # Read progress from file
        progress=$(<"$progress_file")
        
        # Generate the bar
        bar=$(printf "%-${progress}s" "#" | tr ' ' '#')
        bar=$(printf "%-${max}s" "$bar")
        
        # Display the loading bar two lines from the bottom
        tput cup "$((current_line - 1))" 0
        echo -n "[${bar}] $((progress * 2))%"

        # Small delay to avoid constant CPU usage
        sleep 0.1
    done

    # Restore cursor visibility
    tput cnorm
    tput cup "$current_line" 0
    echo "Done!"
}