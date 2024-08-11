```sh
 _     _____ ___  _   _ _____
| |   | ____/ _ \| \ | |__  /
| |   |  _|| | | |  \| | / / 
| |___| |__| |_| | |\  |/ /_ 
|_____|_____\___/|_| \_/____|
```

# Podman on RHEL 9 Server - basic setup and use in rootless environment

*UPDATED August 2024 - tested on RHEL 9.4 and Podman 4.9*

### Prerequisites
* A RHEL9 system with basic system administration privileges.
* Podman installed: 
	https://podman.io/docs/installation
	`dnf install podman`
* Verify `shadow-utils`, `slirp4netns` packages exist

### Useful links:  
- https://blog.while-true-do.io/podman-systemd-container-management
- https://blog.while-true-do.io/podman-portainer/

### Step-by-Step Guide

#### 1. Create a Dedicated rootless User and Group  
*Currently having issues getting rootless containers working with parts of my network so sticking with rootful for now*
```bash
sudo useradd -d /var/lib/podman_service -m -s /bin/bash podman_service
sudo groupadd podman_group
sudo usermod -aG podman_group podman_service
```
* This creates a new user `podman_service` without a home directory and adds it to the `podman_group`. This user account will be used for running rootless containers

#### 2. Set a Password for the User
```bash
sudo passwd podman_service
```
* Set a strong password for the `podman_service` user.

### 3. Verify Other settings for rootful containers:
- Check `/etc/subuid` and `/etc/subgid` files to verify each user that will be allowed to create containers are listed as described here https://github.com/containers/podman/blob/main/docs/tutorials/rootless_tutorial.md
- For rootless containers, enable "lingering" for the podman_service account: `sudo loginctl enable-linger $USER`

### Networking Changes

* Create a new bridge network for our future containers with `sudo podman network create podman-custom`. The reasoning is somewhat trivial, Podman has a default network, that does not support DNS and is not addressable from Portainer (if using Portainer). 
	- After creating a basic network, set it as default
		+ In RHEL 9, the default configuration is derived from `/usr/share/containers/containers.conf`. You can copy this file to `/etc/containers/containers.conf` (`inside ~/.config` if rootless) and set the `default_network` variable if you would like to use a different subnet for the default network. You can then apply the config with `systemctl restart podman`
	- Test a basic nginx image by creating a container, assigning a newly created network and mapping 80:80 if rootful or 8080:80 if rootless
![IMG]([https://hackster.imgix.net/uploads/attachments/394225/Retropie-hotkeys.png?auto=compress%2Cformat&w=740&h=555&fit=max](https://github.com/leonzwrx/homelab-wiki/blob/main/install_guides/portainer_test.png?raw=true)

### 5. Start/Stop/Restart
* The `podman generate systemd` command simplifies the process of creating a systemd unit file.
	- Overview of the process: https://www.youtube.com/watch?v=AGkM2jGT61Y
	- Use arguments `--files` and `--name` to generate the file directly and use the container name.
		- Generate a systemd unit file for a rootful container, then copy and daemon-reload: 
	```bash
	podman generate systemd portainer --files --name
	cp container-portainer.service /etc/systemd/system/
	systemctl daemon-reload
	```
	- Generate a systemd unit file for a rootless container:
	```
	podman generate systemd nextcloud-rootless > ~/.config/systemd/user/nextcloud-rootless.service
	system
	systemctl --user daemon--reload\
	```
	Then change WantedBy section to `WantedBy=default.target`
	
### Notes

* Ensure the `podman_service` user has appropriate permissions to access the Podman socket and volumes.
* Default storage location for rootful containers is `/var/lib/containers/storage`and for rootless - `$HOME/.local/share/containers/storage`
