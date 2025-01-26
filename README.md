    ###################################################################
    #          _____                _____              _              #
    #         |  _  |              |_   _|            | |             #
    #         | | | |_ __   ___ _ __ | |_ __ __ _  ___| | __          #
    #         | | | | '_ \ / _ \ '_ \| | '__/ _` |/ __| |/ /          #
    #         \ \_/ / |_) |  __/ | | | | | | (_| | (__|   <           #
    #          \___/| .__/ \___|_| |_\_/_|  \__,_|\___|_|\_\          #
    #               | |                                               #
    #               |_|                                               #
    #             _                            _                      #
    #            | |                          | |                     #
    #      ______| |     __ _ _   _ _ __   ___| |__   ___ _ __        #
    #     |______| |    / _` | | | | '_ \ / __| '_ \ / _ \ '__|       #
    #            | |___| (_| | |_| | | | | (__| | | |  __/ |          #
    #            \_____/\__,_|\__,_|_| |_|\___|_| |_|\___|_|          #
    #                                                                 #
    ###################################################################

![Static Badge](https://img.shields.io/badge/version-1.1.0-green?style=plastic)

A script to automatically install OpenTrack and configure it for your Steam games running via Proton.

## Features
- **Easy installation** of OpenTrack for Steam games.
- **Supports multiple games** via Proton.
- **Automated setup** for downloading and configuring OpenTrack [latest](https://github.com/opentrack/opentrack/releases)
- **Start Menu Integration**: Creates shortcuts in the **Games** section.

- **Flatpak Support**: Works seamlessly with Flatpak installations of **Steam** and **Protontricks**. ![Static Badge](https://img.shields.io/badge/-NEW-green?style=plastic)
- **Repair Menu**: Fix issues with the launcher or settings easily. ![Static Badge](https://img.shields.io/badge/-NEW-green?style=plastic)
- **AiTrack Setup**: Automatically download and configure [latest](https://github.com/AIRLegend/aitrack/releases). ![Static Badge](https://img.shields.io/badge/-NEW-green?style=plastic)
- **Assisted Mod Installation**: Community-generated support for popular game mods. ![Static Badge](https://img.shields.io/badge/-NEW-green?style=plastic)

## Dependencies
Before installing, ensure you have the following tools installed on your system:
- **Steam** and **Protontricks** (required to locate your Steam games).
- Additional tools:
  - `wget`
  - `7zip`
  - `curl`
  - `wine` (required for running AiTrack).



## Installation Instructions

1. **Download the Latest Version**
Run the following command to download the latest release:
```bash
wget $(curl -s https://api.github.com/repos/hrHVN/OpenTrack-launcher/releases/latest | grep "browser_download_url.*tar.gz" | cut -d '"' -f 4)
```

2. **Extract the Contents**
Replace `[version number]` with the version of the downloaded file:
```bash
tar -xzf Opentrack-launcher-v[version number].tar.gz
```
example:
```bash
tar -xzf OpenTrack-Launcher-v1.1.0.tar.gz
```

3. **Change Directory**
Navigate to the directory containing the install.sh script:
```bash
cd src
```

4. **Make the Script Executable**
Grant execution permissions to the install script:
```bash
chmod +x install.sh
```

5. **Run the Install Script**
Execute the script to begin the installation:
```bash
$ ./install.sh
```

6. **Start OpenTrack-Launcher**
After installation, you can find the OpenTrack-Launcher in your Start Menu under `Games`. Launch it to begin using the tool.

7. **Configure Your Games**
Use the on-screen instructions or refer to the Wiki for help with game setup.



## Highlights of the Launcher

- The tool simplifies head-tracking setup for Steam games using OpenTrack.
- Supports installing community mods and ensures compatibility with Proton.
- Flatpak Steam and Protontricks support ensures no user is left out.

---