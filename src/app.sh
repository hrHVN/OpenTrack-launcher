#!/bin/bash

######################
printf '\e[8;%d;%dt' "40" "100" # Set the terminal window to a default size
# Get the size of the terminal for use with > $(printf "%-${TERMINAL_WIDTH}s" "" | tr ' ' '*')
# to draw a line across the screen
TERMINAL_WIDTH=$(tput cols) 
#######################

SCRIPT_DIR=$(dirname "$0")
SCRIPT_DIR=$(cd "$SCRIPT_DIR" && pwd)
SCRIPT_FOLDER="$SCRIPT_DIR/scripts"
echo $SCRIPT_DIR
#
# Load utilities
#
chmod +x $SCRIPT_FOLDER/*.sh
sleep 0.5

. $SCRIPT_FOLDER/utils.sh
#. $SCRIPT_FOLDER/splash_screen.sh
#
#   Load config file 
#
if [ ! -f "$SCRIPT_DIR/../config.cfg" ]; then
    OTL_VERSION=$(cat $SCRIPT_DIR/version)
    
   cat > $SCRIPT_DIR/config.cfg <<EOF
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
USING_FLATPAK="false"
APT_I_CMD="sudo apt install"
APT_U_CMD="sudo apt update"
EOF
    sleep 0.2
    #
    # make all scripts executable
    #
    chmod +x "$SCRIPT_FOLDER"/*.sh
else 
    # Validate Version
    OTL_VERSION=$(cat $SCRIPT_DIR/version)
fi
sleep 0.2
source $SCRIPT_DIR/../config.cfg

#
#   Detect OS
#
log "Checking OS settings..."
if [ -z $OS ];then
    check_distro
fi
#
#   Detect Steam and protontricks instalation type
#
log "Detrmening proton and steam installations ..."
if [[ -z $STEAM_CMD && -z $STEAM_DIR ]]; then
    . $SCRIPT_FOLDER/detect_instalation.sh
fi
#
# Checking dependencies
#
. $SCRIPT_FOLDER/check_dependencies.sh
#
# Download and set up OpenTrack
#
log "Detecting OpenTrack"
if [ ! -d "$APP_DIR/opentrack" ]; then
    . $SCRIPT_FOLDER/install_launcher/download_opentrack.sh 
fi
#
#   Variables
#
SCRIPT_LAUNCHER="$APP_DIR"

#
# Main Loop
# Render program options
#
PROGRAM_OPTIONS() {
    #clear
    . $SCRIPT_FOLDER/splash_screen.sh

    cat << EOF
$(printf "%-${TERMINAL_WIDTH}s" "" | tr ' ' '*')
    Settings:
    
    Using Flatpak: $USING_FLATPAK
    Steam command: $STEAM_CMD
    Steam directory: $STEAM_DIR
    Games directory: $PROTON_DIR
    Protontrics command: $PROTON_CMD
    Start menu directory: $STARTMENU_DIR

$(printf "%-${TERMINAL_WIDTH}s" "" | tr ' ' '*')

    Time to make some modifications!

    1. Change settings for OpenTrack-Launcher
    2. Set up game launcher for OpenTrack
    3. Fix issue with launcher
    4. Get help with a mod installation
    5. Install AiTrack
    q. Quit OpenTrack-Launcher
    u. Uninstall this program

EOF

# Read input
    read -rp "choice: " OP

# run selected program
    case "$OP" in 
        1)
            while true; do
                log "Configure OpenTrack_Launcher"

                . $SCRIPT_FOLDER/settings_opentrack_launcher.sh
                break
            done
            PROGRAM_OPTIONS
        ;;
        2)
            while true; do
                log "Starting installation"

                . $SCRIPT_FOLDER/install_launcher/install_launcher.sh
                break
            done
            PROGRAM_OPTIONS
        ;;
        3)
            while true; do
                log "Repair launcher"

                . $SCRIPT_FOLDER/fix_instalation/repair.sh
                break
            done
            PROGRAM_OPTIONS
        ;;
        4)
            while true; do
                log "Mod installers"

                . $SCRIPT_FOLDER/mods/mods.sh
                break
            done
            PROGRAM_OPTIONS
        ;;
        5)  
            # Install  AiTrack
            while true; do
                . $SCRIPT_FOLDER/download_aitrack.sh
                
                log "AiTracker sucessfully installed!"
                break
            done
            PROGRAM_OPTIONS
        ;; 
        q) 
            log "Closing OpenTrack-Launcher"
            sleep 1

            exit 1
        ;;
        u)
            log "uninstalling OpenTrack-Launcher"
            $SCRIPT_DIR/uninstall.sh
            exit 0
        ;;
        *) 
            PROGRAM_OPTIONS
            log "Invalid choice: $OP"
        ;;
    esac
}

# Display Menu
PROGRAM_OPTIONS