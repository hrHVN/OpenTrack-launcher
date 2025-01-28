#!/bin/bash
printf '\e[8;%d;%dt' "40" "100"

INSTALL_DIR="$HOME/.local/share/OpenTrack-Launcher"

# This list should only expand to acount for backwards compatibility
OLD_DIRS=(
    "$HOME/.local/share/OpenTrack_Launchers"
)
#
#   Functions   
#
#   Prints messages to the console with timestamps
#
log() {
    sleep 0.1
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}
ReadFromConf()  {
    local config="$INSTALL_DIR/config.cfg"
    local key="$1"
    
    echo $(awk -F"=" '/$key/ {print $2}' "$config")
}
#
#   Saves key-value pairs to a .cfg
#
save_config() {
    local key="$1"
    local value="$2"
    echo "DEBUG[SAVE.cfg]: ${key} ${value}"

    sed -i "s#^${key}=.*#${key}=\"${value}\"#" "$INSTALL_DIR/config.cfg"
}
#
# Install
#
overlay_loading_bar &
loading_bar_pid=$!
cat <<EOF
    ###################################################################
    #          _____                _____              _              #
    #         |  _  |              |_   _|            | |             #
    #         | | | |_ __   ___ _ __ | |_ __ __ _  ___| | __          #
    #         | | | | '_ \ / _ \ '_ \| | '__/ _\` |/ __| |/ /          #
    #         \ \_/ / |_) |  __/ | | | | | | (_| | (__|   <           #
    #          \___/| .__/ \___|_| |_\_/_|  \__,_|\___|_|\_\\          #
    #               | |                                               #
    #               |_|                                               #
    #             _                            _                      #
    #            | |                          | |                     #
    #      ______| |     __ _ _   _ _ __   ___| |__   ___ _ __        #
    #     |______| |    / _\` | | | | '_ \ / __| '_ \ / _ \ '__|       #
    #            | |___| (_| | |_| | | | | (__| | | |  __/ |          #
    #            \_____/\__,_|\__,_|_| |_|\___|_| |_|\___|_|          #
    #                                                                 #
    ###################################################################

                            Developed by hrHVN
                                (Des 2024)
                                
                https://github.com/hrHVN/OpenTrack-launcher
                                v 1.1.1
EOF
log "installing OpenTrack-Launcher ..."

#
#   Create App Location
#
mkdir -p "$INSTALL_DIR"
#
#   install OpenTrack-Launcher
#
if [ -d "$HOME/.local/share/OpenTrack-Launcher/src" ]; then
    rm -rf "$HOME/.local/share/OpenTrack-Launcher/src"
fi
cd ..
cp -r src "$HOME/.local/share/OpenTrack-Launcher"
chmod +x "$HOME/.local/share/OpenTrack-Launcher/src/app.sh"
chmod +x "$HOME/.local/share/OpenTrack-Launcher/src/uninstall.sh"
#
#   Create Launch script
#
log "Creating startmenu shortcut... "

bash -c "cat > $HOME/.local/share/applications/OpenTrack\ Launcher.desktop" <<EOF
[Desktop Entry]
Name=OpenTrack-Launcher
Comment=Launch OpenTrack-Launcher in the terminal
Exec=gnome-terminal -- $HOME/.local/share/OpenTrack-Launcher/src/app.sh
Icon=wine
Terminal=true
Type=Application
Categories=Game;
EOF

chmod +x $HOME/.local/share/applications/OpenTrack\ Launcher.desktop
update-desktop-database $HOME/.local/share/applications
#
#   Load Configs
#
log "configuring settings.."
OTL_VERSION=$(cat $INSTALL_DIR/src/version)

cat > $INSTALL_DIR/config.cfg <<EOF
#
#   OpenTrack-Launcher Locations
#
OTL_VERSION=$OTL_VERSION
APP_DIR="$HOME/.local/share/OpenTrack-Launcher"
STARTMENU_DIR="$HOME/.local/share/applications"
#
#   Local Paths
#
STEAM_CMD=""
STEAM_DIR=""
STEAM_COMP="\$STEAM_DIR/steamapps/compatdata"
PROTON_CMD=""
#
#   System information
#
OS=""
OS_V=""
USING_FLATPACK="false"
APT_I_CMD="sudo apt install"
APT_U_CMD="sudo apt update"
EOF

