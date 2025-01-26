#!/bin/bash
#
#   Variables
#
REP_FOLDER="$SCRIPT_FOLDER/fix_instalation"
INST_FOLDER="$SCRIPT_FOLDER/install_launcher"
RP_APP_ID=0
RP_GAME_NAME=""
RP_FILE_NAME=""

RP_LAUNCHER=0
FILE_LIST=$(ls "$STARTMENU_DIR" | grep ".desktop")
declare -A FILE_MAP

#
#   Splash Screen
#
REP_SPLASH(){
cat << EOF

    ###################################################################
    #                                                                 #
    #                  _____                  _                       #  
    #                 |  __ \                (_)                      #  
    #                 | |__) |___ _ __   __ _ _ _ __                  #  
    #                 |  _  // _ \ '_ \ / _\` | | '__|                 #  
    #                 | | \ \  __/ |_) | (_| | | |                    #  
    #                 |_|  \_\___| .__/ \__,_|_|_|                    #  
    #                            | |                                  #  
    #                            |_|                                  #
    #                                                                 #
    #                                                                 #
    ###################################################################

    Repair options:
    
    x: Delete the launcher
    u: Recreate/update the launcher
    r: Add OpenTrack to proton's RegEx
    i: Increase the delay before OpenTrack launches (Default 8 seconds)
    c: Create a local copy of opentrack inside the proton enviroment
    R: Restore the launcher from backup (Normal Steam shortcut)
    t: Tips/FAQ

    -------------------------------------------------------------------
    q. Back to main menu
    b. Go back to launcher selection
    -------------------------------------------------------------------
EOF
    sleep 0.5
    if [ $RP_LAUNCHER -ne 0 ]; then
        echo "
    Working with: ${FILE_MAP[$RP_LAUNCHER]}
        "
    else
        echo "
    Launcher list:
        "
    fi
}
#
#   List all the launcher scripts
#
select_launcher(){
    local i=1

    while read -r line; do
        # Display the options
        echo "  $i. $line" 

        # Create a map of the files
        FILE_MAP["$i"]=$(echo "$line" | sed 's/ (.*//')

        # increment
        ((i++))
        sleep 0.1
    done <<< "$FILE_LIST"

    read -rp "
    Select a launcher to repair: " OP
    RP_LAUNCHER=$OP

    if [[ "$RP_LAUNCHER" == "b"  ||  "$RP_LAUNCHER" == "q" ]]; then
        log "Returning to the main menu"
        return
    else
        RP_FILE_NAME="${FILE_MAP[$RP_LAUNCHER]}"
        RP_APP_ID=$(awk -F"=" '/Icon=/ {print $2}' "$RP_FILE_NAME" | grep -o '[0-9]*')
        RP_GAME_NAME=$(awk -F"=" '/Name=/ {print $2}' "$RP_FILE_NAME")

        echo "  Working with: $RP_FILE_NAME"
    fi
}

repair_action(){
    case "$1" in
        x) 
            log "Delete the launcher"
            log "DEBUG: $STARTMENU_DIR/${FILE_MAP[$RP_LAUNCHER]}"
            rm "$STARTMENU_DIR/${FILE_MAP[$RP_LAUNCHER]}"
            
            unset FILE_MAP[$RP_LAUNCHER]
            RP_LAUNCHER=0

            update-desktop-database $HOME/.local/share/applications

            loop    # Return to the Repair menu
        ;;
        u) 
            log "Recreate/update the launcher"
            # Get the correct Game name and ID

            . $REP_FOLDER/update_launcher.sh "${FILE_MAP[$RP_LAUNCHER]}"
            
            loop    # Return to the Repair menuSTARTMENU_DIR
        ;;
        r)
            log "Add OpenTrack to proton's RegEx"

            . $REP_FOLDER/set_opentrack_in_proton_register.sh

            loop    # Return to the Repair menu
        ;;
        i) 
            log "Increase the delay before OpenTrack launches (Default 8 seconds)"

            read -rp "How much longer should OpenTrack wait before launching? seconds: " OP_SECONDS

            . $REP_FOLDER/update_launcher.sh 
    
            loop    # Return to the Repair menu
        ;;
        c) 
            log "Create a local copy of opentrack inside the proton enviroment"

            . $REP_FOLDER/copy_opentrack.sh

            loop    # Return to the Repair menu
        ;;
        R) 
            log "Restore the launcher from backup (Normal Steam shortcut)"
            
            . $REP_FOLDER/restore_from_backup.sh

            loop    # Return to the Repair menu
        ;;
        q) 
            log "Going back to main menu"
            sleep 0.3
            return
        ;;
        b) 
            log "select a diffrent Launcher"
            sleep 0.2
            
            REP_SPLASH
            select_launcher
            
            if [[ "$RP_LAUNCHER" == "b"  ||  "$RP_LAUNCHER" == "q" ]]; then
                log "Returning to the main menu"
                return
            fi

            read -rp "  select operation: " OP_REP
            repair_action $OP_REP
        ;;
        t)
            cat <<EOF
    # Troubleshooting Runtime Issues
    If an app isn't running properly inside a Proton container, the issue often stems from compatibility 
    problems with the Windows runtime. Here's how you can address common issues:

    ## 1. Compatibility Mode
    Choosing option [r] will add a new registry entry for OpenTrack within the Proton environment. 
    This entry configures Windows to use compatibility mode (Windows 10) for OpenTrack. 
    In many cases, this alone may resolve runtime issues. However, if the issue persists, read on.

    ## 2. Hard Copy Reference
    Sometimes, Windows behaves oddly and requires a hard copy of the program to "reference" internally. 
    Selecting option [c] will copy OpenTrack.exe into the Proton folder associated with your game. 
    This step can resolve compatibility issues where the registry entry alone doesn't suffice.

    ## 3. Inconsistent OpenTrack Launch
    The scripts work by sending a command to Steam to launch the specified game [GameID]. 
    After waiting 8 seconds, Protontricks is triggered to launch OpenTrack inside the Proton container for [GameID].

    Launch inconsistencies often occur when the delay is too short. This causes Protontricks to attempt launching 
    OpenTrack before Steam has fully initialized. Choosing option [i] allows you to increase the delay, which 
    may help resolve this issue.

    **Common causes of delays include:** Vulkan shader compilation, updates, or CPU load.

    ## 4. Other Issues
    Sometimes, simply recreating the launcher can fix unexplained problems. 
    Selecting option [u] will regenerate the launcher from scratch.

    ## 5. Restore the Original Game Shortcut
    If you'd like to remove the OpenTrack launch command from the game shortcut and restore it to a 
    standard Steam game launcher, choose option [R].
EOF
            read -p "return to the menu"
            loop
        ;;
        *) 
            loop
            log "Invalid choice: $OP"
        ;;
    esac
}
#
#   Repair loop
#
loop(){
    REP_SPLASH
    read -rp "  select operation: " OP_REP
    repair_action $OP_REP
}

# Initial loop
REP_SPLASH
select_launcher

if [[ "$RP_LAUNCHER" == "b"  ||  "$RP_LAUNCHER" == "q" ]]; then
        log "Returning to the main menu"
        return
fi

read -rp "  select operation: " OP_REP
repair_action $OP_REP