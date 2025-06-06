```
 _     _____ ___  _   _ _____
| |   | ____/ _ \| \ | |__  /
| |   |  _|| | | |  \| | / / 
| |___| |__| |_| | |\  |/ /_ 
|_____|_____\___/|_| \_/____|
```
_Updated January 2025_

# FreshRSS setup on podman
	
## Pre-requisites/Prep

1. Verify podman functions correctly and rootless containers can be deployed
2. Add necessary firewall ports to home zone
```bash
sudo firewall-cmd --permanent --zone=home --add-port=8081/tcp
sudo firewall-cmd --reload
```
3. Create podman volumes:
```bash
sudo podman volume create freshrss_data
sudo podman volume create freshrss_extensions
```
4. Pull the image
```bash
sudo podman pull docker.io/freshrss/freshrss:latest
```
5. If using with full-text-rss - need to make sure there is a common network between containers that need to communicate (use the `--network rss-network` when creating containers that need to communicate):
```bash
podman network create --dns=8.8.8.8 rss-network
```
NOTE:  Once containers are online, they need to communicate to each other by their container name

6. Start the container using the config file [here](https://github.com/leonzwrx/homelab-wiki/blob/main/podman_configs/freshrss.txt)

## Setup / Configuration
- Go thru default configs using SQLite - decent guide [here](https://www.youtube.com/watch?v=bWRN93LYRpM)
- Set up default/first user
- Configure Display/Themes configuration and overall look/feel settings
- Install /edit extensions (may need to add Github SSH keys first):
```bash
[podman_service@rhel9-apps _data]$ pwd
/var/lib/podman_service/.local/share/containers/storage/volumes/freshrss_extensions/_data
[podman_service@rhel9-apps _data]$ git clone ssh://git@github.com/FreshRSS/Extensions.git
```
this may include some custom extensions:
```bash
[podman_service@rhel9-apps _data]$ git clone https://github.com/kapdap/freshrss-extensions
```
- Configure sharing options and email (configure `/data/config.php`)
  (may need to add Google's app password / API key and use that as a password below)
  ```
  array (
    'hostname' => 'gmail.com',
    'host' => 'smtp.gmail.com',
    'port' => 465,
    'auth' => true,
    'auth_type' => '',
    'username' => 'user@gmail.com',
    'password' => 'fuck you',
    'secure' => 'ssl',
    'from' => 'user@gmail.com',
  ),
    ```

## Feed Aggregator
[fivefilters Full Text Rss service](https://github.com/heussd/fivefilters-full-text-rss-docker) - retrieves the full-text of individual articles or complete full-text RSS feeds. This is a containerized version. 
**Procedure**
1. Create volumes for a rootless container
```bash
podman volume create full-text-rss-config
podman volume create full-text-rss-data
podman volume create full-text-rss-cache
```
2. Run this container using config file [here](https://github.com/leonzwrx/homelab-wiki/blob/main/podman_configs/full-text-rss.txt)
3. Verify firewall rules are updated:
```
  firewall-cmd --permanent --zone=home --add-port=50000/tcp
  firewall-cmd --zone=home --add-port=50000/tcp
```
4. Load http://rhel9-apps.nilva.local:50000/
   	- Follow the quick start guide for each site
   **NOTE:**
   The URL from freshrss needs to include just the container name, for instance:
   _http://full-text-rss/makefulltextfeed.php?url=sec%3A%2F%2Finsideevs.com%2Frss%2Fnews%2Fall%2F&max=200&links=preserve&exc=&submit=Create+Feed_
## Client Setup (Android)
- Download FeedMe from Playstore
- Enable API via Authentication link listed on the Profile tab (for mobile apps, etc)
    - Might have to play with ad block app / whitelist on Android
    - Connect the app using the API key listed: 
    ![![fresh_rss_api.png](./assets/fresh_rss_api.png)

NOTE: If using reverse proxy, update the API address in the FreshRSS configuration so that it reflects the new domain (rss.nilva.net) and is accessible externally. The mobile app FeedMe relies on the correct API endpoint to communicate with FreshRSS.

**Procedure**
1. edit `freshrss/data/config.php` file
2. Update the Base URL: Look for the base_url setting, and change it to reflect the correct name:
   ```php
   'base_url' => 'https://rss.nilva.net/',
   ```
3. Restart FreshRSS container: `podman restart freshrss`
4. Verify the API is accessible by visiting `https://rss.nilva.net/api/greader.php`
5. Configure FeedMe or another mobile app to use the server address `https://rss.nilva.net/api/greader.php`