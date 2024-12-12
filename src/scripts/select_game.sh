#!/bin/bash

#
# Fetch game list from Protontricks
#
log "Fetching game list from Protontricks..."
GAME_LIST=$(protontricks -l | grep '(')

sleep 0.5

if [ -z "$GAME_LIST" ]; then
    log "ERROR: No games found. Ensure you have launched the game at least once in Steam."
    exit 1
fi

echo "Available games:"
i=1
declare -A GAME_MAP

while read -r line; do
    GAME_NAME=$(echo "$line" | sed 's/ (.*//')
    GAME_ID=$(echo "$line" | grep -oP '\(\K[0-9]+')
    GAME_NAME_UNDERSCORE=$(to_underscore "$GAME_NAME")

    echo "$i. $GAME_NAME ($GAME_ID)"
    GAME_MAP["$i"]="$GAME_NAME_UNDERSCORE:$GAME_ID"
    ((i++))
    sleep 0.1
done <<< "$GAME_LIST"
#
# User selects a game
#

read -rp "Enter the number of the game: " GAME_CHOICE
if ! [[ $GAME_CHOICE =~ ^[0-9]+$ ]] || [ -z "${GAME_MAP[$GAME_CHOICE]}" ]; then
    log "ERROR: Invalid choice."
    exit 1
fi

log "You have selected: ${GAME_MAP[$GAME_CHOICE]}"
export GAME_DATA="${GAME_MAP[$GAME_CHOICE]}"

