```
 _     _____ ___  _   _ _____
| |   | ____/ _ \| \ | |__  /
| |   |  _|| | | |  \| | / / 
| |___| |__| |_| | |\  |/ /_ 
|_____|_____\___/|_| \_/____|
```
_Updated July 2024_

# General RetroPie Setup

## Pre-requisites

1. Refer to the official [RetroPie documentation](https://retropie.org.uk/docs/) for detailed information.
2. Ensure you have a Raspberry Pi with a microSD card.
3. Have access to a Linux machine with `dd`, `unzip`, and `ssh` installed.
4. Make sure your Raspberry Pi is connected to a network.

## ROMs and BIOS Files

Refer to the video for additional configuration details: [Config video](https://www.youtube.com/watch?v=N3A77Oxbm3g)

## Installation Steps

1. **Download RetroPie Image:**
   - Obtain the appropriate RetroPie image for your Raspberry Pi model from [RetroPie Downloads](https://retropie.org.uk/download).

2. **Write Image to SD Card:**
   ```bash
   sudo dd if=path_to_retropie_image.img of=/dev/sdX bs=4M status=progress
   sync
   ```

3. **Initial Configuration:**
   - Insert the microSD card into your Raspberry Pi and boot it up.
   - Set up the IP address and enable SSH from the RetroPie configuration menu.

4. **Configure Video Output:**
   - Edit `/boot/config.txt` to adjust video settings like overscan and resolution.
   - Refer to your display’s documentation for optimal settings.

5. **Update System Packages:**
   ```bash
   sudo apt update && sudo apt upgrade
   sudo apt install vim neofetch htop ranger ncdu
   ```

## File Transfer and Configuration

1. **Copying Configurations from an Older RetroPie Setup:**
   - Backup and transfer the following files and directories:
     - `/etc/fstab`
     - `/etc/udev/rules.d`
     - `/etc/rc.local`
     - `/opt/retropie`
     - `/home/pi/`
     - `/boot/config.txt` and `cmdline.txt` (if needed)

2. **Controller Configuration:**
   - Follow this video for controller setup: [Controller Config](https://www.youtube.com/watch?v=Lt9Xu3r9k4o)
   - After connecting Bluetooth controllers, add the udev rules from the curse-based menu, reboot, and use EmulationStation to set up keys, including hotkeys.

![IMG](https://hackster.imgix.net/uploads/attachments/394225/Retropie-hotkeys.png?auto=compress%2Cformat&w=740&h=555&fit=max)

3. **Installing and Updating Packages:**
   - From the RetroPie setup script, manage packages:
     - **Core Packages:** `runcommand`, `EmulationStation` (if not already installed)
     - **Optional and Supplementary Packages**

4. **Fixing Random Controller Issues:**
   - Configure Bluetooth controllers for slots 1 & 2:
     ```bash
     wget -O- "https://raw.githubusercontent.com/meleu/RetroPie-joystick-selection/master/install.sh" | sudo bash
     ```

## Testing and Backup

1. **Test Games:**
   - Ensure your games are running smoothly.

2. **Backup Existing Configurations:**
   - Script for creating backups:
   ```bash
   #!/bin/bash

   # Customize backup location
   BACKUP_DIR="/media/usb/RetroPie_Backups"

   # Create timestamped backup directory
   TIMESTAMP=$(date +%Y%m%d_%H%M%S)
   BACKUP_PATH="${BACKUP_DIR}/RetroPie_Backup_${TIMESTAMP}"
   mkdir -p "$BACKUP_PATH"

   # Core configuration files
   CONFIG_FILES=(
     "/opt/retropie/configs/all/*"
     "/opt/retropie/emulators/*"
     "/opt/retropie/configs/all/retroarch/configs/*"
     "/etc/fstab"
     "/etc/udev/rules.d/*"
   )

   # Backup core configuration files
   for file in "${CONFIG_FILES[@]}"; do
     if [[ -f "$file" || -d "$file" ]]; then
       rsync -av "$file" "$BACKUP_PATH/"
     fi
   done

   # Additional backup considerations (optional):
   # - Backup ROMs and BIOS files to a separate location
   # - Consider using compression for backups (e.g., tar, zip)
   # - Implement incremental backups
   # - Rotate backups to prevent disk space issues

   echo "RetroPie backup completed successfully!"
   ```

## Game and BIOS Management

1. **ROMs Management:**
   - Navigate to `/home/pi/RetroPie/roms` and create directories for your ROMs:
     ```bash
     mkdir -p snes nes megadrive genesis n64 psx
     ```
   - Copy ROMs using `sftp` or `scp`:
     ```bash
     scp /path/to/roms/*.smc pi@<raspberry_pi_ip>:/home/pi/RetroPie/roms/snes
     ```

2. **BIOS Files:**
   - Place BIOS files in the appropriate emulator’s configuration directory (usually under `/opt/retropie/emulators/<emulator_name>`).

