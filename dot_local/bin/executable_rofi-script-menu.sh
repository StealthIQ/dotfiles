#!/usr/bin/env bash

# style="$($HOME/.config/rofi/applets/menu/style.sh)"

# Theme of rofi got from adix github
dir="$HOME/.config/rofi/launchers/type-7/style-7.rasi"
rofi_command="rofi -no-lazy-grab -theme $dir"

# Comment this line to disable random colors
dire="$HOME/.config/rofi/launchers/text"
styles=($(ls -p --hide="colors.rasi" $dire/styles))
color="${styles[$(( $RANDOM % 10 ))]}"
sed -i -e "s/@import .*/@import \"$color\"/g" $dire/styles/colors.rasi


# Error msg
msg() {
	rofi -theme "$HOME/.config/rofi/applets/styles/message.rasi" -e "$1"
}


#  Sub Module (1) ~ Open Links
Openlinks () {
# Browser
if [[ -f /usr/bin/brave ]]; then
	app="brave"
elif [[ -f /usr/bin/firefox ]]; then
	app="firefox"
elif [[ -f /usr/bin/librewolf ]]; then
	app="librewolf"
else
	msg "No suitable web browser found!"
	exit 1
fi

# Links
search_query="  Search Query                      (1)"
activitywatch="  Activity Watch                    (2)"
duckduckgo="  DuckDuckGo                        (3)"
startpage="爵  Startpage                         (4)"
google="  Google                            (5)"
gmail="  Gmail                             (6)"
protonmail="  Protonmail                        (7)"
github="  Github                            (8)"
twitter="  Twitter                           (9)"
youtube="  YouTube                           (10)"
fmovies="  Fmovies                          (11)"
kissasian="  Kissasian                        (12)"
torrent="﨩  1337x                            (13)"
delete_search_history="  Delete History ...               (21)"
go_back="  Go Back ...                      (22)"

#37
# Variable passed to rofi
options="$search_query\n$activitywatch\n$duckduckgo\n$startpage\n$google\n$gmail\n$protonmail\n$github\n$twitter\n$youtube\n$fmovies\n$kissasian\n$torrent\n$xvideos\n$pornhub\n$xhamster\n$nerd_fonts\n$delete_search_history\n$go_back"

chosen="$(echo -e "$options" | $rofi_command -p "Open In : $app " -dmenu -selected-row 0)"
case $chosen in
    $go_back)
        Main
        ;;    
    $delete_search_history)
        rm -rf $HOME/.cache/rofi-scripts
        ;;   
    $search_query)
        bash $HOME/.config/rofi/web-search.sh
        ;;
    $activitywatch)
        $app http://localhost:5600/#/activity/Unknown/view/ &
        ;;
    $duckduckgo)
        $app https://www.duckduckgo.com &
        ;;
    $startpage)
        $app https://www.startpage.com &
        ;;
    $google)
        $app https://www.google.com &
        ;;
    $gmail)
        $app https://www.gmail.com &
        ;;
    $youtube)
        $app https://www.youtube.com &
        ;;   
    $protonmail)
        $app https://www.protonmail.com &
        ;;
    $github)
        $app https://github.com &
        ;;
    $twitter)
        $app https://twitter.com &
        ;;
    $fmovies)
        $app https://www.fmovies.to/home &
        ;;
    $kissasian)
        $app https://ww2.kissasian.vip/kissasian &
        ;;
    $torrent)
        $app --incognito https://www.1337x.to &
        ;;
esac
}

# Network Module Sub/Sub Module (2.1.1) ~ VPN Status Checker
vpn_status() {
    if ifconfig | /bin/grep -d skip "wg0" >> /dev/null ; then
      echo "Wireguard Connected"
    elif ifconfig | /bin/grep -d skip "tun0" >> /dev/null ; then
      echo "Openvpn Connected"
    elif ifconfig | /bin/grep -d skip "utun420" >> /dev/null ; then
      echo "Windscribe Connected"
    else
      echo "Not Connected"
    fi
}

