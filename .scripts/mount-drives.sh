#!/bin/bash 

# Prints Information about the External Hard Drives 
lsblk_output=$(lsblk)

filtered_output=$(echo "$lsblk_output" | grep -E 'sda[0-9]+')

echo "Available drives:"
echo "$filtered_output"
echo

read -p "Enter the drive you want to operate (e.g., sda1, sda2): " drive_choice

if [[ "$drive_choice" =~ ^(sda[1-2])$ ]]; then
    mount_point="/mnt/drive-$drive_choice"

    # Install ntfs-3g package if not already installed
    paru -S --needed --noconfirm ntfs-3g

    # Attempt to fix the NTFS filesystem
    sudo ntfsfix "/dev/$drive_choice"

    # Create the mount point directory if it doesn't exist
    sudo mkdir -p "$mount_point"

    read -p "Enter 'm' to mount or 'u' to unmount the drive: " operation

    if [[ "$operation" = "m" ]]; then
        # Mount the drive to the chosen mount point
        sudo mount "/dev/$drive_choice" "$mount_point"
        echo -e "\e[32mDrive /dev/$drive_choice mounted at $mount_point.\e[0m"
    elif [[ "$operation" = "u" ]]; then
        # Unmount the drive
        sudo umount "$mount_point"
        echo -e "\e[32mDrive /dev/$drive_choice unmounted from $mount_point.\e[0m"
    else
        echo -e "\e[31mInvalid operation choice.\e[0m"
    fi
else
    echo -e "\e[31mInvalid drive choice.\e[0m"
fi
