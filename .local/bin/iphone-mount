#!/bin/bash

# Install required packages
sudo pacman -S --needed --noconfirm libimobiledevice
yay -S  --needed --noconfirm ifuse

# Start usbmuxd service
sudo systemctl start usbmuxd.service

# Pair the phone
idevicepair pair

# Define mount point directory
MOUNT_POINT="/mnt/iphone"

# Check if the mount point directory exists
if [ ! -d "$MOUNT_POINT" ]; then
  # Create the mount point directory
  sudo mkdir "$MOUNT_POINT"
else
  echo "Mount point directory already exists."
fi

# Mount the phone
sudo ifuse -o allow_other "$MOUNT_POINT"

# Check if the mount was successful
if [ $? -eq 0 ]; then
  # Explore the mounted phone
  ls "$MOUNT_POINT"
else
  echo "Error accessing the mount point: Input/output error."
fi
