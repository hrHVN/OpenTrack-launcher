#!/bin/bash

AC_DIR="$STEAM_DIR/steamapps/common/assettocorsa"
AC_PRFX="$STEAM_COMP/244210/pfx/drive_c/Program\ Files\(x86)/Steam/config/loginusers.vdf"
STEAM_USER_ID="$STEAM_DIR/../root/config/loginusers.vdf"

log "Starting the instalation of Assetto Corsa content Manager.."

if [ ! -d $AC_DIR ]; then
    log "ERROR: Could not find the Assetto Corsa folder.. "
    log "i looked in: $AC_DIR"

    CompleteLoadingBar $_overlay_PID
    read -p "
    press a key to return to menu ..."
    return
fi
#
#   Temp folder
#
verify_folder "$APP_DIR/temp"
 

cd "$APP_DIR/temp"
#
#   download
#
wget "https://github.com/gro-ove/actools/releases/latest/download/Content.Manager.zip"


unzip "Content.Manager.zip"

#
#   Backup original launcher
#
log "creating backup of old launcher.."
mv "$AC_DIR/AssettoCorsa.exe" "$AC_DIR/AssettoCorsa_backup.exe"

#
#   install the new launcher
#
log "installing new launcher.."
mv "$APP_DIR/temp/Content\ Manager.exe" "$AC_DIR/Content\ Manager.exe"

# Tricking steam to launch content manager
ln "$AC_DIR/Content\ Manager.exe" "$AC_DIR/AssettoCorsa.exe"

#
#   setting up user creds
#
ln -sfq "$STEAM_USER_ID" "$AC_PRFX"

#
#   winecfg
#
$PROTON_CMD 123456 dlls add dwrite=n

#
#   End
#
log "finished"

cat <<EOF
    To complete the settup of content manager you can watch this video
    
    https://www.youtube.com/watch?v=8qy_RQr8LbM&t=435s

    this is the path to AC root folder:
    $AC_DIR
EOF
read -p "
    press a key to continue ..."