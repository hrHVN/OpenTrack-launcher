#!/bin/bash

#
#   Inputs
#
GAME_NAME=$1
GAME_ID=$2

if [ -z "$GAME_NAME" ] || [ -z "$GAME_ID" ]; then
    log "ERROR: Game name or ID missing."
    log "$GAME_NAME $GAME_ID"
    exit 1
fi

log "Creating Game scripts.."
sleep 0.5
#
#   Paths
#
SCRIPT_DIR="$HOME/.local/share/OpenTrack_Launchers"
STARTMENU_DIR="$HOME/.local/share/applications"
#
#   Create startmenu script
#
MENU_SCRIPT="$STARTMENU_DIR/launch_$GAME_NAME.desktop"

bash -c "cat > $MENU_SCRIPT" <<EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=$GAME_NAME
Comment=Launches $GAME_NAME with Opentrack using a script
Exec=$SCRIPT_DIR/"launch_$GAME_NAME.sh"
Icon=$HOME/.steam/root/clientui/vr/icon_steam_vr.png
Terminal=false
Categories=Game;
EOF


chmod +x "$MENU_SCRIPT"

log "installed menu script in: $MENU_SCRIPT"
#
#  Create Launcher script
#
LAUNCH_SCRIPT="$SCRIPT_DIR/launch_$GAME_NAME.sh"

bash -c "cat > $LAUNCH_SCRIPT" <<EOF
#!/bin/bash
#
# The id of your Steam app
#
APPID=$GAME_ID
#
# Path to opentrack exe relative to this script
#
OPENTRACK="$SCRIPT_DIR/opentrack/opentrack.exe"
#
#	Launch steam game
#
steam -applaunch \$APPID &
#
# Wait for steam to boot up proton
#
sleep 10
#
# Launch OpenTrack inside the proton container for this game
#
protontricks-launch --appid \$APPID "\$OPENTRACK"
EOF

chmod +x "$LAUNCH_SCRIPT"

log "installed boot script in: $LAUNCH_SCRIPT"
#
#   Refresh the menu folder
#
update-desktop-database $HOME/.local/share/applications

log "Launcher created for $GAME_NAME."