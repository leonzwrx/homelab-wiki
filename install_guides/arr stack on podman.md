```
 _     _____ ___  _   _ _____
| |   | ____/ _ \| \ | |__  /
| |   |  _|| | | |  \| | / / 
| |___| |__| |_| | |\  |/ /_ 
|_____|_____\___/|_| \_/____|
```
_Updated January 2025_

# ARR stack (Media auromation) setup on podman
- If just getting basics, NZBGet, Sonarr, Radarr, Prowlarr, Readarr, Lidarr should supplement Plex server nicely
- Decent overall guide for podman (but older version) [here](https://medium.com/@Pooch/containerized-media-server-setup-with-podman-3727727c8c5f)
- Decent basic `arr` configurtion guide [on YouTube](https://www.youtube.com/watch?v=1eqPmDvMjLY) and its [wiki](https://github.com/automation-avenue/youtube-39-arr-apps-1-click)
- Other optional pieces - lidarr, overseer, gluetun
- Most containers specify UID of 1000 - I'm replacing with UID 0 since these run on rootless `podman_service` account, which has UID of 1001 and should have NFS permissions

## Pre-requisites/Prep

1. Verify podman functions correctly and rootless containers can be deployed
2. Add necessary firewall ports to home zone
```bash
sudo firewall-cmd --permanent --zone=home --add-port=8989/tcp #sonarr
sudo firewall-cmd --permanent --zone=home --add-port=7878/tcp #radarr
sudo firewall-cmd --permanent --zone=home --add-port=6787/tcp #NZBGet
sudo firewall-cmd --permanent --zone=home --add-port=9696/tcp #prowlarr
sudo firewall-cmd --permanent --zone=home --add-port=8787/tcp #readarr
sudo firewall-cmd --permanent --zone=home --add-port=8686/tcp #lidarr
sudo firewall-cmd --permanent --zone=home --add-port=8282/tcp #qbittorrent
sudo firewall-cmd --permanent --zone=home --add-port=6881/tcp #qbittorrent
sudo firewall-cmd --permanent --zone=home --add-port=6881/udp #qbittorrent
sudo firewall-cmd --reload
```
3. Create / verify access to `/mnt/media` and make sure `podman_service` can access the share
    - NOTE: `fstab` file entry: `192.168.254.230:/mnt/z1pool/media   			/mnt/media    		nfs    nfsvers=4,rsize=8192,wsize=8192,timeo=14,retrans=2,hard,intr,x-systemd.requires=network-online.target,x-systemd.automount,x-systemd.idle-timeout=1min    0    0`
	- run `mount -a` to verify
4. Verify all "arr" containers run off the same network with `podman network create arr-network`

## Creating containers

### Sonarr
1. Create podman volumes:
```bash
podman volume create sonarr_config
```
2. Start the container using the config file [here](https://github.com/leonzwrx/homelab-wiki/blob/main/podman_configs/sonarr.txt)
### Radarr
1. Create podman volumes:
```bash
podman volume create radarr_config
```
2. Start the container using the config file [here](https://github.com/leonzwrx/homelab-wiki/blob/main/podman_configs/radarr.txt)
### Prowlarr
1. Create podman volumes:
```bash
podman volume create prowlarr_config
```
2. Start the container using the config file [here](https://github.com/leonzwrx/homelab-wiki/blob/main/podman_configs/prowlarr.txt)
### Readarr
1. Create podman volumes:
```bash
podman volume create readarr_config
```
### Lidarr
1. Create podman volumes:
```bash
podman volume create lidarr_config
```
2. Start the container using the config file [here](https://github.com/leonzwrx/homelab-wiki/blob/main/podman_configs/lidarr.txt)
### NZBGet
1. Create podman volumes:
```bash
podman volume create nzbget_config
```
2. Start the container using the config file [here](https://github.com/leonzwrx/homelab-wiki/blob/main/podman_configs/nzbget.txt)
### qBittorrent
1. Create podman volumes:
```bash
podman volume create qbittorrent_config
```
2. Start the container using the config file [here](https://github.com/leonzwrx/homelab-wiki/blob/main/podman_configs/qbittorrent.txt)

# Communication & core configuration
- For all newly deploying `arr` containers, login and set admin credentials
- In **qBittorrent**:
  1. grab temp password from container's logs and change it
  2. Go to Tools - Options - WebUI - change the user and password and tick 'bypass authentication for clients on localhost' .
- In **NZBGet**:
  1. Change both regular and control passwords (username nzbget)
  2. Add a new category `Uncategorized`, `Books`, rename `Series` to `TV` and make any other  category change if needed
- In **Prowlarr**:
1. Go to Settings - Download Clients - + symbol - Add download client - choose qBittorrent (unless you decided touse different download client)
2. Put the port id matching the WebUI in docker-compose for qBittorrent (set to 8282) and username and password that you configured for qBittorrent in previous step
3. Host - you have to change from localhost to name of the container, like `qbittorrent`:
   	![arr-qbittorrent-prowlar-connection.png](./assets/arr-qbittorrent-prowlar-connection.png)
4. Add another download client - NZBGet (specify credentials) - use the category created above:
![arr-prowlarr-nzbget-connection.png](./assets/arr-prowlarr-nzbget-connection.png)
- In **Sonarr**:
1. Go to Settings - Media Management - Add Root Folder - set `/tv` as your root folder
2. Go to Settings - Download Clients - click + symbol - choose qBittorrent and repeat the steps from Prowlarr. Add NZBGet, same as above (use Category TV)
3. Go to Settings - General - scroll down to API key - copy - go to Prowlarr - Settings - Apps -click '+' - **Sonarr** - paste API key and change 'localhost' to container names as seen below
   ![arr-prowlarr-sonarr-connection.png](./assets/arr-prowlarr-sonarr-connection.png)

- In **Radarr**:
1. Go to Settings - Media Management - Add Root Folder - set `/movies` as your root folder
2. Go to Settings - Download Clients - click + symbol - choose qBittorrent and repeat the steps from Prowlarr. Add NZBGet, same as above (use category Movies)
3. Go to Settings - General - scroll down to API key - copy - go to Prowlarr - Settings - Apps -click '+' - **Radarr** - paste API key and change 'localhost' to container names, same as above
   
- In **Readarr**:
1. Go to Settings - Media Management - Add Root Folder - set `/books` as your root folder
2. Go to Settings - Download Clients - click + symbol - choose qBittorrent and repeat the steps from Prowlarr. Add NZBGet, same as above (use category Books)
3. Go to Settings - General - scroll down to API key - copy - go to Prowlarr - Settings - Apps -click '+' - **Readarr** - paste API key and change 'localhost' to container names, same as above

- In **Lidarr**:
1. Go to Settings - Media Management - Add Root Folder - set `/books` as your root folder
2. Go to Settings - Download Clients - click + symbol - choose qBittorrent and repeat the steps from Prowlarr. Add NZBGet, same as above (use category Music)
3. Go to Settings - General - scroll down to API key - copy - go to Prowlarr - Settings - Apps -click '+' - **Lidarr** - paste API key and change 'localhost' to container names, same as above

# Other settings
- In **Prowlarr**:
1. Add appropriate indexers/torrents, then click "Sync App Indexers". Set seed ratios

- In **Lidarr**:
1. Uncheck "Replace Illegal Characters" under Media - Management
2. Under Settings - Download Clients, uncheck "Remove Downloaded Files" and "Import Automatically"

- **Plex Connection (all arrs)**
  1. Settings - Connect - Add connection to Plex:
  ![arr_connect_to_plex.png](./assets/arr_connect_to_plex.png)
