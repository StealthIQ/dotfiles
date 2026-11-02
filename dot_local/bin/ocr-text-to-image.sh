#!/bin/bash

# -----------------------------------------------------------------------------
# DEPENDENCIES (Arch Linux): 
# sudo pacman -S tesseract tesseract-data-eng grim slurp wl-clipboard libnotify imagemagick
# -----------------------------------------------------------------------------

# 1. Create a simplified temp file path
TEMP_IMG="/tmp/ocr_snap.png"
TEMP_TXT="/tmp/ocr_result.txt"

# 2. Clean up previous runs immediately
rm -f "$TEMP_IMG" "$TEMP_TXT"

# 3. Select area and screenshot
# grim works with slurp to grab a selection. 
# If the user presses Escape (selection is empty), we exit safely.
GEOMETRY=$(slurp)
if [ -z "$GEOMETRY" ]; then
    exit 1
fi

grim -g "$GEOMETRY" "$TEMP_IMG"

# 4. Image Pre-processing (The "Secret Sauce")
# We use ImageMagick to optimize the image for Tesseract:
# -modulate 100,0: Grayscale (removes color noise)
# -resize 400%: Enlarges text for better detection
# -sigmoidal-contrast: Sharpens the text against the background
magick "$TEMP_IMG" -modulate 100,0 -resize 400% -sigmoidal-contrast 10x50% "$TEMP_IMG"

# 5. Run Tesseract (OCR)
# -l eng: Language English (add others like 'eng+rus' if needed)
tesseract "$TEMP_IMG" stdout -l eng > "$TEMP_TXT" 2>/dev/null

# 6. Post-processing & Clipboard
# We trim empty lines/spaces and copy to Wayland clipboard
TRIMMED=$(cat "$TEMP_TXT" | sed '/^[[:space:]]*$/d')

if [ -n "$TRIMMED" ]; then
    echo "$TRIMMED" | wl-copy
    notify-send "OCR Success" "Text copied to clipboard:\n${TRIMMED:0:50}..." -i text-x-generic
else
    notify-send "OCR Failed" "No text detected." -i dialog-error
fi

# 7. Cleanup
rm -f "$TEMP_IMG" "$TEMP_TXT"