source $INSTALL_DIR/config.cfg
#
#   Detect OS
#
log "Checking OS settings..."

check_distro() {
    if [ -f /etc/os-release ]; then
        source /etc/os-release
        
        echo "Operating System: $NAME"
        save_config "OS" "$NAME"

        echo "Version: $VERSION_ID"
        save_config "OS_V" "$VERSION_ID"
    elif [ -f /etc/issue ]; then
        # If /etc/os-release is not found, check /etc/issue
        cat /etc/issue
        local lsb_OS=$(cat /etc/issue | awk -F' ' '{print $1}')
        local lsb_OS_V=$(cat /etc/issue | awk -F' ' '{print $3}')

        echo "Operating System: $lsb_OS"
        save_config "OS" "$lsb_OS"

        echo "Version: $lsb_OS_V"
        save_config "OS_V" "$lsb_OS_V"
    elif command -v lsb_release &>/dev/null; then
        # If neither file is found, use lsb_release (if available)
        local lsb_OS=$(lsb_release -a | grep "Description" | awk -F' ' '{print $1}')
        local lsb_OS_V=$(lsb_release -a | grep "Release" | awk -F' ' '{print $1}')

        echo "Operating System: $lsb_OS"
        save_config "OS" "$lsb_OS"

        echo "Version: $lsb_OS_V"
        save_config "OS_V" "$lsb_OS_V"
    else
        cat << EOF
    Unable to determine Linux distribution.

    Please manualy set OS name and Version in the config file.
    (You can perform this action by selecting the first option 'Change Settings for this APP'
    in the main menu.)
EOF
    fi
    sleep 0.2
    #
    #   Set Distro appropiate install and update comands
    #
    log "Setting the cli package manager commands"
    
    if command -v apt >/dev/null 2>&1; then
        save_config "APT_I_CMD" "sudo apt install"
        save_config "APT_U_CMD" "sudo apt update"

    elif command -v dnf >/dev/null 2>&1; then
        save_config "APT_I_CMD" "sudo dnf install"
        save_config "APT_U_CMD" "sudo dnf update"

    elif command -v yum >/dev/null 2>&1; then
        save_config "APT_I_CMD" "sudo yum install"
        save_config "APT_U_CMD" "sudo yum update"

    elif command -v pacman >/dev/null 2>&1; then
        save_config "APT_I_CMD" "sudo pacman install"
        save_config "APT_U_CMD" "sudo pacman update"

    elif command -v zypper >/dev/null 2>&1; then
        save_config "APT_I_CMD" "sudo zypper install"
        save_config "APT_U_CMD" "sudo zypper update"

    elif command -v apk >/dev/null 2>&1; then
        save_config "APT_I_CMD" "sudo apk install"
        save_config "APT_U_CMD" "sudo apk update"

    elif command -v emerge >/dev/null 2>&1; then
        save_config "APT_I_CMD" "sudo emerge install"
        save_config "APT_U_CMD" "sudo emerge update"

    elif command -v slackpkg >/dev/null 2>&1; then
        save_config "APT_I_CMD" "sudo slackppkg install"
        save_config "APT_U_CMD" "sudo slackppkg update"
    fi
}

check_distro
#
#   Dependency check
#
log "Checking dependencies..."
 
DEPENDENCIES=("wget" "curl" "7z")
MISSING_DEPS=()

TEST_DEPS() {
    MISSING_DEPS=()

    for dep in "${DEPENDENCIES[@]}"; do

        log "testing installation $dep"
         
        if ! command -v $dep &> /dev/null; then
            MISSING_DEPS+=($dep)
        fi
    done
}

