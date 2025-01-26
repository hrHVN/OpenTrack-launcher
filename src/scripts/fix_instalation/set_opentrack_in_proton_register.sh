#!/bin/bash

#
#   Loacal variables
#
PROTON_PREFIX="$STEAM_COMP/$APPID/pfx"

if [ ! -d "$STEAM_COMP/$APPID/pfx" ]; then
    log "Error: Proton prefix not found."
    GAME_CHOICE="b"
    return
fi
#
# Create a registry file to set opentrack.exe compatibility to Windows 10
#
log "creating reg_file .."

REG_FILE="$APP_DIR/opentrack_config.reg"

cat > "$REG_FILE" <<EOF
Windows Registry Editor Version 5.00

[HKEY_CURRENT_USER\Software\Wine\AppDefaults\opentrack.exe]
"Version"="win10"
EOF

#
# Apply the registry changes
#
log "Configuring Proton..."
$PROTON_CMD "$APPID" regedit "$REG_FILE"

# Check if the command succeeded
if [[ $? -eq 0 ]]; then
    log "Success: opentrack.exe is now set to Windows 10 compatibility."
else
    log "Error: Failed to apply registry changes with protontricks."
    exit 1
fi
#
# Clean up temporary registry file
#
rm -f "$REG_FILE"
#
# Confirm success
#
log "Proton configuration updated."

read -p "
press enter to continue..."