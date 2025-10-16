#!/bin/bash

# List of known screen sharing or recording applications
known_apps=("obs" "ffmpeg" "vokoscreen" "simplescreenrecorder")

# Check if any known application processes are running
for app in "${known_apps[@]}"; do
    if pidof -x "$app" >/dev/null; then
        echo "Streamer Mode"
        exit 0
    fi
done

echo "True"
