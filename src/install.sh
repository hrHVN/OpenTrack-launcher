#!/bin/bash
#
# Main controller script for setting up OpenTrack integration
#
#   Variables
#
SCRIPT_DIR=$(dirname "$0")
SCRIPT_DIR=$(cd "$SCRIPT_DIR" && pwd)
SCRIPT_FOLDER="$SCRIPT_DIR/scripts"
SCRIPT_LAUNCHER="$HOME/.local/share/OpenTrack_Launchers"
#
# make all scripts executable
#
chmod +x "$SCRIPT_FOLDER"/*.sh
#
# Load utilities
#
. "$SCRIPT_FOLDER/utils.sh"

$SCRIPT_FOLDER/splash_screen.sh || exit 1
log "Starting OpenTrack Launcher installation process..."
#
# Check dependencies
#
. $SCRIPT_FOLDER/check_dependencies.sh || exit 1
#
#   Get installation folders
#
. $SCRIPT_FOLDER/build_directorys.sh || exit 1
#
# Fetch game list and select game
#
. $SCRIPT_FOLDER/select_game.sh
#GAME_DATA=$("$SCRIPT_FOLDER/select_game.sh")
if [ $? -ne 0 ]; then
    log "ERROR: Game selection failed."
    exit 1
fi
GAME_NAME=$(echo "$GAME_DATA" | cut -d':' -f1)
GAME_ID=$(echo "$GAME_DATA" | cut -d':' -f2)

#
# Download and set up OpenTrack
#
. $SCRIPT_FOLDER/download_opentrack.sh "$SCRIPT_LAUNCHER" || exit 1
#
# Create launcher
#
. $SCRIPT_FOLDER/create_launcher.sh $GAME_NAME $GAME_ID
#
# copy Opentrack inside pfx
#
. $SCRIPT_FOLDER/copy_opentrak_in_pfx.sh "$GAME_ID" || exit 1
#
#   End instlation
#
log "Setup completed successfully!"
exit 0
