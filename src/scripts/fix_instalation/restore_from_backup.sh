#!/bin/bash
#
#   Variables
#
BACKUP_FILE=$(find "$APP_DIR/backups" -name "$RP_FILE_NAME.backup" )

if [ -z "$BACKUP_FILE" ]; then
    BACKUPS=$(ls "$APP_DIR/backups" | grep ".backup")
    declare -A BACKUP_LIST
    i=1

    echo "
        The automation failed! 
        Do you see the correct backup in this list?
    "
    while read -r line; do
        echo "  $i. $line"
        BACKUP_LIST["$i"]="$line"
        ((i++))
    done <<< "$BACKUPS"

    read -rp "use this: " OP_BACKUP
    #BACKUP_FILE="$APP_DIR/$(echo "${BACKUP_LIST[$OP_BACKUP]}" | sed -E 's/^(.*?\.desktop)\..*$/\1/')"
    BACKUP_FILE="$APP_DIR/backups/$RP_FILE_NAME.backup"

    mv "$APP_DIR/backups/${BACKUP_LIST[$OP_BACKUP]}" "$BACKUP_FILE"    
fi

log "Restoring from backup.."

rm $STARTMENU_DIR/"$RP_FILE_NAME"

cp "$BACKUP_FILE" "$STARTMENU_DIR/$RP_FILE_NAME"

log "Restored $RP_FILE_NAME from backup."

update-desktop-database $HOME/.local/share/applications

read -p "
press enter to continue..."