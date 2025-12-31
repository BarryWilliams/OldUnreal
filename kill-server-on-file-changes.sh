#!/bin/bash

WATCH_DIR=$1

echo "File watcher started, monitoring for changes..."
# Wait for file changes
inotifywait -r -e modify,create,delete $WATCH_DIR

echo "Files changed!"

while inotifywait -t 5 -r -e modify,create,delete $WATCH_DIR; do
        echo "File changes occured"
        sleep 5
        echo "Watching for additional changes..."
done

echo "No additional changes detected"

echo "Finding UT99 server process..."
SERVER_PID=$(pgrep -f "ucc-bin server" | head -1)

if [ -n "$SERVER_PID" ]; then
    echo "Sending SIGTERM to PID $SERVER_PID"
    kill -TERM $SERVER_PID
    echo "Server will restart via Kubernetes restart policy"
else
    echo "Server process not found, may already be stopped"
fi