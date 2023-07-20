#!/bin/bash
# Script to send output of speedtest as notification 

speedtest_output=$(speedtest)
Ping=$(echo "$speedtest_output" | awk '/Hosted/ {print substr($0, 37)}')
Hosted=$(echo "$speedtest_output" | grep "Testing from")
Download=$(echo "$speedtest_output" | grep Download)
Upload=$(echo "$speedtest_output" | grep Upload)

clear
echo -e "$Hosted"
echo "$Download"
echo "$Upload"

# Notify Speed
notify-send -w -i /usr/share/icons/Tela-circle/scalable/devices/network-modem.svg "Speedtest Results" "Ping - $Ping\n$Download\n$Upload"

