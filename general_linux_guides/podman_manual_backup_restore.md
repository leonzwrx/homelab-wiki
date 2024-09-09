```bash
 _     _____ ___  _   _ _____
| |   | ____/ _ \| \ | |__  /
| |   |  _|| | | |  \| | / / 
| |___| |__| |_| | |\  |/ /_ 
|_____|_____\___/|_| \_/____|
                             
```
# Podman - backup and restore (manually)
_Updated September 2024_

These steps show how to migrate  a container from a rootful environment to a rootless environment under a different user (e.g., `podman_service`), by backing up and then restoring

### 1. **Backup the Rootful Container**

Before migrating, back up the container to ensure you can restore it in the rootless environment.

#### 1.1 **Commit the Rootful Container to an Image**
First, commit the current running container as a backup image:

```bash
sudo podman commit uptime-kuma uptime-kuma-backup
```

#### 1.2 **Save the Image to a File**
Save the container image as a tarball to move it to the rootless user environment:

```bash
sudo podman save -o /tmp/uptime-kuma-backup.tar uptime-kuma-backup
```

#### 1.3 **Backup Volumes (If Required)**
If the volume `uptime-kuma_data` contains important data, back it up as well:

```bash
sudo tar -czvf /tmp/uptime-kuma_data.tar.gz -C $(sudo podman volume inspect uptime-kuma_data --format {{.Mountpoint}}) .
```

### 2. **Switch to the Rootless User (podman_service)**

#### 2.1 **Log in or `su` to the Rootless User**
Log in as the `podman_service` user that you want to run the container under:

```bash
su - podman_service
```

### 3. **Restore the Container in Rootless Podman**

#### 3.1 **Transfer the Backup Files**
Move the tarball and the volume backup to the rootless user's environment:

```bash
mv /tmp/uptime-kuma-backup.tar ~/
mv /tmp/uptime-kuma_data.tar.gz ~/
```

#### 3.2 **Load the Container Image in Rootless Podman**
Now, load the container image into rootless Podman:

```bash
podman load -i ~/uptime-kuma-backup.tar
```

#### 3.3 **Restore the Volume Data (If Required)**
Create the rootless volume and restore the backed-up data:

```bash
podman volume create uptime-kuma_data
tar -xzvf ~/uptime-kuma_data.tar.gz -C $(podman volume inspect uptime-kuma_data --format {{.Mountpoint}})
```

### 4. **Run the Container Under Rootless Podman**

Once the image and volume are restored, run the container using rootless Podman:

```bash
podman run \
  --detach \
  -p 3001:3001 \
  --volume uptime-kuma_data:/app/data \
  --name uptime-kuma \
  louislam/uptime-kuma:latest
```

### 5. **Check the Container**

#### 5.1 **Verify the Container is Running**
Check if the container is running:

```bash
podman ps
```

#### 5.2 **Check Logs for Any Errors**
If everything is running, but you want to inspect logs for any issues:

```bash
podman logs uptime-kuma
```

### Additional Considerations:
- **Ports**: If the `3001` port is below `1024`, rootless Podman might not be able to bind to it without special privileges. Since `3001` is above `1024`, this should not be an issue.
- **Permissions**: If there are issues with volumes, ensure that the `uptime-kuma_data` volume is owned by the correct mapped UID (e.g., `165536` for `podman_service`).
- In some cases, firewall ports need to be allowed:
``` bash
sudo firewall-cmd --add-port=3001/tcp --permanent
sudo firewall-cmd --reload
```