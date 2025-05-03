```bash
 _     _____ ___  _   _ _____
| |   | ____/ _ \| \ | |__  /
| |   |  _|| | | |  \| | / / 
| |___| |__| |_| | |\  |/ /_ 
|_____|_____\___/|_| \_/____|
                             
```
# Podman - updating containers
_Updated November 2024_

## Automated process
**Get Podcheck Script**  [here](https://github.com/sudo-kraken/podcheck?ref=selfh.st)
```bash
# Using curl:
curl -L https://raw.githubusercontent.com/sudo-kraken/podcheck/main/podcheck.sh -o /usr/local/bin/podcheck.sh
chmod +x /usr/local/bin/podcheck.sh
```
Use `./podcheck.sh -h` for syntax

## Manual process

**Understanding the Process:**

While Podman doesn't have a direct "update" command like some container orchestration tools, the process involves a few steps:

1. **Stop the Container:** This ensures that the container isn't running while we update the image.
2. **Remove the Old Image:** This frees up disk space and ensures we're using the latest version.
3. **Pull the New Image:** This downloads the latest version of the image from the registry.
4. **Recreate the Container:** This starts a new container using the updated image and the same configuration.

**Step-by-Step Procedure:**

1. **Stop the Container:**
   ```bash
   podman stop urbackup-server
   ```

2. **Remove the Container:**
   ```bash
   podman rm urbackup-server
   ```

3. **Pull the Latest Image:**
   ```bash
   podman pull uroni/urbackup-server:latest  # Replace 'latest' with a specific tag if needed
   ```

4. **Recreate the Container:**
   ```bash
   podman run \
       -detach \
       --name urbackup-server \
       --volume /mnt/client_backups:/backups \
       --volume urbackup-server_data:/var/urbackup \
       -p 55413-55415:55413-55415 \
       -p 35623:35623/udp \
       --tz America/Denver \
       uroni/urbackup-server:latest  # Replace 'latest' with a specific tag if needed
   ```

**Additional Considerations:**

- **Data Persistence:** Ensure that your volume mappings (`/mnt/client_backups` and `urbackup-server_data`) are configured correctly to preserve data.
- **Image Tagging:** If you're using a specific image tag, replace `latest` with the appropriate tag in the `podman pull` and `podman run` commands.
- **Podman Compose:** If you're using Podman Compose, you can update the image version in your `podman-compose.yaml` file and then run `podman-compose up -d` to recreate the containers.

**Automating the Process:**

For frequent updates, you can also explore Podman's auto-update feature