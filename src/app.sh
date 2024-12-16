#!/bin/bash

SCRIPT_DIR=$(dirname "$0")
SCRIPT_DIR=$(cd "$SCRIPT_DIR" && pwd)
SCRIPT_FOLDER="$SCRIPT_DIR/scripts"
#
# Load utilities
#
. $SCRIPT_FOLDER/utils.sh
. $SCRIPT_FOLDER/splash_screen.sh
overlay_loading_bar 
#
#   Load config file 
#
. $SCRIPT_DIR/config.cfg

if [ -z "$INSTALL_LOCATION" ]; then
    VERSION=$(cat version)
    
   cat > ./config.cfg <<EOF
INSTALL_LOCATION=""
VERSION=$VERSION
STEAM_CMD=""
PROTON_CMD=""
EOF

    . $SCRIPT_DIR/config.cfg
else 
    # Validate Version
    VERSION=$(cat version)
fi

#
#   Detect OS
#

#
#   Detect Steam and protontricks instalation type
#

#
#   Variables
#
SCRIPT_LAUNCHER="$HOME/.local/share/OpenTrack_Launchers"
#
# make all scripts executable
#
chmod +x "$SCRIPT_FOLDER"/*.sh


#
# Main Loop
# Render program options
#


# Read input

# run selected program

#
#   Return to Main menu
#