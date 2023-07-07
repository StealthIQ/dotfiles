#!/usr/bin/env bash

# Add this script to your wm startup file.

DIR="$HOME/.config/polybar/"

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Bspwm gaps
bspc config top_padding 28
bspc config bottom_padding 30

# Launch the bars
polybar --quiet --reload top -c "$DIR"/config.ini &
polybar --quiet --reload bottom -c "$DIR"/config.ini &
