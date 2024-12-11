# OpenTrack-launcher
A script to automatically install OpenTrack and configure it for your Steam games running via Proton.

## Features
- Easy installation of OpenTrack for Steam games
- Supports multiple games via Proton
- Automated process for downloading and setting up OpenTrack [latest](https://github.com/opentrack/opentrack/releases)
- Creates startmenu shortcuts in GameFolder

## Dependencies
Makeshure you have installed both Steam and Protontrics, as the scripts utilizes the comand 
```bash 
$ protontricks -l
```
to find your steam comaptible games.

- "native" installation of Steam 
- python instalation of Protontricks [GitHub](https://github.com/Matoking/protontricks)

## Installation Instructions

1. **Download the latest version:**
   Download the latest release from GitHub using `wget`:
```bash
wget https://github.com/yourusername/OpenTrack-launcher/releases/download/v1.0/Opentrack-launcher-v1.0.tar.gz
```

2. **Extract the contents**
```bash
tar -xvzf Opentrack-launcher-v1.0.tar.gz
```
3. **Change directory to the folder containing install.sh**
```bash
cd Opentrack-launcher
```
4. **Make the install script executable**
```bash
chmod +x install.sh
```

5. **Run the script to install OpenTrack for your chosen game**
```bash
./install.sh
```

