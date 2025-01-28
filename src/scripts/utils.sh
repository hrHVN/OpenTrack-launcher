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
# escapes spaces for propper file referencing
escape_name_space() {
    echo "$1" | sed 's/ /\\ /g'
}
# verify folders
verify_folder() {
    if [[ ! -z "$1" && ! -d "$1" ]]; then
        log "installing folder $1"
        mkdir -p "$1"
    fi
}

# Update config values
save_config() {
    local key="$1"
    local value="$2"
    echo "DEBUG[SAVE.cfg]: ${key} ${value}"

    sed -i "s#^${key}=.*#${key}=\"${value}\"#" "$SCRIPT_DIR/config.cfg"
}

# Render a loading bar syncronized with a program
_PROGRESS=0
overlay_loading_bar() {
    # Temporary file for holding progress values
    local progress_file="/tmp/OTL_progress-tmp"
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
        progress=$(cat $progress_file)
        
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
#
#   Adds a precentage value to the loading bar 
#   UpdateLoadingBar 13                 # This adds 13% to the bar, it does NOT set the value to 13
#
UpdateLoadingBar() {
    if [ "$_PROGRESS" -lt 49 ];then
        _PROGRESS=$(($_PROGRESS + $1))
        echo "$_PROGRESS" > "/tmp/OTL_progress-tmp"
    fi
}
#
#   enshure the background task is propperly dead before ending the program
#   example: 
#   overlay_loading_bar &                   # Sending the loading bar to the background
#   loading_bar_pid=$!                      # capture and store the PID
#   CompleteLoadingBar $loading_bar_pid     # Kill the background proces and set the bar to 100%
#
CompleteLoadingBar() {
    local progress="/tmp/OTL_progress-tmp"
    if [ $progress -lt 50 ];then
        echo 50 > "/tmp/OTL_progress-tmp"
    fi
    sleep 1

    kill "$1" 2>/dev/null
    return
}

check_distro() {
    if [ -f /etc/os-release ]; then
        source /etc/os-release
        
        echo "Operating System: $NAME"
        save_config "OS" "$NAME"

        echo "Version: $VERSION_ID"
        save_config "OS_V" "$VERSION_ID"
    elif [ -f /etc/issue ]; then
        # If /etc/os-release is not found, check /etc/issue
        cat /etc/issue
        local lsb_OS=$(cat /etc/issue | awk -F' ' '{print $1}')
        local lsb_OS_V=$(cat /etc/issue | awk -F' ' '{print $3}')

        echo "Operating System: $lsb_OS"
        save_config "OS" "$lsb_OS"

        echo "Version: $lsb_OS_V"
        save_config "OS_V" "$lsb_OS_V"
    elif command -v lsb_release &>/dev/null; then
        # If neither file is found, use lsb_release (if available)
        local lsb_OS=$(lsb_release -a | grep "Description" | awk -F' ' '{print $1}')
        local lsb_OS_V=$(lsb_release -a | grep "Release" | awk -F' ' '{print $1}')

        echo "Operating System: $lsb_OS"
        save_config "OS" "$lsb_OS"

        echo "Version: $lsb_OS_V"
        save_config "OS_V" "$lsb_OS_V"
    else
        cat << EOF
    Unable to determine Linux distribution.

    Please manualy set OS name and Version in the config file.
    (You can perform this action by selecting the first option 'Change Settings for this APP'
    in the main menu.)
EOF
    fi
    sleep 0.2
    #
    #   Set Distro appropiate install and update comands
    #
    log "Setting the cli package manager commands"
    
    if command -v apt >/dev/null 2>&1; then
        save_config "APT_I_CMD" "sudo apt install"
        save_config "APT_U_CMD" "sudo apt update"

    elif command -v dnf >/dev/null 2>&1; then
        save_config "APT_I_CMD" "sudo dnf install"
        save_config "APT_U_CMD" "sudo dnf update"

    elif command -v yum >/dev/null 2>&1; then
        save_config "APT_I_CMD" "sudo yum install"
        save_config "APT_U_CMD" "sudo yum update"

    elif command -v pacman >/dev/null 2>&1; then
        save_config "APT_I_CMD" "sudo pacman install"
        save_config "APT_U_CMD" "sudo pacman update"

    elif command -v zypper >/dev/null 2>&1; then
        save_config "APT_I_CMD" "sudo zypper install"
        save_config "APT_U_CMD" "sudo zypper update"

    elif command -v apk >/dev/null 2>&1; then
        save_config "APT_I_CMD" "sudo apk install"
        save_config "APT_U_CMD" "sudo apk update"

    elif command -v emerge >/dev/null 2>&1; then
        save_config "APT_I_CMD" "sudo emerge install"
        save_config "APT_U_CMD" "sudo emerge update"

    elif command -v slackpkg >/dev/null 2>&1; then
        save_config "APT_I_CMD" "sudo slackppkg install"
        save_config "APT_U_CMD" "sudo slackppkg update"
    fi
}