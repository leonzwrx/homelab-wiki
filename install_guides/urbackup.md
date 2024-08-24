```sh
 _     _____ ___  _   _ _____
| |   | ____/ _ \| \ | |__  /
| |   |  _|| | | |  \| | / / 
| |___| |__| |_| | |\  |/ /_ 
|_____|_____\___/|_| \_/____|
```

# UrBackup guide

*UPDATED August 2024*

General guide by CTT: https://christitus.com/urbackup/

### Prerequisites
* Set up a container on the backend with the running service
	- podman setup here: https://github.com/leonzwrx/homelab-wiki/tree/main/podman_configs
	- Set an admin password
	- configure backup windows, exclusions
	
### Client setup - Windows

Windows uses a executable that is made with the “Add New Client” button. By default, windows clients will have full image backup on and no file based backups. Everything should be automated and most defaults should work 	 ![IMAGE](./urbackup_screenshots/urbackup_windows_client.png?raw=true)

**All of the key settings should reside in config files at `C:\Program Files\URbackup\urbackup\data` **

### Client setup - Linux

 ![IMAGE](./urbackup_screenshots/urbackup_clients.png?raw=true)

+ Download the Linux client and install with defaults from http://rhel9-apps.nilva.local:55414 interface
	 ![IMAGE](./urbackup_screenshots/urbackup_linux_client.png?raw=true)
+ Once it's installed and downloaded, manually input the settings into configs at `/usr/local/var/urbackup/data`
* If needed, reference Windows VM's `urbackup/data` folder as a guide
+ `sudo urbackupclientctl status` to verify connection status - it reads everything from `/usr/local/var/urbackup/data`
+ `sudo urbackupclientctl add-backupdir -d /FastData` to start adding directories
	* `sudo urbackupclientctl add-backupdir -d /home -f` to not follow symlinks
```bash
➜ sudo urbackupclientctl list-backupdir
PATH          NAME     FLAGS                                          
------------- -------- ---------------------------------------------- 
/home         home     symlinks_optional,share_hashes                 
/etc          etc      follow_symlinks,symlinks_optional,share_hashes 
/mnt/FastData FastData follow_symlinks,symlinks_optional,share_hashes 
/mnt/Data     Data     follow_symlinks,symlinks_optional,share_hashes 
```

+ To uninstall, run `sudo uninstall_urbackupclient`