#!/bin/bash
#
# Main controller script for setting up OpenTrack integration
#
# Fetch game list and select game
#
. $SCRIPT_FOLDER/select_game.sh

if [ "$GAME_CHOICE" = "b" ]; then
    log "ERROR: Game selection failed."
    return
fi
echo "
    DATA: ${GAME_MAP[$GAME_CHOICE]}
"
#
# Create launcher
#
. $SCRIPT_FOLDER/install_launcher/startmenu_Launcher.sh
#
#   End instlation
#
log "
    Setup completed successfully!
"
read -p "
press enter to continue..."
