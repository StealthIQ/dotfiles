#!/usr/bin/env bash

export SCRIPTPATH="$(cd "$(dirname "$0")" || exit; pwd -P)"
THEME="$SCRIPTPATH/rofi/powermenu.rasi"
# THEME="$HOME/.config/rofi/powermenu/type-6/style-3.rasi"

rofi_command="rofi -no-config -theme $THEME"

# Options
shutdown="Shutdown"
reboot="Restart"
lock="Lock"
suspend="Suspend"
logout="Logout"

# Variable passed to rofi
options="$lock\n$suspend\n$logout\n$reboot\n$shutdown"

chosen="$(echo -e "$options" | $rofi_command -dmenu -selected-row 0)"
case "$chosen" in
    "$shutdown")
        systemctl poweroff
        ;;
    "$reboot")
        systemctl reboot
        ;;
    "$lock")
        if [[ -f /usr/bin/i3lock ]]; then
            i3lock-fancy -f Ubuntu --text "Type your password to unlock..."
        elif [[ -f /usr/bin/betterlockscreen ]]; then
            betterlockscreen -l --text "Error 404:Desktop Crashed"
        fi
        ;;
    "$suspend")
        mpc -q pause
        amixer set Master mute
        systemctl suspend
        ;;
    "$logout")
        loginctl terminate-session "$XDG_SESSION_ID"
        ;;
esac

rm "$SCRIPTPATH"/blurlock.png
