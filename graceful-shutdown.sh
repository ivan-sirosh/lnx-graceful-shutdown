#!/bin/bash

TIMEOUT_MINUTES="$1"
TIMEOUT_SECONDS=$((TIMEOUT_MINUTES * 60))
LOG_FILE="/var/log/graceful-shutdown.log"

# Function to log messages with a timestamp
log() {
    echo "$(date +"%Y-%m-%d %T"): $1" >> "$LOG_FILE"
}

RESOURCE_DOWN=false
START_TIME=0

while true; do
    sleep 60

    REMOTE_RESOURCE="$(ip route show default | awk '/default/ {print $3}')"

    if ping -c 1 -W 5 "$REMOTE_RESOURCE" > /dev/null 2>&1; then
        # Resource is online
        if [ "$RESOURCE_DOWN" = true ]; then
            log "Remote resource: $REMOTE_RESOURCE is back online."
            RESOURCE_DOWN=false
        fi
    else
        if [ "$RESOURCE_DOWN" = false ]; then
            log "Remote resource: $REMOTE_RESOURCE is down. Initiating graceful shutdown... timeout $TIMEOUT_MINUTES min."
            RESOURCE_DOWN=true
            START_TIME=$(date +%s)
        fi
    fi

    # Check if shutdown timeout has been reached
    if [ "$RESOURCE_DOWN" = true ]; then
        CURRENT_TIME=$(date +%s)
        ELAPSED_TIME=$((CURRENT_TIME - START_TIME))
        if [ "$ELAPSED_TIME" -ge "$TIMEOUT_SECONDS" ]; then
            log "Timeout reached. Initiating shutdown..."
            shutdown -h now "Server is shutting down due to remote resource being down for too long."
            exit 0
        fi
    fi
done
