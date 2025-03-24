#!/bin/sh
# updated February 2025
# Run this script as a cron job every half hour or so

# Extract the forwarded port from Gluetun logs
FORWARDED_PORT=$(podman logs gluetun | grep "port forwarded is" | tail -1 | awk '/port forwarded is/ {print $NF}')

# Check if the port was extracted successfully
if [ -z "$FORWARDED_PORT" ]; then
  echo "Failed to extract forwarded port from Gluetun logs."
  exit 1
fi

# Get the current listening port from qBittorrent
CURRENT_PORT=$(curl -s -b cookies.txt "http://localhost:8282/api/v2/app/preferences" | jq .listen_port)

# Compare the ports
if [ "$CURRENT_PORT" = "$FORWARDED_PORT" ]; then
  echo "qBittorrent is already using the correct port: $FORWARDED_PORT."
  exit 0
fi

# Log in to qBittorrent's API (if authentication is enabled)
curl -s -c cookies.txt --data-urlencode "username=your_username" --data-urlencode "password=your_password" "http://localhost:8282/api/v2/auth/login"

# Check if login was successful
if ! grep -q "SID" cookies.txt; then
  echo "Failed to authenticate with qBittorrent API."
  exit 1
fi

# Update the listening port
curl -s -b cookies.txt --data-urlencode "json={\"listen_port\":$FORWARDED_PORT}" "http://localhost:8282/api/v2/app/setPreferences"

# Verify the port change
UPDATED_PORT=$(curl -s -b cookies.txt "http://localhost:8282/api/v2/app/preferences" | jq .listen_port)
if [ "$UPDATED_PORT" = "$FORWARDED_PORT" ]; then
  echo "Successfully updated qBittorrent listening port to $FORWARDED_PORT."
else
  echo "Failed to update qBittorrent listening port."
  exit 1
fi
