#!/usr/bin/env bash
# Locks the session with hyprlock, using whatever wallpaper quickshell currently
# shows. quickshell draws the desktop wallpaper as its own layer surface, which
# the lock screen hides, so hyprlock has to be handed the same image.
#
# Writes a generated include that hyprlock.conf sources. Run with --update-only to
# refresh it without locking (e.g. after changing the wallpaper).

set -u

CONFIG_JSON="${XDG_CONFIG_HOME:-$HOME/.config}/illogical-impulse/config.json"
OUT_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/hypr/hyprlock"
OUT="$OUT_DIR/wallpaper.conf"
LINK="$OUT_DIR/wallpaper.img"
FRAME_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/hyprlock"
FALLBACK="/home/stealthiq/Pictures/OG wallpapers/car_red.jpg"

mkdir -p "$OUT_DIR" "$FRAME_DIR"

wallpaper=""
if [ -r "$CONFIG_JSON" ]; then
    wallpaper=$(jq -r '.background.wallpaperPath // empty' "$CONFIG_JSON" 2>/dev/null)
fi
[ -z "$wallpaper" ] && [ -r "$FALLBACK" ] && wallpaper="$FALLBACK"

# hyprlock cannot play video wallpapers; freeze the first frame instead.
case "${wallpaper,,}" in
    *.mp4|*.webm|*.mkv|*.mov|*.avi|*.gif)
        frame="$FRAME_DIR/wallpaper-frame.png"
        if command -v ffmpeg >/dev/null 2>&1 &&
            ffmpeg -loglevel error -y -i "$wallpaper" -frames:v 1 -vf "scale='min(2560,iw)':-2" "$frame" </dev/null 2>/dev/null; then
            wallpaper="$frame"
        else
            wallpaper="$FALLBACK"
        fi
        ;;
esac

# hyprlock paths are taken verbatim, so hand it a space-free symlink instead of
# e.g. "Pictures/OG wallpapers/car_red.jpg".
rm -f "$LINK"
[ -r "$wallpaper" ] && ln -s "$wallpaper" "$LINK"

tmp="$OUT.$$"
{
    echo "background {"
    echo "    monitor ="
    echo "    path = $LINK"
    echo "    color = rgba(181818FF)"
    echo "    brightness = 0.75"   # keeps the lock screen text readable
    echo "    blur_passes = 1"
    echo "    blur_size = 4"
    echo "}"
} >"$tmp" && mv -f "$tmp" "$OUT"

if [ "${1:-}" = "--update-only" ]; then
    echo "wallpaper: $wallpaper"
    echo "wrote $OUT:"
    sed -n 1,20p "$OUT"
    exit 0
fi

exec hyprlock "$@"
