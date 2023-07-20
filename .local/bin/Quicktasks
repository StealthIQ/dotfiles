}!/bin/bash

# Colors
red=`tput setaf 1`
yellow=`tput setaf 3`
blue=`tput setaf 4`
magenta=`tput setaf 5`
cyan=`tput setaf 6`
white=`tput setaf 7`
green=`tput setaf 2`
reset=`tput sgr0`

# Formating
bold=`tput bold`
dim=`tput dim`
uline=`tput smul`
bold=`tput bold`
bell=`tput bel`

banner() {
  clear

echo -e "\n${red}   ███████╗ ██████╗██████╗ ██╗██████╗ ████████╗          ${yellow}    ██╗  ██╗ ██╗ "
echo -e "   ${red}██╔════╝██╔════╝██╔══██╗██║██╔══██╗╚══██╔══╝          ${yellow}    ╚██╗██╔╝ ██║ "
echo -e "   ${red}███████╗██║     ██████╔╝██║██████╔╝   ██║       █████╗${yellow}     ╚███╔╝  ██║ "
echo -e "   ${red}╚════██║██║     ██╔══██╗██║██╔═══╝    ██║       ╚════╝${yellow}     ██╔██╗  ██║ "
echo -e "   ${red}███████║╚██████╗██║  ██║██║██║        ██║             ${yellow}    ██╔╝ ██╗ ██║ "
echo -e "   ${red}╚══════╝ ╚═════╝╚═╝  ╚═╝╚═╝╚═╝        ╚═╝             ${yellow}    ╚═╝  ╚═╝ ╚═╝ \n"
                                                                      
}

