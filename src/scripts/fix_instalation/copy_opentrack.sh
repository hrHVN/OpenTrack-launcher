#!/bin/bash

log "Copying OpenTrack to Proton prefix..."

verify_folder "$STEAM_COMP/$RP_APP_ID/pfx/drive_c/Program Files/opentrack"

log "Installing opentrack ..."
cp -r "$APP_DIR/opentrack" "$STEAM_COMP/$RP_APP_ID/pfx/drive_c/Program Files/opentrack/"

read -p "
press enter to continue..."