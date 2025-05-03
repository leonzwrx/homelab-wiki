```sh
 _     _____ ___  _   _ _____
| |   | ____/ _ \| \ | |__  /
| |   |  _|| | | |  \| | / / 
| |___| |__| |_| | |\  |/ /_ 
|_____|_____\___/|_| \_/____|
```

# Apache Guacamole on podman

_UPDATED April 2025_

- Using [this](https://github.com/abesnier/docker-guacamole) project as a single container (vs. standard 3 container setup)

### Pre-requisites
1. Add necessary firewall ports to home zone (avoiding default ports 80 and 443)
```bash
sudo firewall-cmd --permanent --zone=home --add-port=8194/tcp
sudo firewall-cmd --reload
```
2. Create podman volume:
```bash
podman volume create guacamole-config
```
3. Start the container using the config file [here](https://github.com/leonzwrx/homelab-wiki/podman_configs/guacamole.txt)
4. Verify there's an existing Cloudflare tunnel to the home network and/or setup port forwarding

### Setup/Configuration
- Set up Caddy with appropriate reverse proxy settings in the Caddyfile [as seen here](https://github.com/leonzwrx/homelab-wiki/install_guides/caddy_on_podman.md)
- Setup new user(s), delete default guacadmin
- Setup all of the connections, preferences
- For VNC connections to Wayland desktop (**existing** session)- need to start `wayvnc` with the following  command (should be located inside a script in ~/.local/bin)
`WAYLAND_DISPLAY=wayland-1 wayvnc -C /home/leo/.config/wayvnc/config &`