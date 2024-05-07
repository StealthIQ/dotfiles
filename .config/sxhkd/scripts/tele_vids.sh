#!/bin/bash

if pgrep mpv; then
    killall mpv
else
    find "$HOME/Downloads/Telegram Desktop" -type f \( -iname "*.mp4" -o -iname "*.mkv" -o -iname "*.avi" \) -exec mpv --osd-bar=no --save-position-on-quit --fs {} +
fi

