#!/bin/bash

#
#   Loacal variables
#
APPID=$1
FOLDER="$HOME/.local/share/OpenTrack_Launchers/opentrack"
STEAM_DIR="$HOME/.steam/steam/steamapps/compatdata/$APPID"
PROTON_PREFIX="$STEAM_DIR/pfx"
STEAM_INSTALL_DIR="$STEAM_DIR/pfx/drive_c/Program Files"

log "DEBUG: $APPID"

if [[ ! -d "$PROTON_PREFIX" ]]; then
    log "Error: Proton prefix not found."
    exit 1
fi
#
#   Copy proton
#
log "Copying OpenTrack to Proton prefix..."

verify_folder "$STEAM_INSTALL_DIR/opentrack"

log "Installing opentrack ..."
cp -r "$FOLDER"/* "$STEAM_INSTALL_DIR/opentrack/"

#
# Create a registry file to set opentrack.exe compatibility to Windows 10
#
log "creating reg_file .."

REG_FILE="$HOME/opentrack_config.reg"

cat > "$REG_FILE" <<EOF
Windows Registry Editor Version 5.00

[HKEY_CURRENT_USER\Software\Wine\AppDefaults\opentrack.exe]
"Version"="win10"
EOF

#
# Apply the registry changes
#
log "Configuring Proton..."

WINEPREFIX="$PROTON_PREFIX" wine regedit /S "$REG_FILE"

log "opentrack.exe is now set to Windows 10 compatibility."
#
# Clean up temporary registry file
#
rm -f "$REG_FILE"
#
# Confirm success
#
log "Proton configuration updated."