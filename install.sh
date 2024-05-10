#!/bin/bash

# Destination directory for scripts
DEST_DIR="/usr/local/bin"
# Destination directory for service files
SERVICE_DIR="/etc/systemd/system"
# Destination directory for env files
ENV_DIR="/etc/default"
# Log file directory
LOG_DIR="/var/log"
# Timeout for triggering shutdown (minutes)
TIMEOUT_MINUTES="$1"

# Check for existing service name
existing_service=$(systemctl list-units --full --no-legend --plain --all --type=service --state=active --state=inactive | grep -oP "^(graceful-shutdown\.service)" | head -n1)

if [ -n "$existing_service" ]; then
    # Stop and disable existing service
    systemctl stop "$existing_service"
    systemctl disable "$existing_service"
    rm -rf $SERVICE_DIR/graceful-shutdown*
    rm -rf $DEST_DIR/graceful-shutdown.sh
    rm -rf $ENV_DIR/graceful-shutdown
fi

# Copy monitoring script to destination directory
cp graceful-shutdown.sh $DEST_DIR
chmod +x $DEST_DIR/graceful-shutdown.sh

# Create systemd service file for monitoring
cp graceful-shutdown.service $SERVICE_DIR/

# Create env file
touch $ENV_DIR/graceful-shutdown
chmod 644 $ENV_DIR/graceful-shutdown
cat <<EOF > "${ENV_DIR}/graceful-shutdown"
TIMEOUT_MINUTES=$TIMEOUT_MINUTES
EOF

# Create log file
touch $LOG_DIR/graceful-shutdown.log
chmod 644 $LOG_DIR/graceful-shutdown.log

# Enable and start the monitoring service
systemctl enable graceful-shutdown.service
systemctl start graceful-shutdown.service

echo "Installation completed."

