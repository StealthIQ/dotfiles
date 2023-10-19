#!/bin/bash

# Directory containing video files
video_directory="$HOME/Downloads/Telegram Desktop"

# File extensions to consider as video formats (add more if needed)
video_extensions=("mp4" "mkv" "avi")

# Check if mpv is already running
if pgrep mpv > /dev/null && pgrep -f mpv > /dev/null; then
    killall mpv
fi

# Use find to locate video files and pass them to mpv
find "$video_directory" -type f \( -name "*.${video_extensions[0]}" \
    $(printf -- '-o -name "*.%s" ' "${video_extensions[@]:1}") \) \
    -exec mpv --osd-bar=no --save-position-on-quit --fs {} \;
