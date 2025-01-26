#!/bin/bash

RP_FILE_PATH="$STARTMENU_DIR/$RP_FILE_NAME"
SLEEP="$OP_SECONDS"

if [ -z $SLEEP ];then
    SLEEP=8
fi

bash -c "cat > \"$RP_FILE_PATH\"" <<EOF
[Desktop Entry]
Name=$RP_GAME_NAME
Comment=Play this game on Steam with HeadTracking
Exec=bash -c "$STEAM_CMD/$RP_APP_ID & sleep $SLEEP && $PROTON_CMD --appid $RP_APP_ID '$APP_DIR/opentrack/opentrack.exe'"
Icon=steam_icon_$RP_APP_ID
Terminal=false
Type=Application
Categories=Game
EOF

update-desktop-database $HOME/.local/share/applications

log "Updated $RP_FILE_NAME with new delay: $SLEEP s."

read -p "
press enter to continue..."