# Network Modules Submodule - (2.1) IP Adress Finder etc...
connected_info() {
# Rofi Options

# JQ - json parser - https://stackoverflow.com/questions/44656515/how-to-remove-double-quotes-in-jq-output-for-parsing-json-files-in-bash
ip="$(curl -s ifconfig.co/json | jq -r .ip)"
country="$(curl -s ifconfig.co/json | jq -r .country)"
city="$(curl -s ifconfig.co/json | jq -r .city)"
time_zone="$(curl -s ifconfig.co/json | jq -r .time_zone)"
latitude="$(curl -s ifconfig.co/json | jq -r .latitude)"
longitude="$(curl -s ifconfig.co/json | jq -r .longitude)"

# Network Basic - https://askubuntu.com/questions/95676/a-tool-to-measure-signal-strength-of-wireless
STATUS="$(nmcli radio wifi)"
SSID="- $(iwgetid -r)"
RANGE=`awk 'NR==3 {printf("%.0f%%\n",$3*10/7)}' /proc/net/wireless`

# Time Zone Finder - https://stackoverflow.com/questions/26802201/bash-get-date-and-time-from-another-time-zone
format='%a - %D | %T | %z'
d=$(TZ=$time_zone date +"$format")
time_z=$(printf "%-32s %s\n" "$d")

# Vpn Connection
vpn_connection=`vpn_status`

network_connected="  Connected $SSID ~ $RANGE"
myip="  My IP - $ip"
ip_country="  IP Country - $country $ip_city"
time_zonee="  $time_z"
vpn_connection="  VPN Status : $vpn_connection"
location="  Lat - $latitude | Lon - $longitude"
net_speed="龍  Do Speedtest"
go_back="  Go Back ...                      (11)"

# Variable passed to rofi
options="$network_connected\n$myip\n$ip_country\n$time_zonee\n$vpn_connection\n$location\n$net_speed\n$go_back"

chosen="$(echo -e "$options" | $rofi_command -p "" -dmenu -selected-row 0)"
case $chosen in
    $go_back)
        Main
        ;;
    $network_connected)
    if [[ $STATUS == *"enable"* ]]; then
            nmcli radio wifi off
    else
            nmcli radio wifi on
    fi 
    ;; 
    $net_speed)
        bash ~/.scripts/speedtest.sh
    ;;
esac
}

# Sub Module (2) - Network Info + Another Sub Module
Network() {
## Get info
IFACE="$(nmcli | grep -i interface | awk '/interface/ {print $2}')"
#SSID="$(iwgetid -r)"
#LIP="$(nmcli | grep -i server | awk '/server/ {print $2}')"
#PIP="$(dig +short myip.opendns.com @resolver1.opendns.com )"
STATUS="$(nmcli radio wifi)"
RANGE=`awk 'NR==3 {printf("%.0f%%\n",$3*10/7)}' /proc/net/wireless`

active=""
urgent=""


if (ping -c 1 1.1.1.1 || ping -c 1 google.com) &>/dev/null; then
	if [[ $STATUS == *"enable"* ]]; then
        if [[ $IFACE == e* ]]; then
            SSID="- $(iwgetid -r)"
            connected="鷺  Connected $SSID"
        else
            SSID="- $(iwgetid -r)"
            connected="鷺  Connected $SSID"
        fi
	active="-a 0"
	# PIP="$(curl -s ifconfig.co/ip)"
	fi
else
    urgent="-u 0"
    SSID="Disconnected"
    PIP="Not Available"
    connected="  Disconnected"
fi 

# ip_city=`curl -s ifconfig.co/city`
# ip_country=`curl -s ifconfig.co/country`

## Icons
signal_streangth="  WiFi Signal Strength = $RANGE" 
party_loud="醙 Party Loud"
launch_cli="  Wifi Manu"
trackip_bash="  Track IP (Bash)"
trackip_py="  Track IP (PY)"
dnsleak_test="  DNS Leak Test"
go_back="  Go Back ..."

options="$connected\n$signal_streangth\n$launch_cli\n$party_loud\n$trackip_bash\n$trackip_py\n$dnsleak_test\n$go_back"

# $PIP | $ip_country | $ip_city 
## Main
chosen="$(echo -e "$options" | $rofi_command -p "  " -dmenu $active $urgent -selected-row 1)"
case $chosen in
  $signal_streangth)
        Network
        ;;
  $go_back)
        Main
        ;;
    $connected)
        connected_info
        ;;
    $launch_cli)
        break
        $HOME/.config/rofi/rofi-network-manager/./rofi-network-manager.sh
        ;;
    $party_loud)
        alacritty -e bash $HOME/tools/PartyLoud/partyloud.sh
        ;;
    $trackip_bash)
        alacritty -e bash $HOME/.config/polybar/scripts/security/trackip
        ;;
    $trackip_py)
        alacritty -e python3 .py
        ;;
    $dnsleak_test)
        alacritty -e bash $HOME/tools/dnsleaktest.sh;read
        ;;
esac
}


