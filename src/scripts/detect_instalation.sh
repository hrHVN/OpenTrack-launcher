#!/bin/bash
#
#   ProtonTricks
#
if [ -z "$PROTON_CMD" ]; then
    FP_PT=$(flatpak list | awk -F' ' '/Protontricks/ {print $2}')

    if ! [ -z $FP_PT ]; then
        # Set the protontrics to match Flatpack
        save_config "PROTON_CMD" "flatpak run $FP_PT"
        log "Protontricks flatpack installation detected!"
        
        save_config "USING_FLATPAK" "true"

    elif  command -v "protontricks" &> /dev/null;then
        save_config "PROTON_CMD" "protontricks-launch"
        log "local Protontricks installation detected!"

    else
        echo "ERROR: You need to set the protontrics command manualy!"
        read -p "
    press enter to continue..."
    fi
fi
#
#   Steam 
#
steamDirs=(
    "$HOME/.steam/steam"
    "$HOME/.var/app/com.valvesoftware.Steam/.steam/steam"
)

for dir in "${steamDirs[@]}"; do
    log "verifying folder $dir"

    if [ -d "$dir" ]; then
        save_config "STEAM_DIR" "$dir"
    fi
    sleep 0.1
done

#if [ -z "$STEAM_DIR" ];then
#    log "Did not find STEAM installation Directory! Please manually add the path to \"./steam/steam\""    fi
#fi

if [ -z "$STEAM_CMD" ]; then
    ST_PT=$(flatpak list | awk -F' ' '/Steam/ {print $2}')

    if [ ! -z $ST_PT ]; then
        # Set Steam  to match Flatpack
        save_config "STEAM_CMD" "flatpak run $ST_PT"
        log "Steam flatpack instalation detected!"

    elif ! command -v "protontricks" &> /dev/null;then
        save_config "STEAM_CMD" "steam steam://rungameid"
        log "local Steam instalation detected!"
        
    else
        log "ERROR: You need to set the steam command manualy!"
    
        read -p "
    press enter to continue..."
    fi
fi