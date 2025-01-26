#!/bin/bash

log "Loading settings"

declare -A SETTINGS

SETTINGS[1]="steam command|$STEAM_CMD|STEAM_CMD"
SETTINGS[2]="steam folder|$STEAM_DIR|STEAM_DIR"
SETTINGS[3]="proton command|$PROTON_CMD|PROTON_CMD"
SETTINGS[4]="Distro|$OS|OS"
SETTINGS[5]="Distro version|$OS_V|OS_V"
SETTINGS[6]="Use Faltpack|$USING_FLATPACK|USING_FLATPACK"
SETTINGS[7]="CLI install command|$APT_I_CMD|APT_I_CMD"
SETTINGS[8]="CLI update command|$APT_U_CMD|APT_U_CMD"

PrintSettings(){    
    
    echo ""

    for i in $(seq 1 8); do
        KEY=$(echo "${SETTINGS[$i]}" | cut -d'|' -f1)
        VALUE=$(printf "%s\n" "${SETTINGS[$i]}" | cut -d'|' -f2)
        echo "$i. $KEY: $VALUE"
    done

    echo "q. Back to main menu"
    read -rp "select setting to edit: " OP
    
    case "$OP" in
        [1-8])
            S_KEY=$(echo "${SETTINGS[$OP]}" | cut -d'|' -f3)
            read -rp "write the new value: " NEW_VAL
            
            echo "DEBUG [SWITCH]:$S_KEY = $NEW_VAL"

            save_config "$S_KEY" "$NEW_VAL"

            SETTINGS[$OP]="$(echo "${SETTINGS[$i]}" | cut -d'|' -f1)|$NEW_VAL|$(echo "${SETTINGS[$i]}" | cut -d'|' -f3)"

            log "Udated '$KEY' with '$NEW_VAL'"
            sleep 2
            PrintSettings
            ;;
        q)
            #PROGRAM_OPTIONS
            log "Returning to main menu"
            sleep 1
            ;;
        *)
            echo "
            Invalid choice, please try again.
            "
            PrintSettings
            ;;
    esac
}

PrintSettings