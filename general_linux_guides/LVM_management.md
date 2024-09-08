```bash
 _     _____ ___  _   _ _____
| |   | ____/ _ \| \ | |__  /
| |   |  _|| | | |  \| | / / 
| |___| |__| |_| | |\  |/ /_ 
|_____|_____\___/|_| \_/____|
                             
```

## LVM management
_Updated July 2024_

## LVM Overview

**Logical Volume Management (LVM)** is a storage virtualization technology that abstracts physical storage devices into logical volumes. This abstraction layer provides enhanced flexibility, management, and resilience for disk-based data storage.

### LVM Components
* **Physical Volumes (PVs):** Physical storage devices or partitions dedicated to LVM.
* **Volume Groups (VGs):** Collections of PVs that are managed as a single entity.
* **Logical Volumes (LVs):** Disk partitions created within a VG, providing a flexible way to manage storage space.

### LVM Command Categories

**LVM Layer 1: Physical Volumes**
* **`lvmdiskscan`**: Displays a summary of available physical volumes and volume groups.
* **`pvcreate <device>`**: Creates a physical volume from a specified device.
* **`pvremove <device>`**: Removes a physical volume from LVM management.
* **`pvdisplay <PV>`**: Displays detailed information about a physical volume.
* **`pvresize <PV>`**: Resizes a physical volume.

**LVM Layer 2: Volume Groups**
* **`vgcreate <VG_name> <PV>`**: Creates a volume group from one or more physical volumes.
* **`vgextend <VG_name> <PV>`**: Adds a physical volume to an existing volume group.
* **`vgreduce <VG_name> <PV>`**: Removes a physical volume from a volume group (requires data migration).
* **`vgdisplay <VG_name>`**: Displays detailed information about a volume group.
* **`vgscan`**: Scans for volume groups.

**LVM Layer 3: Logical Volumes**
* **`lvcreate -L <size> -n <LV_name> <VG_name>`**: Creates a logical volume with a specified size and name within a volume group.
* **`lvextend -L <size> <LV>`**: Extends a logical volume to a specified size.
* **`lvreduce -L <size> <LV>`**: Reduces a logical volume to a specified size (data loss possible).
* **`lvremove <LV>`**: Removes a logical volume.
* **`lvdisplay <LV>`**: Displays detailed information about a logical volume.
* **`lvscan`**: Scans for logical volumes.

### Extending a Logical Volume
```shell
cfdisk /dev/sda                        # create new partition, using all free space
pvcreate /dev/sdaX                     # initialize partition for use with LVM
vgdisplay                              # to find VG name
vgextend /dev/vgname /dev/sdaX         # this extends the volume group
lvextend -l +100%FREE /dev/vgname/root # this extends the LVM
resize2fs /dev/vgname/root             # this extends the filesystem
```

### Extending a RHEL/Fedora Logical Volume (after adding new space to the VM)

1. **Identify the new disk:**
   * Use `fdisk -l` to identify the device name (e.g., `/dev/sda`).
   * Confirm the new disk size.

2. **Create a new partition:**
   * Use `fdisk /dev/sda` (or the appropriate device).
   * Create a new primary partition (type 'n'), select the partition number (e.g., '3'), and set the first sector and last sector defaults (press Enter twice).
   * Change the partition type to LVM (type 't', select the partition number, and enter '8e').
   * Write the changes to the partition table (type 'w').
   * Reboot the system.

3. **Verify the new partition:**
   * Use `fdisk -l` to confirm the new partition with type '8e'.

4. **Create a physical volume:**
   * Convert the new partition into a physical volume:
     ```bash
     pvcreate /dev/sda3
     ```
     Replace `/dev/sda3` with the actual device name.

5. **Extend the volume group:**
   * Identify the volume group to extend (use `vgdisplay`).
   * Add the new physical volume to the volume group:
     ```bash
     vgextend VolGroup1 /dev/sda3
     ```
     Replace `VolGroup1` with the actual volume group name.

6. **Extend the logical volume:**
   * Identify the logical volume to extend (use `lvdisplay`).
   * Extend the logical volume by a specific size:
     ```bash
     lvextend -L+50G /dev/VolGroup1/LogVol00
     ```
     Replace `/dev/VolGroup1/LogVol00` with the actual logical volume path and adjust the size as needed.
   * Alternatively, use `lvextend -l +100%FREE /dev/VolGroup1/LogVol00` to use all available free space.

7. **Resize the filesystem:**
   * Use the appropriate filesystem resize tool:
     * **ext4:** `ext2online /dev/VolGroup1/LogVol00`
     * **XFS:** `xfs_growfs /dev/VolGroup1/LogVol00`
     * **Other filesystems:** `resize2fs /dev/VolGroup1/LogVol00`
