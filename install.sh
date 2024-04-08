#!/bin/bash

# Destination directory for scripts
DEST_DIR="/usr/local/bin"
# Destination directory for service files
SERVICE_DIR="/etc/systemd/system"
# Log file directory
LOG_DIR="/var/log"
# Timeout for triggering shutdown (minutes)
TIMEOUT="$1"

# Check for existing service name
existing_service=$(systemctl list-units --full --no-legend --plain --all --type=service --state=active --state=inactive | grep -oP "^(remote_monitor@?[0-9]*\.service|remote_monitor\.service)" | head -n1)

if [ -n "$existing_service" ]; then
    # Stop and disable existing service
    systemctl stop "$existing_service"
    systemctl disable "$existing_service"
    rm -rf $SERVICE_DIR/remote_monitor*
    rm -rf $DEST_DIR/remote_monitor.sh
fi

# Copy monitoring script to destination directory
cp remote_monitor.sh $DEST_DIR
chmod +x $DEST_DIR/remote_monitor.sh

# Create systemd service file for monitoring
cp remote_monitor@.service $SERVICE_DIR/

# Create log file
touch $LOG_DIR/remote_monitor.log
chmod 644 $LOG_DIR/remote_monitor.log

# Enable and start the monitoring service
systemctl enable remote_monitor@"$TIMEOUT".service
systemctl start remote_monitor@"$TIMEOUT".service

echo "Installation completed."

