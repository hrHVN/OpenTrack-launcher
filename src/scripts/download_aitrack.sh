#!/bin/bash

log "Installing AiTrack ..."
sleep 0.2

if [ -d "$APP_DIR/aitrack" ]; then

    log "aitrack is already installed. Skipping download."
    read -p "
        OpenTrack-Launcher currently does not suport automatic updating of the AiTrack instalation."
    return
fi

if ! command -v $dep &> /dev/null;then
    log "ERROR: Too launch AiTrack we need WINE instaled. Please install wine."
    read -p "
        press a key to go back.."
    return
fi

cd $APP_DIR
#
#   Create the Program folder
#
verify_folder "$APP_DIR/aitrack"

# Download and extract OpenTrack
log "Downloading and extracting OpenTrack..."
sleep 0.1

# Download latest OpenTrack
wget -O source.zip https://github.com/AIRLegend/aitrack/releases/download/v0.7.1-alpha/aitrack-v0.7.1.zip
sleep 0.1

unzip source.zip
# Renaming the folder to remove versioning
mv aitrack-v0.7.1 aitrack
sleep 0.1

#creating launcher
bash -c "cat > $STARTMENU_DIR/AiTrack.desktop" <<EOF
[Desktop Entry]
Name=AiTrack
Comment=Launch AiTrack in Wine
Exec=sh -c "cd $HOME/.local/share/OpenTrack-Launcher/aitrack/ && wine aitrack.exe"
Icon=wine
Terminal=false
Type=Application
Categories=Utility;
EOF

update-desktop-database $HOME/.local/share/applications

# Clean up
log "cleaning up installation files..."
sleep 0.1

rm -r source.zip

log "OpenTrack installed successfully."

read -p "
    Press a key to continue"