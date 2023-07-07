#!/bin/bash
# Low Battery Warning Script

# Variables [ Commands ]
cap=$(cat /sys/class/power_supply/BAT0/capacity)
battinfo=$(acpi -b)
time=$(acpi -b | cut -f 5 -d " ")

# Battery Full [ 95% ]
if ((cap > 94)); then
    DISPLAY=:0.0 notify-send -i /usr/share/icons/gnome/32x32/status/battery-full-charged.png "Battery Full [Unplug the charger]" "Percentage - $cap% \nDischarging - Time Left $time"
    # mpv ~/.config/polybar/scripts/music/battery-charged.mp3 &
    exit 0
fi

# Battery Low [ 30% ]
if [[ $(echo "$battinfo" | grep Discharging) && $cap < 35 ]]; then
    DISPLAY=:0.0 notify-send -i /usr/share/icons/gnome/32x32/status/battery-low.png "Battery Low [Plug in charger]" "Percentage - $cap% \nDischarging - Time Left $time"
    mpv ~/.config/polybar/scripts/music/battery-warning.mp3 &
    exit 0
fi


# Battery Very Low [ About to DIE ] - Calculated by time left
if [[ $(echo "$battinfo" | grep Discharging) && $(echo "$time" | cut -f 1 -d ":") -lt 0 && $(echo "$time" | cut -f 2 -d ":") -lt 15 ]]; then
    DISPLAY=:0.0 notify-send -i /usr/share/icons/gnome/32x32/status/battery-caution.png "Battery about to [ DIE ]" "Percentage - $cap% \nDischarging - Time Left $time"
    # mpv ~/.config/polybar/scripts/music/battery-warning.mp3 &
    exit 0
fi