TEST_DEPS
#
#   Error handler
#
if [ ${#MISSING_DEPS[@]} -gt 0 ]; then
    log "ERROR: The following dependencies are missing: ${MISSING_DEPS[*]}"
    log "ERROR: performing autmoated install"
     

    if $APT_I_CMD -y "${MISSING_DEPS[@]}";then
        log "All dependencies are installed."
        MISSING_DEPS=()
    else
        TEST_DEPS
    fi
fi

if [ ${#MISSING_DEPS[@]} -eq 0 ]; then
    log "All dependencies are installed."
     
else
    log "ERROR: The following dependencies are missing: ${MISSING_DEPS[*]}"
    log "Please install them before you try again."
     
    
    read -p "
        Press enter to continue"
fi
#
#   Detect Steam and protontricks instalation type
#
log "Detrmening proton and steam installations ..."

#   ProtonTricks
PROTON_CMD=$(ReadFromConf "PROTON_CMD")

if [ -z "$PROTON_CMD" ]; then
    FP_PT=$(flatpak list | awk -F' ' '/Protontricks/ {print $2}')
     

    if ! [ -z $FP_PT ]; then
        # Set the protontrics to match Flatpack
        save_config "PROTON_CMD" "flatpak run $FP_PT"
        log "Protontricks flatpack installation detected!"
         
        
        save_config "USING_FLATPAK" "true"
         

    elif  command -v "protontricks" &> /dev/null;then
        save_config "PROTON_CMD" "protontricks-launch"
        log "local Protontricks installation detected!"
         

    else
        echo "ERROR: You need to set the protontrics command manualy!"
        read -p "
    press enter to continue..."
    fi
fi

#
#   Steam 
#
STEAM_CMD=$(ReadFromConf "STEAM_CMD")
steamDirs=(
    "$HOME/.steam/steam"
    "$HOME/.var/app/com.valvesoftware.Steam/.steam/steam"
)
 
for dir in "${steamDirs[@]}"; do
    log "verifying folder $dir"
     
    if [ -d "$dir" ]; then
        save_config "STEAM_DIR" "$dir"
    fi
    sleep 0.1
done
 

if [ -z "$STEAM_CMD" ]; then
    ST_PT=$(flatpak list | awk -F' ' '/Steam/ {print $2}')
     

    if [ ! -z $ST_PT ]; then
        # Set Steam  to match Flatpack
        save_config "STEAM_CMD" "flatpak run $ST_PT"
        log "Steam flatpack instalation detected!"
         
    elif command -v "steam" &> /dev/null;then
        save_config "STEAM_CMD" "steam steam://rungameid"
        log "local Steam instalation detected!"        
    else
        log "ERROR: You need to set the steam command manualy!"

        read -p "
    press enter to continue..."
    fi
fi
#
#   Remove old instalations
#
for dir in "${OLD_DIRS[@]}"; do
    if [ -d "$dir" ]; then
        rm -rf $dir
    fi
done

log "Searching for old launcher files..."
STARTMENU_DIR=$(ReadFromConf "STARTMENU_DIR")
DESKTOP_FILES=$(grep -l "OpenTrack-Launcher" "$STARTMENU_DIR"/launch_*.desktop 2>/dev/null)
 
if [ -n "$DESKTOP_FILES" ]; then
    STEAM_CMD=$(ReadFromConf "STEAM_CMD")
    PROTON_CMD=$(ReadFromConf "PROTON_CMD")
    log "Removing launcher files:"
    
    for file in $DESKTOP_FILES; do
        RP_APP_ID=$(awk -F"=" '/Icon=/ {print $2}' "$file" | grep -o '[0-9]*')
        RP_GAME_NAME=$(awk -F"=" '/Name=/ {print $2}' "$file")
        #
        #   Create new launcher
        #
        bash -c "cat > \"$RP_FILE_PATH\"" <<EOF
[Desktop Entry]
Name=$RP_GAME_NAME
Comment=Play this game on Steam with HeadTracking
Exec=bash -c "$STEAM_CMD/$RP_APP_ID & sleep 8 && $PROTON_CMD --appid $RP_APP_ID '$APP_DIR/opentrack/opentrack.exe'"
Icon=steam_icon_$RP_APP_ID
Terminal=false
Type=Application
Categories=Game
EOF
        # Delete old file
        log " - $file"
        rm -f "$file"
    done
    update-desktop-database $HOME/.local/share/applications

else
    log "No launcher files found."
     
fi
#
# Done!
#

log "finish!"
read -p "press enter to close"
exit 0
