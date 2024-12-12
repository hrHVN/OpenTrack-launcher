#!/bin/bash

#
#   Instalation folders
#
installDirs=(
    "$HOME/.local/share/OpenTrack_Launchers" 
    "$HOME/.local/share/applications"
    )
for dir in "${installDirs}"; do
    log "verifying folder $dir"
    verify_folder "$dir"
done
#
#   Steam Paths
#
steamDirs=(
    "$HOME/.steam"
    "$HOME/.steam/steam/steamapps/compatdata"
)
for dir in "${steamDirs}"; do
    log "verifying folder $dir"
    if [[ ! -d "$dir" ]]; then
        log "Did not find $dir"
    fi
done
