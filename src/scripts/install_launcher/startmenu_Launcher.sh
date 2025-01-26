#!/bin/bash
#
#   Inputs
#
GAME_NAME=$(echo "$GAME_DATA" | cut -d':' -f1)
GAME_ID=$(echo "$GAME_DATA" | cut -d':' -f2)
#
#   Paths
#
DESKTOP_FILE=$(echo "$GAME_NAME.desktop" | sed 's/ /\\ /g')
EXISTING_FILE=$(find $STARTMENU_DIR -name "$DESKTOP_FILE")
#
#   Local Functions
#
CreateNewLauncher() {
    local location=$(echo "$1" | sed 's/ /\\ /g')

    bash -c "cat > $location" <<EOF
[Desktop Entry]
Name=$GAME_NAME
Comment=Play this game on Steam
Exec=bash -c "$STEAM_CMD/$GAME_ID & sleep 8 && $PROTON_CMD --appid $GAME_ID '$APP_DIR/opentrack/opentrack.exe'"
Icon=steam_icon_$GAME_ID
Terminal=false
Type=Application
Categories=Game
EOF
}

# Backup the original launcher and recreate it with the new steam/proton launcher
ModifyLauncher(){
    log "creating backup of $EXISTING_FILE"
    local BACKUP_FILE=$(find $APP_DIR/backups -name "$EXISTING_FILE.backup")
    
    if [ -z "$BACKUP_FILE" ]; then
        cp "$EXISTING_FILE" "$APP_DIR/backups/$DESKTOP_FILE.backup"
    fi

    CreateNewLauncher "$EXISTING_FILE"
}

# Create a new launcher
DualLaunchers(){
    local DUAL_FILE=$(to_underscore "OTL $GAME_NAME.desktop")
    bash -c "cat > $STARTMENU_DIR/$DUAL_FILE" <<EOF
[Desktop Entry]
Name=OpenTrack-Launcher: $GAME_NAME
Comment=Play this game on Steam with HeadTracking
Exec=bash -c "$STEAM_CMD/$GAME_ID & sleep 8 && $PROTON_CMD --appid $GAME_ID '$APP_DIR/opentrack/opentrack.exe'"
Icon=steam_icon_$GAME_ID
Terminal=false
Type=Application
Categories=Game
EOF
}

Loop(){
cat << EOF
    
    $1

    would you like for us to modify this file or create a new seperate launcher that 
    launches $GAME_NAME and OpenTrack for you?

    [y]: Yes, modify the existing file (Creates a backup of the original file)
    [n]: Make a seperate launcher

EOF
    read -rp "answer: " CHOICE
    
    if [ "$CHOICE" = "y" ]; then
        ModifyLauncher
    elif [ "$CHOICE" = "n" ]; then
        DualLaunchers
    else 
        # Invalid Input
        log "ERROR: Invalid choice."
        return
    fi
}
#
#   Main Loop
#   Locating the existing launcher -> either modify/duplicate/create new launcher
#
if ! [ -n "$EXISTING_FILE" ]; then
    FILE_LIST=$(ls "$STARTMENU_DIR" | grep ".desktop")
    declare -A FILE_MAP
    i=1

cat << EOF

The automation did not find an existing launcher for $GAME_NAME.

Please select the correct launcher file bellow;

EOF

    while read -r line; do
    # Display the options
    echo "$i. $line" 

    # Create a map of the files
    FILE_MAP["$i"]="$line"

    # increment
    ((i++))
    sleep 0.1
    done <<< "$FILE_LIST"

    # Catch all option
    echo "$i. My game is not listed"

    #Get the user input
    read -rp "select file: " FILE_CHOICE

    if [ $FILE_CHOICE = $i ]; then
        # Create a new launcher
        GAME_NAME=$(awk -F= '/^Name=/ {print $2}' "$STARTMENU_DIR/${FILE_MAP[$FILE_CHOICE]}")
        GAME_ID=$(sed -n 's/^Icon=steam_icon_\([0-9]*\)$/\1/p' "$STARTMENU_DIR/${FILE_MAP[$FILE_CHOICE]}")
        
        log "creating start menu shortcut..."

        CreateNewLauncher "$STARTMENU_DIR/$GAME_NAME.desktop"
        
    elif ! [[ $FILE_CHOICE =~ ^[0-9]+$ ]] || [ -z "${FILE_MAP[$FILE_CHOICE]}" ]; then
        # Invalid Input
        log "ERROR: Invalid choice."

    elif [ $FILE_CHOICE = 'b']; then
        log "Retruning to main menu"
    else 
        # Continue with the app
        DESKTOP_FILE="${FILE_MAP[$FILE_CHOICE]}"
        EXISTING_FILE="$STARTMENU_DIR/${FILE_MAP[$FILE_CHOICE]}"
        GAME_NAME=$(awk -F= '/^Name=/ {print $2}' "$STARTMENU_DIR/${FILE_MAP[$FILE_CHOICE]}")
        GAME_ID=$(sed -n 's/^Icon=steam_icon_\([0-9]*\)$/\1/p' "$STARTMENU_DIR/${FILE_MAP[$FILE_CHOICE]}")

        Loop "using this launcher $EXISTING_FILE "
    fi
else
    # Continue with the app
    Loop "We found this launcher: $EXISTING_FILE."
fi
#
#   Refresh the menu folder
#
update-desktop-database $HOME/.local/share/applications

log "Launcher created for $GAME_NAME"

read -p "
press enter to continue..."