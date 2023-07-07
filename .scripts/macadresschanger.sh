#!/bin/bash

# paru -Sy macchanger (install this package)

while true; do
  userInput=0
  clear

  echo "Please choose how to change your MAC address:"
  echo
  echo "[1] Change all MAC addresses"
  echo "[2] Force change all MAC addresses, disable interfaces, then change the MAC"
  echo "[3] Change to a specific MAC address"
  echo "[4] Show available interfaces"
  echo "[5] Show assigned MAC addresses"
  echo "[6] Revert back all MAC addresses to original status"
  echo "[7] Exit"
  echo
  echo "Choose your module:"
  read -r n

  case $n in
    1) userInput=1 ;;
    2) userInput=2 ;;
    3) userInput=3 ;;
    4) userInput=4 ;;
    5) userInput=5 ;;
    6) userInput=6 ;;
    7) userInput=7 ;;
    *) print_error "Warning: wrong value" ; sleep 1 ;;
  esac

  if [[ $userInput == 7 ]]; then
    clear
    echo "Done!!"
    echo
    exit 1
  fi

  if [[ $userInput == 5 ]]; then
    clear
    D='/sys/class/net'
    theChangecounter=0
    for nic in "$D"/*; do
      themac=$(< "$nic/address")
      if [[ $themac != "00:00:00:00:00:00" && $themac != "" ]]; then
        ((theChangecounter++))
        echo "Device($theChangecounter): ${cayn}${nic##*/} ${reset}Mac: ${cayn}$themac${reset}"
      fi
    done
    echo
    echo "Total MAC addresses found ${green}$theChangecounter${reset}"
    echo
    read -n 1 -s -r -p "${reset}Press any key to continue....."
  fi

  if [[ $userInput == 4 ]]; then
    clear
    theChangecounter=0
    arp -n
    echo
    ip link show
    echo
    sudo lshw -class network -short
    echo
    for i in $(nmcli device status | awk '{print $1}'); do
      if [[ $i != "DEVICE" && $i != "lo" ]]; then
        ((theChangecounter++))
        echo "Device($theChangecounter): ${cayn}$i${reset}"
      fi
    done
    echo "Total devices found ${green}$theChangecounter${reset}"
    echo
    read -n 1 -s -r -p "${reset}Press any key to continue....."
  fi

  if [[ $userInput == 3 ]]; then
    clear
    echo
    echo "Please type in the interface name you would like to change the MAC address:"
    read -r n
    sudo macchanger -r "$n"
    echo
    read -n 1 -s -r -p "${reset}Press any key to continue....."
  fi

  if [[ $userInput == 1 ]]; then
    clear
    D='/sys/class/net'
    theChangecounter=0
    for nic in "$D"/*; do
      themac=$(< "$nic/address")
      if [[ $themac != "00:00:00:00:00:00" && $themac != "" ]]; then
        if sudo timeout 10 sudo macchanger -r "$nic"; then
          echo "MAC changed for $nic"
          ((theChangecounter++))
          echo
        fi
      fi
    done

    if [[ $theChangecounter == 0 ]]; then
      print_error "MAC address could not be changed"
    fi

    echo
    echo "Total MAC addresses changed ${green}$theChangecounter${reset}"
    echo
    read -n 1 -s -r -p "${reset}Press any key to continue....."
  fi

  if [[ $userInput == 2 ]]; then
    clear

    for intf in /sys/class/net/*; do
      echo "Taking ${green}$intf${reset} down"
      sudo ifconfig "$(basename "$intf")" down
    done
    echo

    D='/sys/class/net'
    theChangecounter=0
    for nic in "$D"/*; do
      themac=$(< "$nic/address")
      if [[ $themac != "00:00:00:00:00:00" && $themac != "" ]]; then
        if sudo timeout 10 sudo macchanger -r "$nic"; then
          echo "MAC changed for $nic"
          ((theChangecounter++))
          echo
        fi
      fi
    done

    if [[ $theChangecounter == 0 ]]; then
      print_error "MAC address could not be changed"
    fi

    for intf in /sys/class/net/*; do
      echo "Taking ${green}$intf${reset} up"
      sudo ifconfig "$(basename "$intf")" up
    done

    echo
    echo "Total MAC addresses changed = ${green}$theChangecounter${reset}"
    echo
    read -n 1 -s -r -p "${reset}Press any key to continue....."
  fi

  if [[ $userInput == 6 ]]; then
    clear

    for intf in /sys/class/net/*; do
      echo "Taking ${green}$intf${reset} down"
      sudo ifconfig "$(basename "$intf")" down
    done
    echo

    D='/sys/class/net'
    theChangecounter=0
    for nic in "$D"/*; do
      themac=$(< "$nic/address")
      if [[ $themac != "00:00:00:00:00:00" && $themac != "" ]]; then
        if sudo timeout 10 sudo macchanger -p "$nic"; then
          echo "MAC changed for $nic"
          ((theChangecounter++))
          echo
        fi
      fi
    done

    if [[ $theChangecounter == 0 ]]; then
      print_error "MAC address could not be changed"
    fi

    for intf in /sys/class/net/*; do
      echo "Taking ${green}$intf${reset} up"
      sudo ifconfig "$(basename "$intf")" up
    done

    echo
    echo "Total MAC addresses changed ${green}$theChangecounter${reset}"
    echo
    read -n 1 -s -r -p "${reset}Press any key to continue....."
  fi
done

