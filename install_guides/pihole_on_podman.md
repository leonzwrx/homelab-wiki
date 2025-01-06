```
 _     _____ ___  _   _ _____
| |   | ____/ _ \| \ | |__  /
| |   |  _|| | | |  \| | / / 
| |___| |__| |_| | |\  |/ /_ 
|_____|_____\___/|_| \_/____|
```
_Updated January 2025_

# Pihole setup on podman (RHEL 9)
	
## Prerequisites/Prep

1. Verify podman functions correctly and rooted containers can be deployed
2. Add necessary firewall ports to home zone (avoiding default ports 80 and 443)
```bash
sudo firewall-cmd --zone=home --add-port=8080/tcp
sudo firewall-cmd --zone=home --add-port=4443/tcp
sudo firewall-cmd --zone=home --add-port=53/tcp
sudo firewall-cmd --zone=home --add-port=53/udp
sudo firewall-cmd --permanent --zone=home --add-port=53/udp
sudo firewall-cmd --permanent --zone=home --add-port=53/tcp
sudo firewall-cmd --permanent --zone=home --add-port=4443/tcp
sudo firewall-cmd --permanent --zone=home --add-port=8080/tcp
```
3. Create podman volumes:
```bash
sudo podman volume create pihole_pihole
sudo podman volume create pihole_dnsmasq
```
4. Pull the image
```bash
sudo podman pull docker.io/pihole/pihole
```
5. Start the container using the config file [here](https://github.com/leonzwrx/homelab-wiki/podman_configs/pihole.txt)

## Setup
1. Restore config using Settings - Teleporter tab
2. If needed, change password using :
```bash
sudo podman exec -it pihole /bin/bash
root@pi-hole:/# sudo pihole -a -p      
```
3. Test functionality, DNS resolution, update gravity, etc using [this tutorial](https://www.crosstalksolutions.com/the-worlds-greatest-pi-hole-and-unbound-tutorial-2023/)
4. Point all clients to podman host for DNS resolution

## Issues/Troubleshooting
**Caveat for Aardvark DNS service**
- Podman 4+ uses Aardvark DNS service uses port 53. The containers will not be able to address each other based on their container names.
- Workaround is to edit `/etc/containers/container.conf` and add the `dns_bind_port` parameter to the [network] section and assign a port. I chose port 54 (it’s officially meant for some old Xerox network service which is no longer in use).
- The resulting section in the `containers.conf` file would look something like this:
```
[network]
dns_bind_port = 54
```
After saving, you need to restart the podman service (or the machine). After that, the DNS service works as expected and containers on the same network can be addressed by their container name.