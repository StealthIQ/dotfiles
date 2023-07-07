#!/bin/bash

# Function to handle errors
handle_error() {
    echo "error: package '$1' was not found"
}

# Function to copy fonts to the destination folder
copy_font() {
    source_font=$1
    destination_folder="$HOME/.dotfiles/.fonts/"

    # Extracting the font file name
    font_file=$(basename "$source_font")

    # Copying the font file to the destination folder
    cp "$source_font" "$destination_folder/$font_file"

    if [ $? -eq 0 ]; then
        echo "Font '$font_file' copied successfully."
    else
        echo "Failed to copy font '$font_file'."
    fi
}

# Font files to copy
font_files=(
    "/usr/share/fonts/noto/NotoFangsongKSSRotated-Regular.ttf"
    "/usr/share/fonts/OTF/DroidSansMNerdFont-Regular.otf"
    "/usr/share/fonts/TTF/all-the-icons.ttf"
    "B.ttf"
    "/usr/share/fonts/TTF/DejaVuMathTeXGyre.ttf"
    "/usr/share/fonts/TTF/FantasqueSansMNerdFont-Bold.ttf"
    "/usr/share/fonts/TTF/FiraCode-Bold.ttf"
    "/usr/share/fonts/TTF/FiraMono-Bold.ttf"
    "/usr/share/fonts/TTF/FiraSans-Bold.ttf"
    "/usr/share/fonts/TTF/fa-brands-400.ttf"
    "/usr/share/fonts/TTF/Hack-Bold.ttf"
    "/usr/share/fonts/TTF/icomoon-feather.ttf"
    "/usr/share/fonts/TTF/ionicons.ttf"
    "/usr/share/fonts/TTF/iosevka-bold.ttf"
    "/usr/share/fonts/TTF/IosevkaNerdFont-Bold.ttf"
    "/usr/share/fonts/TTF/JetBrainsMono-Bold.ttf"
    "/usr/share/fonts/liberation/LiberationMono-Bold.ttf"
    "/usr/share/fonts/TTF/MaterialIcons-Regular.ttf"
    "/usr/share/fonts/TTF/SymbolsNerdFont-Regular.ttf"
    "/usr/share/fonts/TTF/OpenSans-Bold.ttf"
    "/usr/share/fonts/ubuntu/Ubuntu-B.ttf"
    "/usr/share/fonts/Unifont/Unifont.ttf"
)

# Create the destination folder if it doesn't exist
mkdir -p "$HOME/.dotfiles/.fonts/"

# Loop through the font files and copy them
for font_file in "${font_files[@]}"; do
    copy_font "$font_file" || handle_error "$font_file"
done
