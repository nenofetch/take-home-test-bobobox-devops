#!/bin/bash

LOG_FILE="health_check.log" # Logging file
HOST=$1
PORT=${2:-80} # Port 80 as default port if user not provided

# Print basic information for using this script
if [ -z "$1" ]; then
  echo "Usage: $0 host port"
  echo "Example: localhost 443 < for checking port 443 on localhost host"
  exit 1
fi

# Function for print log of the messages wth timestamp
log() {
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

log "Starting health check for $HOST on port $PORT..."

#
# ---- PING TEST SECTION ---- 
#
ping -c 2 "$HOST" > /dev/null 2>&1
if [ $? -ne 0 ]; then
  log "Server unreachable."
  exit 2
else
  log "Server is available"
fi


#
# ---- HTTP/S CHECK USING CURL SECTION ----
#
curl --connect-timeout 5 -s "http://$HOST:$PORT" > /dev/null
if [ $? -eq 0 ]; then
  log "Web service on port $PORT is UP."
else
  log "Web service on port $PORT is DOWN."
fi

#
# ---- DISK USAGE CHECK SECTION ----
#
DISK_USAGE=$(df -h / | awk 'NR==2 {print $5}')
log "Disk usage on / is $DISK_USAGE"

log "Health check complete and the report can check on the $LOG_FILE"
