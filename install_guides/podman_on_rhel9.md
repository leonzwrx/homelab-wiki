```sh
 _     _____ ___  _   _ _____
| |   | ____/ _ \| \ | |__  /
| |   |  _|| | | |  \| | / / 
| |___| |__| |_| | |\  |/ /_ 
|_____|_____\___/|_| \_/____|
```

# Podman on RHEL 9 Server - basic setup and use in rootless environment

_UPDATED December 2024 - tested on RHEL 9.5 and Podman 5.2

### Pre-requisites
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

### 3. Verify Other settings for rootless containers:
- Check `/etc/subuid` and `/etc/subgid` files to verify each user that will be allowed to create containers are listed as described here [https://github.com/containers/podman/blob/main/docs/tutorials/rootless_tutorial.md](sudo chown -R podman_service:podman_service /sys/fs/cgroup/user.slice/user-1001.slice)
- For rootless containers, enable "lingering" for the podman_service account: `sudo loginctl enable-linger $USER`
- Verify whether your rootless configuration is properly set up. Run the following command to show how the UIDs are assigned to the user namespace:

```bash
podman unshare cat /proc/self/uid_map
```

### 4. Start/Stop/Restart
* The `podman generate systemd` command simplifies the process of creating a systemd unit file.
	- Overview of the process: [here](https://www.youtube.com/watch?v=AGkM2jGT61Y)
	- Using the `--new` `--files` and `--name` flags in `podman generate systemd` avoids conflicts with old service files and ensures a clean restart.
		- Generate a systemd unit file for a rootful container, then copy and daemon-reload: 
	```bash
	cd /tmp
    podman generate systemd --new --name --files <container_name>
	cp container-name.service /etc/systemd/system/
	systemctl daemon-reload
    systemctl enable container-<container_name>.service
	```
	- Generate a systemd unit file for a rootless container:
```bash
	cd ~/.config/systemd/user
    podman generate systemd --new --name --files <container_name>
	systemctl --user daemon-reload
    systemctl --user enable container-<container_name>.service
```
- [Optionally] Change WantedBy section to `WantedBy=default.target` and `Restart` section is set:
```ini
[Service]
Restart=always
RestartSec=5
```
### Notes
* Ensure the `podman_service` user has appropriate permissions to access the Podman socket and volumes.
* Default storage location for rootful containers is `/var/lib/containers/storage`and for rootless - `$HOME/.local/share/containers/storage`
* If having issues with permissions on a NAS volume, add matching user's uid to the ACL in TrueNAS dataset
  * Add this to podman_service `.bashrc` file if quering user service throws errors:
```bash
    # Start dbus session automatically
if [ -z "$DBUS_SESSION_BUS_ADDRESS" ]; then
    export $(dbus-launch)
fi

#add XDG_RUNTIME_DIR variable

if [ -z "$XDG_RUNTIME_DIR" ]; then
    export XDG_RUNTIME_DIR=/run/user/$(id -ru)
fi
```

### Troubleshooting / Issues
* If getting this error (came up after upgrading to Podman 5+):
`Error: current system boot ID differs from cached boot ID; an unhandled reboot has occurred. Please delete directories "/tmp/containers-user-1001/containers" and "/tmp/podman-run-1001/libpod/tmp" and re-run Podman`
  3 solutions:
  1 ) use `-tmpdir` argument 
  2 )  or an easier solution is to mount `/tmp` to a tmpfs and not xfs - enable `tmp.mount`
  3) set the temp directory in `/etc/containers/containers.conf`

*If getting this error when trying to run commands against the container: 
`Error: crun: writing file /sys/fs/cgroup/user.slice/user-1001.slice/user@1001.service/app.slice/a79d5d3bab4aac8a5c7c8d6ec481f551c6f93ff2b599d052083e7629f41dee82/cgroup.procs: Permission denied: OCI permission denied`
- This has to do with cgroups and podman somehow failing to detect the current cgroup ownership. 
- Running a prefix of `systemd-run --scope --user` should successfully execute the command against the container because it creates a proper systemd scope
- Access the  container using ssh from the base machine. Do not login as `root` user and switch to 'non-root' `podman_service` user using `su` method.