```sh
 _     _____ ___  _   _ _____
| |   | ____/ _ \| \ | |__  /
| |   |  _|| | | |  \| | / / 
| |___| |__| |_| | |\  |/ /_ 
|_____|_____\___/|_| \_/____|
```

# Homepage dashboard on podman

_UPDATED February 2025_

- [Homepage](https://gethomepage.dev/) homepage

### Pre-requisites
1. Add necessary firewall ports to home zone (avoiding default ports 80 and 443). Port 8000 is for gluetun's widget
```bash
sudo firewall-cmd --permanent --zone=home --add-port=3000/tcp
sudo firewall-cmd --permanent --zone=home --add-port=8000/tcp
sudo firewall-cmd --reload
```
2. Create podman volume:
```bash
podman volume create homepage-config
```
3. Create a .env file in the home directory and assign permissions
```bash
mkdir ~/homepage; touch ~/homepage/.env
chmod 600 ~/homepage/.env
```
5. Start the rootless container using the config file [here](https://github.com/leonzwrx/homelab-wiki/podman_configs/homepage.txt)
NOTE: --privileged flag needed to read some resource values

### Setup/Configuration
- On the container host, browse `volumes/homepage-config/_data` and verify all of the .yaml files have been created
- Sample configs from Christian Lempa [here](https://github.com/ChristianLempa/homelab/blob/main/homepage/homepage-prod-1) or Techno Tim [here](https://technotim.live/posts/homepage-dashboard/)
- If not using existing configuration, configure each of the .yaml files starting with `settings.yaml`as described [here](https://gethomepage.dev/configs/settings/)
- Next, for each of the `services.yaml` entries - reference official documentation [here](https://gethomepage.dev/widgets/services/) to make sure syntax in and API permissions for each widget is set properly
- Verify all `.env` values are set correctly
- Configure widgets.yaml
- Configure bookmarks.yaml if applicable
- Make sure `.env` file is backed up

**In order to get gluetun widget working, follow instructions [here](https://github.com/qdm12/gluetun-wiki/blob/main/setup/advanced/control-server.md)**
- Create a `config.toml` file inside the podman host such as
```toml
[[roles]]
name = "dashboard"
# Define a list of routes with the syntax "Http-Method /path"
routes = [
  "GET /v1/openvpn/portforwarded",
  "GET /v1/publicip/ip",
  "GET /v1/openvpn/status"
]
# Define an authentication method with its parameters
auth = "basic"
username = "myusername"
password = "mypassword"
```
- Make sure gluetun's config has these lines:
```ini
  -p 8000:8000/tcp \
  -v /path/to/gluetun/config/config.toml:/gluetun/auth/config.toml \
  ```
- Verify the functionality of the API by visiting http://podmanhost:8000/v1/openvpn/status