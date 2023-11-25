#!/bin/bash

REMOTE_RESOURCE="$1"
TIMEOUT="$2"
SHUTDOWN_FLAG="/var/run/remote_monitor_shutdown.flag"
LOG_FILE="/var/log/remote_monitor.log"

# Function to log messages with a timestamp
log() {
    echo "$(date +"%Y-%m-%d %T"): $1" >> "$LOG_FILE"
}

# Function to handle termination signals
terminate() {
    log "Received termination signal. Exiting."
    exit 0
}

# Trap termination signals
trap terminate SIGTERM SIGINT

log "Checking remote resource: $REMOTE_RESOURCE"

while true; do
    if ping -c 1 -W 5 "$REMOTE_RESOURCE"; then
        # Check if shutdown flag exists, and if so, remove it
        if [ -e "$SHUTDOWN_FLAG" ]; then
            log "Resource is back online. Cancelling shutdown."
            rm "$SHUTDOWN_FLAG"
            shutdown -c  # Cancel any pending shutdown
        fi
    else
        log "Remote resource is down. Initiating graceful shutdown..."
        touch "$SHUTDOWN_FLAG"  # Create a flag to indicate shutdown is in progress
        shutdown -h "+$TIMEOUT" "Server is shutting down due to remote resource being down."
    fi
    sleep 60
done
