```bash
 _     _____ ___  _   _ _____
| |   | ____/ _ \| \ | |__  /
| |   |  _|| | | |  \| | / / 
| |___| |__| |_| | |\  |/ /_ 
|_____|_____\___/|_| \_/____|
                             
```

## btrfs RAID 1 setup
*Updated July 2024*

### Creating a BTRFS RAID 1 Array

**Note:** Replace `/dev/sdX` and `/dev/sdY` with the actual device names of your disks. Always back up your data before proceeding with any disk operations.

```bash
# Create a mount point
sudo mkdir /data

# List block devices
sudo lsblk

# Create a BTRFS RAID 1 filesystem
sudo mkfs.btrfs -L data -d raid1 -m raid1 -f /dev/sdX /dev/sdY

# Mount the filesystem
sudo mount /dev/sdX /data

# Verify the mount
sudo df -h /data

# Check BTRFS filesystem details
sudo btrfs filesystem show /data

# Get the UUID of the RAID array
sudo blkid --match-token TYPE=btrfs

# Edit the fstab file for automatic mounting
sudo nano /etc/fstab

# Add the following line to /etc/fstab (replace UUID with the actual UUID):
UUID=<UUID> /data btrfs defaults 0 2

# Reboot the system
sudo reboot
```

### Post-Setup Checks and Maintenance
```bash
# Check the mount after reboot
df -h /data

# Set appropriate permissions
sudo chown -R user:group /data

# BTRFS maintenance commands
sudo btrfs filesystem sync /data  # Force sync unwritten data blocks
sudo btrfs filesystem show /dev/sdX  # Show usage by individual devices
sudo btrfs check --force /dev/sdX  # Check filesystem integrity
sudo btrfs filesystem usage /data  # Show filesystem usage
sudo btrfs filesystem du --summarize /data  # Summarize disk usage
```

### Breaking RAID 1 into Standalone Drives (Caution: Data Loss Risk)
**Warning:** This process will convert your RAID 1 array into individual drives, potentially leading to data loss if a drive fails. Use with extreme caution and ensure proper backups.

```bash
# Convert RAID 1 to single-copy
sudo btrfs balance start -f -sconvert=single -mconvert=single -dconvert=single /data

# Remove a device from the array
sudo btrfs device remove /dev/sdX /data
```