# Option Selection Module
select_option() {

    # little helpers for terminal print control and key input
    ESC=$( printf "\033")
    cursor_blink_on()  { printf "$ESC[?25h"; }
    cursor_blink_off() { printf "$ESC[?25l"; }
    cursor_to()        { printf "$ESC[$1;${2:-1}H"; }
    print_option()     { printf "$2   $1 "; }
    print_selected()   { printf "$2  $ESC[7m $1 $ESC[27m"; }
    get_cursor_row()   { IFS=';' read -sdR -p $'\E[6n' ROW COL; echo ${ROW#*[}; }
    get_cursor_col()   { IFS=';' read -sdR -p $'\E[6n' ROW COL; echo ${COL#*[}; }
    key_input()         {
                        local key
                        IFS= read -rsn1 key 2>/dev/null >&2
                        if [[ $key = ""      ]]; then echo enter; fi;
                        if [[ $key = $'\x20' ]]; then echo space; fi;
                        if [[ $key = "k" ]]; then echo up; fi;
                        if [[ $key = "j" ]]; then echo down; fi;
                        if [[ $key = "h" ]]; then echo left; fi;
                        if [[ $key = "l" ]]; then echo right; fi;
                        if [[ $key = "a" ]]; then echo all; fi;
                        if [[ $key = "n" ]]; then echo none; fi;
                        if [[ $key = $'\x1b' ]]; then
                            read -rsn2 key
                            if [[ $key = [A || $key = k ]]; then echo up;    fi;
                            if [[ $key = [B || $key = j ]]; then echo down;  fi;
                            if [[ $key = [C || $key = l ]]; then echo right;  fi;
                            if [[ $key = [D || $key = h ]]; then echo left;  fi;
                        fi 
    }
    print_options_multicol() {
        # print options by overwriting the last lines
        local curr_col=$1
        local curr_row=$2
        local curr_idx=0

        local idx=0
        local row=0
        local col=0
        
        curr_idx=$(( $curr_col + $curr_row * $colmax ))
        
        for option in "${options[@]}"; do

            row=$(( $idx/$colmax ))
            col=$(( $idx - $row * $colmax ))

            cursor_to $(( $startrow + $row + 1)) $(( $offset * $col + 1))
            if [ $idx -eq $curr_idx ]; then
                print_selected "$option"
            else
                print_option "$option"
            fi
            ((idx++))
        done
    }

    # initially print empty new lines (scroll down if at bottom of screen)
    for opt; do printf "\n"; done

    # determine current screen position for overwriting the options
    local return_value=$1
    local lastrow=`get_cursor_row`
    local lastcol=`get_cursor_col`
    local startrow=$(($lastrow - $#))
    local startcol=1
    local lines=$( tput lines )
    local cols=$( tput cols ) 
    local colmax=$2
    local offset=$(( $cols / $colmax ))

    local size=$4
    shift 4

    # ensure cursor and input echoing back on upon a ctrl+c during read -s
    trap "cursor_blink_on; stty echo; printf '\n'; exit" 2
    cursor_blink_off

    local active_row=0
    local active_col=0
    while true; do
        print_options_multicol $active_col $active_row 
        # user key control
        case `key_input` in
            enter)  break;;
            up)     ((active_row--));
                    if [ $active_row -lt 0 ]; then active_row=0; fi;;
            down)   ((active_row++));
                    if [ $active_row -ge $(( ${#options[@]} / $colmax ))  ]; then active_row=$(( ${#options[@]} / $colmax )); fi;;
            left)     ((active_col=$active_col - 1));
                    if [ $active_col -lt 0 ]; then active_col=0; fi;;
            right)     ((active_col=$active_col + 1));
                    if [ $active_col -ge $colmax ]; then active_col=$(( $colmax - 1 )) ; fi;;
        esac
    done

    # cursor position back to normal
    cursor_to $lastrow
    printf "\n"
    cursor_blink_on

    return $(( $active_col + $active_row * $colmax ))
}

# Network Fix
network_fix() {
#Delete never used Network ids
nmcli --fields UUID,TIMESTAMP-REAL con show | grep never |  awk '{print $1}' | while read line; do nmcli con delete uuid  $line;    done;

# remove protected tor first node
sudo rm -f /usr/lib/tor-browser/tor-browser_en-US/Browser/TorBrowser/Data/Tor/state

# Stop open snith service to save cpu resources
# sudo systemctl stop opensnitch;

# Start up check connection
wget --timeout=5 --waitretry=0 --tries=3 --retry-connrefused -q --spider duckduckgo.com &> /dev/null
if [ $? -eq 0 ]; 
then
	notify-send "Internet found no issues do nothing bye";
	echo "Net found exit";
        sleep 3;
	# exit 1;
else
	#initilize the network
	echo "Dhclient the smart way";	
	for i in $( nmcli device status | awk '{print $1}' );
	do
		if [[ $i != "DEVICE" ]]
		then
			echo "Dhcp for:$i";
			sudo timeout 1 sudo dhclient $i;
		fi
	done

        sudo systemctl restart NetworkManager
	echo "initilize the network done";
        sleep 5;
fi
clear;
}

vpn_connect() {
    sudo wg-quick down wg0; sudo wg-quick up wg0 && ifconfig | grep "wg0: flags=209<UP,POINTOPOINT,RUNNING,NOARP>" && myip=$(curl -s ifconfig.co/) && country=$(curl -s ifconfig.co/country) && city=$(curl -s ifconfig.co/city) && notify-send -i /home/i0xfce/.icons/Gladient/lock.png '✅ Wireguard VPN Connected' \ "🔥 Ip Changed - ${myip} \n ✰ ${country} - ${city}" || notify-send -i /home/i0xfce/.icons/Papirus-Dark-Custom/48x48@2x/statusdialog-warning.svg "🔥 Wireguard VPN Not Connected" "⚠️ Please Either Manually Check by typing [ sudo wg ] or check your ip"
}

# Wireguard Disconnect
vpn_disconnect() {
    sudo wg-quick down wg0; myip=$(curl -s ifconfig.co/) && country=$(curl -s ifconfig.co/country) && city=$(curl -s ifconfig.co/city) && notify-send -i /home/i0xfce/.icons/Papirus-Custom/48x48@2x/status/changes-allow.svg "🔥 Wireguard VPN Disconnected" \ "🗲 Your current Ip - ${myip} \n ✰ ${country} - ${city}"
}

# Start
while true
do
	userInput=0;
	# clear;
        banner
	echo -e "   ${magenta}${bold}《 ${uline}Please choose from the options below${reset}${magenta}${bold} 》${reset}${cyan}";

	# echo -e "   ${cyan}[01] Fix all Network Problems";
	# echo -e "   [02] Connect wireguard [+VPN]";
	# echo -e "   [03] Disconnect wireguard [-VPN]";
	# echo -e "   [04] System Updates";
	# echo -e "   [05] System Overview";
	# echo -e "   [06] Party Loud [ Random Website Noise]";
	# echo -e "   [07] Speedtest + Network Monitor";
	# echo -e "   [08] Wallpaper Downloader";
	# echo -e "   [09] IP Tool [Python]";
	# echo -e "   [10] Fix Everything Back to normal";
	# echo -e "   [11] Do an overall security checkup";
	# echo -e "   [12] Anonymize [ Randomize Mac | Timezone to match ip ]${reset}";
	# echo -e "   [13] Execute a Command";
	# echo -e "   [14] Open terminal in root [ST]";
	# echo -e "   ${dim}[0] Exit${reset}";

        options=(
"[01] Connect wireguard [+VPN]"
"[02] Disconnect wireguard [-VPN]"
"[03] Open Rofi Wifi Menu"
"[04] System Updates"
"[05] System Overview"
"[06] Party Loud [ Random Website Noise]"
"[07] Network Monitor"
"[08] Wallpaper Downloader"
"[09] IP Tool [Python]"
"[10] Fix Everything Back to normal"
"[11] Do an overall security checkup"
"[12] Anonymize [ Randomize Mac | Timezone to match ip ]"
"[13] Execute a Command"
"[14] Open terminal in root [ST]"
"[00] Edit this script [VIM]")

        # echo -e "\n${blue}   [~] Choose your module :${reset}${magenta}"
        # options=(1 2 3 4 5 6 7 8 9 10 11 12 0)
        # options=(1 2 3 4 5 6 7 8 9 10 11 12 13 14 0)

        select_option $? 1 "${options[@]}" #-Number of rows/colums
        ops=${options[$?]}
        echo -e "${cyan}"
        n=$(echo "${ops}" | cut -b 2-3)

	# read -p "${blue}   [~] Choose your module :${reset}" n;
	case $n in
		01) userInput=1;;
		02) userInput=2;;
		03) userInput=3;;
		04) userInput=4;;
		05) userInput=5;;
		06) userInput=6;;
		07) userInput=7;;
		08) userInput=8;;
		09) userInput=9;;
		10) userInput=10;;
		11) userInput=11;;
		12) userInput=12;;
		13) userInput=13;;
		14) userInput=14;;
		00) userInput=0;;
		# *) echo -e "${red}   ✘  Warning: wrong value!! Exiting...";sleep 1;;
		*) exit 1;	
              esac

        # Open Script in VIM
	if [[ $userInput = "0" ]]
	then
	        clear;
                neovide ~/.scripts/Nitroplex.sh
		echo "";
		echo -e "${green}✔  Opened Script in Vim ++ ${green} | Done";
		echo "";
		read -n 1 -s -r -p "${reset}Press any key to continue.....";	
	fi

        # Fix Network Problems - 3
        # Network Manager
	if [[ $userInput = "3" ]]
	then
		clear;
                # network_fix
                bash $HOME/.config/rofi/rofi-network-manager/rofi-network-manager.sh
		echo "";
		echo -e "${green}✔  NetworkManager Closed++ ${green} | Done";
		echo "";
		read -n 1 -s -r -p "${reset}Press any key to continue.....";
	fi

        # Connect Wireguard - 1
	if [[ $userInput = "1" ]]
	then
		clear;
                vpn_connect
		echo "";
		echo -e "${green}✔  VPN Connected ++ ${green} | Done";
		echo "";
		read -n 1 -s -r -p "${reset}Press any key to continue.....";
	fi

        # Disconnect Wireguard - 2
	if [[ $userInput = "2" ]]
	then
		clear;
                vpn_disconnect
		echo "";
		echo -e "${green}✔  VPN Disconnect -- ${green} | Done";
		echo "";
		read -n 1 -s -r -p "${reset}Press any key to continue.....";
	fi


        # System Updates - 4
	if [[ $userInput = "4" ]]
	then
		clear;
                paru --noconfirm -Syu;
		echo "";
		echo -e "${green}✔  System Updated -- ${green} | Done";
		echo "";
		read -n 1 -s -r -p "${reset}Press any key to continue.....";
	fi


        # System Overview - 5
	if [[ $userInput = "5" ]]
	then
		clear;
                btop
		echo "";
		echo -e "${green}✔  btop launched -- ${green} | Done";
		echo "";
		read -n 1 -s -r -p "${reset}Press any key to continue.....";
	fi


        # Party Loud [ Random Website Noise] - 6
	if [[ $userInput = "6" ]]
	then
		clear;
                bash $HOME/tools/PartyLoud/partyloud.sh;
                echo "";
		echo -e "${green}✔  Module 6 [ Party Loud ] -- ${green} | Done";
		echo "";
		read -n 1 -s -r -p "${reset}Press any key to continue.....";
	fi


        # Network Monitor - 7
	if [[ $userInput = "7" ]]
	then
		clear;
                # bash ~/.scripts/speedtest.sh;
                # sleep 6;
                # sudo setcap cap_sys_ptrace,cap_dac_read_search,cap_net_raw,cap_net_admin+ep $(which bandwhich)
                bandwhich;
		echo "";
		echo -e "${green}✔  Net Monitor 7 [ Bandwhich ] -- ${green} | Done";
		echo "";
		read -n 1 -s -r -p "${reset}Press any key to continue.....";
	fi


        # Wallpaper Downloader - 8
	if [[ $userInput = "8" ]]
	then
		clear;
                python3 ~/MEGAsync/Projects/Python/Wallpaper_Downloader/_main_.py
		echo "";
		echo -e "${green}✔  Module 8 [ Wallpaper Downloader ] -- ${green} | Done";
		echo "";
		read -n 1 -s -r -p "${reset}Press any key to continue.....";
	fi


        # IP Tool [Python] - 9
	if [[ $userInput = "9" ]]
	then
		clear;
                bash $HOME/.config/polybar/scripts/security/trackip;
		echo "";
		echo -e "${green}✔  IP Adress Tracking-- ${green} | Done";
		echo "";
		read -n 1 -s -r -p "${reset}Press any key to continue.....";
	fi


        # Fix Everything Back to normal - 10
	if [[ $userInput = "10" ]]
	then
		clear;
                sudo kali-whoami --fix;
		echo "";
		echo -e "${green}✔  Module 10 [ Fix Problems ] -- ${green} | Done";
		echo "";
		read -n 1 -s -r -p "${reset}Press any key to continue.....";
        fi


        # Do an overall security checkup - 11
	if [[ $userInput = "11" ]]
	then
		clear;
                bash $HOME/tools/dnsleaktest.sh;
		echo "";
		echo -e "${green}✔  Module 11 [ Dnsleak Test ] -- ${green} | Done";
		echo "";
		read -n 1 -s -r -p "${reset}Press any key to continue.....";
	fi


        # Anonymize [ Randomize Mac | Timezone to match ip ] - 12
	if [[ $userInput = "12" ]]
	then
		clear;
                sudo kali-whoami --start;
		echo "";
		echo -e "${green}✔  kali-whoami started -- ${green} | Done";
		echo "";
		read -n 1 -s -r -p "${reset}Press any key to continue.....";
	fi

  
        # Excute a command - 13
	if [[ $userInput = "13" ]]
	then
		clear;
                read -p "Enter the command you want to excute : " command
                echo -e "${blue}"
                ${command}
		echo -e "\n${green}✔  Command Excuted -- ${green} | Done \n";
		read -n 1 -s -r -p "${reset}Press any key to continue.....";
	fi 


        # Opoen terminal in root - 14
	if [[ $userInput = "14" ]]
	then
		clear;
                sudo st;
		echo "";
		echo -e "${green}✔  Opened root terminal in another window -- ${green} | Done";
		echo "";
		read -n 1 -s -r -p "${reset}Press any key to continue.....";
	fi       


  done