# Sub Module - (3) Run Scripts
Run_Scripts() {

# Script Modules
stopwatch_script="  Stopwatch Script  (1)"
ip_script="直  Ip Adress Script  (1)"
nitro_script="  Nitro Script (2)"
backup_configs="  Backup Configs (3)"
shread_trash="  Shread Trash (4)"
mpv_telegram="辶  Mpv - Telegram (5)"
quick_wipe="  Quick Wipe (6)"
safe_clean="  Safe Clean (7)"
wall_downloader="  Wallpaper Downloader (8)"
torrent_stream="﴾  Torrent Stream (9)"
updates_checker="  Updates Checker (10)"
fix_mpv="  Porn Mode (12)"
video_mpv="  Play in MPV       (13)"
go_back="  Go Back ... (11)"

# Variable passed to rofi
options="$stopwatch_script\n$ip_script\n$nitro_script\n$backup_configs\n$shread_trash\n$mpv_telegram\n$quick_wipe\n$safe_clean\n$wall_downloader\n$torrent_stream\n$updates_checker\n$fix_mpv\n$video_mpv\n$go_back"

chosen="$(echo -e "$options" | $rofi_command -p " " -dmenu -selected-row 0)"
case $chosen in
    $stopwatch_script)
        if pgrep stopwatch; then pkill stopwatch; else stopwatch; fi
        ;;
    $video_mpv)
        bash ~/.scripts/link-mpv.sh
        ;;
    $ip_script)
        alacritty -e bash
        ;;
    $nitro_script)
        alacritty -e bash $HOME/.scripts/Nitroplex.sh
        ;;
    $backup_configs)
        alacritty -e bash $HOME/.scripts/Backup_Configs_Mega.sh
        ;;
    $shread_trash)
        bleachbit -s ~/.local/share/Trash;
        ;;
    $mpv_telegram) # open all videos in Telegram Desktop Folder as playlist 
        mpv --osd-bar=no ~/Downloads/Telegram\ Desktop/*
        ;;
    $quick_wipe)
        alacritty -e bash 
        ;;
    $safe_clean)
        alacritty -e bash
        ;;
    $wall_downloader)
        alacritty -e python3 ~/MEGAsync/Projects/Python/Wallpaper_Downloader/_main_.py
        ;;
    $torrent_stream)
        alacritty -e python /home/i0xfce/MEGAsync/Projects/Python/torrent-strm/Main/_xmain_.py
        ;;
    $updates_checker)
        alacritty -e bash
        ;;
    $fix_mpv)
        bash $HOME/.scripts/fix_mpv.sh &
        ;;
    $go_back)
        Main
        ;;
esac
}

# Sub Module - (4) Quick Script Editor (vim,nvim,neovide)
Edit_Script() {
# Rofi Options
rofi_current="  Edit Current                      (1)"
bspwmrc="  Edit Bspwmrc                      (2)"
sxhkdrc="  Edit Sxhkdrc                      (3)"
polybar_modules="  Edit Polybar Modules              (4)"
polybar_config="  Edit Polybar Config               (5)"
pywall_srp="  Edit Pywall Script                (6)"
nitroplex_script="  Edit Nitroplex Script             (7)"
fix_mpv="  Edit Fix MPV Script               (8)"
edit_rofi_search="  Edit Rofi Search Script           (9)"
delete_swap_vim="  Delete Vim Swap ...              (21)"
go_back="  Go Back ...                      (22)"

# Variable passed to rofi
options="$rofi_current\n$bspwmrc\n$sxhkdrc\n$polybar_modules\n$polybar_config\n$pywall_srp\n$nitroplex_script\n$fix_mpv\n$edit_rofi_search\n$delete_swap_vim\n$go_back"

chosen="$(echo -e "$options" | $rofi_command -p " " -dmenu -selected-row 0)"
case $chosen in
    $edit_rofi_search)
        neovide ~/.config/rofi/web-search.sh
        ;;
    $rofi_current)
        neovide ~/.config/rofi/applets/menu/rofi-script-menu.sh
        ;;
    $delete_swap_vim)
        trash $HOME/.local/share/nvim/swap
        notify-send -i "Nvim" "Swap Files deleted successfully"
        ;;
    $pywall_srp)
        neovide ~/.config/polybar/scripts/pywall.sh
        ;;
    $fix_mpv)
        neovide ~/.scripts/fix_mpv.sh
        ;;
    $bspwmrc)
        neovide $HOME/.config/bspwm/bspwmrc
        ;;
    $sxhkdrc)
        neovide $HOME/.config/sxhkd/sxhkdrc
        ;;
    $polybar_modules)
        neovide $HOME/.config/polybar/modules.ini
        ;;
    $polybar_config)
        neovide $HOME/.config/polybar/config.ini
        ;;
    $nitroplex_script)
        neovide $HOME/.scripts/Nitroplex.sh
        ;;
    $go_back)
        Main
        ;;
esac
}

system_module() {
rofi -no-lazy-grab -show drun \
-modi run,drun,window \
-theme $dir/"$theme"
}

# Main Module - 1 
Main() {
# Rofi Options
open_links="   Open Links                                                                          (1)"
network_modules="直 Network Modules                                                              (2)"
run_scripts="   Run Scripts                                                                            (3)"
edit_scripts="   Edit Scripts                                                                           (4)"
system_modules="漣  System Modules                                                               (5)"
extra_modules="  Extra Modules                                                                       (6)"

# Variable passed to rofi
options="$open_links\n$network_modules\n$run_scripts\n$edit_scripts\n$system_modules\n$extra_modules"

chosen="$(echo -e "$options" | $rofi_command -p " " -dmenu -selected-row 0)"
case $chosen in
    $open_links)
        Openlinks
        ;;
    $run_scripts)
        Run_Scripts
        ;;
    $edit_scripts)
        Edit_Script
        ;;
    $system_modules)
        system_module 
        ;;
    $network_modules)
        Network
        ;;
    $extra_modules)
        sleep 1;
        xdotool key k 1 5 i 3 1 l 0 4 l 9 1 a at 2 4 slash 7 KP_Enter
        ;;
esac
}

# Starting ...
Main
