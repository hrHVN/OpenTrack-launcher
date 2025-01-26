#!/bin/bash

INSTALL_DIR="$HOME/.local/share/OpenTrack-Launcher"
# This list should only expand to acount for backwards compatibility
OLD_DIRS=(
    "$HOME/.local/share/OpenTrack_Launchers"
)
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
    tput cnorm
    kill "$1" 2>/dev/null
    return
}

log() {
    sleep 0.1
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}
#
#
#
log "installing OpenTrack-Launcher ..."

overlay_loading_bar &
loading_bar_pid=$!
#
#   Create App Location
#
mkdir -p "$INSTALL_DIR"
UpdateLoadingBar 1
#
#   install OpenTrack-Launcher
#
cd ..
cp -r src "$HOME/.local/share/OpenTrack-Launcher"
UpdateLoadingBar 1

chmod +x "$HOME/.local/share/OpenTrack-Launcher/src/app.sh"
UpdateLoadingBar 1

chmod +x "$HOME/.local/share/OpenTrack-Launcher/src/uninstall.sh"
UpdateLoadingBar 1
#
#   Create Launch script
#
log "Creating startmenu shortcut... "
UpdateLoadingBar 1

bash -c "cat > $HOME/.local/share/applications/OpenTrack\ Launcher.desktop" <<EOF
[Desktop Entry]
Name=OpenTrack-Launcher
Comment=Launch OpenTrack-Launcher in the terminal
Exec=gnome-terminal -- $HOME/.local/share/OpenTrack-Launcher/src/app.sh
Icon=wine
Terminal=true
Type=Application
Categories=Game;
EOF

chmod +x $HOME/.local/share/applications/OpenTrack\ Launcher.desktop
UpdateLoadingBar 1

update-desktop-database $HOME/.local/share/applications
UpdateLoadingBar 5

#
#   Load Configs
#
log "configuring settings.."
UpdateLoadingBar 1

OTL_VERSION=$(cat $INSTALL_DIR/src/version)

cat > $INSTALL_DIR/config.cfg <<EOF
#
#   OpenTrack-Launcher Locations
#
OTL_VERSION=$OTL_VERSION
APP_DIR="$HOME/.local/share/OpenTrack-Launcher"
STARTMENU_DIR="$HOME/.local/share/applications"
#
#   Local Paths
#
STEAM_CMD=""
STEAM_DIR=""
STEAM_COMP="\$STEAM_DIR/steamapps/compatdata"
PROTON_CMD=""
#
#   System information
#
OS=""
OS_V=""
USING_FLATPACK="false"
APT_I_CMD="sudo apt install"
APT_U_CMD="sudo apt update"
EOF
UpdateLoadingBar 3

source $INSTALL_DIR/config.cfg
#
#   Detect OS
#
log "Checking OS settings..."
. $INSTALL_DIR/src/scripts/check_distro
UpdateLoadingBar 5

#
#   Detect Steam and protontricks instalation type
#
log "Detrmening proton and steam installations ..."
. $INSTALL_DIR/src/scripts/detect_instalation.sh
UpdateLoadingBar 5
#
# Checking dependencies
#
. $INSTALL_DIR/src/scripts/check_dependencies.sh
UpdateLoadingBar 5

#
# Download and set up OpenTrack
#
log "Detecting OpenTrack"
. $INSTALL_DIR/src/scripts/install_launcher/download_opentrack.sh 
UpdateLoadingBar 15
#
#   Remove old instalations
#
for dir in "${OLD_DIRS[@]}"; do
    if [ -d "$dir" ]; then
        rm -rf $dir
    fi
    UpdateLoadingBar 1
done

log "Searching for old launcher files..."

DESKTOP_FILES=$(grep -l "OpenTrack-Launcher" "$STARTMENU_DIR"/launch_*.desktop 2>/dev/null)
UpdateLoadingBar 5

if [ -n "$DESKTOP_FILES" ]; then
    source $INSTALL_DIR/config.cfg
    
    log "Removing launcher files:"
    
    for file in $DESKTOP_FILES; do
        UpdateLoadingBar 1

        RP_APP_ID=$(awk -F"=" '/Icon=/ {print $2}' "$file" | grep -o '[0-9]*')
        RP_GAME_NAME=$(awk -F"=" '/Name=/ {print $2}' "$file")
        #
        #   Create new launcher
        #
        bash -c "cat > \"$RP_FILE_PATH\"" <<EOF
[Desktop Entry]
Name=$RP_GAME_NAME
Comment=Play this game on Steam with HeadTracking
Exec=bash -c "$STEAM_CMD/$RP_APP_ID & sleep 8 && $PROTON_CMD --appid $RP_APP_ID '$APP_DIR/opentrack/opentrack.exe'"
Icon=steam_icon_$RP_APP_ID
Terminal=false
Type=Application
Categories=Game
EOF
        # Delete old file
        log " - $file"
        rm -f "$file"
    done
    update-desktop-database $HOME/.local/share/applications

else
    log "No launcher files found."
    UpdateLoadingBar 1
fi
#
# Done!
#
CompleteLoadingBar $loading_bar_pid

log "finish!"
exit 0