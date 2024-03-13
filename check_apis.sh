#!/bin/bash

# Configuration
CONFIG_FILE="services_config.json"
LOG_DIR="/var/apis/api_monitoring_script/log"
MAX_LOG_SIZE=10240 # Max log size in KB
MAX_RESTART_ATTEMPTS=3
RESTART_DELAY=10 # Delay in seconds

# Function to rotate log file
rotate_log() {
  if [ -f "$LOG_FILE" ] && [ $(du -k "$LOG_FILE" | cut -f1) -ge $MAX_LOG_SIZE ]; then
    mv "$LOG_FILE" "$LOG_FILE.$(date '+%Y%m%d%H%M%S')"
  fi
}

# Function to log messages with timestamps
log_message() {
  rotate_log
  echo "$(date '+%Y-%m-%d %H:%M:%S'): $1" >> "$LOG_FILE"
}

# Main script
LOG_FILE="$LOG_DIR/$(date '+%Y-%m-%d').log"
mkdir -p "$LOG_DIR"

# Read services from JSON config file
services=$(jq -r 'to_entries|map("\(.key)=\(.value)")|.[]' $CONFIG_FILE)

# Error handling and service restart policy
for service in $services; do
  name=$(echo $service | cut -d= -f1)
  url=$(echo $service | cut -d= -f2)
  attempt=0

  while [ $attempt -lt $MAX_RESTART_ATTEMPTS ]; do
    if curl -s --fail "$url"; then
      log_message "$name is running fine."
      break
    else
      log_message "Health check failed for $name, attempt $((attempt+1))..."
      systemctl restart "$name.service"
      sleep $RESTART_DELAY
      attempt=$((attempt+1))
    fi
  done

  if [ $attempt -eq $MAX_RESTART_ATTEMPTS ]; then
    log_message "Failed to restart $name after $MAX_RESTART_ATTEMPTS attempts."
  fi
done
