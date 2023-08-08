#!/bin/bash

# Colors
green="#02fc34"
red="#fc0202"

# Check if Picom is running and output status to Polybar
picom_status() {
  if pgrep -x "picom" &> /dev/null; then
    echo "%{F$green}"
  else
    echo "%{F$red}"
  fi
}

# Toggle Picom Blur
picom_toggle_blur() {
  if pgrep -x "picom" &> /dev/null; then
    killall picom
  else
    picom --blur-method dual_kawase --blur-strength 6 -b &> /dev/null &
  fi
}

# Toggle Picom Transparency
picom_toggle_transparent() {
  if pgrep -x "picom" &> /dev/null; then
    killall picom &> /dev/null
  else
    picom &> /dev/null &
  fi
}

# Main (User Input)
if [[ $1 = "--toggle-blur" ]]; then
  picom_toggle_blur
elif [[ $1 = "--toggle-transparent" ]]; then
  picom_toggle_transparent
elif [[ $1 = "--status" ]]; then
  picom_status
else
  printf "[!] Available options:\n --toggle-blur\n --toggle-transparent\n --status\n"
fi

