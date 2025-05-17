```
 _     _____ ___  _   _ _____
| |   | ____/ _ \| \ | |__  /
| |   |  _|| | | |  \| | / / 
| |___| |__| |_| | |\  |/ /_ 
|_____|_____\___/|_| \_/____|
```
_Updated January 2025_

# Caddy reverse proxy setup on podman - with CloudFlare Tunnel
**Concept**

* Caddy acts as a reverse proxy, forwarding traffic to internal service (FreshRSS or similar) on `rhel9-apps.nilva.local:8081`.
* Cloudflare Tunnel handles SSL termination and encrypts traffic between the internet and your server.

**Why Disable Automatic HTTPS in Caddy?**

* Cloudflare acts as SSL endpoint, so Caddy doesn't need to manage certificates (Let's Encrypt).
* This simplifies the Caddy configuration and avoids potential conflicts.

**Overall Traffic Flow:**

1. Access a public hostname such as `rss.nilva.net` through a browser.
2. Cloudflare intercepts the request and terminates the HTTPS connection.
3. Cloudflare forwards the decrypted request (usually HTTP) to the home lab through the Cloudflare Tunnel.
4. Router directs the traffic to the podman container running Caddy (listening on port 80).
5. Caddy acts as a reverse proxy, forwarding the request to your application such as FreshRSS server (`rhel9-apps.nilva.local:8081`).
6. FreshRSS processes the request and sends the response back to Caddy.
7. Caddy relays the response back to Cloudflare.
8. Cloudflare encrypts the response with HTTPS and sends it back to the user's browser.

## Prerequisites

* A running Cloudflare Tunnel configured with your domain (e.g., `rss.nilva.net`).

* Port forwarding rules on your home router to direct traffic on ports 80 and 443 to the podman host running Caddy.

* Podman installed on your RHEL 9 server.

## Setup/Configuration
1. Add necessary firewall ports to home zone
```bash
firewall-cmd --permanent --zone=home --add-service=http
firewall-cmd --permanent --zone=home --add-service=https
firewall-cmd --reload
```
2. Create podman volumes:
```bash
podman volume create caddyfile
podman volume create caddy_data
podman volume create caddy_config
```
3. Start the rootful container using the config file [here](https://github.com/leonzwrx/homelab-wiki/blob/main/podman_configs/caddy.txt)
4. Verify Caddy functionality by lauching podman host's default port 80 page:
![caddy_80.png](./assets/caddy_80.png)
5. Edit the Caddy file and enable HTTPS - this configuration tells caddy to manage rss.nilva.net and enables Let's Encrypt for HTTPS automatically (serves files from `/usr/share/caddy` and redirects HTTP requests to HTTPS) if desired
6. Restart caddy container: `podman restart caddy` and verify certificate has been installed
7. If all other  testing successful, change Caddyfile again to use reverse proxy (and restart caddy again)

Caddy file below that shows 2 scenarios where all SSL is managed by Cloudflare and not Caddy. The critical part lies within the nested `transport http` block. This block configures how Caddy handles the HTTPS connection to the backend:

 *`tls`: This directive instructs Caddy to use TLS/SSL for the connection.
 *`tls_insecure_skip_verify`: This directive instructs Caddy to bypass certificate verification for the backend server.

```
http://rss.nilva.net {
	reverse_proxy rhel9-apps.nilva.local:8081
}

http://remote.nilva.net {
	reverse_proxy rhel9-apps.nilva.local:8194
}

http://watchlist.nilva.net {
	reverse_proxy rhel9-apps.nilva.local:5055
}
```