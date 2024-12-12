#!/bin/bash

USER_HOME=$HOME

if [ -n "$SUDO_USER" ]; then
    USER_HOME=$(eval echo ~"$SUDO_USER")
fi

SCRIPT="$USER_HOME/.local/share/OpenTrack_Launchers"
STARTMENU="$USER_HOME/.local/share/applications"

#
#   Dependency check
#
echo "Checking dependencies..."
sleep 1

DEPENDENCIES=("steam" "protontricks" "wget" "curl" "7z")
MISSING_DEPS=()

for cmd in "${DEPENDENCIES[@]}"; do
    if ! command -v $cmd &> /dev/null; then
        MISSING_DEPS+=($cmd)
    fi
done

if [ ${#MISSING_DEPS[@]} -gt 0 ]; then
    echo "The following dependencies are missing: ${MISSING_DEPS[*]}"
    echo "Please install them and rerun the script."
    exit 1
fi
#
#   Ge available games
#
echo "Fetching game list from Protontricks..."
sleep 1

GAME_LIST=$(protontricks -l | grep -oP ".*?\(\d+\)")
if [ -z "$GAME_LIST" ]; then
    echo "No games found. Ensure the games have been launched at least once."
    exit 1
fi

# Display numbered list of games
echo "Available games:"
mapfile -t GAME_ARRAY <<< "$GAME_LIST"
for i in "${!GAME_ARRAY[@]}"; do
    echo "$((i+1)). ${GAME_ARRAY[i]}"
done

# Prompt user for selection
echo
read -p "Enter the number of the game you want to install OpenTrack for: " SELECTION

# Validate selection
if ! [[ "$SELECTION" =~ ^[0-9]+$ ]] || [ "$SELECTION" -lt 1 ] || [ "$SELECTION" -gt "${#GAME_ARRAY[@]}" ]; then
    echo "Invalid selection. Exiting."
    exit 1
fi

SELECTED_GAME="${GAME_ARRAY[$((SELECTION-1))]}"
GAME=$(echo "$SELECTED_GAME" | grep -oP ".*(?=\s\(\d+\))" | tr ' ' '_')
GAME_ID=$(echo "$SELECTED_GAME" | grep -oP "\d+")

echo "Installing OpenTrack for $GAME... $GAME_ID"
sleep 1
#
#   Install Directory
#
if [ -d "$SCRIPT/opentrack" ]; then
    echo "OpenTrack is already installed. Skipping download."
    cd $SCRIPT
else
    mkdir -p $SCRIPT
    cd $SCRIPT

    # Download and extract OpenTrack
    echo "Downloading and extracting OpenTrack..."

    # Download latest OpeenTrack
    wget -O source.7z $(curl -s https://api.github.com/repos/opentrack/opentrack/releases/latest | grep "browser_download_url.*portable.*7z" | cut -d '"' -f 4)
    7z x source.7z -osource
    mv source/install opentrack
    rm -r source source.7z
fi

#
#   Install boot script
#
bash -c "cat > $STARTMENU/launch_'$GAME'.desktop" <<EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=$GAME
Comment=Launches $GAME with Opentrack using a script
Exec=$SCRIPT/"launch_$GAME.sh"
Icon=$USER_HOME/.steam/root/clientui/vr/icon_steam_vr.png
Terminal=false
Categories=Game;
EOF

#
#  install Launcher script
#
bash -c "cat > $SCRIPT/launch_$GAME.sh" <<EOF
#!/bin/bash

# The id of your Steam app
APPID=$GAME_ID

# PAth to opentrack exe relative to this script
OPENTRACK="$SCRIPT/opentrack/opentrack.exe"

#
#	Launch steam game
#
steam -applaunch \$APPID &

# sleep 10 seconds
sleep 10

# Launch OpenTrack inside the proton container for this game
protontricks-launch --appid \$APPID "\$OPENTRACK"
EOF

#
#   Make executables
#
sleep 1

chmod +x $SCRIPT/"launch_$GAME.sh"

sleep 1

chmod +x $STARTMENU/"launch_$GAME.desktop"

sleep 1

#
#   Refresh the menue folder
#
update-desktop-database $USER_HOME/.local/share/applications
