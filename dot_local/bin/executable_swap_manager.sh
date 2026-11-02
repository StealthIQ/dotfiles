#!/bin/bash

# Function to create a swap file
create_swap() {
    echo "Enter the size of swap file (in GB):"
    read swap_size

    # Convert GB to MB (1 GB = 1024 MB)
    swap_size_mb=$((swap_size * 1024))

    # Check if the file already exists
    if [ -f /swapfile ]; then
        echo "Swap file already exists. Do you want to overwrite it? (y/n)"
        read overwrite
        if [ "$overwrite" != "y" ]; then
            echo "Exiting without changes."
            exit 0
        fi
    fi

    # Create the swap file
    echo "Creating swap file of $swap_size GB..."
    sudo dd if=/dev/zero of=/swapfile bs=1M count=$swap_size_mb status=progress

    # Set the correct permissions
    sudo chmod 600 /swapfile

    # Make the swap file
    sudo mkswap /swapfile

    # Enable swap
    sudo swapon /swapfile

    # Add to fstab for persistent swap
    echo "/swapfile none swap sw 0 0" | sudo tee -a /etc/fstab

    # Confirm and display the result
    echo "Swap file created and enabled."
    swapon --show
    free -h
}

# Function to delete the swap file
delete_swap() {
    if [ ! -f /swapfile ]; then
        echo "No swap file found. Nothing to delete."
        exit 0
    fi

    # Turn off swap
    echo "Turning off swap..."
    sudo swapoff /swapfile

    # Remove the entry from fstab
    sudo sed -i '/\/swapfile/d' /etc/fstab

    # Remove the swap file
    sudo rm /swapfile

    # Confirm and display the result
    echo "Swap file deleted."
    swapon --show
    free -h
}

# Menu to choose between creating or deleting swap
echo "Swap Management Script"
echo "1. Create a swap file"
echo "2. Delete the swap file"
echo "3. Exit"
echo "Choose an option (1-3):"
read option

case $option in
    1)
        create_swap
        ;;
    2)
        delete_swap
        ;;
    3)
        echo "Exiting script."
        exit 0
        ;;
    *)
        echo "Invalid option. Exiting."
        exit 1
        ;;
esac
