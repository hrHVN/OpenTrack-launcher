#!/bin/bash

echo "Fetching game list from Protontricks..."
sleep 1
#
#   Get games from proton
#
GAME_LIST=$(protontricks -l | grep -oP ".*?\(\d+\)")
#
#   Catch Error on proton available games
#
if [ -z "$GAME_LIST" ]; then
    echo "No games found. Ensure the games have been launched at least once."
    exit 1
fi
#
# Display numbered list of games
#
echo "Available games:"
mapfile -t GAME_ARRAY <<< "$GAME_LIST"

for i in "${!GAME_ARRAY[@]}"; do
    echo "$((i+1)). ${GAME_ARRAY[i]}"
done
#
# Prompt user for selection
#
echo
read -p "Enter the number for the game you want to install OpenTrack for: " SELECTION
#
# Validate selection
#
if ! [[ "$SELECTION" =~ ^[0-9]+$ ]] || [ "$SELECTION" -lt 1 ] || [ "$SELECTION" -gt "${#GAME_ARRAY[@]}" ]; then
    echo "Invalid selection. Exiting."
    exit 1
fi
#
#
#
SELECTED_GAME="${GAME_ARRAY[$((SELECTION-1))]}"
GAME=$(echo "$SELECTED_GAME" | grep -oP ".*(?=\s\(\d+\))" | tr ' ' '_')
GAME_ID=$(echo "$SELECTED_GAME" | grep -oP "\d+")