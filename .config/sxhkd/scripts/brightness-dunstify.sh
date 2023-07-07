#!/bin/bash

# You can call this script like this:
# $./volume.sh up
# $./volume.sh down
# $./volume.sh mute

function get_brightness {
    brillo | cut -d '.' -f 1
}


function send_notification {
    DIR=`dirname "$0"`
    brightness=`get_brightness`
#$DIR/notify-send.sh "$brightness""      " -i "$icon_name" -t 2000 -h int:value:"$brightness" -h string:synchronous:"─" --replace=555
    # Make the bar with the special character ─ (it's not dash -)
    # https://en.wikipedia.org/wiki/Box-drawing_character
#bar=$(seq -s "─" $(($volume/5)) | sed 's/[0-9]//g')
    icon_name="/home/i0xfce/.icons/forest-icons/16x16/apps/brightnesssettings.svg"
    # Send the notification
    $DIR/notify-send.sh "Changing Brightness " "$brightness" -i "$icon_name" -t 1100 -h int:value:"$brightness" --replace=555

}


case $1 in
  up)
    # increase the backlight by 5%
    brillo -q -A 1
    send_notification
    ;;
  down)
    # decrease the backlight by 5%
    brillo -q -U 1
    send_notification
    ;;
esac

