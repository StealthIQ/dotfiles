#!/bin/bash

# Set the directory where you want to search for image files
image_directory="$HOME/.wallpapers/images/"

# Loop through all image files in the directory
find "$image_directory" -type f -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.gif" -o -iname "*.bmp" -o -iname "*.tiff" | while read -r image_file; do

    # Get image dimensions using the identify command from ImageMagick
    dimensions=$(identify -format "%w %h" "$image_file")

    # Extract width and height values
    width=$(echo "$dimensions" | awk '{print $1}')
    height=$(echo "$dimensions" | awk '{print $2}')

    # Check if the image dimensions are below 1920x1080
    if ((width < 1920 || height < 1080)); then
        # Remove the image file
        echo "Removing $image_file"
        rm "$image_file"
    fi

done

