#!/usr/bin/env bash

# Add this script to your wm startup file.

CONFIG_DIR="$HOME/.config/polybar/"

terminate_running_bars() {
  pkill -9 polybar
  while pgrep -u $UID -x polybar >/dev/null; do
    sleep 1
  done
}

set_bspwm_gaps() {
  bspc config top_padding 28
  bspc config bottom_padding 30
}

launch_polybar() {
  polybar --quiet --reload $1 -c "$CONFIG_DIR"/config.ini &
}

main() {
  terminate_running_bars
  set_bspwm_gaps

  launch_polybar top
  launch_polybar bottom

  if xrandr -q | grep 'HDMI-1 connected' >/dev/null; then
    launch_polybar top_external
    launch_polybar bottom_external
  fi
}

main "$@"
