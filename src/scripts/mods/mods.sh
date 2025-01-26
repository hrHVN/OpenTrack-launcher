#!/bin/bash

# A shortcut to the folder wich holds mod_installer scripts
# usage: $MOD_FOLDER/my_script.sh
MOD_FOLDER="$SCRIPT_FOLDER/mods"

MOD_OPTIONS() {
    #
    #   Add a numbered selection and description here
    #
    cat << EOF

    Mod Install scripts.
    
    These scripts are designed to make it easier to install specifick mods in to a game, these are 
    typical mods that require eiter tweeking or that files are placed correctly.
    
    NOTE!! Theese scripts are experimental and may werry well not work for you. Use at own risk!
    
    
    1. Assetto Corsa Content Manager
    b. Go back to main menu
    q. quit OpenTrack-Launcher

EOF

# Read input
    read -rp "choice: " OP

# run selected program
    case "$OP" in 
        1)
            log "Installing Content Manger for Asetto Corsa"
            sleep 1
            . $MOD_FOLDER/assetto_corsa_content_manager.sh
            
            MOD_OPTIONS
        ;;
#
#   Add new script runtimes bellow this comment
#
        2)  
            log "Coming soon!"
            sleep 2
            MOD_OPTIONS
        ;;
#
#   Add new script runtimes before this comment
#
        b)
            log "going back to the Main menu"
            
            sleep 0.3
            PROGRAM_OPTIONS
        ;;
        q) 
            log "Closing OpenTrack-Launcher"

            exit 1
        ;;
    esac
}

# Display Menu
MOD_OPTIONS