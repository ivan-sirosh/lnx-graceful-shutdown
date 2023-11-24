#!/bin/bash

# Destination directory for scripts
DEST_DIR="/usr/local/bin"
# Destination directory for service files
SERVICE_DIR="/etc/systemd/system"
# Log file directory
LOG_DIR="/var/log"
# User to run the service (adjust as needed)
SERVICE_USER="root"

# Copy monitoring script to destination directory
cp monitor_remote.sh "$DEST_DIR"
chmod +x "$DEST_DIR/monitor_remote.sh"

# Create systemd service file for monitoring
cp monitor_remote.service "$SERVICE_DIR"

# Create log file
touch "$LOG_DIR/remote_monitor.log"
chmod 644 "$LOG_DIR/remote_monitor.log"

# Enable and start the monitoring service
systemctl enable remote_monitor.service
systemctl start remote_monitor.service

echo "Installation completed."
