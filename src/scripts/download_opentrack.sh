#!/bin/bash

FOLDER=$1
#
#   Install OpenTrack
#
log "Installing OpenTrack ..."
sleep 0.5

if [ -d "$FOLDER/opentrack" ]; then

    log "OpenTrack is already installed. Skipping download."

    else
    #
    #   Create the Program folder
    #
    verify_folder $FOLDER
    # mkdir -p $FOLDER
    cd $FOLDER

    # Download and extract OpenTrack
    log "Downloading and extracting OpenTrack..."
    sleep 0.1

    # Download latest OpenTrack
    wget -O source.7z $(curl -s https://api.github.com/repos/opentrack/opentrack/releases/latest | grep "browser_download_url.*portable.*7z" | cut -d '"' -f 4)
    sleep 0.1

    7z x source.7z -osource
    sleep 0.1

    # Clean up
    log "cleaning up installation files..."
    sleep 0.1

    mv source/install opentrack
    rm -r source source.7z

    log "OpenTrack installed successfully."
fi