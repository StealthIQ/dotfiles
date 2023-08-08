#!/bin/bash

# Function to check if an image can generate a 16-color palette using ImageMagick
function has_16_color_palette() {
    local image="$1"
    local palette_colors=$(convert "$image" -colors 16 -format %c histogram:info: | wc -l)
    return $((palette_colors >= 16))
}

# Set the number of CPU cores to use for parallel processing
num_cores=$(nproc)

# Get the list of image files in the current directory (modify the path if needed)
image_files=$(find . -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.gif" \))

# Execute the image removal in parallel using GNU parallel
echo "Removing images..."
parallel --halt soon,fail=1 -j "$num_cores" --line-buffer \
  "function has_16_color_palette() { local image=\"{}\"; local palette_colors=\$(convert \"\$image\" -colors 16 -format %c histogram:info: | wc -l); return \$((palette_colors >= 16)); }; \
  if ! has_16_color_palette \"{}\"; then rm \"{}\"; echo \"Removed: {}\"; fi" ::: "${image_files[@]}"
