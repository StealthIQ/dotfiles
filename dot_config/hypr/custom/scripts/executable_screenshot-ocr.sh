#!/usr/bin/env bash
# Drag a region on screen, get its text in the clipboard.
# Bound to SUPER SHIFT E in ~/.config/hypr/custom/keybinds.conf
#
# Usage:
#   screenshot-ocr.sh            # drag-select a region
#   screenshot-ocr.sh image.png  # OCR an existing image (handy for testing)
set -euo pipefail

SHOT_DIR="$HOME/Pictures/Screenshots"
mkdir -p "$SHOT_DIR"

STAMP="$(date +%Y%m%d-%H%M%S)"
SHOT="$SHOT_DIR/ocr-$STAMP.png"
WORK="$(mktemp -d "${XDG_RUNTIME_DIR:-/tmp}/screenshot-ocr.XXXXXX")"
trap 'rm -rf "$WORK"' EXIT

fail() {
	notify-send -a "Screenshot OCR" -u critical -i dialog-error "OCR failed" "$1"
	exit 1
}

# --- 1. capture ---------------------------------------------------------
if [[ $# -gt 0 ]]; then
	[[ -f $1 ]] || fail "No such image: $1"
	cp -- "$1" "$WORK/shot.png"
else
	geometry="$(slurp)" || exit 0 # Esc / right-click cancels, stay silent
	[[ -n $geometry ]] || exit 0
	grim -g "$geometry" "$WORK/shot.png" || fail "Screen capture failed"
fi
cp -- "$WORK/shot.png" "$SHOT"

# --- 2. OCR -------------------------------------------------------------
# Grayscale + 2x upscale + sharpen: on screenshot-sized UI text this fixes
# real misreads ("Hypriand" -> "Hyprland") that raw capture produces.
ocr_src="$WORK/shot.png"
if command -v magick >/dev/null 2>&1; then
	if magick "$WORK/shot.png" -colorspace Gray -resize 200% -sharpen 0x1 "$WORK/ocr.png"; then
		ocr_src="$WORK/ocr.png"
	fi
fi

tesseract "$ocr_src" "$WORK/out" -l eng --psm 3 >/dev/null 2>&1 ||
	fail "tesseract could not read the selected area"

# Trim leading/trailing blank lines, keep paragraph breaks in between.
text="$(awk '{ line[NR] = $0; if (NF && !first) first = NR; if (NF) last = NR }
END   { if (!last) exit; for (i = first; i <= last; i++) print line[i] }' "$WORK/out.txt")"

[[ -n $text ]] || fail "No text found in the selected area."

# --- 3. clipboard + feedback -------------------------------------------
printf '%s\n' "$text" | wl-copy

chars=${#text}
lines=$(printf '%s\n' "$text" | wc -l)
preview="$(head -n1 <<<"$text" | cut -c1-120)"
notify-send -a "Screenshot OCR" -i edit-copy \
	"Text copied — ${chars} chars, ${lines} lines" \
	"${preview}
Saved: $(basename "$SHOT")"
