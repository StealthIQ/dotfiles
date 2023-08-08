#!/bin/bash

# Function to check if an image can generate a 16-color palette using ImageMagick
function has_16_color_palette() {
    local image="$1"
    local palette_colors=$(convert "$image" -colors 16 -format %c histogram:info: | wc -l)
    return $((palette_colors >= 16))
}

# Get the list of image files in the current directory (modify the path if needed)
image_files=$(find . -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" \))

# Create an array to store the image removal commands
remove_commands=()

# Process images in parallel and build the removal commands
for image in $image_files; do
    if ! has_16_color_palette "$image"; then
        remove_commands+=("rm \"$image\"")
        echo "To be removed: $image"
    fi
done

# Execute the removal commands in parallel
if [[ ${#remove_commands[@]} -gt 0 ]]; then
    echo "Removing images..."
    parallel --halt soon,fail=1 ::: "${remove_commands[@]}"
fi
