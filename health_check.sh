#!/usr/bin/env bash

TARGET=$1
PORT=${2:-80} 
LOG_FILE="health_check.log"

if [ -z "$TARGET" ]; then
    echo "Error: Missing target argument."
    echo "Usage: $0 <IP_or_Hostname> [port]"
    exit 1
fi

log_result() {
    local MESSAGE="$1"
    local TIMESTAMP
    TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
    echo "$MESSAGE"
    echo "[$TIMESTAMP] $MESSAGE" >> "$LOG_FILE"
}

if ! ping -c 1 -W 2 "$TARGET" &> /dev/null; then
    log_result "Server $TARGET is unreachable."
    echo "Results logged to $LOG_FILE"
    exit 1 
else
    log_result "Server $TARGET is reachable."
fi

if curl -s --connect-timeout 5 "http://$TARGET:$PORT" &> /dev/null; then
    log_result "Web service on port $PORT is UP."
else
    log_result "Web service on port $PORT is DOWN."
fi

DISK_USAGE=$(df -h / | awk 'NR==2 {print $5}')
log_result "Disk usage on / is $DISK_USAGE."

echo "Results logged to $LOG_FILE"