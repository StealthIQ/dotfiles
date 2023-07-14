#!/usr/bin/env bash

green="#02fc34"
red="#fc0202"

vpn_connect() {
    if kitty wg-quick up wg0 && ip link show dev wg0 &> /dev/null; then
        if ip link show dev wg0 | grep -q "state UP" &> /dev/null; then
            myip=$(curl -s ifconfig.co/)
            country=$(curl -s ifconfig.co/country)
            city=$(curl -s ifconfig.co/city)
            notify-send -i $HOME/.icons/Gladient/lock.png "✅ Wireguard VPN Connected" "🔥 IP Changed - $myip \n ✰ $country - $city"
        else
            notify-send -i $HOME/.icons/Papirus-Dark-Custom/48x48@2x/statusdialog-warning.svg "🔥 Wireguard VPN Not Connected" "⚠️ Please Either Manually Check by typing [ sudo wg ] or check your IP"
        fi
    else
        notify-send -i $HOME/.icons/Papirus-Dark-Custom/48x48@2x/statusdialog-warning.svg "🔥 Wireguard VPN Not Connected" "⚠️ Device wg0 does not exist"
    fi
}

vpn_disconnect() {
    kitty wg-quick down wg0
    myip=$(curl -s ifconfig.co/)
    country=$(curl -s ifconfig.co/country)
    city=$(curl -s ifconfig.co/city)
    notify-send -i $HOME/.icons/Papirus-Dark-Custom/48x48@2x/status/changes-allow.svg "🔥 Wireguard VPN Disconnected" "🗲 Your current IP - $myip \n ✰ $country - $city"
}

vpn_status() {
    if ip link show dev wg0 &> /dev/null; then
        if ip link show dev wg0 | grep -q "state UP" &> /dev/null; then
            echo "%{F$green}"
        else
            echo "%{F$green}󰯄"
        fi
    elif ip link show dev tun0 &> /dev/null; then
        if ip link show dev tun0 | grep -q "state UP" &> /dev/null; then
            echo "%{F$green}󰯄"
        else
            echo "%{F$green}󰕥"
        fi
    else
        echo "%{F$red}ﱾ"
    fi
}

if [[ $1 = "--connect" ]]; then
    vpn_connect
elif [[ $1 = "--disconnect" ]]; then
    vpn_disconnect
elif [[ $1 = "--status" ]]; then
    vpn_status
fi
