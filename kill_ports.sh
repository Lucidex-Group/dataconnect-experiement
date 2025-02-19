#!/bin/bash

# Define ports to kill
PORTS=(5001 5003 8080 8085 9000 9099 9199 9299 9399 50001)

# Function to find and kill processes running on specific ports
kill_port() {
  local port=$1
  echo "Finding process running on port $port..."
  pid=$(lsof -ti :$port)
  if [ -z "$pid" ]; then
    echo "No process found on port $port."
  else
    echo "Killing process $pid running on port $port..."
    kill -9 $pid
    echo "Process on port $port killed."
  fi
}

# Iterate through all specified ports
for port in "${PORTS[@]}"; do
  kill_port $port
done

echo "Port cleanup complete."