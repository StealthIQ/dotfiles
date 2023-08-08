#!/bin/bash

# for GTK Apps to launch without delay
for f in /etc/X11/xinit/xinitrc.d/*.sh; do
  source "$f"
done

# locale settings
export LANG="en_US.UTF-8"

# Wallpaper Restore
# /usr/bin/nitrogen --restore &

/usr/bin/dbus-update-activation-environment --systemd DBUS_SESSION_BUS_ADDRESS DISPLAY XAUTHORITY &

/usr/bin/xrdb -merge ~/.Xresources &

/usr/bin/nm-applet &
/usr/bin/pamac-tray &
/usr/bin/dunst &

# Auto suspend when not online [ paru -Sy --noconfirm --needed xidlehook ]
# 300s - 5m / 900s - 15m / 1800s - 30m / 3600s - 1h / 86400s -24h
/usr/bin/xidlehook --not-when-audio --not-when-fullscreen --timer 900 'feh $HOME/Pictures/Blackwall/black-solid & systemctl suspend' 'betterlockscreen -l --text "Error 404: Desktop Crashed"' &

# Gestures app
/usr/bin/libinput-gestures-setup start &

/usr/bin/xsetroot -cursor_name left_ptr &

# Normal Applications
/usr/bin/xdman &
/usr/bin/conky &
/usr/bin/megasync &
/usr/bin/aw-qt &
/usr/bin/copyq &
/usr/bin/ulauncher --no-window-shadow --hide-window &
/usr/bin/sxhkd &
/usr/bin/redshift &
/usr/bin/safeeyes &
/usr/bin/todoist &
/usr/bin/cpupower-gui -b &
/usr/bin/blueman-applet &
/usr/bin/mpd --kill
/usr/bin/mpd --no-daemon --stdout --verbose &
/usr/bin/kdeconnect-indicator &

# battery-monitor & # https://github.com/maateen/battery-monitor

# Window Managers
exec /usr/bin/bspwm

