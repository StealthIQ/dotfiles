#!/bin/bash

WALLPAPER_DIR=~/MEGAsync/.wallpapers
DEST_DIR=~/.wallpapers

# Create the destination directory if it doesn't exist
mkdir -p "$DEST_DIR"

# Change to the wallpaper directory
cd "$WALLPAPER_DIR"

# Loop through the wallpaper files and create symlinks
for file in wallpaper-*.jpg wallpaper-*.jpeg wallpaper-*.png; do
    ln -s "$WALLPAPER_DIR/$file" "$DEST_DIR/$file"
done
